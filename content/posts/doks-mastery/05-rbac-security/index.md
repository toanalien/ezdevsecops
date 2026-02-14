---
title: "DOKS Mastery Phần 5: RBAC, Network Policies & Bảo mật Kubernetes"
date: 2026-02-14
draft: false
description: "Bảo mật DOKS cluster với RBAC, network policies, pod security standards, OPA/Gatekeeper, Falco, và HashiCorp Vault"
categories: ["Kubernetes", "Cloud Security"]
tags: ["kubernetes", "digitalocean", "doks", "rbac", "network-policies", "pod-security", "opa", "falco", "vault", "security"]
series: ["DOKS Mastery"]
weight: 5
mermaid: true
---

## Giới thiệu

Bảo mật Kubernetes không phải là một tính năng tùy chọn - đó là yêu cầu bắt buộc. Trong môi trường production, một lỗ hổng bảo mật duy nhất có thể dẫn đến:

- **Data breach**: Rò rỉ thông tin khách hàng, credentials, hoặc dữ liệu nhạy cảm
- **Service disruption**: Tấn công DDoS, ransomware, hoặc crypto mining
- **Compliance violations**: Không đáp ứng các tiêu chuẩn như GDPR, PCI-DSS, HIPAA
- **Financial loss**: Chi phí khắc phục sự cố, tiền chuộc, và mất uy tín

### Shared Responsibility Model

Khi sử dụng DOKS (DigitalOcean Kubernetes Service), bảo mật được chia sẻ giữa DigitalOcean và bạn:

**DigitalOcean chịu trách nhiệm:**
- Control plane security (API server, etcd, scheduler, controller manager)
- Node OS patching và security updates
- Network infrastructure và DDoS protection
- Data encryption at rest cho etcd

**Bạn chịu trách nhiệm:**
- Workload security (containers, applications)
- RBAC configuration
- Network policies
- Secrets management
- Image security và vulnerability scanning
- Runtime security monitoring

{{< callout type="warning" >}}
**Lưu ý quan trọng**: DigitalOcean không thể bảo vệ bạn khỏi misconfiguration hoặc insecure application code. Bảo mật workloads là trách nhiệm của bạn!
{{< /callout >}}

### Nội dung phần này

Trong phần này, chúng ta sẽ đi sâu vào các khía cạnh bảo mật quan trọng nhất:

1. **RBAC (Role-Based Access Control)**: Quản lý ai có quyền làm gì trong cluster
2. **Network Policies**: Kiểm soát traffic giữa các pods
3. **Pod Security Standards**: Ngăn chặn containers có đặc quyền cao
4. **Secrets Management**: Bảo vệ credentials và sensitive data
5. **Image Security**: Scanning và hardening container images
6. **Policy Enforcement với OPA/Gatekeeper**: Tự động enforce best practices
7. **Runtime Security với Falco**: Phát hiện hành vi bất thường
8. **HashiCorp Vault Integration**: Quản lý secrets một cách chuyên nghiệp

## RBAC Deep Dive

RBAC (Role-Based Access Control) là cơ chế authorization chính trong Kubernetes. Thay vì gán quyền trực tiếp cho users, RBAC sử dụng roles để nhóm các permissions, sau đó bind users vào roles.

### RBAC Architecture

{{< mermaid >}}
graph LR
    A[Subject: User/ServiceAccount/Group] -->|RoleBinding| B[Role]
    B -->|Permissions| C[Resources: Pods/Deployments/Secrets]

    style A fill:#e1f5ff
    style B fill:#fff4e1
    style C fill:#ffe1e1
{{< /mermaid >}}

**Các thành phần chính:**

- **Subject**: Ai được cấp quyền? (User, ServiceAccount, Group)
- **Role/ClusterRole**: Tập hợp các permissions (verbs + resources)
- **RoleBinding/ClusterRoleBinding**: Liên kết Subject với Role

### Role vs ClusterRole

| Aspect | Role | ClusterRole |
|--------|------|-------------|
| **Scope** | Namespace-scoped | Cluster-wide |
| **Use cases** | Dev/staging environments, team-specific access | Cluster admins, monitoring tools |
| **Resources** | Pods, Services, ConfigMaps, etc. | Nodes, PersistentVolumes, Namespaces |
| **Risk level** | Lower (isolated) | Higher (global impact) |

### Tạo Role cho Developer

Tạo namespace cho dev team:

```bash
kubectl create namespace dev-team
```

Tạo file `role-dev-deployer.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: dev-deployer
  namespace: dev-team
rules:
  # Cho phép đọc/tạo/update/delete pods
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

  # Cho phép quản lý Deployments
  - apiGroups: ["apps"]
    resources: ["deployments", "replicasets"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

  # Cho phép đọc ConfigMaps (nhưng KHÔNG được delete)
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list", "watch"]

  # Cho phép đọc Services
  - apiGroups: [""]
    resources: ["services"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]

  # CHO PHÉP tạo Secrets (cẩn thận!)
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get", "list", "create"]
```

Apply role:

```bash
kubectl apply -f role-dev-deployer.yaml
```

### Tạo ServiceAccount và RoleBinding

Tạo ServiceAccount cho developer:

```bash
kubectl create serviceaccount dev-sa -n dev-team
```

Tạo file `rolebinding-dev.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-deployer-binding
  namespace: dev-team
subjects:
  # Bind cho ServiceAccount
  - kind: ServiceAccount
    name: dev-sa
    namespace: dev-team

  # Bind cho user (nếu dùng OIDC/external auth)
  # - kind: User
  #   name: john@example.com
  #   apiGroup: rbac.authorization.k8s.io

  # Bind cho group
  # - kind: Group
  #   name: dev-team-group
  #   apiGroup: rbac.authorization.k8s.io

roleRef:
  kind: Role
  name: dev-deployer
  apiGroup: rbac.authorization.k8s.io
```

Apply binding:

```bash
kubectl apply -f rolebinding-dev.yaml
```

### Tạo token cho ServiceAccount

Từ Kubernetes 1.24+, tokens không còn tự động tạo. Sử dụng TokenRequest API:

```bash
# Tạo token có thời hạn 1 giờ
kubectl create token dev-sa -n dev-team --duration=1h

# Token có thời hạn 24 giờ
kubectl create token dev-sa -n dev-team --duration=24h
```

Hoặc tạo long-lived token (không khuyến khích):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: dev-sa-token
  namespace: dev-team
  annotations:
    kubernetes.io/service-account.name: dev-sa
type: kubernetes.io/service-account-token
```

### Test RBAC permissions

Test quyền của ServiceAccount:

```bash
# Kiểm tra xem dev-sa có thể list pods không
kubectl auth can-i list pods -n dev-team --as=system:serviceaccount:dev-team:dev-sa
# Output: yes

# Kiểm tra xem dev-sa có thể delete secrets không
kubectl auth can-i delete secrets -n dev-team --as=system:serviceaccount:dev-team:dev-sa
# Output: no

# List tất cả permissions của dev-sa
kubectl auth can-i --list -n dev-team --as=system:serviceaccount:dev-team:dev-sa
```

### ClusterRole Example: Monitoring

Tạo ClusterRole cho Prometheus monitoring:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus-reader
rules:
  # Đọc metrics từ tất cả nodes
  - apiGroups: [""]
    resources: ["nodes", "nodes/metrics", "nodes/stats", "nodes/proxy"]
    verbs: ["get", "list", "watch"]

  # Đọc pods và services metrics
  - apiGroups: [""]
    resources: ["pods", "services", "endpoints"]
    verbs: ["get", "list", "watch"]

  # Đọc metrics từ API server
  - nonResourceURLs: ["/metrics", "/metrics/cadvisor"]
    verbs: ["get"]
```

ClusterRoleBinding:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus-reader-binding
subjects:
  - kind: ServiceAccount
    name: prometheus
    namespace: monitoring
roleRef:
  kind: ClusterRole
  name: prometheus-reader
  apiGroup: rbac.authorization.k8s.io
```

{{< callout type="danger" >}}
**Security Warning**: Tránh sử dụng wildcards trong RBAC rules!

❌ **BAD**: `verbs: ["*"]` hoặc `resources: ["*"]`
✅ **GOOD**: `verbs: ["get", "list", "watch"]`

Wildcards cấp quyền quá rộng và tạo ra rủi ro privilege escalation.
{{< /callout >}}

### RBAC Audit và Best Practices

**Audit existing permissions:**

```bash
# Xem tất cả RoleBindings trong namespace
kubectl get rolebindings -n dev-team

# Xem chi tiết RoleBinding
kubectl describe rolebinding dev-deployer-binding -n dev-team

# List tất cả ClusterRoleBindings
kubectl get clusterrolebindings
```

**Best Practices:**

1. **Principle of Least Privilege**: Chỉ cấp quyền tối thiểu cần thiết
2. **Namespace isolation**: Sử dụng Role thay vì ClusterRole khi có thể
3. **Avoid `cluster-admin`**: Chỉ sử dụng cho break-glass scenarios
4. **Regular audits**: Review permissions hàng tháng
5. **ServiceAccount per application**: Không share ServiceAccount giữa nhiều apps
6. **Token expiration**: Sử dụng short-lived tokens với TokenRequest API
7. **Document permissions**: Ghi chú lý do cấp từng permission

## Network Policies

Network Policies cho phép bạn kiểm soát traffic giữa các pods ở layer 3 và 4 (IP và port). DOKS sử dụng **Cilium CNI** natively, hỗ trợ đầy đủ Network Policies.

### Default Deny-All Policy

**Quan trọng nhất**: Luôn bắt đầu với default deny-all policy, sau đó explicitly allow traffic cần thiết.

Tạo file `netpol-default-deny.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all-ingress
  namespace: production
spec:
  # Apply cho tất cả pods trong namespace
  podSelector: {}

  # Chặn tất cả ingress traffic
  policyTypes:
    - Ingress

  # Không có rules nào = deny all
  # ingress: []
```

Apply policy:

```bash
kubectl create namespace production
kubectl apply -f netpol-default-deny.yaml
```

**Kết quả**: Tất cả pods trong namespace `production` sẽ KHÔNG thể nhận traffic từ bất kỳ đâu (kể cả từ pods khác trong cùng namespace).

### Allow Specific Traffic: Frontend → Backend

Giả sử bạn có kiến trúc:
- **Frontend pods**: Nhận traffic từ internet qua LoadBalancer
- **Backend API pods**: Chỉ nhận traffic từ frontend
- **Database pods**: Chỉ nhận traffic từ backend

{{< mermaid >}}
graph LR
    A[Internet] -->|port 80/443| B[Frontend Pods]
    B -->|port 8080| C[Backend Pods]
    C -->|port 5432| D[Database Pods]

    style A fill:#e1f5ff
    style B fill:#fff4e1
    style C fill:#ffe1f4
    style D fill:#e1ffe1
{{< /mermaid >}}

**1. Allow Frontend to receive traffic from LoadBalancer:**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-ingress
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: frontend

  policyTypes:
    - Ingress

  ingress:
    # Cho phép tất cả traffic vào port 80
    - from: []
      ports:
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443
```

{{< callout type="info" >}}
**Giải thích**: `from: []` với `ingress` rule có nghĩa là cho phép từ **mọi nguồn**. Điều này OK cho frontend vì nó cần public access.
{{< /callout >}}

**2. Allow Backend to receive traffic ONLY from Frontend:**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-from-frontend
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend

  policyTypes:
    - Ingress

  ingress:
    - from:
        # Chỉ cho phép từ pods có label app=frontend
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
```

**3. Allow Database to receive traffic ONLY from Backend:**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-db-from-backend
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: database

  policyTypes:
    - Ingress

  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: backend
      ports:
        - protocol: TCP
          port: 5432
```

### Egress Policies: Kiểm soát Outbound Traffic

Mặc định, pods có thể gửi traffic đến bất kỳ đâu. Bạn có thể hạn chế điều này:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-egress-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend

  policyTypes:
    - Egress

  egress:
    # Cho phép DNS resolution
    - to:
        - namespaceSelector:
            matchLabels:
              name: kube-system
      ports:
        - protocol: UDP
          port: 53

    # Cho phép kết nối tới database
    - to:
        - podSelector:
            matchLabels:
              app: database
      ports:
        - protocol: TCP
          port: 5432

    # Cho phép HTTPS ra external APIs (ví dụ: payment gateway)
    - to:
        - namespaceSelector: {}
      ports:
        - protocol: TCP
          port: 443
```

### Cross-Namespace Communication

Cho phép pods từ namespace `monitoring` scrape metrics từ namespace `production`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-monitoring-scrape
  namespace: production
spec:
  podSelector:
    matchLabels:
      metrics: enabled

  policyTypes:
    - Ingress

  ingress:
    - from:
        # Cho phép từ namespace monitoring
        - namespaceSelector:
            matchLabels:
              name: monitoring
          podSelector:
            matchLabels:
              app: prometheus
      ports:
        - protocol: TCP
          port: 9090
```

**Lưu ý**: Bạn cần label namespace trước:

```bash
kubectl label namespace monitoring name=monitoring
```

### Testing Network Policies

Deploy test pods để verify policies:

```bash
# Deploy frontend
kubectl run frontend --image=nginx --labels=app=frontend -n production

# Deploy backend
kubectl run backend --image=nginx --labels=app=backend -n production

# Test từ frontend → backend (should work)
kubectl exec -it frontend -n production -- curl http://backend:8080

# Test từ frontend → database (should FAIL)
kubectl exec -it frontend -n production -- curl http://database:5432
```

{{< callout type="warning" >}}
**Cilium-specific features**: DOKS sử dụng Cilium CNI, hỗ trợ:
- Layer 7 (HTTP) filtering
- DNS-based policies
- Cluster mesh (multi-cluster networking)

Bạn có thể sử dụng `CiliumNetworkPolicy` CRD cho advanced use cases. Xem [Cilium docs](https://docs.cilium.io/en/stable/policy/).
{{< /callout >}}

### Network Policy Best Practices

1. **Default deny first**: Luôn tạo default deny-all policy
2. **Explicit allow**: Chỉ allow traffic thực sự cần thiết
3. **Label-based selection**: Sử dụng labels rõ ràng, dễ hiểu
4. **Test thoroughly**: Verify policies không block legitimate traffic
5. **Monitor violations**: Sử dụng Cilium/Hubble để monitor dropped packets
6. **Document policies**: Ghi chú lý do cho mỗi policy rule

## Pod Security Standards

Pod Security Standards (PSS) là cơ chế thay thế cho PodSecurityPolicy (deprecated từ K8s 1.21, removed ở 1.25). PSS định nghĩa 3 security profiles:

| Profile | Use Case | Restrictions |
|---------|----------|--------------|
| **Privileged** | System/infrastructure workloads | No restrictions (dangerous!) |
| **Baseline** | Common workloads | Minimal restrictions, block known privilege escalations |
| **Restricted** | Security-critical workloads | Heavily restricted, following hardening best practices |

### Enforcing Pod Security Standards

DOKS hỗ trợ PSS thông qua Pod Security Admission controller (enabled by default từ K8s 1.23+).

**Enforce restricted mode cho production namespace:**

```bash
kubectl label namespace production \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/warn=restricted
```

**Modes:**
- `enforce`: Block pods vi phạm policy
- `audit`: Log violations (không block)
- `warn`: Show warnings cho users (không block)

### Restricted SecurityContext Example

Tạo file `pod-secure.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
  namespace: production
spec:
  # SecurityContext ở pod-level
  securityContext:
    # Chạy với non-root user
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000

    # Seccomp profile (restrict syscalls)
    seccompProfile:
      type: RuntimeDefault

  containers:
    - name: app
      image: nginx:1.25-alpine

      # SecurityContext ở container-level
      securityContext:
        # Không cho phép privilege escalation
        allowPrivilegeEscalation: false

        # Drop ALL capabilities, chỉ giữ lại những gì cần
        capabilities:
          drop:
            - ALL
          # add:
          #   - NET_BIND_SERVICE  # Nếu cần bind port < 1024

        # Read-only root filesystem
        readOnlyRootFilesystem: true

        # Chạy với non-root user
        runAsNonRoot: true
        runAsUser: 1000

      # Vì root filesystem là read-only, mount volumes cho writable dirs
      volumeMounts:
        - name: cache
          mountPath: /var/cache/nginx
        - name: run
          mountPath: /var/run

  volumes:
    - name: cache
      emptyDir: {}
    - name: run
      emptyDir: {}
```

Apply pod:

```bash
kubectl apply -f pod-secure.yaml
```

### Violating Pod Security

Thử tạo pod vi phạm restricted policy:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: insecure-app
  namespace: production
spec:
  containers:
    - name: app
      image: nginx
      securityContext:
        privileged: true  # ❌ Vi phạm restricted policy!
```

Kết quả:

```bash
kubectl apply -f pod-insecure.yaml
# Error: pods "insecure-app" is forbidden: violates PodSecurity "restricted:latest":
# privileged (container "app" must not set securityContext.privileged=true)
```

{{< callout type="danger" >}}
**Privileged containers = root access to host!**

Privileged containers có thể:
- Mount host filesystems
- Access host network interfaces
- Load kernel modules
- Escape to host OS

**NEVER** run untrusted workloads as privileged!
{{< /callout >}}

### Security Best Practices for Pods

**Checklist:**

- ✅ `runAsNonRoot: true` (container không chạy với UID 0)
- ✅ `allowPrivilegeEscalation: false`
- ✅ `capabilities.drop: [ALL]` (drop tất cả Linux capabilities)
- ✅ `readOnlyRootFilesystem: true` (ngăn ghi vào container filesystem)
- ✅ `seccompProfile.type: RuntimeDefault` (restrict syscalls)
- ✅ Resource limits (CPU/memory) để ngăn DoS
- ✅ Liveness/readiness probes

## Secrets Management

Kubernetes Secrets lưu sensitive data (passwords, tokens, keys) dưới dạng base64-encoded (NOT encrypted by default).

### Native K8s Secrets: Limitations

**Tạo secret:**

```bash
# Từ literal values
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=MyS3cr3tP@ssw0rd \
  -n production

# Từ file
echo -n 'admin' > username.txt
echo -n 'MyS3cr3tP@ssw0rd' > password.txt
kubectl create secret generic db-credentials \
  --from-file=username=username.txt \
  --from-file=password=password.txt \
  -n production
```

**Sử dụng trong Pod:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-secrets
spec:
  containers:
    - name: app
      image: myapp:1.0
      env:
        # Inject từng key
        - name: DB_USERNAME
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: username

        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password

      # Hoặc mount toàn bộ secret như files
      volumeMounts:
        - name: db-creds
          mountPath: /etc/secrets
          readOnly: true

  volumes:
    - name: db-creds
      secret:
        secretName: db-credentials
```

**Limitations:**

1. **Base64 != Encryption**: Bất kỳ ai có quyền `get secrets` đều đọc được plaintext
2. **No rotation**: Phải manual update secrets và restart pods
3. **No audit**: Không biết ai đã access secret khi nào
4. **etcd exposure**: Nếu etcd backup bị leak, tất cả secrets bị lộ

{{< callout type="info" >}}
**DOKS encrypts etcd at rest**: DigitalOcean tự động encrypt etcd data-at-rest với AES-256. Tuy nhiên, secrets vẫn plaintext khi:
- API server trả về cho clients có quyền
- Pods mount secrets như env vars hoặc volumes
{{< /callout >}}

### Secrets Best Practices

1. **RBAC**: Hạn chế `get/list secrets` permissions
2. **Namespace isolation**: Secrets không share giữa namespaces
3. **Least privilege**: Pods chỉ mount secrets thực sự cần
4. **No env vars**: Prefer volume mounts (env vars có thể leak qua logs)
5. **External secret stores**: Sử dụng Vault, AWS Secrets Manager, etc.

### External Secrets Overview

Thay vì lưu secrets trong Kubernetes, lưu trong external vault và inject vào runtime:

| Solution | Pros | Cons |
|----------|------|------|
| **HashiCorp Vault** | Feature-rich, dynamic secrets, audit logs | Complex setup |
| **External Secrets Operator** | Supports multiple backends (AWS/GCP/Azure) | Requires external service |
| **Sealed Secrets** | GitOps-friendly, encrypted in Git | No rotation |
| **SOPS** | Simple, file-based encryption | Manual workflow |

Chúng ta sẽ implement **HashiCorp Vault** ở phần sau.

## Image Security

Container images có thể chứa vulnerabilities (CVEs), malware, hoặc outdated dependencies. Image security là first line of defense.

### Vulnerability Scanning với Trivy

**Cài đặt Trivy:**

```bash
# macOS
brew install aquasecurity/trivy/trivy

# Linux
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy
```

**Scan image:**

```bash
# Scan public image
trivy image nginx:1.25-alpine

# Scan với severity filter (chỉ show CRITICAL/HIGH)
trivy image --severity CRITICAL,HIGH nginx:1.25-alpine

# Scan image từ private registry
trivy image registry.digitalocean.com/myregistry/myapp:v1.0
```

**Output mẫu:**

```text
nginx:1.25-alpine (alpine 3.18.4)
===================================
Total: 2 (CRITICAL: 1, HIGH: 1, MEDIUM: 0, LOW: 0)

┌─────────────┬─────────────────┬──────────┬───────────────────┬───────────────┬─────────────────────────────────┐
│   Library   │  Vulnerability  │ Severity │ Installed Version │ Fixed Version │             Title               │
├─────────────┼─────────────────┼──────────┼───────────────────┼───────────────┼─────────────────────────────────┤
│ openssl     │ CVE-2023-12345  │ CRITICAL │ 3.1.2-r0          │ 3.1.3-r0      │ OpenSSL: Remote Code Execution  │
│ libcurl     │ CVE-2023-67890  │ HIGH     │ 8.4.0-r0          │ 8.5.0-r0      │ curl: Buffer Overflow           │
└─────────────┴─────────────────┴──────────┴───────────────────┴───────────────┴─────────────────────────────────┘
```

### DigitalOcean Container Registry Scanning

DOCR (DigitalOcean Container Registry) có built-in vulnerability scanning:

```bash
# Enable scanning cho registry
doctl registry configure

# Push image
docker tag myapp:v1.0 registry.digitalocean.com/myregistry/myapp:v1.0
docker push registry.digitalocean.com/myregistry/myapp:v1.0

# Xem scan results trong DigitalOcean Console
# hoặc dùng doctl
doctl registry repository list-tags myregistry/myapp
```

### Image Security Best Practices

**1. Use minimal base images:**

```dockerfile
# ❌ BAD: Large attack surface
FROM ubuntu:22.04

# ✅ GOOD: Minimal Alpine
FROM alpine:3.18

# ✅ BETTER: Distroless (no shell, no package manager)
FROM gcr.io/distroless/static-debian11
```

**2. Multi-stage builds để giảm final image size:**

```dockerfile
# Stage 1: Build
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Stage 2: Runtime
FROM alpine:3.18
COPY --from=builder /app/myapp /usr/local/bin/
CMD ["myapp"]
```

**3. Never use `latest` tag:**

```yaml
# ❌ BAD
image: nginx:latest

# ✅ GOOD: Pinned version
image: nginx:1.25.3-alpine

# ✅ BETTER: SHA256 digest (immutable)
image: nginx@sha256:abcd1234...
```

{{< callout type="danger" >}}
**`latest` tag risks:**
- Non-deterministic deployments
- Rolling back khó khăn
- Security vulnerabilities khi upstream update
- Build reproducibility issues
{{< /callout >}}

**4. Scan images trong CI/CD pipeline:**

```yaml
# GitHub Actions example
name: Security Scan
on: [push]

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build image
        run: docker build -t myapp:${{ github.sha }} .

      - name: Run Trivy scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:${{ github.sha }}
          severity: 'CRITICAL,HIGH'
          exit-code: 1  # Fail build nếu có vulns
```

**5. Image pull policies:**

```yaml
spec:
  containers:
    - name: app
      image: myapp:v1.0
      imagePullPolicy: Always  # Always pull để đảm bảo latest scanned image
```

## OPA/Gatekeeper: Policy Enforcement

OPA (Open Policy Adapter) + Gatekeeper cho phép bạn enforce policies **before** resources được tạo trong cluster. Ví dụ:
- Chặn containers chạy với root user
- Bắt buộc tất cả images phải từ trusted registry
- Require resource limits
- Enforce naming conventions

### Cài đặt Gatekeeper

```bash
# Add Helm repo
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update

# Install Gatekeeper
helm install gatekeeper gatekeeper/gatekeeper \
  --namespace gatekeeper-system \
  --create-namespace \
  --set audit.replicas=1 \
  --set validatingWebhookTimeoutSeconds=5
```

Verify installation:

```bash
kubectl get pods -n gatekeeper-system
# NAME                                             READY   STATUS
# gatekeeper-audit-5d7f8c7b9f-xxxxx                1/1     Running
# gatekeeper-controller-manager-xxxxxx-xxxxx       1/1     Running
```

### ConstraintTemplate: Define Policy Logic

Tạo file `template-require-labels.yaml`:

```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredlabels
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredLabels
      validation:
        openAPIV3Schema:
          type: object
          properties:
            labels:
              type: array
              items:
                type: string

  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredlabels

        violation[{"msg": msg, "details": {"missing_labels": missing}}] {
          provided := {label | input.review.object.metadata.labels[label]}
          required := {label | label := input.parameters.labels[_]}
          missing := required - provided
          count(missing) > 0
          msg := sprintf("You must provide labels: %v", [missing])
        }
```

Apply template:

```bash
kubectl apply -f template-require-labels.yaml
```

### Constraint: Enforce Policy

Tạo file `constraint-pod-labels.yaml`:

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata:
  name: pod-must-have-labels
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    namespaces:
      - production

  parameters:
    labels:
      - app
      - environment
      - owner
```

Apply constraint:

```bash
kubectl apply -f constraint-pod-labels.yaml
```

### Test Policy Enforcement

Thử tạo pod không có labels:

```bash
kubectl run test-pod --image=nginx -n production
# Error from server (Forbidden): admission webhook "validation.gatekeeper.sh" denied the request:
# [pod-must-have-labels] You must provide labels: {"app", "environment", "owner"}
```

Tạo pod với đủ labels:

```bash
kubectl run test-pod --image=nginx -n production \
  --labels=app=nginx,environment=production,owner=devops-team
# pod/test-pod created
```

### More Policy Examples

**Require images from trusted registry:**

```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8strustedimages
spec:
  crd:
    spec:
      names:
        kind: K8sTrustedImages
      validation:
        openAPIV3Schema:
          type: object
          properties:
            registries:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8strustedimages

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not startswith(container.image, input.parameters.registries[_])
          msg := sprintf("Image '%v' not from trusted registry", [container.image])
        }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sTrustedImages
metadata:
  name: trusted-images-only
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
  parameters:
    registries:
      - "registry.digitalocean.com/myregistry/"
      - "gcr.io/myproject/"
```

{{< callout type="info" >}}
**Gatekeeper vs Kyverno**: Cả hai đều là policy engines. Gatekeeper dùng Rego (từ OPA), Kyverno dùng YAML-based policies (dễ học hơn). Chọn tool phù hợp với team bạn.
{{< /callout >}}

## Falco: Runtime Security Monitoring

Falco phát hiện anomalous behavior trong runtime, ví dụ:
- Shell spawned trong container
- Sensitive file access (/etc/passwd, /etc/shadow)
- Outbound connections tới suspicious IPs
- Privilege escalation attempts

### Cài đặt Falco trên DOKS

```bash
# Add Helm repo
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

# Install Falco
helm install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  --set driver.kind=modern_ebpf \
  --set tty=true
```

**Lưu ý**: DOKS kernel hỗ trợ eBPF driver (modern_ebpf), không cần kernel module.

Verify installation:

```bash
kubectl get pods -n falco
# NAME          READY   STATUS    RESTARTS   AGE
# falco-xxxxx   1/1     Running   0          2m
```

### Falco Default Rules

Xem logs để thấy alerts:

```bash
kubectl logs -n falco -l app.kubernetes.io/name=falco -f
```

**Trigger test alert:**

```bash
# Tạo pod
kubectl run test-pod --image=nginx -n production

# Exec vào pod và chạy shell command (triggers Falco rule)
kubectl exec -it test-pod -n production -- /bin/sh
ls /etc
cat /etc/passwd
```

**Falco alert:**

```json
{
  "output": "Notice A shell was spawned in a container with an attached terminal (user=root user_loginuid=-1 k8s.ns=production k8s.pod=test-pod container=test-pod shell=sh parent=runc cmdline=sh terminal=34816 container_id=abcd1234)",
  "priority": "Notice",
  "rule": "Terminal shell in container",
  "time": "2026-02-14T10:30:45.123456789Z",
  "output_fields": {
    "container.id": "abcd1234",
    "k8s.ns.name": "production",
    "k8s.pod.name": "test-pod"
  }
}
```

### Custom Falco Rules

Tạo ConfigMap với custom rules:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: falco-custom-rules
  namespace: falco
data:
  custom-rules.yaml: |
    - rule: Unauthorized Network Connection
      desc: Detect outbound connection to suspicious IP
      condition: >
        outbound and
        fd.sip in (suspicious_ips)
      output: >
        Suspicious outbound connection
        (user=%user.name command=%proc.cmdline connection=%fd.name)
      priority: WARNING
      tags: [network, suspicious]

    - list: suspicious_ips
      items: ["192.0.2.1", "198.51.100.0/24"]

    - rule: Write to /etc Directory
      desc: Detect write attempts to /etc
      condition: >
        open_write and
        fd.name startswith /etc
      output: >
        File below /etc opened for writing
        (user=%user.name command=%proc.cmdline file=%fd.name)
      priority: ERROR
      tags: [filesystem, persistence]
```

Update Falco to load custom rules:

```bash
helm upgrade falco falcosecurity/falco \
  --namespace falco \
  --reuse-values \
  --set customRules.custom-rules\.yaml="$(kubectl get cm falco-custom-rules -n falco -o jsonpath='{.data.custom-rules\.yaml}')"
```

### Falco Alerts Integration

**Forward alerts to Slack/PagerDuty:**

Falco hỗ trợ [Falcosidekick](https://github.com/falcosecurity/falcosidekick) để forward alerts tới 50+ outputs:

```bash
helm install falcosidekick falcosecurity/falcosidekick \
  --namespace falco \
  --set config.slack.webhookurl="https://hooks.slack.com/services/YOUR/WEBHOOK/URL" \
  --set config.slack.minimumpriority="warning"

# Update Falco to send alerts to Falcosidekick
helm upgrade falco falcosecurity/falco \
  --namespace falco \
  --reuse-values \
  --set falcosidekick.enabled=true \
  --set falcosidekick.fullfqdn=falcosidekick:2801
```

## HashiCorp Vault Integration

Vault là enterprise-grade secrets management solution với features:
- **Dynamic secrets**: Tạo credentials on-demand, auto-revoke
- **Encryption-as-a-Service**: Encrypt/decrypt data mà không lưu secrets
- **Audit logs**: Track mọi secret access
- **Leasing & Renewal**: Secrets có TTL, tự động rotate

### Cài đặt Vault trên DOKS

```bash
# Add HashiCorp Helm repo
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

# Install Vault in dev mode (HA mode requires Consul/Raft backend)
helm install vault hashicorp/vault \
  --namespace vault \
  --create-namespace \
  --set server.dev.enabled=true \
  --set ui.enabled=true \
  --set ui.serviceType=LoadBalancer
```

{{< callout type="warning" >}}
**Dev mode warning**: `server.dev.enabled=true` chỉ dùng cho testing! Production cần HA mode với persistent storage và auto-unseal.
{{< /callout >}}

Wait for LoadBalancer:

```bash
kubectl get svc -n vault vault-ui
# NAME       TYPE           EXTERNAL-IP       PORT(S)
# vault-ui   LoadBalancer   143.198.123.45    8200:30000/TCP
```

Access Vault UI: `http://143.198.123.45:8200`

**Root token (dev mode)**: `root`

### Enable Kubernetes Auth Method

```bash
# Exec vào Vault pod
kubectl exec -it vault-0 -n vault -- /bin/sh

# Login với root token
vault login root

# Enable Kubernetes auth
vault auth enable kubernetes

# Configure Kubernetes auth
vault write auth/kubernetes/config \
  kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"

# Exit pod
exit
```

### Lưu Secrets vào Vault

```bash
# Enable KV secrets engine
kubectl exec -it vault-0 -n vault -- vault secrets enable -path=secret kv-v2

# Lưu database credentials
kubectl exec -it vault-0 -n vault -- vault kv put secret/database/config \
  username="admin" \
  password="MyS3cr3tP@ssw0rd"

# Đọc secret
kubectl exec -it vault-0 -n vault -- vault kv get secret/database/config
```

### Tạo Vault Policy

```bash
kubectl exec -it vault-0 -n vault -- sh -c 'cat <<EOF | vault policy write myapp-policy -
path "secret/data/database/config" {
  capabilities = ["read"]
}
EOF'
```

### Bind Policy tới Kubernetes ServiceAccount

```bash
# Tạo role liên kết K8s ServiceAccount với Vault policy
kubectl exec -it vault-0 -n vault -- vault write auth/kubernetes/role/myapp \
  bound_service_account_names=myapp-sa \
  bound_service_account_namespaces=production \
  policies=myapp-policy \
  ttl=24h
```

### Inject Secrets vào Pods

Tạo ServiceAccount:

```bash
kubectl create serviceaccount myapp-sa -n production
```

Tạo file `pod-with-vault.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-with-vault
  namespace: production
  annotations:
    # Vault Agent Injector annotations
    vault.hashicorp.com/agent-inject: "true"
    vault.hashicorp.com/role: "myapp"
    vault.hashicorp.com/agent-inject-secret-database-config.txt: "secret/data/database/config"
    vault.hashicorp.com/agent-inject-template-database-config.txt: |
      {{- with secret "secret/data/database/config" -}}
      export DB_USERNAME="{{ .Data.data.username }}"
      export DB_PASSWORD="{{ .Data.data.password }}"
      {{- end }}
spec:
  serviceAccountName: myapp-sa
  containers:
    - name: app
      image: nginx:alpine
      command: ["/bin/sh"]
      args:
        - -c
        - |
          source /vault/secrets/database-config.txt
          echo "DB_USERNAME: $DB_USERNAME"
          # App code sử dụng $DB_USERNAME và $DB_PASSWORD
          tail -f /dev/null
```

Apply pod:

```bash
kubectl apply -f pod-with-vault.yaml
```

Verify secrets được inject:

```bash
# Check pod có 2 containers (app + vault-agent sidecar)
kubectl get pod myapp-with-vault -n production
# NAME                READY   STATUS    RESTARTS   AGE
# myapp-with-vault    2/2     Running   0          30s

# Xem secret được inject
kubectl exec -it myapp-with-vault -n production -c app -- cat /vault/secrets/database-config.txt
# export DB_USERNAME="admin"
# export DB_PASSWORD="MyS3cr3tP@ssw0rd"
```

{{< callout type="info" >}}
**Vault Agent Injector**: Tự động inject vault-agent sidecar container vào pod. Sidecar authenticate với Vault, fetch secrets, và write vào shared volume `/vault/secrets/`.
{{< /callout >}}

### Vault Best Practices

1. **HA mode**: Production cần 3+ Vault replicas với Raft/Consul backend
2. **Auto-unseal**: Sử dụng cloud KMS (AWS/GCP/Azure) để auto-unseal
3. **TLS everywhere**: Enable TLS cho Vault API
4. **Audit logs**: Enable audit logging
5. **Dynamic secrets**: Sử dụng database engine cho dynamic DB credentials
6. **Regular backups**: Backup Vault data thường xuyên

## Security Checklist & Tổng kết

### Comprehensive Security Checklist

**RBAC & Authentication:**
- [ ] Enable RBAC cho tất cả namespaces
- [ ] Tạo namespace-scoped Roles (không dùng ClusterRole trừ khi cần thiết)
- [ ] Avoid wildcards trong RBAC rules
- [ ] ServiceAccount per application
- [ ] Short-lived tokens với TokenRequest API
- [ ] Regular RBAC audits (monthly)
- [ ] Document tất cả permissions

**Network Policies:**
- [ ] Default deny-all ingress policy cho production namespaces
- [ ] Explicit allow rules cho legitimate traffic
- [ ] Egress policies để restrict outbound connections
- [ ] Test policies thoroughly trước khi enforce
- [ ] Monitor network policy violations với Cilium/Hubble

**Pod Security:**
- [ ] Enforce Pod Security Standards (restricted cho production)
- [ ] `runAsNonRoot: true` cho tất cả containers
- [ ] `allowPrivilegeEscalation: false`
- [ ] Drop ALL capabilities, chỉ add khi cần thiết
- [ ] `readOnlyRootFilesystem: true`
- [ ] `seccompProfile: RuntimeDefault`
- [ ] Resource limits (CPU/memory)
- [ ] Liveness/readiness probes

**Secrets Management:**
- [ ] Restrict RBAC permissions cho secrets
- [ ] Không commit secrets vào Git
- [ ] Sử dụng external secrets (Vault, External Secrets Operator)
- [ ] Rotate secrets regularly
- [ ] Audit secret access

**Image Security:**
- [ ] Scan tất cả images với Trivy/Grype
- [ ] Fail builds nếu có CRITICAL/HIGH vulns
- [ ] Sử dụng minimal base images (Alpine/Distroless)
- [ ] Pin image versions (no `latest` tag)
- [ ] Multi-stage builds để giảm image size
- [ ] Sign images với Cosign/Notary
- [ ] `imagePullPolicy: Always`

**Policy Enforcement:**
- [ ] Deploy OPA Gatekeeper hoặc Kyverno
- [ ] Require labels cho tất cả resources
- [ ] Enforce trusted registries
- [ ] Require resource limits
- [ ] Block privileged containers
- [ ] Enforce naming conventions

**Runtime Security:**
- [ ] Deploy Falco hoặc Tetragon
- [ ] Configure custom rules cho use cases của bạn
- [ ] Forward alerts tới Slack/PagerDuty
- [ ] Regular review Falco logs

**Compliance & Audit:**
- [ ] Enable Kubernetes audit logging
- [ ] Export audit logs ra SIEM
- [ ] Regular security reviews (quarterly)
- [ ] Penetration testing (annual)
- [ ] Compliance scans (CIS Benchmark)

### Tổng kết

Security là một **journey, không phải destination**. Bạn không thể "hoàn thành" security một lần rồi quên đi - threats luôn evolve, và security posture cần được review và improve liên tục.

**Key takeaways:**

1. **Defense in depth**: Nhiều layers of security (RBAC + Network Policies + Pod Security + Runtime monitoring)
2. **Principle of least privilege**: Chỉ cấp quyền tối thiểu cần thiết
3. **Automation**: Sử dụng tools (Gatekeeper, Falco, Trivy) để enforce policies tự động
4. **Visibility**: Monitor và audit mọi thứ
5. **Education**: Train team về security best practices

### Các bước tiếp theo

- **Part 6: Troubleshooting & Performance Tuning**: Debug cluster issues, optimize resource usage, performance profiling
- **Part 7: CI/CD Integration**: GitOps với ArgoCD/Flux, automated deployments, rollback strategies

---

**Tài liệu tham khảo:**
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/security-checklist/)
- [RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Cilium Network Policies](https://docs.cilium.io/en/stable/policy/)
- [OPA Gatekeeper](https://open-policy-agent.github.io/gatekeeper/)
- [Falco Rules](https://falco.org/docs/rules/)
- [HashiCorp Vault K8s Integration](https://developer.hashicorp.com/vault/docs/platform/k8s)

{{< callout type="info" >}}
**Questions?** Hãy comment bên dưới hoặc join [DOKS Community Forum](https://www.digitalocean.com/community/tags/kubernetes)!
{{< /callout >}}
