---
title: "DOKS Mastery Phần 7: CI/CD Pipeline với GitHub Actions"
date: 2026-02-14
draft: false
description: "Xây dựng CI/CD pipeline production-grade với GitHub Actions, DigitalOcean Container Registry, OIDC & API Token auth, và DevSecOps"
categories: ["Kubernetes", "CI/CD Pipelines"]
tags: ["kubernetes", "digitalocean", "doks", "github-actions", "cicd", "container-registry", "oidc", "devsecops", "trivy", "gitleaks"]
series: ["DOKS Mastery"]
weight: 7
mermaid: true
---

Chào mừng bạn đến với phần cuối cùng của **DOKS Mastery Series**! Trong 6 phần trước, chúng ta đã xây dựng một production Kubernetes cluster hoàn chỉnh từ A-Z. Bây giờ là lúc tự động hóa toàn bộ quy trình deployment với **CI/CD pipeline production-grade**.

## Tại sao cần CI/CD cho Kubernetes?

Chạy `kubectl apply` thủ công có nhiều rủi ro:

- **Không nhất quán**: Ai đó quên apply manifest mới nhất
- **Thiếu kiểm tra**: Deploy code có lỗ hổng bảo mật
- **Không có audit trail**: Ai deploy gì, khi nào?
- **Chậm & dễ sai**: Copy-paste lệnh, typo, quên namespace

**CI/CD pipeline giải quyết tất cả điều này** bằng cách tự động hóa từ `git push` đến pod chạy trên cluster.

## Pipeline End-to-End

Đây là pipeline chúng ta sẽ xây dựng:

{{< mermaid >}}
graph LR
    A[Git Push] --> B[Security Scan]
    B --> C{Có lỗ hổng?}
    C -->|Có| D[❌ Dừng Pipeline]
    C -->|Không| E[Build Docker Image]
    E --> F[Scan Image với Trivy]
    F --> G{Có CVE HIGH/CRITICAL?}
    G -->|Có| D
    G -->|Không| H[Push to DO Registry]
    H --> I[Deploy to DOKS]
    I --> J[Verify Deployment]
    J --> K[✅ Pipeline Success]
{{< /mermaid >}}

Trong bài này, bạn sẽ học:

1. **DigitalOcean Container Registry** - Lưu trữ Docker images riêng tư
2. **GitHub Actions Workflows** - Tự động hóa build, test, deploy
3. **Xác thực OIDC & API Token** - Hai phương pháp kết nối với DOKS
4. **DevSecOps Pipeline** - Security scanning, linting, verification
5. **Deployment Strategies** - Rolling updates, Blue-Green, Canary

Let's get started! 🚀

---

## 1. DigitalOcean Container Registry Setup

### Tạo Private Registry

DigitalOcean Container Registry là nơi lưu trữ Docker images riêng tư của bạn (tương tự Docker Hub nhưng private và có integration sâu với DOKS).

```bash
# Tạo registry với tên unique (lowercase, hyphens only)
doctl registry create ezdevsecops-registry

# Output:
# Name                     Endpoint
# ezdevsecops-registry     registry.digitalocean.com/ezdevsecops-registry
```

{{< callout type="tip" >}}
**Pricing**: Registry được tính theo storage (500GB = $20/month). Plan Starter (100GB) miễn phí nếu bạn có Droplet hoặc DOKS cluster đang chạy.
{{< /callout >}}

### Đăng nhập Registry từ Local Machine

```bash
# Đăng nhập Docker daemon với DO registry
doctl registry login

# Output:
# Logging Docker in to registry.digitalocean.com
```

Lệnh này tự động cấu hình `~/.docker/config.json` với credentials.

### Build & Push Image Test

Hãy thử push một image test:

```bash
# Build sample app
docker build -t registry.digitalocean.com/ezdevsecops-registry/api:v1.0.0 .

# Push to registry
docker push registry.digitalocean.com/ezdevsecops-registry/api:v1.0.0

# List images
doctl registry repository list-v2

# Output:
# Name    Tag Count    Last Updated
# api     1            2026-02-14 07:30:00
```

### Kết nối Registry với DOKS Cluster

Để DOKS cluster có thể pull images từ registry mà không cần ImagePullSecrets:

```bash
# Integrate registry với cluster
doctl kubernetes cluster registry add ezdevsecops-cluster

# Verify integration
kubectl get secrets -n kube-system | grep registry
```

{{< callout type="tip" >}}
**Auto-integration**: Khi registry được integrate, DOKS tự động tạo secret trong `kube-system` namespace và cấu hình kubelet để dùng secret đó khi pull images từ `registry.digitalocean.com`.
{{< /callout >}}

### Quản lý Registry qua DO Console

Ngoài CLI, bạn có thể quản lý registry qua [DigitalOcean Console](https://cloud.digitalocean.com/registry):

- View all images và tags
- Xóa old tags (clean up storage)
- Setup Garbage Collection (tự động xóa unused images)
- View storage usage & billing

---

## 2. GitHub Actions: Xác thực với API Token

GitHub Actions cần quyền truy cập vào DOKS cluster để deploy. Có **2 phương pháp xác thực**:

1. **API Token** (đơn giản, long-lived credentials)
2. **OIDC** (bảo mật hơn, short-lived credentials) ← **Recommended**

Chúng ta sẽ tìm hiểu cả hai, bắt đầu với API Token.

### Step 1: Tạo DigitalOcean API Token

1. Truy cập [DigitalOcean API Tokens](https://cloud.digitalocean.com/account/api/tokens)
2. Click **Generate New Token**
3. Name: `github-actions-doks`
4. Scopes: **Read & Write**
5. Copy token (chỉ hiển thị 1 lần!)

{{< callout type="danger" >}}
**Bảo mật Token**: KHÔNG BAO GIỜ commit token vào Git! Luôn lưu trong GitHub Secrets hoặc vault.
{{< /callout >}}

### Step 2: Lưu Secrets trong GitHub

Vào repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**:

| Secret Name | Value |
|------------|-------|
| `DIGITALOCEAN_ACCESS_TOKEN` | `dop_v1_xxxxx...` (token vừa tạo) |
| `CLUSTER_NAME` | `ezdevsecops-cluster` |
| `REGISTRY_NAME` | `ezdevsecops-registry` |

### Step 3: Workflow với API Token

Tạo file `.github/workflows/deploy-api-token.yml`:

```yaml
name: Deploy with API Token

on:
  push:
    branches: [main]
    paths:
      - 'src/**'
      - 'Dockerfile'
      - 'k8s/**'

env:
  IMAGE_NAME: api
  K8S_NAMESPACE: production

jobs:
  deploy:
    name: Build and Deploy
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install doctl
        uses: digitalocean/action-doctl@v2
        with:
          token: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}

      - name: Login to DO Container Registry
        run: doctl registry login --expiry-seconds 1200

      - name: Build Docker image
        run: |
          docker build \
            -t registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -t registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:latest \
            .

      - name: Push image to registry
        run: |
          docker push registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          docker push registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:latest

      - name: Save kubeconfig
        run: doctl kubernetes cluster kubeconfig save ${{ secrets.CLUSTER_NAME }}

      - name: Deploy to DOKS
        run: |
          kubectl set image deployment/api-deployment \
            api=registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -n ${{ env.K8S_NAMESPACE }}

      - name: Verify deployment
        run: |
          kubectl rollout status deployment/api-deployment -n ${{ env.K8S_NAMESPACE }} --timeout=5m
```

**Giải thích Workflow**:

- **Trigger**: Chạy khi push code vào `main` branch (chỉ khi files trong `src/`, `Dockerfile`, `k8s/` thay đổi)
- **doctl action**: Cài đặt `doctl` CLI và xác thực với API token
- **Registry login**: Expire sau 20 phút (đủ cho build)
- **Image tagging**: Tag với `git SHA` (immutable) và `latest` (convenience)
- **kubectl set image**: Update image của deployment (thay vì `kubectl apply`)
- **Rollout status**: Đợi deployment hoàn tất hoặc timeout sau 5 phút

{{< callout type="warning" >}}
**API Token Limitation**: Token này có quyền **full access** vào DigitalOcean account của bạn (không chỉ DOKS). Nếu token bị leak, attacker có thể xóa toàn bộ infrastructure. **Dùng OIDC thay thế (xem phần tiếp theo).**
{{< /callout >}}

---

## 3. GitHub Actions: Xác thực với OIDC (Recommended)

**OpenID Connect (OIDC)** cho phép GitHub Actions lấy **short-lived credentials** từ DigitalOcean mà không cần lưu trữ long-lived API tokens. Credentials này tự động expire sau vài phút.

### Cách OIDC Hoạt động

{{< mermaid >}}
sequenceDiagram
    participant GHA as GitHub Actions
    participant GitHub as GitHub OIDC Provider
    participant DO as DigitalOcean

    GHA->>GitHub: Request OIDC token
    GitHub->>GHA: Issue JWT token (signed)
    GHA->>DO: Exchange JWT for DO credentials
    DO->>DO: Verify JWT signature & claims
    DO->>GHA: Issue temporary access token
    GHA->>DO: Use token to access DOKS
    Note over GHA,DO: Token expires after 1 hour
{{< /mermaid >}}

**Lợi ích**:

- **No long-lived secrets**: Token chỉ tồn tại trong workflow run
- **Principle of least privilege**: Scope token theo repository cụ thể
- **Audit trail**: DigitalOcean logs ghi rõ workflow nào đã access

### Step 1: Cấu hình Trust Policy trên DigitalOcean

{{< callout type="warning" >}}
**Lưu ý**: Tính năng OIDC cho DOKS hiện tại vẫn đang trong beta. Kiểm tra [DigitalOcean OIDC docs](https://docs.digitalocean.com/products/kubernetes/how-to/authenticate-github-actions/) để xem status mới nhất.
{{< /callout >}}

Tạo trust relationship giữa GitHub repository và DigitalOcean:

```bash
# Tạo OIDC trust policy (via doctl hoặc API)
doctl kubernetes cluster set-oidc ezdevsecops-cluster \
  --issuer-url https://token.actions.githubusercontent.com \
  --client-id https://github.com/your-org \
  --username-claim sub \
  --groups-claim groups
```

**Hoặc cấu hình qua API** (nếu doctl chưa support):

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITALOCEAN_ACCESS_TOKEN" \
  -d '{
    "issuer": "https://token.actions.githubusercontent.com",
    "audience": "https://github.com/your-username",
    "subject": "repo:your-username/your-repo:ref:refs/heads/main"
  }' \
  "https://api.digitalocean.com/v2/kubernetes/clusters/$(doctl k8s cluster get ezdevsecops-cluster --format ID --no-header)/oidc"
```

### Step 2: Update GitHub Workflow Permissions

Workflow cần quyền `id-token: write` để request OIDC token:

```yaml
permissions:
  contents: read
  id-token: write  # Required for OIDC
```

### Step 3: Workflow với OIDC

Tạo file `.github/workflows/deploy-oidc.yml`:

```yaml
name: Deploy with OIDC

on:
  push:
    branches: [main]
    paths:
      - 'src/**'
      - 'Dockerfile'
      - 'k8s/**'

permissions:
  contents: read
  id-token: write  # Required for OIDC

env:
  IMAGE_NAME: api
  K8S_NAMESPACE: production

jobs:
  deploy:
    name: Build and Deploy
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Get OIDC token
        id: oidc
        uses: actions/github-script@v7
        with:
          script: |
            const token = await core.getIDToken('https://github.com/${{ github.repository_owner }}')
            core.setOutput('token', token)

      - name: Install doctl
        uses: digitalocean/action-doctl@v2
        with:
          token: ${{ steps.oidc.outputs.token }}

      - name: Login to DO Container Registry
        run: doctl registry login --expiry-seconds 1200

      - name: Build Docker image
        run: |
          docker build \
            -t registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -t registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:latest \
            .

      - name: Push image to registry
        run: |
          docker push registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          docker push registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:latest

      - name: Save kubeconfig
        run: doctl kubernetes cluster kubeconfig save ${{ secrets.CLUSTER_NAME }}

      - name: Deploy to DOKS
        run: |
          kubectl set image deployment/api-deployment \
            api=registry.digitalocean.com/${{ secrets.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -n ${{ env.K8S_NAMESPACE }}

      - name: Verify deployment
        run: |
          kubectl rollout status deployment/api-deployment -n ${{ env.K8S_NAMESPACE }} --timeout=5m
```

**Key Differences từ API Token workflow**:

- `permissions: id-token: write` - Cho phép request OIDC token
- `actions/github-script@v7` - Request OIDC token từ GitHub
- Pass OIDC token thay vì long-lived API token

{{< callout type="tip" >}}
**Best Practice**: Dùng OIDC cho production workloads. API Token chỉ dùng cho testing hoặc POC (Proof of Concept).
{{< /callout >}}

---

## 4. RBAC Service Account cho CI/CD

**Principle of Least Privilege**: GitHub Actions workflow chỉ nên có quyền **deploy** vào `production` namespace, không có quyền delete resources hay access namespace khác.

### Tạo Dedicated ServiceAccount

Tạo file `k8s/rbac/ci-serviceaccount.yaml`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: github-actions-deployer
  namespace: production
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: deployer-role
  namespace: production
rules:
  # Allow update deployments
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "list", "update", "patch"]

  # Allow read pods (for rollout status verification)
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]

  # Allow read replicasets (for rollout history)
  - apiGroups: ["apps"]
    resources: ["replicasets"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: github-actions-deployer-binding
  namespace: production
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: deployer-role
subjects:
  - kind: ServiceAccount
    name: github-actions-deployer
    namespace: production
```

**Apply RBAC**:

```bash
kubectl apply -f k8s/rbac/ci-serviceaccount.yaml
```

### Generate ServiceAccount Token

```bash
# Tạo token cho ServiceAccount (không expire - dùng cho CI/CD)
kubectl create token github-actions-deployer \
  --namespace production \
  --duration=87600h  # 10 years

# Copy token và lưu vào GitHub Secret: K8S_SA_TOKEN
```

### Update Workflow để dùng ServiceAccount

Thay thế step `Save kubeconfig`:

```yaml
- name: Configure kubectl with ServiceAccount
  run: |
    kubectl config set-cluster doks \
      --server=https://$(doctl kubernetes cluster get ${{ secrets.CLUSTER_NAME }} --format PublicIPv4 --no-header):443 \
      --insecure-skip-tls-verify=true

    kubectl config set-credentials github-actions-deployer \
      --token=${{ secrets.K8S_SA_TOKEN }}

    kubectl config set-context doks \
      --cluster=doks \
      --user=github-actions-deployer \
      --namespace=production

    kubectl config use-context doks
```

{{< callout type="tip" >}}
**Certificate Verification**: Trong production, thay `--insecure-skip-tls-verify=true` bằng `--certificate-authority=/path/to/ca.crt` để verify cluster certificate.
{{< /callout >}}

---

## 5. Production CI/CD Workflow Hoàn Chỉnh

Đây là **complete production-grade workflow** với 3 jobs song song và sequential:

```yaml
name: Production CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read
  id-token: write
  security-events: write  # For uploading SARIF results

env:
  REGISTRY_NAME: ezdevsecops-registry
  IMAGE_NAME: api
  K8S_NAMESPACE: production
  TRIVY_VERSION: 0.48.0

jobs:
  #############################################################################
  # JOB 1: Security Scanning
  #############################################################################
  security-scan:
    name: Security & Compliance Checks
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for Gitleaks

      - name: Run Gitleaks (Secret Detection)
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Install kubeconform
        run: |
          wget https://github.com/yannh/kubeconform/releases/download/v0.6.4/kubeconform-linux-amd64.tar.gz
          tar xf kubeconform-linux-amd64.tar.gz
          sudo mv kubeconform /usr/local/bin/

      - name: Validate Kubernetes manifests
        run: |
          kubeconform \
            -strict \
            -ignore-missing-schemas \
            -kubernetes-version 1.28.0 \
            -summary \
            k8s/

      - name: Scan Dockerfile with Trivy
        uses: aquasecurity/trivy-action@0.16.1
        with:
          scan-type: 'config'
          scan-ref: 'Dockerfile'
          exit-code: '1'
          severity: 'CRITICAL,HIGH'

  #############################################################################
  # JOB 2: Build and Push Image
  #############################################################################
  build-and-push:
    name: Build & Scan Docker Image
    runs-on: ubuntu-22.04
    needs: security-scan  # Wait for security checks
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    outputs:
      image-digest: ${{ steps.push.outputs.digest }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Install doctl
        uses: digitalocean/action-doctl@v2
        with:
          token: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}

      - name: Login to DO Container Registry
        run: doctl registry login --expiry-seconds 3600

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: registry.digitalocean.com/${{ env.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix={{branch}}-
            type=ref,event=branch
            type=semver,pattern={{version}}
            type=raw,value=latest,enable={{is_default_branch}}

      - name: Build and push
        id: push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=registry,ref=registry.digitalocean.com/${{ env.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:buildcache
          cache-to: type=registry,ref=registry.digitalocean.com/${{ env.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:buildcache,mode=max

      - name: Scan image with Trivy
        uses: aquasecurity/trivy-action@0.16.1
        with:
          image-ref: registry.digitalocean.com/${{ env.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'

      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: 'trivy-results.sarif'

  #############################################################################
  # JOB 3: Deploy to DOKS
  #############################################################################
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-22.04
    needs: build-and-push
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    environment:
      name: production
      url: https://api.ezdevsecops.com

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install doctl
        uses: digitalocean/action-doctl@v2
        with:
          token: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}

      - name: Save kubeconfig
        run: doctl kubernetes cluster kubeconfig save ${{ secrets.CLUSTER_NAME }}

      - name: Update deployment image
        run: |
          kubectl set image deployment/api-deployment \
            api=registry.digitalocean.com/${{ env.REGISTRY_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -n ${{ env.K8S_NAMESPACE }} \
            --record

      - name: Wait for rollout
        run: |
          kubectl rollout status deployment/api-deployment \
            -n ${{ env.K8S_NAMESPACE }} \
            --timeout=10m

      - name: Verify deployment health
        run: |
          # Check pod status
          kubectl get pods -n ${{ env.K8S_NAMESPACE }} -l app=api

          # Check deployment events
          kubectl describe deployment api-deployment -n ${{ env.K8S_NAMESPACE }}

          # Verify at least 2 replicas running
          READY=$(kubectl get deployment api-deployment -n ${{ env.K8S_NAMESPACE }} -o jsonpath='{.status.readyReplicas}')
          if [ "$READY" -lt 2 ]; then
            echo "❌ Only $READY replicas ready, expected at least 2"
            exit 1
          fi
          echo "✅ Deployment healthy: $READY replicas ready"

      - name: Run smoke tests
        run: |
          # Get LoadBalancer IP
          LB_IP=$(kubectl get svc api-service -n ${{ env.K8S_NAMESPACE }} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

          # Health check
          curl -f http://$LB_IP/health || exit 1

          # Version check
          curl -f http://$LB_IP/version | grep ${{ github.sha }} || exit 1

          echo "✅ Smoke tests passed"

      - name: Rollback on failure
        if: failure()
        run: |
          echo "❌ Deployment failed, rolling back..."
          kubectl rollout undo deployment/api-deployment -n ${{ env.K8S_NAMESPACE }}
          kubectl rollout status deployment/api-deployment -n ${{ env.K8S_NAMESPACE }} --timeout=5m
```

**Highlights của Workflow này**:

1. **3 Jobs song song → sequential**:
   - `security-scan` → chạy đầu tiên (Gitleaks, kubeconform, Dockerfile scan)
   - `build-and-push` → chỉ chạy sau khi security pass, build image + Trivy scan
   - `deploy` → chỉ chạy sau khi image push thành công

2. **DevSecOps Gates**:
   - Gitleaks: Detect hardcoded secrets trong code
   - Kubeconform: Validate K8s YAML syntax
   - Trivy: Scan Dockerfile và final image cho CVEs
   - Exit code `1` = fail pipeline nếu có HIGH/CRITICAL vulnerabilities

3. **Optimized Build**:
   - Docker Buildx với layer caching
   - Cache layer trong registry (`buildcache` tag)
   - Metadata action để generate smart tags

4. **Production Safeguards**:
   - GitHub Environment protection (require approvals)
   - Smoke tests sau deployment
   - Auto-rollback nếu verify fails
   - Minimum replica check (≥2 pods running)

5. **Observability**:
   - Upload Trivy results vào GitHub Security tab
   - Deployment events logging
   - Detailed error messages

{{< callout type="tip" >}}
**GitHub Environment Protection**: Trong repo settings → Environments → `production`, bạn có thể enable "Required reviewers" để force manual approval trước khi deploy. Rất hữu ích cho critical workloads!
{{< /callout >}}

---

## 6. DevSecOps Pipeline Deep Dive

**DevSecOps** = Development + Security + Operations. Security không phải là afterthought, mà được integrate vào mỗi stage của pipeline.

{{< mermaid >}}
graph TB
    subgraph "Security Gates"
        A[Code Commit] --> B[Secret Detection<br/>Gitleaks]
        B --> C[YAML Validation<br/>kubeconform]
        C --> D[Dockerfile Scan<br/>Trivy Config]
        D --> E[Build Image]
        E --> F[Image Vulnerability Scan<br/>Trivy Image]
        F --> G{CVE CRITICAL/HIGH?}
        G -->|Yes| H[❌ Block Deployment]
        G -->|No| I[Push to Registry]
        I --> J[Deploy to K8s]
        J --> K[Runtime Security<br/>Falco Optional]
    end

    style B fill:#ff6b6b
    style C fill:#4ecdc4
    style D fill:#ffe66d
    style F fill:#ff6b6b
    style K fill:#95e1d3
{{< /mermaid >}}

### 1. Secret Detection với Gitleaks

**Problem**: Developers accidentally commit API keys, passwords, tokens vào Git.

**Solution**: Gitleaks scans full Git history để detect secrets:

```yaml
- name: Run Gitleaks
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Gitleaks config** (`.gitleaks.toml` - optional, có default rules):

```toml
[extend]
useDefault = true

[[rules]]
id = "digitalocean-api-token"
description = "DigitalOcean API Token"
regex = '''dop_v1_[a-f0-9]{64}'''

[[rules]]
id = "postgres-connection-string"
description = "PostgreSQL connection string"
regex = '''postgres://[^:]+:[^@]+@[^/]+/[^\s]+'''

[allowlist]
paths = [
  '''\.env\.example$''',  # Allow example env files
  '''README\.md$'''
]
```

### 2. YAML Validation với kubeconform

**Problem**: Typo trong K8s YAML (e.g., `apiVerison` thay vì `apiVersion`) chỉ bị catch khi `kubectl apply` → pipeline đã waste resources để build/push image.

**Solution**: Validate YAML schema TRƯỚC khi build:

```yaml
- name: Validate K8s manifests
  run: |
    kubeconform \
      -strict \
      -ignore-missing-schemas \
      -kubernetes-version 1.28.0 \
      -summary \
      k8s/
```

**Flags**:
- `-strict`: Reject additional properties (catch typos)
- `-ignore-missing-schemas`: OK nếu schema không tồn tại (e.g., CRDs)
- `-kubernetes-version`: Target K8s version
- `-summary`: Show summary table (passed/failed counts)

### 3. Image Scanning với Trivy

**Trivy** scans Docker images cho vulnerabilities (CVEs) trong OS packages và application dependencies.

**2 stages**:

1. **Config scan** (Dockerfile best practices):

```yaml
- name: Scan Dockerfile
  uses: aquasecurity/trivy-action@0.16.1
  with:
    scan-type: 'config'
    scan-ref: 'Dockerfile'
    exit-code: '1'
    severity: 'CRITICAL,HIGH'
```

2. **Image scan** (CVEs trong final image):

```yaml
- name: Scan image
  uses: aquasecurity/trivy-action@0.16.1
  with:
    image-ref: registry.digitalocean.com/ezdevsecops-registry/api:${{ github.sha }}
    format: 'sarif'
    output: 'trivy-results.sarif'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'
```

**SARIF format** = Static Analysis Results Interchange Format → upload vào GitHub Security tab:

```yaml
- name: Upload Trivy results
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: 'trivy-results.sarif'
```

Sau khi upload, vào **Security tab** → **Code scanning alerts** để xem chi tiết CVEs.

{{< callout type="warning" >}}
**Trivy Database**: Trivy cần download vulnerability database (~200MB) mỗi lần chạy. Để speed up, cache database trong GitHub Actions cache:

```yaml
- name: Cache Trivy DB
  uses: actions/cache@v3
  with:
    path: ~/.cache/trivy
    key: ${{ runner.os }}-trivy-${{ github.run_id }}
    restore-keys: |
      ${{ runner.os }}-trivy-
```
{{< /callout >}}

### 4. Deployment Verification

Sau khi deploy, **ALWAYS verify** trước khi mark pipeline là success:

```yaml
- name: Verify deployment
  run: |
    # Wait for rollout
    kubectl rollout status deployment/api-deployment -n production --timeout=10m

    # Check ready replicas
    READY=$(kubectl get deployment api-deployment -n production -o jsonpath='{.status.readyReplicas}')
    if [ "$READY" -lt 2 ]; then
      echo "❌ Only $READY replicas ready"
      exit 1
    fi

    # Smoke test
    LB_IP=$(kubectl get svc api-service -n production -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    curl -f http://$LB_IP/health || exit 1
```

**Rollback nếu verify fails**:

```yaml
- name: Rollback on failure
  if: failure()
  run: |
    kubectl rollout undo deployment/api-deployment -n production
```

---

## 7. Deployment Strategies

Có nhiều cách deploy application lên Kubernetes. Chọn strategy phù hợp tùy thuộc vào risk tolerance và downtime requirements.

### Rolling Update (Default)

**Kubernetes default strategy**. Update pods dần dần:

1. Tạo pod mới với image mới
2. Đợi pod ready
3. Terminate pod cũ
4. Lặp lại cho đến khi tất cả pods updated

**Config**:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Tối đa 1 pod thêm vào (tổng 5 pods during rollout)
      maxUnavailable: 1  # Tối đa 1 pod không available
  template:
    spec:
      containers:
      - name: api
        image: registry.digitalocean.com/ezdevsecops-registry/api:v2.0.0
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

**Pros**:
- Zero downtime
- Tự động rollback nếu readinessProbe fails
- No extra infrastructure

**Cons**:
- Có khoảng thời gian cả v1 và v2 đang chạy cùng lúc (có thể gây inconsistency)
- Nếu bug chỉ xuất hiện sau vài phút, một số users đã bị ảnh hưởng

### Blue-Green Deployment

Deploy **full stack mới** (Green) song song với stack cũ (Blue). Khi Green ready, switch traffic sang Green, giữ Blue làm backup.

**Implementation**:

```yaml
# Blue deployment (current)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-blue
spec:
  replicas: 4
  selector:
    matchLabels:
      app: api
      version: blue
  template:
    metadata:
      labels:
        app: api
        version: blue
    spec:
      containers:
      - name: api
        image: registry.digitalocean.com/ezdevsecops-registry/api:v1.0.0
---
# Green deployment (new)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-green
spec:
  replicas: 4
  selector:
    matchLabels:
      app: api
      version: green
  template:
    metadata:
      labels:
        app: api
        version: green
    spec:
      containers:
      - name: api
        image: registry.digitalocean.com/ezdevsecops-registry/api:v2.0.0
---
# Service (switch between blue/green)
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
    version: blue  # ← Change to "green" to switch traffic
  ports:
  - port: 80
    targetPort: 8080
```

**Workflow để switch**:

```bash
# Deploy green stack
kubectl apply -f k8s/deployment-green.yaml

# Test green stack (via separate test service)
kubectl apply -f k8s/service-green-test.yaml
curl http://green-test.example.com/health

# Switch traffic to green
kubectl patch service api-service -p '{"spec":{"selector":{"version":"green"}}}'

# Monitor for issues
# If OK: delete blue deployment
# If issues: switch back to blue
```

**Pros**:
- Instant rollback (just switch selector back)
- Full testing on production infrastructure trước khi release traffic
- No mixed versions

**Cons**:
- **2x resources** (cả Blue và Green cùng chạy)
- Requires external state storage (database, cache) để cả 2 stacks share state

### Canary Deployment

Deploy version mới cho **một phần nhỏ traffic** (e.g., 10%), monitor metrics, rồi tăng dần lên 100% nếu không có issues.

**Manual Canary** (với replicas):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-v1
spec:
  replicas: 9  # 90% traffic
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
        version: v1
    spec:
      containers:
      - name: api
        image: registry.digitalocean.com/ezdevsecops-registry/api:v1.0.0
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-v2-canary
spec:
  replicas: 1  # 10% traffic
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
        version: v2
    spec:
      containers:
      - name: api
        image: registry.digitalocean.com/ezdevsecops-registry/api:v2.0.0
---
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api  # Both v1 and v2 match
  ports:
  - port: 80
    targetPort: 8080
```

Service sẽ load-balance traffic theo số lượng pods (9:1 ratio).

**Automated Canary với Argo Rollouts**:

Để có **progressive delivery** tự động (tăng dần traffic + auto-rollback based on metrics), dùng [Argo Rollouts](https://argoproj.github.io/rollouts/):

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: api-rollout
spec:
  replicas: 10
  strategy:
    canary:
      steps:
      - setWeight: 10   # 10% traffic to new version
      - pause: {duration: 5m}
      - setWeight: 30
      - pause: {duration: 5m}
      - setWeight: 50
      - pause: {duration: 5m}
      - setWeight: 100
      analysis:
        templates:
        - templateName: error-rate-analysis
        startingStep: 1
  template:
    spec:
      containers:
      - name: api
        image: registry.digitalocean.com/ezdevsecops-registry/api:v2.0.0
```

{{< callout type="tip" >}}
**Argo Rollouts** integrate với Prometheus để auto-analyze metrics (error rate, latency) và tự động rollback nếu thấy degradation. Highly recommended cho production workloads!
{{< /callout >}}

---

## 8. Monitoring & Alerting cho CI/CD

CI/CD pipeline cần monitoring để detect failures sớm:

### GitHub Actions Monitoring

**Slack/Discord notifications**:

```yaml
- name: Notify on failure
  if: failure()
  uses: slackapi/slack-github-action@v1.24.0
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
    payload: |
      {
        "text": "❌ Deployment failed: ${{ github.repository }}",
        "blocks": [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "*Deployment Failed*\n\n*Repository:* ${{ github.repository }}\n*Branch:* ${{ github.ref }}\n*Commit:* ${{ github.sha }}\n*Author:* ${{ github.actor }}\n\n<${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}|View Logs>"
            }
          }
        ]
      }
```

### Deployment Metrics

Track deployment frequency & success rate với **Prometheus + Grafana**:

```yaml
- name: Record deployment metric
  if: success()
  run: |
    curl -X POST http://pushgateway.monitoring.svc.cluster.local:9091/metrics/job/deployments \
      -d "deployment_total{app=\"api\",status=\"success\"} 1"
```

**Grafana Dashboard queries**:

```promql
# Deployment frequency (per day)
increase(deployment_total[1d])

# Deployment success rate
sum(rate(deployment_total{status="success"}[1h]))
/
sum(rate(deployment_total[1h]))

# Time to deploy (from commit to running pod)
histogram_quantile(0.95, deployment_duration_seconds_bucket)
```

---

## 9. Troubleshooting Common Issues

### Issue 1: ImagePullBackOff

**Symptom**:

```bash
kubectl get pods -n production
# NAME                    READY   STATUS             RESTARTS   AGE
# api-5d4f8c7b9-abcde     0/1     ImagePullBackOff   0          2m
```

**Cause**: Cluster không thể pull image từ registry.

**Debug**:

```bash
# Check registry integration
doctl kubernetes cluster registry list

# Re-integrate registry
doctl kubernetes cluster registry add ezdevsecops-cluster

# Verify secret exists
kubectl get secret -n kube-system | grep registry
```

### Issue 2: Deployment Rollout Stuck

**Symptom**:

```bash
kubectl rollout status deployment/api-deployment -n production
# Waiting for deployment "api-deployment" rollout to finish: 2 out of 4 new replicas have been updated...
# (stuck forever)
```

**Cause**: New pods fail readinessProbe.

**Debug**:

```bash
# Check pod status
kubectl get pods -n production -l app=api

# Check pod logs
kubectl logs -n production -l app=api --tail=100

# Check events
kubectl describe deployment api-deployment -n production

# Check readinessProbe
kubectl get pod <pod-name> -n production -o yaml | grep -A 10 readinessProbe
```

**Fix**: Adjust `initialDelaySeconds` hoặc fix application code.

### Issue 3: Trivy Scan Fails với Rate Limit

**Symptom**:

```text
Error: failed to download vulnerability DB: GET https://github.com/aquasecurity/trivy-db/releases/download/db/trivy.db: 403 rate limit exceeded
```

**Cause**: GitHub rate limits anonymous downloads.

**Fix**: Authenticate Trivy với GitHub token:

```yaml
- name: Scan image with Trivy
  uses: aquasecurity/trivy-action@0.16.1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    image-ref: registry.digitalocean.com/ezdevsecops-registry/api:${{ github.sha }}
```

### Issue 4: OIDC Authentication Fails

**Symptom**:

```text
Error: failed to get OIDC token: unable to get OIDC token: audience not allowed
```

**Cause**: Trust policy không match repository.

**Debug**:

```bash
# Check trust policy configuration
doctl kubernetes cluster get ezdevsecops-cluster --format ID,Name,OIDC

# Verify GitHub repository subject claim format
# Should be: repo:<org>/<repo>:ref:refs/heads/<branch>
```

**Fix**: Update trust policy với correct subject claim.

---

## 10. Tổng Kết DOKS Mastery Series

Chúc mừng! Bạn đã hoàn thành **DOKS Mastery Series** - một hành trình từ zero đến production-ready Kubernetes cluster trên DigitalOcean! 🎉

### Những gì bạn đã học qua 7 phần:

**Phần 1: DOKS Cluster Setup**
- Tạo production DOKS cluster với `doctl`
- Node pools, autoscaling, monitoring
- kubectl configuration & cluster access

**Phần 2: Application Deployment**
- Deployments, Services, ConfigMaps, Secrets
- Rolling updates & rollback strategies
- Health checks (liveness & readiness probes)

**Phần 3: Storage & StatefulSets**
- Persistent Volumes với DigitalOcean Block Storage
- StatefulSets cho stateful applications (PostgreSQL)
- Storage classes & dynamic provisioning

**Phần 4: Networking & Ingress**
- ClusterIP, NodePort, LoadBalancer services
- Ingress controller (Nginx) configuration
- TLS certificates với Cert-Manager

**Phần 5: Security & RBAC**
- RBAC roles & role bindings
- ServiceAccounts & Pod Security Standards
- Network Policies & Secret management

**Phần 6: Monitoring & Logging**
- Prometheus & Grafana stack
- Loki cho centralized logging
- Alerting rules & Slack integration

**Phần 7: CI/CD Pipeline** (bài này)
- GitHub Actions workflows
- DigitalOcean Container Registry
- OIDC authentication
- DevSecOps pipeline (Gitleaks, Trivy, kubeconform)
- Deployment strategies (Rolling, Blue-Green, Canary)

### Bạn bây giờ có thể:

✅ Deploy production-grade applications lên Kubernetes
✅ Manage persistent data với StatefulSets & PVs
✅ Expose applications với Ingress & TLS
✅ Secure clusters với RBAC & Network Policies
✅ Monitor clusters với Prometheus & Grafana
✅ Automate deployments với CI/CD pipelines
✅ Scan for vulnerabilities với Trivy
✅ Implement zero-downtime deployments

### Next Steps: Advanced Topics

Sau series này, bạn có thể explore các topics nâng cao:

**1. GitOps với Flux hoặc ArgoCD**
- Declarative deployment từ Git repository
- Automatic sync & drift detection
- Multi-cluster management

**2. Service Mesh với Istio/Linkerd**
- Advanced traffic management (A/B testing, traffic splitting)
- mTLS cho service-to-service encryption
- Distributed tracing với Jaeger

**3. Multi-cluster & Multi-region**
- Kubernetes Federation
- Cross-cluster service discovery
- Disaster recovery strategies

**4. Advanced Autoscaling**
- Horizontal Pod Autoscaler (HPA) với custom metrics
- Vertical Pod Autoscaler (VPA)
- Cluster Autoscaler tuning

**5. Cost Optimization**
- Right-sizing workloads
- Spot instances (DigitalOcean Droplets)
- Resource quotas & limits

**6. Advanced Security**
- Open Policy Agent (OPA) cho policy enforcement
- Falco cho runtime security monitoring
- Vulnerability scanning automation

---

## Resources & References

**Official Documentation**:
- [DigitalOcean Kubernetes](https://docs.digitalocean.com/products/kubernetes/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Argo Rollouts](https://argoproj.github.io/rollouts/)

**Tools Used**:
- [doctl CLI](https://docs.digitalocean.com/reference/doctl/)
- [kubeconform](https://github.com/yannh/kubeconform)
- [Gitleaks](https://github.com/gitleaks/gitleaks)
- [Trivy](https://github.com/aquasecurity/trivy)

**GitHub Actions**:
- [digitalocean/action-doctl](https://github.com/digitalocean/action-doctl)
- [docker/build-push-action](https://github.com/docker/build-push-action)
- [aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action)

---

## Kết luận

CI/CD không chỉ là automation - nó là **foundation của DevOps culture**: deploy nhanh, deploy an toàn, deploy thường xuyên. Với pipeline bạn đã build trong bài này, bạn có:

- **Security scanning** ở mọi stage (code, Dockerfile, image, runtime)
- **Automated testing** trước khi deploy
- **Zero-downtime deployments** với rolling updates
- **Automatic rollback** nếu có issues
- **Audit trail** của mọi deployment

**Remember**: Pipeline này là starting point. Tùy vào team size và requirements, bạn sẽ thêm nhiều stages khác: integration tests, load testing, chaos engineering, compliance scanning, etc.

**Most important**: **Iterate & improve**. Monitor pipeline metrics (success rate, duration), listen to team feedback, và continuously refine quy trình.

Cảm ơn bạn đã đồng hành cùng **DOKS Mastery Series**! Happy deploying! 🚀

---

**Bài tiếp theo**: Explore GitOps với Flux/ArgoCD (coming soon)

**Previous**: [Phần 6: Troubleshooting & Performance]({{< relref "/posts/doks-mastery/06-troubleshooting-performance" >}})
