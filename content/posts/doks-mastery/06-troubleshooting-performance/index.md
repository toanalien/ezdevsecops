---
title: "DOKS Mastery Phần 6: Troubleshooting & Tối ưu Hiệu suất"
date: 2026-02-14
draft: false
description: "Debug các vấn đề phổ biến trên DOKS và tối ưu hiệu suất với HPA, VPA, resource limits, Prometheus & Grafana"
categories: ["Kubernetes"]
tags: ["kubernetes", "digitalocean", "doks", "troubleshooting", "hpa", "vpa", "monitoring", "prometheus", "grafana", "performance"]
series: ["DOKS Mastery"]
weight: 6
mermaid: true
---

Trong phần 6 của series DOKS Mastery, chúng ta sẽ học cách debug các vấn đề phổ biến và tối ưu hiệu suất cluster của bạn.

<!--more-->

## Giới thiệu về Troubleshooting Methodology

Khi gặp vấn đề trên Kubernetes, hãy tuân theo quy trình 4 bước:

1. **Observe** - Thu thập thông tin, kiểm tra trạng thái
2. **Diagnose** - Phân tích logs, events, metrics
3. **Fix** - Áp dụng giải pháp phù hợp
4. **Verify** - Xác nhận vấn đề đã được giải quyết

{{< mermaid >}}
flowchart TD
    A[Pod không chạy] --> B{Kiểm tra Events}
    B -->|Error Events| C[Kiểm tra Logs]
    B -->|No Events| D[Kiểm tra Resources]
    C -->|App Error| E[Fix Application]
    C -->|Config Error| F[Fix ConfigMap/Secret]
    D -->|Insufficient| G[Tăng Resources]
    D -->|Sufficient| H[Kiểm tra Networking]
    H --> I[DNS/Service Discovery]
    E --> J[Verify Pod Running]
    F --> J
    G --> J
    I --> J
{{< /mermaid >}}

## Vấn đề về Pod

### CrashLoopBackOff

Pod liên tục restart do ứng dụng crash ngay sau khi khởi động.

**Chẩn đoán:**

```bash
# Xem chi tiết Pod
kubectl describe pod my-app-pod

# Xem logs của container hiện tại
kubectl logs my-app-pod

# Xem logs của container trước đó (đã crash)
kubectl logs my-app-pod --previous

# Theo dõi logs real-time
kubectl logs -f my-app-pod
```

**Nguyên nhân phổ biến:**

1. **Application crash** - Lỗi code, uncaught exception
2. **Missing configuration** - ConfigMap, Secret không tồn tại
3. **OOM (Out of Memory)** - Ứng dụng vượt quá memory limit
4. **Wrong command/args** - Lệnh khởi động sai
5. **Health check fail** - Liveness probe quá aggressive

**Giải pháp:**

```yaml
# Fix: Tăng memory limit và điều chỉnh health check
apiVersion: v1
kind: Pod
metadata:
  name: my-app-pod
spec:
  containers:
  - name: app
    image: my-app:1.0
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "512Mi"  # Tăng từ 256Mi
        cpu: "500m"
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 30  # Tăng delay
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 3  # Cho phép fail 3 lần
```

{{< callout type="tip" >}}
**DO Console:** Vào **Kubernetes** → Cluster → **Workloads** → chọn Pod → tab **Events** để xem lịch sử events và **Logs** để xem logs trực tiếp.
{{< /callout >}}

### ImagePullBackOff

Kubernetes không thể pull image từ registry.

**Chẩn đoán:**

```bash
# Xem chi tiết lỗi
kubectl describe pod my-app-pod

# Output sẽ hiển thị:
# Events:
#   Failed to pull image "registry.example.com/my-app:1.0":
#   rpc error: code = Unknown desc = Error response from daemon:
#   pull access denied
```

**Nguyên nhân:**

1. Image name hoặc tag sai
2. Private registry cần authentication
3. Network không kết nối được registry
4. Image không tồn tại

**Giải pháp cho Private Registry:**

```bash
# Tạo Docker registry secret
kubectl create secret docker-registry regcred \
  --docker-server=registry.example.com \
  --docker-username=myuser \
  --docker-password=mypassword \
  --docker-email=myemail@example.com

# Hoặc từ file config
kubectl create secret generic regcred \
  --from-file=.dockerconfigjson=$HOME/.docker/config.json \
  --type=kubernetes.io/dockerconfigjson
```

```yaml
# Sử dụng imagePullSecrets
apiVersion: v1
kind: Pod
metadata:
  name: my-app-pod
spec:
  containers:
  - name: app
    image: registry.example.com/my-app:1.0
  imagePullSecrets:
  - name: regcred
```

### Pending Pods

Pod застряt ở trạng thái Pending, không được schedule lên node.

**Chẩn đoán:**

```bash
# Kiểm tra pod status
kubectl get pods
kubectl describe pod my-app-pod

# Kiểm tra node resources
kubectl top nodes
kubectl describe nodes
```

**Nguyên nhân:**

1. **Insufficient resources** - Không đủ CPU/Memory trên các node
2. **Node affinity mismatch** - Không có node nào match affinity rules
3. **Taints and tolerations** - Pod không có toleration cho node taints
4. **PVC not bound** - PersistentVolumeClaim chưa được bind

**Giải pháp:**

```bash
# Scale node pool nếu thiếu resources
# Qua DO Console: Kubernetes → Cluster → Node Pools → Resize

# Hoặc dùng doctl
doctl kubernetes cluster node-pool update <cluster-id> <pool-id> \
  --count 3

# Kiểm tra PVC
kubectl get pvc
kubectl describe pvc my-pvc
```

{{< callout type="warning" >}}
Nếu pod Pending do thiếu resources, DO sẽ tự động scale node pool nếu bạn đã enable **cluster autoscaler** (sẽ học ở phần sau).
{{< /callout >}}

## Vấn đề về Networking

### DNS Resolution

Test DNS resolution trong cluster:

```bash
# Deploy debug pod
kubectl run dnsutils --image=gcr.io/kubernetes-e2e-test-images/dnsutils:1.3 \
  --rm -it --restart=Never -- bash

# Trong pod, test DNS
nslookup kubernetes.default
nslookup my-service.default.svc.cluster.local

# Test external DNS
nslookup google.com
```

**Kiểm tra CoreDNS:**

```bash
# Xem CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Xem logs
kubectl logs -n kube-system -l k8s-app=kube-dns

# Restart CoreDNS nếu cần
kubectl rollout restart deployment/coredns -n kube-system
```

### Service Discovery Issues

Service không route traffic đến pods đúng.

```bash
# Kiểm tra service endpoints
kubectl get svc my-service
kubectl get endpoints my-service

# Nếu endpoints empty, kiểm tra selector
kubectl describe svc my-service
kubectl get pods --show-labels
```

**Ví dụ lỗi selector mismatch:**

```yaml
# Service selector
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: myapp      # Tìm pods với label này
    version: v1
  ports:
  - port: 80

---
# Pod labels (WRONG!)
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: my-app    # Khác "myapp" → không match!
    version: v1
```

**Fix:**

```yaml
# Sửa pod labels để match service selector
metadata:
  labels:
    app: myapp
    version: v1
```

### LoadBalancer Stuck Pending

Service type LoadBalancer không được provision IP.

```bash
# Kiểm tra service
kubectl get svc my-lb-service

# Output:
# NAME            TYPE           EXTERNAL-IP   PORT(S)
# my-lb-service   LoadBalancer   <pending>     80:31234/TCP
```

**Nguyên nhân:**

1. DO LoadBalancer đang được provision (chờ 2-5 phút)
2. Quota limit đã đạt maximum
3. Region không hỗ trợ LoadBalancer
4. Billing issue

**Kiểm tra qua DO Console:**

1. **Networking** → **Load Balancers** - xem trạng thái provisioning
2. Kiểm tra **Billing** - đảm bảo không có vấn đề thanh toán
3. Kiểm tra **API rate limits**

```bash
# Xem events của service
kubectl describe svc my-lb-service

# Xem DO LB thông qua doctl
doctl compute load-balancer list
```

## Vấn đề về Storage

### PVC Pending

PersistentVolumeClaim không được bound với PersistentVolume.

```bash
# Kiểm tra PVC và PV
kubectl get pvc
kubectl get pv

# Chi tiết PVC
kubectl describe pvc my-pvc
```

**Nguyên nhân:**

1. **No matching StorageClass** - StorageClass không tồn tại
2. **Insufficient capacity** - Yêu cầu storage lớn hơn available
3. **Access mode mismatch** - PV không support access mode của PVC
4. **Node affinity** - PV chỉ available trên specific nodes

**Giải pháp:**

```yaml
# Sử dụng DOKS default StorageClass
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: do-block-storage  # DOKS default
  resources:
    requests:
      storage: 10Gi
```

```bash
# List available StorageClasses
kubectl get storageclass

# Output trên DOKS:
# NAME                         PROVISIONER
# do-block-storage (default)   dobs.csi.digitalocean.com
# do-block-storage-retain      dobs.csi.digitalocean.com
# do-block-storage-xfs         dobs.csi.digitalocean.com
```

### Volume Mount Failures

Container không thể mount volume.

```bash
# Xem pod events
kubectl describe pod my-app-pod

# Common errors:
# - MountVolume.SetUp failed: volume not attached
# - Volume is already exclusively attached to one node
```

**Giải pháp:**

```bash
# Xóa và recreate pod (đối với StatefulSet)
kubectl delete pod my-app-pod-0

# Kiểm tra CSI driver
kubectl get pods -n kube-system | grep csi

# Verify volume attachment
kubectl get volumeattachment
```

{{< callout type="tip" >}}
**DO Console:** Vào **Volumes** để xem tất cả Block Storage volumes, trạng thái attachment, và resize volumes nếu cần.
{{< /callout >}}

## Vấn đề về Node

### Node NotReady

Node ở trạng thái NotReady, không nhận pods mới.

```bash
# Xem node status
kubectl get nodes

# Chi tiết node
kubectl describe node <node-name>

# Xem node conditions
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}'
```

**Node Conditions quan trọng:**

- **Ready** - Node healthy và ready nhận pods
- **DiskPressure** - Disk space thấp
- **MemoryPressure** - Memory không đủ
- **PIDPressure** - Quá nhiều processes
- **NetworkUnavailable** - Network chưa configure đúng

**Giải pháp:**

```bash
# Nếu DiskPressure - cleanup images
kubectl get nodes -o jsonpath='{.items[*].status.images[*].names}' | tr ' ' '\n' | sort | uniq

# Cordon node để prevent scheduling
kubectl cordon <node-name>

# Drain node để di chuyển pods
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# Uncordon sau khi fix
kubectl uncordon <node-name>
```

{{< callout type="danger" >}}
**Cảnh báo:** `kubectl drain` sẽ evict tất cả pods trên node. Đảm bảo workloads có replicas trước khi drain.
{{< /callout >}}

### Resource Pressure và Eviction

Khi node thiếu resources, Kubernetes sẽ evict pods.

```bash
# Xem resource usage
kubectl top nodes
kubectl top pods --all-namespaces

# Xem evicted pods
kubectl get pods --all-namespaces --field-selector=status.phase=Failed
```

**Eviction signals:**

- `memory.available < 100Mi` - Evict pods theo priority
- `nodefs.available < 10%` - Disk pressure
- `imagefs.available < 15%` - Image storage pressure

**Prevention:**

```yaml
# Đặt resource requests và limits đúng
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "500m"
```

### Node Pool Scaling Issues

Node pool không scale theo expectation.

```bash
# Xem node pool info qua doctl
doctl kubernetes cluster node-pool list <cluster-id>

# Update node count
doctl kubernetes cluster node-pool update <cluster-id> <pool-id> \
  --count 5

# Enable autoscaler
doctl kubernetes cluster node-pool update <cluster-id> <pool-id> \
  --auto-scale \
  --min-nodes 2 \
  --max-nodes 10
```

**DO Console:**

1. **Kubernetes** → Cluster → **Node Pools**
2. Click **Edit** trên node pool
3. Adjust **Node count** hoặc enable **Autoscale**
4. Set **Min nodes** và **Max nodes**

## Resource Requests & Limits

Cấu hình resources đúng cách là foundation cho performance tốt.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: my-app:1.0
        ports:
        - containerPort: 8080
        resources:
          # REQUESTS: Lượng resources được đảm bảo
          # Scheduler dùng để quyết định node nào có đủ resources
          requests:
            memory: "256Mi"   # Guaranteed memory
            cpu: "250m"       # 0.25 CPU core

          # LIMITS: Maximum resources container có thể dùng
          # Vượt quá memory limit → OOMKilled
          # Vượt quá CPU limit → throttled
          limits:
            memory: "512Mi"   # Max memory
            cpu: "500m"       # Max 0.5 CPU core

        # Health checks
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10

        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
```

**Best practices:**

{{< callout type="warning" >}}
**Quan trọng:** Nếu không set `requests`, HPA sẽ không hoạt động! HPA cần biết baseline resources để tính toán scaling.
{{< /callout >}}

**Resource recommendations:**

1. **Start with requests** - Set requests dựa trên app requirements
2. **Observe actual usage** - Dùng `kubectl top pods` để monitor
3. **Set limits** - Thường gấp 1.5-2x requests
4. **Iterate** - Điều chỉnh dựa trên metrics

```bash
# Xem actual resource usage
kubectl top pods
kubectl top nodes

# Xem resources của pod
kubectl describe pod <pod-name> | grep -A 10 "Requests:"
```

**Quality of Service (QoS) classes:**

- **Guaranteed** - requests = limits → Ưu tiên cao nhất
- **Burstable** - requests < limits → Ưu tiên trung bình
- **BestEffort** - Không có requests/limits → Evict đầu tiên

## Horizontal Pod Autoscaler (HPA)

HPA tự động scale số lượng pods dựa trên CPU, memory, hoặc custom metrics.

### Cấu hình HPA v2

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
  namespace: default
spec:
  # Target deployment/statefulset/replicaset
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app

  # Min và max replicas
  minReplicas: 2
  maxReplicas: 10

  # Metrics để scale
  metrics:

  # Scale dựa trên CPU usage
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70  # Target 70% CPU

  # Scale dựa trên Memory usage
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80  # Target 80% Memory

  # Behavior controls (optional) - Fine-tune scaling behavior
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300  # Chờ 5 phút trước khi scale down
      policies:
      - type: Percent
        value: 50              # Scale down max 50% pods
        periodSeconds: 60      # Trong 60s
      - type: Pods
        value: 2               # Hoặc max 2 pods
        periodSeconds: 60
      selectPolicy: Min        # Chọn policy conservative nhất

    scaleUp:
      stabilizationWindowSeconds: 0    # Scale up ngay lập tức
      policies:
      - type: Percent
        value: 100             # Scale up max 100% (double)
        periodSeconds: 15      # Trong 15s
      - type: Pods
        value: 4               # Hoặc max 4 pods
        periodSeconds: 15
      selectPolicy: Max        # Chọn policy aggressive nhất
```

### Deploy HPA

```bash
# Apply HPA config
kubectl apply -f hpa.yaml

# Xem HPA status
kubectl get hpa

# Output:
# NAME         REFERENCE          TARGETS              MINPODS   MAXPODS   REPLICAS
# my-app-hpa   Deployment/my-app  45%/70%, 60%/80%     2         10        3

# Chi tiết HPA
kubectl describe hpa my-app-hpa

# Watch HPA real-time
kubectl get hpa -w
```

### Verify Metrics Server

HPA cần metrics-server để hoạt động. DOKS đã pre-install metrics-server.

```bash
# Kiểm tra metrics-server
kubectl get deployment metrics-server -n kube-system

# Test metrics availability
kubectl top nodes
kubectl top pods

# Nếu không có metrics-server, install:
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Test HPA

```bash
# Generate load để trigger scaling
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh

# Trong pod, gửi requests:
while true; do wget -q -O- http://my-app-service; done

# Ở terminal khác, watch HPA
kubectl get hpa my-app-hpa -w

# Xem pods scaling up
kubectl get pods -l app=my-app -w
```

{{< callout type="tip" >}}
**Load testing tools:** Sử dụng `Apache Bench` (`ab`), `wrk`, hoặc `k6` để generate realistic load và test HPA behavior.
{{< /callout >}}

## Vertical Pod Autoscaler (VPA)

VPA tự động điều chỉnh CPU và memory requests/limits dựa trên usage.

### Install VPA

```bash
# Clone VPA repository
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler

# Install VPA
./hack/vpa-up.sh

# Verify installation
kubectl get pods -n kube-system | grep vpa
```

### Cấu hình VPA

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  # Target deployment
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app

  # Update mode
  updatePolicy:
    updateMode: "Auto"
    # Modes:
    # - "Off": Chỉ recommend, không update
    # - "Initial": Set resources khi tạo pod mới
    # - "Recreate": Recreate pods với resources mới
    # - "Auto": Recreate + evict pods khi cần

  # Resource policy
  resourcePolicy:
    containerPolicies:
    - containerName: app
      # Min resources
      minAllowed:
        cpu: 100m
        memory: 128Mi
      # Max resources
      maxAllowed:
        cpu: 2
        memory: 2Gi
      # Control mode per resource
      controlledResources: ["cpu", "memory"]
      # Controlled values
      controlledValues: RequestsAndLimits  # Hoặc RequestsOnly
```

```bash
# Apply VPA
kubectl apply -f vpa.yaml

# Xem VPA recommendations
kubectl describe vpa my-app-vpa

# Output sẽ hiển thị:
# Recommendation:
#   Container Recommendations:
#     Container Name:  app
#     Lower Bound:
#       Cpu:     150m
#       Memory:  200Mi
#     Target:
#       Cpu:     250m
#       Memory:  350Mi
#     Upper Bound:
#       Cpu:     500m
#       Memory:  700Mi
```

{{< callout type="warning" >}}
**Conflict Warning:** Không nên dùng HPA và VPA cùng scale **cùng metric** (VD: cả 2 đều scale CPU). Best practice:
- **VPA** cho memory recommendations (mode "Off" để chỉ recommend)
- **HPA** cho CPU-based horizontal scaling
{{< /callout >}}

**Recommended VPA strategy:**

```yaml
# VPA in recommendation-only mode
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Off"  # Chỉ recommend, không auto-update
  resourcePolicy:
    containerPolicies:
    - containerName: app
      controlledResources: ["memory"]  # Chỉ recommend memory
```

## Monitoring: Prometheus & Grafana

### Install kube-prometheus-stack

`kube-prometheus-stack` là Helm chart bao gồm Prometheus, Grafana, Alertmanager, và các dashboards pre-configured.

**Step 1: Add Helm repository**

```bash
# Add prometheus-community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update repo
helm repo update

# Xem chart info
helm show chart prometheus-community/kube-prometheus-stack
```

**Step 2: Tạo values file để customize**

```yaml
# prometheus-values.yaml
# Grafana configuration
grafana:
  enabled: true
  adminPassword: "admin123"  # CHANGE THIS!

  # Persistence for dashboards
  persistence:
    enabled: true
    storageClassName: do-block-storage
    size: 10Gi

  # Grafana service
  service:
    type: LoadBalancer  # Expose qua DO LoadBalancer
    annotations:
      service.beta.kubernetes.io/do-loadbalancer-name: "grafana-lb"

  # Ingress (nếu dùng ingress thay vì LB)
  ingress:
    enabled: false
    # enabled: true
    # ingressClassName: nginx
    # hosts:
    #   - grafana.example.com

# Prometheus configuration
prometheus:
  prometheusSpec:
    # Retention time
    retention: 30d

    # Storage
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: do-block-storage
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 50Gi

    # Resources
    resources:
      requests:
        cpu: 500m
        memory: 2Gi
      limits:
        cpu: 1000m
        memory: 4Gi

    # Service monitors - Auto-discover services to scrape
    serviceMonitorSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false

# Alertmanager configuration
alertmanager:
  alertmanagerSpec:
    storage:
      volumeClaimTemplate:
        spec:
          storageClassName: do-block-storage
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 10Gi

# Node exporter - Collect node metrics
nodeExporter:
  enabled: true

# Kube-state-metrics - Collect Kubernetes object metrics
kubeStateMetrics:
  enabled: true
```

**Step 3: Install chart**

```bash
# Tạo namespace
kubectl create namespace monitoring

# Install kube-prometheus-stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values prometheus-values.yaml

# Xem installation progress
kubectl get pods -n monitoring -w

# Xem services
kubectl get svc -n monitoring
```

**Step 4: Access Grafana**

```bash
# Get Grafana LoadBalancer IP
kubectl get svc prometheus-grafana -n monitoring

# Output:
# NAME                TYPE           EXTERNAL-IP      PORT(S)
# prometheus-grafana  LoadBalancer   165.232.xxx.xxx  80:xxxxx/TCP

# Truy cập Grafana:
# URL: http://<EXTERNAL-IP>
# Username: admin
# Password: admin123 (từ values file)
```

**Alternative: Port-forward nếu không dùng LoadBalancer**

```bash
# Port-forward Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Access: http://localhost:3000
```

### Grafana Dashboards

Kube-prometheus-stack đi kèm nhiều dashboards pre-configured:

**Dashboards quan trọng:**

1. **Kubernetes / Compute Resources / Cluster** - Overview toàn cluster
   - Total CPU/Memory usage
   - Pod count
   - Network I/O

2. **Kubernetes / Compute Resources / Namespace (Pods)** - Per-namespace metrics
   - CPU/Memory per pod
   - Network usage
   - Storage usage

3. **Kubernetes / Compute Resources / Node (Pods)** - Per-node metrics
   - Node CPU/Memory
   - Pods per node
   - Disk usage

4. **Kubernetes / Networking / Cluster** - Network metrics
   - Bandwidth usage
   - Packet rates
   - Error rates

**Import thêm dashboards:**

```bash
# Grafana UI: + → Import → Nhập Dashboard ID từ grafana.com

# Popular dashboards:
# - 315: Kubernetes cluster monitoring
# - 8588: Kubernetes Deployment Statefulset Daemonset metrics
# - 6417: Kubernetes Cluster (Prometheus)
```

### Prometheus Queries (PromQL)

Access Prometheus UI để query metrics trực tiếp:

```bash
# Port-forward Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Access: http://localhost:9090
```

**Useful queries:**

```promql
# CPU usage per pod
sum(rate(container_cpu_usage_seconds_total{namespace="default"}[5m])) by (pod)

# Memory usage per pod
sum(container_memory_usage_bytes{namespace="default"}) by (pod)

# Pod restart count
kube_pod_container_status_restarts_total

# Available vs used memory per node
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Network receive bandwidth
sum(rate(container_network_receive_bytes_total[5m])) by (pod)

# PVC usage percentage
(kubelet_volume_stats_used_bytes / kubelet_volume_stats_capacity_bytes) * 100
```

### Alertmanager Configuration

Cấu hình alerts để nhận thông báo khi có issues.

```yaml
# alertmanager-config.yaml
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-prometheus-kube-prometheus-alertmanager
  namespace: monitoring
stringData:
  alertmanager.yaml: |
    global:
      resolve_timeout: 5m

    # Notification receivers
    receivers:
    - name: 'slack'
      slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
        channel: '#alerts'
        title: 'Kubernetes Alert'
        text: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'

    - name: 'email'
      email_configs:
      - to: 'ops@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'alertmanager@example.com'
        auth_password: 'password'

    - name: 'null'

    # Routing
    route:
      receiver: 'slack'
      group_by: ['alertname', 'cluster']
      group_wait: 10s
      group_interval: 10s
      repeat_interval: 12h

      routes:
      # Critical alerts → Slack + Email
      - match:
          severity: critical
        receiver: slack
        continue: true

      - match:
          severity: critical
        receiver: email

      # Warning alerts → Slack only
      - match:
          severity: warning
        receiver: slack
```

```bash
# Apply alertmanager config
kubectl apply -f alertmanager-config.yaml

# Restart alertmanager
kubectl rollout restart statefulset/alertmanager-prometheus-kube-prometheus-alertmanager -n monitoring
```

**Default alerts included:**

- `KubePodCrashLooping` - Pod restart nhiều lần
- `KubeNodeNotReady` - Node not ready
- `KubePodNotReady` - Pod not ready
- `KubeMemoryOvercommit` - Memory overcommit
- `KubeCPUOvercommit` - CPU overcommit
- `KubePersistentVolumeFillingUp` - PV gần full

### DigitalOcean Monitoring Integration

DO cung cấp built-in monitoring có thể complement với Prometheus.

```bash
# Enable DO monitoring qua doctl
doctl kubernetes cluster update <cluster-id> \
  --enable-monitoring

# Xem metrics qua DO Console:
# Kubernetes → Cluster → Insights tab
```

**DO Metrics available:**

- Node CPU/Memory/Disk usage
- Network bandwidth
- LoadBalancer metrics
- Volume metrics

**Best practice:** Dùng cả DO monitoring (overview nhanh) và Prometheus/Grafana (deep dive, custom metrics).

## Bảng Tham Khảo Nhanh

| Triệu chứng | Lệnh kiểm tra | Nguyên nhân thường gặp | Cách sửa |
|-------------|---------------|------------------------|----------|
| **CrashLoopBackOff** | `kubectl logs <pod> --previous` | App crash, missing config, OOM | Fix code, tăng memory limit, kiểm tra ConfigMap/Secret |
| **ImagePullBackOff** | `kubectl describe pod <pod>` | Sai image name, private registry | Sửa image name, tạo imagePullSecret |
| **Pending Pod** | `kubectl describe pod <pod>` | Thiếu resources, affinity mismatch | Scale nodes, sửa affinity rules |
| **Pod Evicted** | `kubectl get pods --field-selector=status.phase=Failed` | Node resource pressure | Tăng resource requests, scale nodes |
| **Service không route** | `kubectl get endpoints <svc>` | Selector mismatch | Sửa service selector hoặc pod labels |
| **DNS không resolve** | `nslookup <service>` (trong pod) | CoreDNS issue | Restart CoreDNS deployment |
| **PVC Pending** | `kubectl describe pvc <pvc>` | StorageClass không tồn tại, thiếu capacity | Sửa storageClassName, tăng node storage |
| **Node NotReady** | `kubectl describe node <node>` | Disk/Memory pressure, network issue | Cleanup disk, restart node, scale pool |
| **HPA không scale** | `kubectl get hpa` | Metrics server không chạy, thiếu requests | Install metrics-server, set resource requests |
| **High latency** | `kubectl top pods` | CPU/Memory throttling | Tăng resources, optimize code |
| **LoadBalancer Pending** | `kubectl describe svc <svc>` | DO LB provisioning, quota limit | Chờ provision, kiểm tra billing/quota |
| **Volume mount fail** | `kubectl describe pod <pod>` | Volume attached to wrong node | Delete pod, recreate; kiểm tra CSI driver |
| **Slow deployment** | `kubectl rollout status deployment/<name>` | Slow health checks, image pull | Tối ưu probe timing, dùng image caching |

## Tổng kết

Trong phần 6, chúng ta đã học:

✅ **Troubleshooting methodology** - Quy trình 4 bước: Observe → Diagnose → Fix → Verify
✅ **Debug pod issues** - CrashLoopBackOff, ImagePullBackOff, Pending pods
✅ **Networking troubleshooting** - DNS, service discovery, LoadBalancer
✅ **Storage issues** - PVC pending, volume mount failures
✅ **Node management** - NotReady nodes, resource pressure, eviction
✅ **Resource optimization** - Requests & limits best practices
✅ **Horizontal Pod Autoscaler (HPA)** - Auto-scale pods dựa trên CPU/memory
✅ **Vertical Pod Autoscaler (VPA)** - Auto-adjust resource requests/limits
✅ **Monitoring stack** - Full Prometheus & Grafana setup với kube-prometheus-stack
✅ **Alerting** - Alertmanager configuration cho notifications

**Key takeaways:**

- Luôn set resource requests/limits để tránh resource contention
- Dùng HPA cho horizontal scaling, VPA cho resource optimization
- Monitor metrics với Prometheus/Grafana để proactive troubleshooting
- DO Console và `kubectl` bổ sung cho nhau trong troubleshooting

**Tiếp theo:** Trong **Part 7: CI/CD với GitLab và GitHub Actions**, chúng ta sẽ học cách setup CI/CD pipelines để tự động build, test, và deploy ứng dụng lên DOKS.

{{< callout type="tip" >}}
**Practice:** Setup monitoring stack trên DOKS cluster của bạn, import dashboards, và configure alerts cho các critical metrics. Test HPA bằng cách generate load và quan sát scaling behavior qua Grafana.
{{< /callout >}}
