---
title: "DOKS Mastery Phần 2: Hướng dẫn cho System Admin"
date: 2026-02-14
draft: false
description: "Hướng dẫn quản lý DOKS cluster cho System Admin - vòng đời cluster, node pool, giám sát tài nguyên, sao lưu & khôi phục"
categories: ["Kubernetes"]
tags: ["kubernetes", "digitalocean", "doks", "sysadmin", "cluster-management", "node-pool", "backup"]
series: ["DOKS Mastery"]
weight: 2
mermaid: true
---

## Giới thiệu

Trong chuỗi bài **DOKS Mastery**, phần 2 này tập trung vào vai trò của **System Administrator** - người chịu trách nhiệm quản lý vòng đời cluster, đảm bảo hiệu suất, tính sẵn sàng cao và khả năng phục hồi thảm họa.

Khác với Developer tập trung vào deploy ứng dụng, SysAdmin cần nắm vững các kỹ năng sau:

- **Quản lý Cluster lifecycle**: Nâng cấp Kubernetes version, bảo trì định kỳ
- **Quản lý Node Pool**: Thêm/xóa worker nodes, tự động mở rộng (auto-scaling)
- **Giám sát tài nguyên**: CPU, memory, disk, network của toàn cluster
- **Backup & Disaster Recovery**: Sao lưu dữ liệu, khôi phục khi có sự cố

{{< callout type="info" >}}
**Yêu cầu**: Đã hoàn thành [Phần 1: Chuẩn bị Kubernetes trên DigitalOcean]({{< relref "/posts/doks-mastery/01-doks-preparation" >}}) và có kiến thức cơ bản về Linux/CLI.
{{< /callout >}}

### Vai trò của SysAdmin trong Kubernetes

{{< mermaid >}}
graph TB
    SysAdmin[System Administrator]

    SysAdmin --> Cluster[Quản lý Cluster]
    SysAdmin --> Nodes[Quản lý Node Pool]
    SysAdmin --> Monitor[Giám sát & Alert]
    SysAdmin --> Backup[Backup & DR]

    Cluster --> Upgrade[Nâng cấp K8s version]
    Cluster --> Maintain[Bảo trì định kỳ]

    Nodes --> AutoScale[Auto-scaling]
    Nodes --> Resize[Thay đổi kích thước]

    Monitor --> Metrics[CPU/Memory/Disk]
    Monitor --> Quota[Resource Quotas]

    Backup --> Velero[Velero Backup]
    Backup --> Snapshots[Volume Snapshots]

    style SysAdmin fill:#ff6b6b
    style Cluster fill:#4ecdc4
    style Nodes fill:#45b7d1
    style Monitor fill:#96ceb4
    style Backup fill:#ffeaa7
{{< /mermaid >}}

SysAdmin đóng vai trò cầu nối giữa infrastructure và application layer, đảm bảo môi trường Kubernetes hoạt động ổn định và hiệu quả.

---

## Quản lý vòng đời Cluster

### Liệt kê và xem thông tin Cluster

**CLI với doctl:**

```bash
# Liệt kê tất cả clusters
doctl kubernetes cluster list

# Xem chi tiết một cluster
doctl kubernetes cluster get <cluster-name>

# Lấy kubeconfig
doctl kubernetes cluster kubeconfig save <cluster-name>
```

**DigitalOcean Console:**

1. Đăng nhập [cloud.digitalocean.com](https://cloud.digitalocean.com)
2. Vào **Kubernetes** từ menu bên trái
3. Click vào tên cluster để xem chi tiết
4. Tab **Overview** hiển thị: version, endpoint, node pools, resource usage

{{< callout type="tip" >}}
**Pro tip**: Sử dụng `doctl kubernetes cluster list --format Name,Region,Version,Status` để xuất thông tin dạng bảng tùy chỉnh.
{{< /callout >}}

### Nâng cấp Kubernetes Version

DigitalOcean tự động cung cấp các bản vá bảo mật, nhưng **major/minor version upgrade** cần SysAdmin thực hiện thủ công.

**CLI với doctl:**

```bash
# Kiểm tra version khả dụng
doctl kubernetes options versions

# Nâng cấp cluster lên version mới
doctl kubernetes cluster upgrade <cluster-name> --version <new-version>

# Ví dụ: Nâng cấp từ 1.28 lên 1.29
doctl kubernetes cluster upgrade my-production-cluster --version 1.29.1-do.0
```

**DigitalOcean Console:**

1. Vào **Kubernetes** → Chọn cluster
2. Tab **Settings** → **Upgrade** section
3. Chọn version mới từ dropdown
4. Click **Upgrade Cluster**
5. Xác nhận upgrade (cluster sẽ upgrade từng node một, rolling restart)

{{< callout type="warning" >}}
**Lưu ý quan trọng khi upgrade**:
- Backup cluster trước khi nâng cấp
- Kiểm tra [Kubernetes Release Notes](https://kubernetes.io/releases/) cho breaking changes
- Test trên staging cluster trước khi áp dụng lên production
- Upgrade từng minor version một (1.28 → 1.29 → 1.30), không nhảy cóc
{{< /callout >}}

### Cửa sổ bảo trì (Maintenance Windows)

DOKS tự động áp dụng security patches trong **maintenance window** đã cấu hình.

**CLI với doctl:**

```bash
# Xem maintenance window hiện tại
doctl kubernetes cluster get <cluster-name> --format MaintenancePolicy

# Cập nhật maintenance window (format: day=<day>,start_time=<HH:MM>)
doctl kubernetes cluster update <cluster-name> \
  --maintenance-window "day=sunday,start_time=02:00"
```

**DigitalOcean Console:**

1. Vào **Kubernetes** → Chọn cluster
2. Tab **Settings** → **Maintenance** section
3. Chọn **Day of week** và **Start time** (UTC)
4. Click **Update**

{{< callout type="info" >}}
**Best Practice**: Đặt maintenance window vào thời gian traffic thấp (2-4 AM UTC cho US traffic, tùy timezone).
{{< /callout >}}

### Xóa Cluster

**CLI với doctl:**

```bash
# Xóa cluster (cần xác nhận)
doctl kubernetes cluster delete <cluster-name>

# Xóa kèm theo Load Balancers và Volumes
doctl kubernetes cluster delete <cluster-name> --dangerous --update-kubeconfig
```

**DigitalOcean Console:**

1. Vào **Kubernetes** → Chọn cluster
2. Tab **Settings** → Scroll xuống **Destroy** section
3. Click **Destroy** button
4. Nhập tên cluster để xác nhận

{{< callout type="warning" >}}
**Cảnh báo**: Xóa cluster sẽ xóa tất cả resources (pods, services, volumes). Load Balancers và Persistent Volumes **không tự động xóa** để tránh mất dữ liệu. Xóa thủ công sau khi kiểm tra.
{{< /callout >}}

---

## Quản lý Node Pool

Node Pool là nhóm các worker nodes có cùng cấu hình (CPU, RAM, disk). DOKS cho phép tạo nhiều node pools với cấu hình khác nhau cho workloads khác nhau.

### Thêm Node Pool mới

**CLI với doctl:**

```bash
# Tạo node pool mới
doctl kubernetes cluster node-pool create <cluster-name> \
  --name <pool-name> \
  --size <droplet-size> \
  --count <node-count> \
  --auto-scale \
  --min-nodes <min> \
  --max-nodes <max>

# Ví dụ: Tạo pool cho workload CPU-intensive
doctl kubernetes cluster node-pool create my-cluster \
  --name cpu-optimized-pool \
  --size c-4 \
  --count 2 \
  --auto-scale \
  --min-nodes 2 \
  --max-nodes 5
```

**DigitalOcean Console:**

1. Vào **Kubernetes** → Chọn cluster
2. Tab **Overview** → Scroll xuống **Node Pools** section
3. Click **Add Node Pool**
4. Chọn:
   - **Node plan** (Droplet size)
   - **Node count** (số lượng ban đầu)
   - **Enable auto-scaling** (optional)
   - **Min/Max nodes** (nếu bật auto-scale)
   - **Tags** và **Labels** (optional, để organize)
5. Click **Add Node Pool**

{{< callout type="tip" >}}
**Use case cho multiple node pools**:
- **General pool** (`s-2vcpu-4gb`): Web apps, API servers
- **CPU pool** (`c-4`): CI/CD runners, build jobs
- **Memory pool** (`m-4vcpu-32gb`): Databases, caching layers
- **GPU pool** (nếu cần): ML/AI workloads
{{< /callout >}}

### Thay đổi kích thước Node Pool

**CLI với doctl:**

```bash
# Resize node pool (tăng/giảm số lượng nodes)
doctl kubernetes cluster node-pool update <cluster-name> <pool-id> \
  --count <new-count>

# Ví dụ: Tăng từ 2 lên 4 nodes
doctl kubernetes cluster node-pool update my-cluster pool-abc123 --count 4

# List node pools để lấy pool-id
doctl kubernetes cluster node-pool list <cluster-name>
```

**DigitalOcean Console:**

1. Vào **Kubernetes** → Chọn cluster → Tab **Overview**
2. Tìm node pool cần resize trong **Node Pools** section
3. Click **Edit** (icon bút chì)
4. Điều chỉnh **Node Count** slider
5. Click **Update**

{{< callout type="info" >}}
**Lưu ý**: Khi giảm số nodes, Kubernetes sẽ drain nodes (di chuyển pods sang nodes khác) trước khi xóa. Quá trình này có thể mất vài phút.
{{< /callout >}}

### Cấu hình Auto-Scaling

Auto-scaling tự động thêm/bớt nodes dựa trên resource usage (CPU/memory requests).

**CLI với doctl:**

```bash
# Enable auto-scaling cho node pool hiện có
doctl kubernetes cluster node-pool update <cluster-name> <pool-id> \
  --auto-scale \
  --min-nodes 2 \
  --max-nodes 10

# Disable auto-scaling
doctl kubernetes cluster node-pool update <cluster-name> <pool-id> \
  --auto-scale=false
```

**DigitalOcean Console:**

1. Vào **Kubernetes** → Chọn cluster → Tab **Overview**
2. Tìm node pool → Click **Edit**
3. Bật **Autoscale** toggle
4. Đặt **Min nodes** và **Max nodes**
5. Click **Update**

{{< mermaid >}}
graph LR
    A[Pod Scheduling Failed] --> B{Resource Available?}
    B -->|No| C[Cluster Autoscaler Triggered]
    C --> D[Add New Node]
    D --> E[Pod Scheduled Successfully]

    F[Node Underutilized] --> G{Pod Count Low?}
    G -->|Yes| H[Drain Node]
    H --> I[Remove Node]
    I --> J[Cost Optimized]

    style A fill:#ff6b6b
    style E fill:#51cf66
    style J fill:#51cf66
    style C fill:#ffd43b
    style H fill:#ffd43b
{{< /mermaid >}}

{{< callout type="warning" >}}
**Auto-scaling considerations**:
- Set `min-nodes` đủ cao để handle baseline traffic
- Set `max-nodes` để tránh chi phí vượt ngân sách
- Auto-scaling dựa trên **pod requests**, không phải actual usage
- Thời gian scale-up: 1-3 phút (thời gian khởi động node mới)
{{< /callout >}}

### Xóa Node Pool

**CLI với doctl:**

```bash
# Xóa node pool
doctl kubernetes cluster node-pool delete <cluster-name> <pool-id>
```

**DigitalOcean Console:**

1. Vào **Kubernetes** → Chọn cluster → Tab **Overview**
2. Tìm node pool → Click **Delete** (icon thùng rác)
3. Xác nhận xóa

{{< callout type="warning" >}}
**Chú ý**: Pods đang chạy trên node pool sẽ bị evict. Đảm bảo có node pool khác để Kubernetes reschedule pods.
{{< /callout >}}

---

## Giám sát tài nguyên

### Giám sát Node và Pod với kubectl

**Xem resource usage của nodes:**

```bash
# CPU và memory usage của tất cả nodes
kubectl top nodes

# Output:
# NAME                   CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
# pool-abc-123           250m         12%    1024Mi          25%
# pool-abc-456           800m         40%    3072Mi          75%
```

**Xem resource usage của pods:**

```bash
# Tất cả pods trong namespace
kubectl top pods -n <namespace>

# Tất cả pods trong cluster
kubectl top pods --all-namespaces

# Sort theo CPU/memory
kubectl top pods --all-namespaces --sort-by=cpu
kubectl top pods --all-namespaces --sort-by=memory
```

{{< callout type="tip" >}}
**Cài đặt metrics-server** (DOKS đã cài sẵn):
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
{{< /callout >}}

### DigitalOcean Console Monitoring Dashboard

1. Vào **Kubernetes** → Chọn cluster
2. Tab **Insights** hiển thị:
   - **CPU Usage**: % CPU usage theo thời gian
   - **Memory Usage**: % memory usage theo thời gian
   - **Network I/O**: Bandwidth in/out
   - **Disk I/O**: Read/write operations
3. Click **View Details** để drill down vào từng node

{{< callout type="info" >}}
**DO Monitoring** tích hợp sẵn với DOKS, không cần cài thêm agent. Metrics lưu trữ 14 ngày.
{{< /callout >}}

### Resource Quotas per Namespace

Resource Quotas giới hạn tổng tài nguyên mà một namespace có thể sử dụng.

**Tạo ResourceQuota:**

```yaml
# resource-quota-dev.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: development
spec:
  hard:
    requests.cpu: "10"          # Tổng CPU requests: 10 cores
    requests.memory: 20Gi       # Tổng memory requests: 20GB
    limits.cpu: "20"            # Tổng CPU limits: 20 cores
    limits.memory: 40Gi         # Tổng memory limits: 40GB
    persistentvolumeclaims: "10" # Tối đa 10 PVCs
    pods: "50"                  # Tối đa 50 pods
    services.loadbalancers: "2" # Tối đa 2 LoadBalancers
```

**Apply quota:**

```bash
kubectl apply -f resource-quota-dev.yaml

# Xem quota status
kubectl describe resourcequota dev-quota -n development
```

**Output:**

```text
Name:                   dev-quota
Namespace:              development
Resource                Used   Hard
--------                ----   ----
limits.cpu              5      20
limits.memory           10Gi   40Gi
persistentvolumeclaims  3      10
pods                    12     50
requests.cpu            2.5    10
requests.memory         5Gi    20Gi
services.loadbalancers  1      2
```

{{< callout type="warning" >}}
**Quan trọng**: Nếu namespace có ResourceQuota, **tất cả pods phải khai báo resource requests/limits**. Nếu không, pod sẽ bị reject.
{{< /callout >}}

### LimitRange Setup

LimitRange đặt giới hạn mặc định cho từng container/pod trong namespace.

**Tạo LimitRange:**

```yaml
# limit-range-dev.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: dev-limits
  namespace: development
spec:
  limits:
  # Giới hạn cho containers
  - type: Container
    max:
      cpu: "2"           # Max 2 cores per container
      memory: 4Gi        # Max 4GB per container
    min:
      cpu: 100m          # Min 100m CPU per container
      memory: 128Mi      # Min 128MB per container
    default:
      cpu: 500m          # Default limit nếu không khai báo
      memory: 1Gi
    defaultRequest:
      cpu: 200m          # Default request nếu không khai báo
      memory: 512Mi
    maxLimitRequestRatio:
      cpu: "4"           # Limit/Request ratio tối đa 4x
      memory: "2"        # Limit/Request ratio tối đa 2x

  # Giới hạn cho pods
  - type: Pod
    max:
      cpu: "4"           # Max 4 cores per pod
      memory: 8Gi        # Max 8GB per pod

  # Giới hạn cho PVCs
  - type: PersistentVolumeClaim
    max:
      storage: 50Gi      # Max 50GB per PVC
    min:
      storage: 1Gi       # Min 1GB per PVC
```

**Apply LimitRange:**

```bash
kubectl apply -f limit-range-dev.yaml

# Xem LimitRange
kubectl describe limitrange dev-limits -n development
```

{{< callout type="tip" >}}
**Best Practice**: Kết hợp ResourceQuota (giới hạn namespace) và LimitRange (giới hạn container) để kiểm soát tài nguyên hiệu quả.
{{< /callout >}}

### Ví dụ tổng hợp: Namespace với Quota và Limits

```bash
# 1. Tạo namespace
kubectl create namespace production

# 2. Apply ResourceQuota
cat <<EOF | kubectl apply -f -
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
    pods: "200"
EOF

# 3. Apply LimitRange
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: prod-limits
  namespace: production
spec:
  limits:
  - type: Container
    max:
      cpu: "4"
      memory: 8Gi
    min:
      cpu: 100m
      memory: 128Mi
    default:
      cpu: 1
      memory: 2Gi
    defaultRequest:
      cpu: 500m
      memory: 1Gi
EOF

# 4. Verify
kubectl get resourcequota,limitrange -n production
```

---

## Sao lưu & Khôi phục (Backup & DR)

### Velero - Backup solution cho Kubernetes

**Velero** là tool open-source để backup/restore toàn bộ Kubernetes resources và Persistent Volumes.

**Cài đặt Velero:**

```bash
# 1. Download Velero CLI
wget https://github.com/vmware-tanzu/velero/releases/download/v1.12.0/velero-v1.12.0-linux-amd64.tar.gz
tar -xvf velero-v1.12.0-linux-amd64.tar.gz
sudo mv velero-v1.12.0-linux-amd64/velero /usr/local/bin/

# 2. Tạo DigitalOcean Spaces (S3-compatible storage) để lưu backup
# Vào DO Console → Spaces → Create Space
# Lưu Access Key và Secret Key

# 3. Tạo credentials file
cat <<EOF > credentials-velero
[default]
aws_access_key_id=<YOUR_SPACES_ACCESS_KEY>
aws_secret_access_key=<YOUR_SPACES_SECRET_KEY>
EOF

# 4. Install Velero vào cluster
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.8.0 \
  --bucket <your-spaces-bucket-name> \
  --backup-location-config region=nyc3,s3ForcePathStyle="true",s3Url=https://nyc3.digitaloceanspaces.com \
  --snapshot-location-config region=nyc3 \
  --secret-file ./credentials-velero

# 5. Verify installation
kubectl get pods -n velero
```

{{< callout type="info" >}}
**DigitalOcean Spaces**: Dịch vụ object storage tương thích S3 API của DO, giá $5/month cho 250GB.
{{< /callout >}}

**Tạo backup:**

```bash
# Backup toàn bộ cluster
velero backup create full-cluster-backup

# Backup một namespace
velero backup create app-backup --include-namespaces production

# Backup với schedule (cron format)
velero schedule create daily-backup --schedule="0 2 * * *"

# Xem backup status
velero backup describe full-cluster-backup
velero backup logs full-cluster-backup
```

**Restore từ backup:**

```bash
# List backups
velero backup get

# Restore toàn bộ backup
velero restore create --from-backup full-cluster-backup

# Restore chỉ một namespace
velero restore create --from-backup app-backup --include-namespaces production

# Xem restore status
velero restore describe <restore-name>
velero restore logs <restore-name>
```

{{< callout type="warning" >}}
**Velero limitations**:
- Không backup cluster-level configs (RBAC, CRDs) mặc định → Cần flag `--include-cluster-resources=true`
- Persistent Volumes cần snapshot provider (DO Volumes hỗ trợ)
- Restore không tự động xóa resources đã tồn tại → Cần cleanup trước khi restore
{{< /callout >}}

### Persistent Volume Snapshots với doctl

**Tạo snapshot của Volume:**

```bash
# 1. List volumes
doctl compute volume list

# 2. Tạo snapshot
doctl compute volume snapshot <volume-id> --snapshot-name backup-2026-02-14

# 3. List snapshots
doctl compute volume-snapshot list
```

**DigitalOcean Console:**

1. Vào **Volumes** từ menu bên trái
2. Tìm volume cần backup → Click **More** → **Take Snapshot**
3. Nhập tên snapshot
4. Click **Take Snapshot**

**Restore từ snapshot:**

```bash
# Tạo volume mới từ snapshot
doctl compute volume create restored-volume \
  --size 100GB \
  --region nyc3 \
  --snapshot <snapshot-id>
```

**DigitalOcean Console:**

1. Vào **Volumes** → **Create Volume**
2. Chọn **From Snapshot**
3. Chọn snapshot từ dropdown
4. Cấu hình volume name, region
5. Click **Create Volume**

{{< callout type="tip" >}}
**Best Practice**: Combine Velero (Kubernetes resources) + DO Volume Snapshots (Persistent data) cho full disaster recovery.
{{< /callout >}}

### Backup Strategy cho Production

{{< callout type="info" >}}
**Recommended backup strategy**:

**Daily backups**:
- Velero scheduled backup: `0 2 * * *` (2 AM UTC mỗi ngày)
- Backup toàn bộ cluster resources
- Retention: 7 ngày

**Weekly backups**:
- Velero scheduled backup: `0 3 * * 0` (3 AM UTC mỗi Chủ nhật)
- Backup toàn bộ cluster + PV snapshots
- Retention: 4 tuần

**Monthly backups**:
- Manual backup vào ngày 1 hàng tháng
- Backup toàn bộ cluster + config exports
- Retention: 12 tháng

**Disaster Recovery Test**:
- Mỗi quý, test restore từ backup vào staging cluster
- Verify data integrity và application functionality
{{< /callout >}}

**Setup automated backups với Velero:**

```bash
# Daily backup (giữ 7 ngày)
velero schedule create daily-backup \
  --schedule="0 2 * * *" \
  --ttl 168h

# Weekly backup (giữ 4 tuần)
velero schedule create weekly-backup \
  --schedule="0 3 * * 0" \
  --ttl 672h \
  --include-cluster-resources=true

# Verify schedules
velero schedule get
```

---

## Tổng kết & Bước tiếp theo

Trong bài viết này, chúng ta đã tìm hiểu các kỹ năng cần thiết cho **System Admin** quản lý DOKS cluster:

### Kiến thức đã học

✅ **Quản lý Cluster Lifecycle**:
- List, get, upgrade, delete clusters
- Cấu hình maintenance windows
- Best practices khi nâng cấp Kubernetes version

✅ **Quản lý Node Pool**:
- Thêm/xóa/resize node pools
- Cấu hình auto-scaling
- Multiple node pools cho workload khác nhau

✅ **Giám sát Tài nguyên**:
- `kubectl top nodes/pods`
- ResourceQuota và LimitRange
- DigitalOcean monitoring dashboard

✅ **Backup & Disaster Recovery**:
- Velero backup/restore
- DO Volume snapshots
- Backup strategy cho production

### Checklist cho SysAdmin

Sau khi đọc xong bài viết, bạn nên có khả năng:

- [ ] Nâng cấp Kubernetes cluster lên version mới
- [ ] Tạo và quản lý multiple node pools
- [ ] Cấu hình auto-scaling cho node pools
- [ ] Thiết lập ResourceQuota và LimitRange cho namespaces
- [ ] Giám sát resource usage với kubectl và DO Console
- [ ] Cài đặt và sử dụng Velero backup
- [ ] Tạo và restore từ volume snapshots
- [ ] Thiết lập automated backup schedules

### Bước tiếp theo

🚀 **[Phần 3: Hướng dẫn cho DevOps Engineer]({{< relref "/posts/doks-mastery/03-devops-guide" >}})**

Trong phần tiếp theo, chúng ta sẽ tìm hiểu:
- CI/CD pipelines với GitHub Actions
- GitOps với ArgoCD/FluxCD
- Advanced networking: Ingress, Service Mesh
- Security best practices: RBAC, Network Policies, Pod Security Standards
- Cost optimization strategies

{{< callout type="tip" >}}
**Thực hành ngay**: Tạo một DOKS cluster, deploy một ứng dụng, thiết lập auto-scaling, tạo backup với Velero. Hands-on là cách học tốt nhất!
{{< /callout >}}

---

### Tài liệu tham khảo

- [DigitalOcean Kubernetes Documentation](https://docs.digitalocean.com/products/kubernetes/)
- [Velero Documentation](https://velero.io/docs/)
- [Kubernetes Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)

---

*Nếu bạn có câu hỏi hoặc gặp vấn đề khi thực hành, hãy để lại comment bên dưới!*
