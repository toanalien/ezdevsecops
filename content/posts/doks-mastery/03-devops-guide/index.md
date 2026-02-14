---
title: "DOKS Mastery Phần 3: Hướng dẫn cho DevOps Engineer"
date: 2026-02-14
draft: false
description: "Infrastructure-as-Code với Terraform, thiết kế High Availability, chiến lược Namespace, và tự động hóa trên DOKS"
categories: ["Kubernetes", "Infrastructure"]
tags: ["kubernetes", "digitalocean", "doks", "devops", "terraform", "helm", "kustomize", "gitops", "high-availability"]
series: ["DOKS Mastery"]
weight: 3
mermaid: true
---

## Giới thiệu

Trong hệ sinh thái Kubernetes, DevOps Engineer đóng vai trò then chốt trong việc xây dựng và duy trì infrastructure một cách hiệu quả, đáng tin cậy, và có khả năng mở rộng. Bạn chịu trách nhiệm về:

- **Infrastructure-as-Code (IaC)**: Quản lý cluster và resources thông qua code, đảm bảo tính nhất quán và khả năng tái tạo
- **High Availability**: Thiết kế hệ thống có khả năng chịu lỗi, tránh single point of failure
- **Automation**: Tự động hóa deployment, scaling, và operations để giảm thiểu lỗi thủ công
- **Resource Management**: Tối ưu hóa chi phí và performance thông qua quản lý resources hiệu quả

Trong phần này, chúng ta sẽ đi sâu vào các kỹ thuật và best practices giúp bạn vận hành DOKS cluster một cách chuyên nghiệp.

## Infrastructure-as-Code với Terraform

### Tại sao sử dụng Terraform?

Terraform cho phép bạn định nghĩa toàn bộ infrastructure thông qua code, mang lại nhiều lợi ích:

- **Version Control**: Track changes qua Git
- **Reproducibility**: Tạo lại infrastructure giống hệt nhau ở bất kỳ đâu
- **Documentation**: Code chính là documentation
- **Collaboration**: Team có thể review và approve thông qua Pull Requests

### Setup DigitalOcean Terraform Provider

Đầu tiên, tạo file `versions.tf` để khai báo provider:

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.34.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}
```

Tạo file `variables.tf`:

```hcl
variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Name of the DOKS cluster"
  type        = string
  default     = "production-cluster"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "sgp1"
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.2-do.0"
}
```

### DOKS Cluster Resource Configuration

Tạo file `main.tf` với cấu hình cluster đầy đủ:

```hcl
# VPC for cluster isolation
resource "digitalocean_vpc" "k8s_vpc" {
  name     = "${var.cluster_name}-vpc"
  region   = var.region
  ip_range = "10.10.0.0/16"
}

# DOKS Cluster
resource "digitalocean_kubernetes_cluster" "primary" {
  name    = var.cluster_name
  region  = var.region
  version = var.k8s_version
  vpc_uuid = digitalocean_vpc.k8s_vpc.id

  # Auto-upgrade settings
  auto_upgrade = true
  surge_upgrade = true

  # Maintenance window
  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  # System node pool (critical workloads)
  node_pool {
    name       = "system-pool"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 4

    labels = {
      node-type = "system"
      workload  = "critical"
    }

    taint {
      key    = "workload-type"
      value  = "system"
      effect = "NoSchedule"
    }
  }

  tags = ["production", "k8s", "managed"]
}

# Application node pool (user workloads)
resource "digitalocean_kubernetes_node_pool" "app_pool" {
  cluster_id = digitalocean_kubernetes_cluster.primary.id

  name       = "app-pool"
  size       = "s-4vcpu-8gb"
  auto_scale = true
  min_nodes  = 3
  max_nodes  = 10

  labels = {
    node-type = "application"
    workload  = "general"
  }

  tags = ["production", "app-workload"]
}

# High-memory node pool (databases, caches)
resource "digitalocean_kubernetes_node_pool" "memory_pool" {
  cluster_id = digitalocean_kubernetes_cluster.primary.id

  name       = "memory-pool"
  size       = "s-2vcpu-8gb-intel"
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 3

  labels = {
    node-type = "memory-optimized"
    workload  = "database"
  }

  taint {
    key    = "workload-type"
    value  = "database"
    effect = "NoSchedule"
  }

  tags = ["production", "memory-intensive"]
}
```

Tạo file `outputs.tf`:

```hcl
output "cluster_id" {
  description = "DOKS Cluster ID"
  value       = digitalocean_kubernetes_cluster.primary.id
}

output "cluster_endpoint" {
  description = "DOKS Cluster API endpoint"
  value       = digitalocean_kubernetes_cluster.primary.endpoint
}

output "cluster_status" {
  description = "DOKS Cluster status"
  value       = digitalocean_kubernetes_cluster.primary.status
}

output "kubeconfig" {
  description = "Kubeconfig for cluster access"
  value       = digitalocean_kubernetes_cluster.primary.kube_config[0].raw_config
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID for the cluster"
  value       = digitalocean_vpc.k8s_vpc.id
}
```

### Terraform Workflow

Tạo file `terraform.tfvars`:

```hcl
do_token     = "dop_v1_your_token_here"
cluster_name = "production-doks"
region       = "sgp1"
k8s_version  = "1.28.2-do.0"
```

{{< callout type="warning" >}}
**Bảo mật Token**: Không commit file `terraform.tfvars` vào Git. Thêm vào `.gitignore`:
```
terraform.tfvars
*.tfstate
*.tfstate.backup
.terraform/
```
{{< /callout >}}

Khởi tạo và apply Terraform:

```bash
# Initialize Terraform (download providers)
terraform init

# Validate configuration syntax
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# Save kubeconfig
terraform output -raw kubeconfig > ~/.kube/config-doks
export KUBECONFIG=~/.kube/config-doks

# Verify cluster access
kubectl cluster-info
kubectl get nodes
```

### State Management Best Practices

{{< callout type="tip" >}}
**Remote State Storage**: Trong production, luôn sử dụng remote backend để lưu trữ state:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "doks/production/terraform.tfstate"
    region = "sgp1"
    endpoint = "sgp1.digitaloceanspaces.com"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
```

Hoặc sử dụng Terraform Cloud cho state management tự động.
{{< /callout >}}

## Thiết kế High Availability

High Availability (HA) đảm bảo ứng dụng của bạn luôn sẵn sàng phục vụ, ngay cả khi có sự cố xảy ra.

### Multi-Node Pool Strategy

DOKS hỗ trợ nhiều node pools với các mục đích khác nhau:

**1. System Node Pool** - Chạy critical system components:
- CoreDNS, kube-proxy
- Ingress controllers
- Monitoring agents (Prometheus, Datadog)
- Sử dụng taints để tránh user workloads

**2. Application Node Pool** - Chạy application workloads:
- Web servers, APIs
- Background workers
- General purpose workloads
- Auto-scaling theo traffic

**3. Specialized Pools** - Workloads đặc biệt:
- Memory-optimized: Databases, Redis, Elasticsearch
- CPU-optimized: Machine learning, video processing
- GPU nodes: AI/ML training (nếu cần)

Quản lý node pools qua DigitalOcean Console:

1. Truy cập **Kubernetes** → chọn cluster
2. Chuyển sang tab **Node Pools**
3. Click **Add Node Pool**
4. Cấu hình: name, droplet size, count, auto-scaling, labels, taints
5. Click **Add Node Pool**

{{< mermaid >}}
graph TB
    subgraph "High Availability Architecture"
        LB[Load Balancer]

        subgraph "System Pool"
            SN1[System Node 1<br/>Ingress + CoreDNS]
            SN2[System Node 2<br/>Ingress + CoreDNS]
        end

        subgraph "App Pool"
            AN1[App Node 1<br/>Pod Replicas]
            AN2[App Node 2<br/>Pod Replicas]
            AN3[App Node 3<br/>Pod Replicas]
        end

        subgraph "Memory Pool"
            MN1[Memory Node 1<br/>Redis Primary]
            MN2[Memory Node 2<br/>Redis Replica]
        end

        LB --> SN1
        LB --> SN2
        SN1 --> AN1
        SN1 --> AN2
        SN2 --> AN2
        SN2 --> AN3
        AN1 -.-> MN1
        AN2 -.-> MN1
        AN3 -.-> MN2
        MN1 <-.replication.-> MN2
    end
{{< /mermaid >}}

### Pod Disruption Budgets (PDB)

PDB đảm bảo số lượng pods tối thiểu luôn available trong quá trình maintenance:

```yaml
# pdb-api-deployment.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
  namespace: production
spec:
  minAvailable: 2  # Luôn có ít nhất 2 pods running
  selector:
    matchLabels:
      app: api
      tier: backend
---
# Hoặc sử dụng maxUnavailable
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: worker-pdb
  namespace: production
spec:
  maxUnavailable: 1  # Chỉ cho phép tối đa 1 pod down
  selector:
    matchLabels:
      app: worker
      tier: processing
```

Apply PDB:

```bash
kubectl apply -f pdb-api-deployment.yaml
kubectl get pdb -n production
kubectl describe pdb api-pdb -n production
```

### Anti-Affinity Rules

Anti-affinity đảm bảo pods được phân tán trên các nodes khác nhau, tránh single point of failure:

```yaml
# deployment-with-anti-affinity.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
        tier: frontend
    spec:
      # Pod Anti-Affinity - phân tán pods ra các nodes khác nhau
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - web-app
            topologyKey: kubernetes.io/hostname

        # Node Affinity - ưu tiên schedule vào app-pool
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: node-type
                operator: In
                values:
                - application

      containers:
      - name: web
        image: nginx:1.25-alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"

        # Health checks
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10

        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
```

Apply và verify:

```bash
kubectl apply -f deployment-with-anti-affinity.yaml
kubectl get pods -n production -o wide
# Kiểm tra pods được phân tán trên các nodes khác nhau
```

{{< callout type="tip" >}}
**requiredDuringScheduling vs preferredDuringScheduling**:
- `required`: Hard constraint - pod sẽ **không** được schedule nếu vi phạm
- `preferred`: Soft constraint - scheduler sẽ **cố gắng** đáp ứng nhưng vẫn schedule nếu không thể

Sử dụng `required` cho critical workloads, `preferred` cho flexibility.
{{< /callout >}}

## Chiến lược Namespace & Multi-Tenancy

Namespaces cung cấp logical isolation cho resources, rất hữu ích cho multi-environment và multi-team setups.

### Environment Separation

Tạo namespaces cho các môi trường khác nhau:

```bash
# Tạo namespaces
kubectl create namespace development
kubectl create namespace staging
kubectl create namespace production

# Hoặc sử dụng YAML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: development
  labels:
    environment: dev
    team: engineering
---
apiVersion: v1
kind: Namespace
metadata:
  name: staging
  labels:
    environment: staging
    team: engineering
---
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    environment: prod
    team: engineering
EOF
```

Verify:

```bash
kubectl get namespaces --show-labels
```

### ResourceQuota per Namespace

ResourceQuota giới hạn tổng resources mà một namespace có thể sử dụng:

```yaml
# resourcequota-development.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: development
spec:
  hard:
    # Compute resources
    requests.cpu: "10"
    requests.memory: 20Gi
    limits.cpu: "20"
    limits.memory: 40Gi

    # Storage
    requests.storage: 100Gi
    persistentvolumeclaims: "10"

    # Object counts
    pods: "50"
    services: "20"
    configmaps: "30"
    secrets: "30"
    replicationcontrollers: "20"
---
# resourcequota-staging.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: staging-quota
  namespace: staging
spec:
  hard:
    requests.cpu: "20"
    requests.memory: 40Gi
    limits.cpu: "40"
    limits.memory: 80Gi
    requests.storage: 200Gi
    persistentvolumeclaims: "20"
    pods: "100"
    services: "40"
---
# resourcequota-production.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: prod-quota
  namespace: production
spec:
  hard:
    requests.cpu: "50"
    requests.memory: 100Gi
    limits.cpu: "100"
    limits.memory: 200Gi
    requests.storage: 500Gi
    persistentvolumeclaims: "50"
    pods: "200"
    services: "100"
```

Apply quotas:

```bash
kubectl apply -f resourcequota-development.yaml
kubectl apply -f resourcequota-staging.yaml
kubectl apply -f resourcequota-production.yaml

# Check quota usage
kubectl describe quota -n development
kubectl describe quota -n staging
kubectl describe quota -n production
```

### LimitRange per Namespace

LimitRange đặt giới hạn mặc định cho từng pod/container:

```yaml
# limitrange-development.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: dev-limitrange
  namespace: development
spec:
  limits:
  # Container limits
  - type: Container
    default:  # Default limits nếu không chỉ định
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:  # Default requests nếu không chỉ định
      cpu: "100m"
      memory: "128Mi"
    max:  # Maximum limits
      cpu: "2"
      memory: "4Gi"
    min:  # Minimum requests
      cpu: "50m"
      memory: "64Mi"

  # Pod limits (tổng của tất cả containers)
  - type: Pod
    max:
      cpu: "4"
      memory: "8Gi"
    min:
      cpu: "100m"
      memory: "128Mi"

  # PVC limits
  - type: PersistentVolumeClaim
    max:
      storage: "50Gi"
    min:
      storage: "1Gi"
---
# limitrange-production.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: prod-limitrange
  namespace: production
spec:
  limits:
  - type: Container
    default:
      cpu: "1"
      memory: "1Gi"
    defaultRequest:
      cpu: "250m"
      memory: "256Mi"
    max:
      cpu: "8"
      memory: "16Gi"
    min:
      cpu: "100m"
      memory: "128Mi"

  - type: Pod
    max:
      cpu: "16"
      memory: "32Gi"

  - type: PersistentVolumeClaim
    max:
      storage: "200Gi"
    min:
      storage: "5Gi"
```

Apply limit ranges:

```bash
kubectl apply -f limitrange-development.yaml
kubectl apply -f limitrange-production.yaml

kubectl describe limitrange -n development
kubectl describe limitrange -n production
```

### Xem Namespaces qua DigitalOcean Console

1. Truy cập **Kubernetes** → chọn cluster
2. Chuyển sang tab **Resources**
3. Chọn **Namespaces** trong dropdown
4. Xem danh sách namespaces, resource usage, quotas

{{< mermaid >}}
graph TB
    subgraph "Namespace Strategy"
        subgraph "Development Namespace"
            DEV_QUOTA[ResourceQuota:<br/>CPU: 10<br/>Memory: 20Gi<br/>Pods: 50]
            DEV_LIMIT[LimitRange:<br/>Default CPU: 500m<br/>Default Mem: 512Mi]
            DEV_APPS[Dev Apps<br/>& Services]
        end

        subgraph "Staging Namespace"
            STG_QUOTA[ResourceQuota:<br/>CPU: 20<br/>Memory: 40Gi<br/>Pods: 100]
            STG_LIMIT[LimitRange:<br/>Default CPU: 1<br/>Default Mem: 1Gi]
            STG_APPS[Staging Apps<br/>& Services]
        end

        subgraph "Production Namespace"
            PROD_QUOTA[ResourceQuota:<br/>CPU: 50<br/>Memory: 100Gi<br/>Pods: 200]
            PROD_LIMIT[LimitRange:<br/>Default CPU: 1<br/>Default Mem: 1Gi]
            PROD_APPS[Production Apps<br/>& Services]
        end

        DEV_QUOTA --> DEV_APPS
        DEV_LIMIT --> DEV_APPS
        STG_QUOTA --> STG_APPS
        STG_LIMIT --> STG_APPS
        PROD_QUOTA --> PROD_APPS
        PROD_LIMIT --> PROD_APPS
    end
{{< /mermaid >}}

{{< callout type="warning" >}}
**LimitRange vs ResourceQuota**:
- **LimitRange**: Giới hạn cho **từng** pod/container (individual)
- **ResourceQuota**: Giới hạn **tổng** resources của namespace (aggregate)

Cả hai nên được sử dụng cùng nhau để quản lý resources hiệu quả.
{{< /callout >}}

## Tự động hóa & Công cụ

### Helm - Package Manager cho Kubernetes

Helm đơn giản hóa việc deploy và quản lý applications phức tạp.

**Cài đặt Helm**:

```bash
# Linux
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# macOS
brew install helm

# Verify
helm version
```

**Deploy NGINX Ingress Controller**:

```bash
# Add Helm repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install nginx-ingress vào system-pool
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.replicaCount=2 \
  --set controller.nodeSelector."node-type"=system \
  --set controller.tolerations[0].key=workload-type \
  --set controller.tolerations[0].operator=Equal \
  --set controller.tolerations[0].value=system \
  --set controller.tolerations[0].effect=NoSchedule \
  --set controller.service.type=LoadBalancer \
  --set controller.metrics.enabled=true \
  --set controller.podAnnotations."prometheus\.io/scrape"="true" \
  --set controller.podAnnotations."prometheus\.io/port"="10254"

# Check installation
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

# Get LoadBalancer IP
kubectl get svc nginx-ingress-ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

**Quản lý Helm releases**:

```bash
# List installed releases
helm list -A

# Upgrade release
helm upgrade nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --reuse-values \
  --set controller.replicaCount=3

# Rollback to previous version
helm rollback nginx-ingress -n ingress-nginx

# Uninstall release
helm uninstall nginx-ingress -n ingress-nginx
```

### Kustomize - Template-Free Kubernetes Configuration

Kustomize cho phép customize YAML manifests mà không cần templating.

**Directory Structure**:

```
k8s-manifests/
├── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
└── overlays/
    ├── development/
    │   ├── kustomization.yaml
    │   ├── replica-patch.yaml
    │   └── configmap-patch.yaml
    ├── staging/
    │   ├── kustomization.yaml
    │   └── replica-patch.yaml
    └── production/
        ├── kustomization.yaml
        ├── replica-patch.yaml
        └── resource-limits.yaml
```

**Base Configuration** (`base/deployment.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web
        image: myapp:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
```

**Base Kustomization** (`base/kustomization.yaml`):

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- deployment.yaml
- service.yaml
- configmap.yaml

commonLabels:
  app: web-app
  managed-by: kustomize
```

**Development Overlay** (`overlays/development/kustomization.yaml`):

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: development

bases:
- ../../base

patchesStrategicMerge:
- replica-patch.yaml
- configmap-patch.yaml

images:
- name: myapp
  newTag: dev-latest

commonLabels:
  environment: development
```

**Development Replica Patch** (`overlays/development/replica-patch.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 2
```

**Production Overlay** (`overlays/production/kustomization.yaml`):

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: production

bases:
- ../../base

patchesStrategicMerge:
- replica-patch.yaml
- resource-limits.yaml

images:
- name: myapp
  newTag: v1.2.3

commonLabels:
  environment: production

replicas:
- name: web-app
  count: 5
```

**Apply với Kustomize**:

```bash
# Preview changes
kubectl kustomize overlays/development

# Apply development configuration
kubectl apply -k overlays/development

# Apply production configuration
kubectl apply -k overlays/production

# Diff before applying
kubectl diff -k overlays/staging
```

### GitOps - Tự động hóa với Flux và ArgoCD

GitOps là phương pháp quản lý infrastructure và applications thông qua Git làm single source of truth.

**Flux CD** - Lightweight GitOps operator:

```bash
# Install Flux CLI
curl -s https://fluxcd.io/install.sh | sudo bash

# Bootstrap Flux on cluster
flux bootstrap github \
  --owner=your-github-username \
  --repository=fleet-infra \
  --branch=main \
  --path=clusters/production-doks \
  --personal

# Flux sẽ tự động:
# 1. Tạo GitHub repository
# 2. Deploy Flux components vào cluster
# 3. Monitor Git repo và tự động sync changes
```

**ArgoCD** - Declarative GitOps CD:

```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

{{< callout type="tip" >}}
**Flux vs ArgoCD**:
- **Flux**: Lightweight, CLI-driven, excellent for multi-cluster
- **ArgoCD**: Feature-rich UI, better visualization, easier for teams

Tham khảo docs:
- Flux: https://fluxcd.io/docs/
- ArgoCD: https://argo-cd.readthedocs.io/

Cả hai đều là CNCF projects và production-ready.
{{< /callout >}}

## Tổng kết & Bước tiếp theo

Trong phần này, bạn đã học được:

✅ **Infrastructure-as-Code với Terraform**:
- Setup DigitalOcean provider
- Provisioning DOKS cluster với multiple node pools
- State management best practices

✅ **High Availability Design**:
- Multi-node pool strategy (system, app, specialized)
- Pod Disruption Budgets để đảm bảo availability
- Anti-affinity rules để phân tán pods

✅ **Namespace & Multi-Tenancy**:
- Environment separation (dev/staging/prod)
- ResourceQuota để giới hạn tổng resources
- LimitRange để set defaults cho pods

✅ **Automation Tools**:
- Helm để package và deploy applications
- Kustomize để customize manifests cho nhiều environments
- GitOps concepts với Flux và ArgoCD

### Bước tiếp theo

Bạn đã nắm vững infrastructure và DevOps practices. **Phần 4** sẽ hướng dẫn cho Developers:

- Deploy applications lên DOKS
- ConfigMaps và Secrets management
- Persistent storage với DigitalOcean Volumes
- CI/CD integration với GitHub Actions
- Logging và debugging applications

**[Tiếp tục đọc DOKS Mastery Phần 4: Hướng dẫn cho Developer →](#)**

---

**Tài liệu tham khảo**:
- [Terraform DigitalOcean Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
- [DOKS Documentation](https://docs.digitalocean.com/products/kubernetes/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Helm Documentation](https://helm.sh/docs/)
- [Kustomize Documentation](https://kustomize.io/)
