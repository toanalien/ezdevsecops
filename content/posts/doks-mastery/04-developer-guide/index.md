---
title: "DOKS Mastery Phần 4: Hướng dẫn cho Developer"
date: 2026-02-14
draft: false
description: "Hướng dẫn Developer triển khai ứng dụng trên DOKS - namespace setup, deployment, service exposure, ingress, và debugging"
categories: ["Kubernetes"]
tags: ["kubernetes", "digitalocean", "doks", "developer", "deployment", "ingress", "debugging", "service"]
series: ["DOKS Mastery"]
weight: 4
mermaid: true
---

## Giới thiệu

Trong phần 4 của series DOKS Mastery, chúng ta sẽ tập trung vào góc nhìn của Developer - những người trực tiếp triển khai và vận hành ứng dụng trên Kubernetes cluster. Bài viết này sẽ hướng dẫn bạn từng bước từ việc thiết lập môi trường làm việc, deploy ứng dụng, expose services, cấu hình ingress cho đến các kỹ thuật debugging thiết yếu.

### Vai trò của Developer trong Kubernetes

Developer làm việc với Kubernetes cần nắm vững:
- **Deployment**: Triển khai và cập nhật ứng dụng
- **Service Management**: Quản lý cách ứng dụng giao tiếp với nhau
- **Networking**: Hiểu cách traffic được route từ bên ngoài vào ứng dụng
- **Debugging**: Nhanh chóng xác định và khắc phục sự cố
- **Resource Management**: Tối ưu hóa tài nguyên cluster

### Luồng request trong Kubernetes

{{< mermaid >}}
graph LR
    A[User/Client] -->|HTTP/HTTPS| B[Ingress Controller]
    B -->|Route theo host/path| C[Ingress Resource]
    C -->|Forward request| D[Service]
    D -->|Load balance| E1[Pod 1]
    D -->|Load balance| E2[Pod 2]
    D -->|Load balance| E3[Pod 3]

    style A fill:#e1f5ff
    style B fill:#fff3cd
    style C fill:#d4edda
    style D fill:#cce5ff
    style E1 fill:#f8d7da
    style E2 fill:#f8d7da
    style E3 fill:#f8d7da
{{< /mermaid >}}

Hiểu rõ luồng này giúp bạn thiết kế và debug ứng dụng hiệu quả hơn.

---

## Namespace & Context Setup

### Tại sao cần Namespace?

Namespace là cơ chế phân vùng logic trong Kubernetes cluster, cho phép:
- **Tách biệt môi trường**: dev, staging, production
- **Quản lý tài nguyên**: resource quotas per namespace
- **Phân quyền**: RBAC có thể áp dụng theo namespace
- **Tổ chức**: nhóm resources theo team hoặc project

### Tạo và quản lý Namespace

```bash
# Tạo namespace mới
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace production

# Liệt kê tất cả namespaces
kubectl get namespaces

# Xem chi tiết namespace
kubectl describe namespace dev
```

### Cấu hình Context

Context trong kubectl giúp bạn quản lý nhiều cluster và namespace dễ dàng:

```bash
# Xem context hiện tại
kubectl config current-context

# Liệt kê tất cả contexts
kubectl config get-contexts

# Tạo context mới với namespace mặc định
kubectl config set-context dev-context \
  --cluster=do-sgp1-my-cluster \
  --user=do-sgp1-my-cluster-admin \
  --namespace=dev

# Tạo context cho staging
kubectl config set-context staging-context \
  --cluster=do-sgp1-my-cluster \
  --user=do-sgp1-my-cluster-admin \
  --namespace=staging

# Chuyển đổi context
kubectl config use-context dev-context

# Kiểm tra namespace hiện tại
kubectl config view --minify --output 'jsonpath={..namespace}'
```

### Sử dụng kubens và kubectx

Công cụ `kubectx` và `kubens` giúp chuyển đổi context/namespace nhanh hơn:

```bash
# Cài đặt (macOS)
brew install kubectx

# Cài đặt (Linux)
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Sử dụng kubectx để chuyển cluster
kubectx                          # Liệt kê contexts
kubectx dev-context              # Chuyển sang dev context
kubectx -                        # Quay lại context trước đó

# Sử dụng kubens để chuyển namespace
kubens                           # Liệt kê namespaces
kubens staging                   # Chuyển sang namespace staging
kubens -                         # Quay lại namespace trước đó
```

{{< callout type="tip" >}}
**Pro Tip**: Thêm namespace hiện tại vào shell prompt để tránh nhầm lẫn môi trường. Với Oh My Zsh, bạn có thể dùng plugin `kube-ps1`.
{{< /callout >}}

### Quản lý Namespace trên DigitalOcean Console

1. Đăng nhập vào **DigitalOcean Console**
2. Vào **Kubernetes** → chọn cluster của bạn
3. Tab **Resources** → chọn **Namespaces** từ dropdown
4. Bạn sẽ thấy tất cả namespaces và resources bên trong

{{< callout type="warning" >}}
**Lưu ý**: Khi xóa namespace, tất cả resources bên trong sẽ bị xóa. Luôn backup trước khi xóa namespace production!
{{< /callout >}}

### Workflow thực tế với nhiều môi trường

```bash
# Morning workflow
kubectx production-cluster       # Chuyển sang production cluster
kubens production                # Chuyển sang production namespace
kubectl get pods                 # Check production pods

# Development work
kubectx dev-cluster              # Chuyển sang dev cluster
kubens dev                       # Chuyển sang dev namespace
kubectl apply -f app.yaml        # Deploy thay đổi mới

# Staging testing
kubens staging                   # Chuyển sang staging (cùng cluster)
kubectl apply -f app.yaml        # Deploy lên staging để test

# Quick check production
kubectx production-cluster && kubens production
kubectl get pods
```

---

## Triển khai ứng dụng

### Deployment - Khái niệm cốt lõi

Deployment là resource quan trọng nhất để quản lý ứng dụng stateless trong K8s. Nó cung cấp:
- **Declarative updates**: Bạn khai báo trạng thái mong muốn
- **Rolling updates**: Cập nhật zero-downtime
- **Rollback**: Quay lại phiên bản trước nếu có lỗi
- **Scaling**: Tăng/giảm số lượng pods dễ dàng
- **Self-healing**: Tự động khởi tạo lại pods bị lỗi

### Deployment YAML hoàn chỉnh

Dưới đây là một Deployment YAML đầy đủ với các best practices:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
  namespace: dev
  labels:
    app: nginx
    env: dev
    version: v1.0.0
  annotations:
    description: "Nginx web server deployment for dev environment"
spec:
  # Số lượng pod replicas
  replicas: 3

  # Strategy cho rolling update
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Cho phép tạo thêm 1 pod khi update
      maxUnavailable: 0  # Không cho phép pod nào unavailable

  # Selector để match pods
  selector:
    matchLabels:
      app: nginx
      env: dev

  # Template cho pods
  template:
    metadata:
      labels:
        app: nginx
        env: dev
        version: v1.0.0
    spec:
      # Image pull secret nếu dùng private registry
      imagePullSecrets:
        - name: docr-secret

      containers:
      - name: nginx
        image: registry.digitalocean.com/my-registry/nginx:1.25.3
        imagePullPolicy: IfNotPresent

        ports:
        - name: http
          containerPort: 80
          protocol: TCP

        # Resource requests và limits
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"

        # Liveness probe - kiểm tra container còn sống không
        livenessProbe:
          httpGet:
            path: /health
            port: http
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3

        # Readiness probe - kiểm tra container sẵn sàng nhận traffic
        readinessProbe:
          httpGet:
            path: /ready
            port: http
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3

        # Environment variables
        env:
        - name: ENVIRONMENT
          value: "development"
        - name: LOG_LEVEL
          value: "debug"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url

        # Volume mounts
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/conf.d
          readOnly: true
        - name: cache
          mountPath: /var/cache/nginx

      # Volumes
      volumes:
      - name: config
        configMap:
          name: nginx-config
      - name: cache
        emptyDir: {}

      # Node affinity (optional) - ưu tiên deploy trên nodes nhất định
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - nginx
              topologyKey: kubernetes.io/hostname
```

### Deploy ứng dụng

```bash
# Apply deployment
kubectl apply -f deployment.yaml

# Xem trạng thái deployment
kubectl get deployments -n dev
kubectl rollout status deployment/nginx-app -n dev

# Xem pods được tạo
kubectl get pods -n dev -l app=nginx

# Xem chi tiết deployment
kubectl describe deployment nginx-app -n dev

# Xem ReplicaSet được tạo bởi deployment
kubectl get replicasets -n dev -l app=nginx
```

### Cấu hình DigitalOcean Container Registry

Để pull private images từ DOCR, bạn cần tạo Secret:

```bash
# Tạo secret cho DOCR
kubectl create secret docker-registry docr-secret \
  --docker-server=registry.digitalocean.com \
  --docker-username=<your-do-token> \
  --docker-password=<your-do-token> \
  --docker-email=<your-email> \
  --namespace=dev

# Verify secret
kubectl get secret docr-secret -n dev -o yaml
```

{{< callout type="tip" >}}
**Best Practice**: Tạo separate DO token cho mỗi cluster/namespace với quyền "read" cho registry. Token này được rotate định kỳ mỗi 3-6 tháng.
{{< /callout >}}

### Service YAML

Service là abstraction layer để expose pods. Dưới đây là các loại Service phổ biến:

#### 1. ClusterIP Service (internal traffic)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: dev
  labels:
    app: nginx
spec:
  type: ClusterIP  # Default type
  selector:
    app: nginx
    env: dev
  ports:
  - name: http
    port: 80        # Port của Service
    targetPort: 80  # Port của container
    protocol: TCP
  sessionAffinity: None
```

#### 2. LoadBalancer Service (external traffic)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-loadbalancer
  namespace: dev
  annotations:
    # DigitalOcean Load Balancer annotations
    service.beta.kubernetes.io/do-loadbalancer-name: "nginx-dev-lb"
    service.beta.kubernetes.io/do-loadbalancer-protocol: "http"
    service.beta.kubernetes.io/do-loadbalancer-algorithm: "round_robin"
    service.beta.kubernetes.io/do-loadbalancer-healthcheck-path: "/health"
    service.beta.kubernetes.io/do-loadbalancer-healthcheck-protocol: "http"
spec:
  type: LoadBalancer
  selector:
    app: nginx
    env: dev
  ports:
  - name: http
    port: 80
    targetPort: 80
    protocol: TCP
  - name: https
    port: 443
    targetPort: 80
    protocol: TCP
```

```bash
# Apply service
kubectl apply -f service.yaml

# Xem services
kubectl get svc -n dev

# Xem external IP của LoadBalancer (có thể mất vài phút)
kubectl get svc nginx-loadbalancer -n dev -w

# Xem endpoints - pods thực tế đằng sau service
kubectl get endpoints nginx-service -n dev

# Test service từ trong cluster
kubectl run curl-test --image=curlimages/curl -i --rm --restart=Never -- \
  curl http://nginx-service.dev.svc.cluster.local
```

### Xem Workloads trên DigitalOcean Console

1. **DigitalOcean Console** → **Kubernetes** → chọn cluster
2. Tab **Workloads**: Xem tất cả deployments, pods, replicasets
3. Click vào deployment để xem:
   - Pod status và health
   - Resource usage (CPU, Memory)
   - Events và logs
   - YAML configuration
4. Tab **Networking**: Xem services và load balancers

---

## Expose Service & Ingress

### So sánh các phương thức expose

| Phương thức | Use Case | Chi phí | External IP | SSL/TLS | Path-based routing |
|------------|----------|---------|-------------|---------|-------------------|
| **ClusterIP** | Internal services | Miễn phí | ❌ Không | N/A | N/A |
| **NodePort** | Development/testing | Miễn phí | ✅ Node IP:Port | Manual | ❌ Không |
| **LoadBalancer** | 1 service = 1 LB | $12/tháng mỗi LB | ✅ Có | Manual | ❌ Không |
| **Ingress** | Nhiều services qua 1 LB | $12/tháng (1 LB) | ✅ Có | ✅ Tự động (cert-manager) | ✅ Có |

{{< callout type="warning" >}}
**Chi phí**: Mỗi LoadBalancer Service tạo 1 DigitalOcean Load Balancer riêng ($12/tháng). Dùng Ingress để chia sẻ 1 LB cho nhiều services, tiết kiệm chi phí đáng kể!
{{< /callout >}}

### Cài đặt Nginx Ingress Controller

Ingress Controller là thành phần thực thi Ingress rules. Nginx Ingress Controller là lựa chọn phổ biến nhất.

```bash
# Add Helm repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install nginx ingress controller
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/do-loadbalancer-name"="nginx-ingress-lb" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/do-loadbalancer-protocol"="http" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/do-loadbalancer-healthcheck-path"="/healthz" \
  --set controller.metrics.enabled=true \
  --set controller.podAnnotations."prometheus\.io/scrape"="true" \
  --set controller.podAnnotations."prometheus\.io/port"="10254"

# Verify installation
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

# Lấy external IP của ingress controller (Load Balancer)
kubectl get svc ingress-nginx-controller -n ingress-nginx
```

{{< callout type="tip" >}}
**Note**: Ingress Controller tạo một DigitalOcean Load Balancer. IP của LB này sẽ là điểm vào cho tất cả Ingress resources.
{{< /callout >}}

### Ingress Resource với Host và Path Rules

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: dev
  annotations:
    # Nginx Ingress Controller annotations
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"

    # Rate limiting
    nginx.ingress.kubernetes.io/limit-rps: "100"

    # CORS
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
spec:
  ingressClassName: nginx

  # TLS configuration (nếu dùng cert-manager)
  tls:
  - hosts:
    - app.example.com
    - api.example.com
    secretName: app-tls-cert

  rules:
  # Rule 1: app.example.com
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80

  # Rule 2: api.example.com
  - host: api.example.com
    http:
      paths:
      - path: /v1
        pathType: Prefix
        backend:
          service:
            name: backend-v1-service
            port:
              number: 8080

      - path: /v2
        pathType: Prefix
        backend:
          service:
            name: backend-v2-service
            port:
              number: 8080

  # Rule 3: Default fallback
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: default-service
            port:
              number: 80
```

```bash
# Apply ingress
kubectl apply -f ingress.yaml

# Xem ingress resources
kubectl get ingress -n dev

# Xem chi tiết ingress
kubectl describe ingress app-ingress -n dev

# Test ingress với curl
INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Test với host header
curl -H "Host: app.example.com" http://$INGRESS_IP
curl -H "Host: api.example.com" http://$INGRESS_IP/v1
```

### Traffic Flow với Ingress

{{< mermaid >}}
graph TB
    A[Internet User] -->|DNS: app.example.com| B[DigitalOcean Load Balancer]
    B -->|IP: 157.230.x.x| C[Ingress Controller Pod]

    C -->|Check Ingress Rules| D{Host & Path Match}

    D -->|app.example.com /| E[frontend-service]
    D -->|api.example.com /v1| F[backend-v1-service]
    D -->|api.example.com /v2| G[backend-v2-service]

    E -->|Load Balance| H1[Frontend Pod 1]
    E -->|Load Balance| H2[Frontend Pod 2]

    F -->|Load Balance| I1[Backend V1 Pod 1]
    F -->|Load Balance| I2[Backend V1 Pod 2]

    G -->|Load Balance| J1[Backend V2 Pod 1]
    G -->|Load Balance| J2[Backend V2 Pod 2]

    style A fill:#e1f5ff
    style B fill:#fff3cd
    style C fill:#d4edda
    style D fill:#f8d7da
    style E fill:#cce5ff
    style F fill:#cce5ff
    style G fill:#cce5ff
{{< /mermaid >}}

### Xem Networking trên DigitalOcean Console

1. **DigitalOcean Console** → **Kubernetes** → chọn cluster
2. Tab **Networking**:
   - **Services**: Xem tất cả ClusterIP, LoadBalancer services
   - **Ingresses**: Xem Ingress rules và backends
   - **Load Balancers**: Click vào để xem:
     - Forwarding rules
     - Backend health
     - SSL certificates
     - Traffic statistics
3. Tab **Load Balancers** (ngoài Kubernetes):
   - Xem chi tiết DO Load Balancer được tạo bởi Ingress Controller
   - Configure SSL/TLS certificates
   - View traffic graphs

{{< callout type="tip" >}}
**DNS Configuration**: Sau khi có Ingress Controller external IP, cấu hình DNS A record:
```text
app.example.com     A    157.230.x.x
api.example.com     A    157.230.x.x
*.example.com       A    157.230.x.x (wildcard)
```
{{< /callout >}}

---

## Gỡ lỗi & Logs

Debugging là kỹ năng thiết yếu khi làm việc với Kubernetes. Dưới đây là các công cụ và kỹ thuật quan trọng nhất.

### Xem Logs

```bash
# Xem logs của pod
kubectl logs <pod-name> -n dev

# Xem logs và follow (real-time)
kubectl logs -f <pod-name> -n dev

# Xem logs của container cụ thể (nếu pod có nhiều containers)
kubectl logs <pod-name> -c <container-name> -n dev

# Xem logs của container trước đó (khi pod bị restart)
kubectl logs <pod-name> --previous -n dev

# Xem logs từ tất cả pods của deployment
kubectl logs -l app=nginx -n dev --all-containers=true

# Xem 100 dòng logs gần nhất
kubectl logs <pod-name> -n dev --tail=100

# Xem logs trong 1 giờ qua
kubectl logs <pod-name> -n dev --since=1h

# Stream logs từ nhiều pods
kubectl logs -l app=nginx -n dev -f --max-log-requests=10
```

{{< callout type="tip" >}}
**Stern**: Tool mạnh mẽ để xem logs từ nhiều pods cùng lúc:
```bash
# Install stern
brew install stern  # macOS
# or download from https://github.com/stern/stern

# Xem logs từ tất cả nginx pods
stern nginx -n dev

# Filter theo regex
stern "^nginx-.*" -n dev --since 15m
```
{{< /callout >}}

### Exec vào Container

```bash
# Exec vào pod với interactive shell
kubectl exec -it <pod-name> -n dev -- /bin/bash
# Hoặc nếu không có bash
kubectl exec -it <pod-name> -n dev -- /bin/sh

# Exec vào container cụ thể
kubectl exec -it <pod-name> -c <container-name> -n dev -- /bin/bash

# Chạy một lệnh cụ thể
kubectl exec <pod-name> -n dev -- ls -la /var/log
kubectl exec <pod-name> -n dev -- cat /etc/nginx/nginx.conf
kubectl exec <pod-name> -n dev -- env

# Kiểm tra network từ trong pod
kubectl exec <pod-name> -n dev -- curl http://backend-service
kubectl exec <pod-name> -n dev -- nslookup backend-service
kubectl exec <pod-name> -n dev -- ping -c 3 backend-service
```

### Describe Resources

```bash
# Describe pod - xem events, status, containers
kubectl describe pod <pod-name> -n dev

# Describe deployment
kubectl describe deployment <deployment-name> -n dev

# Describe service - xem endpoints
kubectl describe service <service-name> -n dev

# Describe ingress
kubectl describe ingress <ingress-name> -n dev

# Describe node
kubectl describe node <node-name>

# Xem events của pod cụ thể
kubectl get events --field-selector involvedObject.name=<pod-name> -n dev

# Xem events của namespace
kubectl get events -n dev --sort-by='.lastTimestamp'
```

### Port Forwarding

Port forward cho phép bạn truy cập service/pod từ máy local mà không cần expose ra ngoài:

```bash
# Forward port từ pod
kubectl port-forward <pod-name> 8080:80 -n dev

# Forward port từ deployment
kubectl port-forward deployment/<deployment-name> 8080:80 -n dev

# Forward port từ service
kubectl port-forward service/<service-name> 8080:80 -n dev

# Forward với address cụ thể (cho phép remote access)
kubectl port-forward --address 0.0.0.0 pod/<pod-name> 8080:80 -n dev

# Forward nhiều ports
kubectl port-forward <pod-name> 8080:80 8443:443 -n dev
```

Sau đó truy cập: `http://localhost:8080`

{{< callout type="warning" >}}
**Security**: Port forwarding mở port trên máy local của bạn. Không dùng `--address 0.0.0.0` trên mạng không tin cậy!
{{< /callout >}}

### Kiểm tra Events

Events là nguồn thông tin quan trọng khi debug:

```bash
# Xem tất cả events trong namespace
kubectl get events -n dev

# Xem events sorted by time
kubectl get events -n dev --sort-by='.metadata.creationTimestamp'

# Xem events của một resource cụ thể
kubectl get events --field-selector involvedObject.name=nginx-app -n dev

# Watch events real-time
kubectl get events -n dev --watch

# Xem warning events
kubectl get events -n dev --field-selector type=Warning
```

### Common Debug Scenarios

| Vấn đề | Triệu chứng | Debug Commands | Giải pháp |
|--------|------------|----------------|-----------|
| **Pod CrashLoopBackOff** | Pod liên tục restart | `kubectl logs <pod> --previous`<br>`kubectl describe pod <pod>` | Check logs lỗi khởi động, sửa image hoặc config |
| **ImagePullBackOff** | Không pull được image | `kubectl describe pod <pod>` | Kiểm tra image name, registry credentials (imagePullSecrets) |
| **Pending Pod** | Pod không được schedule | `kubectl describe pod <pod>`<br>`kubectl get nodes` | Kiểm tra resource requests, node capacity, taints/tolerations |
| **Service không reach được** | Connection refused | `kubectl get endpoints <svc>`<br>`kubectl describe svc <svc>` | Kiểm tra selector labels, pod readiness |
| **Ingress 404** | Path không tìm thấy | `kubectl describe ingress <ing>`<br>`kubectl logs -n ingress-nginx <controller-pod>` | Kiểm tra host/path rules, service backend |
| **DNS resolution failed** | nslookup fails | `kubectl exec <pod> -- nslookup <service>`<br>`kubectl get svc kube-dns -n kube-system` | Kiểm tra CoreDNS pods, service FQDN format |
| **OOMKilled** | Pod bị kill vì hết memory | `kubectl describe pod <pod>`<br>`kubectl top pod <pod>` | Tăng memory limits hoặc tối ưu app |
| **Liveness probe failed** | Pod restart do probe fail | `kubectl logs <pod> --previous`<br>`kubectl describe pod <pod>` | Kiểm tra probe config, tăng timeout/threshold |

### Debug Pod Network Connectivity

```bash
# Tạo debug pod với network tools
kubectl run debug-pod --image=nicolaka/netshoot -i --rm --restart=Never -- bash

# Từ debug pod, test connectivity
nslookup nginx-service.dev.svc.cluster.local
curl http://nginx-service.dev.svc.cluster.local
ping nginx-service.dev.svc.cluster.local
traceroute nginx-service.dev.svc.cluster.local

# Test external connectivity
curl https://google.com
nslookup google.com

# Check DNS
cat /etc/resolv.conf
```

### Check Resource Usage

```bash
# Cài đặt metrics-server (nếu chưa có)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Xem CPU/Memory usage của nodes
kubectl top nodes

# Xem CPU/Memory usage của pods
kubectl top pods -n dev

# Xem pods sorted by CPU
kubectl top pods -n dev --sort-by=cpu

# Xem pods sorted by memory
kubectl top pods -n dev --sort-by=memory

# Xem resource usage của containers trong pod
kubectl top pod <pod-name> -n dev --containers
```

### Xem Pod Logs trên DigitalOcean Console

1. **DigitalOcean Console** → **Kubernetes** → chọn cluster
2. Tab **Workloads** → click vào deployment
3. Click vào pod name
4. Tab **Logs**: Xem real-time logs
   - Filter by time range
   - Search trong logs
   - Download logs
5. Tab **Events**: Xem lifecycle events của pod
6. Tab **Terminal**: Exec vào container trực tiếp từ browser

{{< callout type="tip" >}}
**Console Logs**: DO Console giữ logs trong 1 giờ. Để lưu logs lâu hơn, cần setup log aggregation như Loki, Elasticsearch hoặc DigitalOcean Managed Logging.
{{< /callout >}}

### Debug Checklist

Khi gặp vấn đề, đi theo checklist này:

```bash
# 1. Kiểm tra pod status
kubectl get pods -n dev
kubectl describe pod <pod-name> -n dev

# 2. Xem logs
kubectl logs <pod-name> -n dev
kubectl logs <pod-name> -n dev --previous  # Nếu pod đã restart

# 3. Kiểm tra events
kubectl get events -n dev --sort-by='.lastTimestamp' | grep <pod-name>

# 4. Kiểm tra service endpoints
kubectl get endpoints -n dev
kubectl describe service <service-name> -n dev

# 5. Test connectivity từ trong cluster
kubectl run curl-test --image=curlimages/curl -i --rm --restart=Never -- \
  curl http://<service-name>.<namespace>.svc.cluster.local

# 6. Kiểm tra resource usage
kubectl top pod <pod-name> -n dev

# 7. Exec vào pod để debug
kubectl exec -it <pod-name> -n dev -- /bin/bash

# 8. Xem configuration
kubectl get deployment <deployment-name> -n dev -o yaml
kubectl get service <service-name> -n dev -o yaml
```

---

## Tổng kết & Bước tiếp theo

Trong phần 4 này, chúng ta đã đi qua toàn bộ workflow của Developer khi làm việc với DOKS:

### Kiến thức đã học

✅ **Namespace & Context Management**
- Tổ chức resources với namespaces
- Quản lý multi-cluster/multi-environment với kubectl contexts
- Sử dụng kubens/kubectx để tăng productivity

✅ **Application Deployment**
- Viết Deployment YAML với best practices
- Cấu hình resources, probes, affinity
- Pull private images từ DigitalOcean Container Registry
- Tạo và quản lý Services (ClusterIP, LoadBalancer)

✅ **Ingress & Traffic Management**
- So sánh các phương thức expose services
- Cài đặt Nginx Ingress Controller
- Cấu hình Ingress với host và path-based routing
- Hiểu traffic flow từ user đến pods

✅ **Debugging & Troubleshooting**
- Xem và stream logs từ pods
- Exec vào containers để debug
- Sử dụng describe và events để xác định vấn đề
- Port forwarding để test local
- Giải quyết các vấn đề phổ biến

### Best Practices Recap

🎯 **Development Workflow**
```bash
# 1. Setup context cho namespace
kubectx dev-cluster && kubens dev

# 2. Apply changes
kubectl apply -f deployment.yaml

# 3. Watch rollout
kubectl rollout status deployment/app -n dev

# 4. Check logs
kubectl logs -f deployment/app -n dev

# 5. Test
kubectl port-forward deployment/app 8080:80 -n dev
```

🎯 **Production Deployment**
```bash
# 1. Switch to production
kubectx prod-cluster && kubens production

# 2. Review changes
kubectl diff -f deployment.yaml

# 3. Apply với rollout strategy
kubectl apply -f deployment.yaml

# 4. Monitor rollout
kubectl rollout status deployment/app -n production
watch kubectl get pods -n production

# 5. Rollback nếu cần
kubectl rollout undo deployment/app -n production
```

### Tools Checklist

Đảm bảo bạn đã cài đặt các tools này:

```bash
# Essential
✅ kubectl
✅ kubectx & kubens
✅ helm
✅ doctl (DigitalOcean CLI)

# Recommended
✅ stern (multi-pod logs)
✅ k9s (terminal UI cho K8s)
✅ kubectl-tree (visualize resource relationships)
✅ kubetail (aggregate logs from multiple pods)
```

### Phần tiếp theo

Trong **DOKS Mastery Phần 5: RBAC & Security**, chúng ta sẽ học:

🔐 **Role-Based Access Control (RBAC)**
- ServiceAccounts, Roles, RoleBindings
- ClusterRoles và ClusterRoleBindings
- Best practices cho phân quyền
- Audit logging

🔒 **Security Hardening**
- Pod Security Standards (PSS)
- Network Policies
- Secrets management
- Image scanning và vulnerability detection
- Runtime security với Falco

🛡️ **Compliance & Governance**
- Policy enforcement với OPA/Gatekeeper
- Resource quotas và limit ranges
- Admission controllers

---

### Tài liệu tham khảo

- [Kubernetes Official Documentation](https://kubernetes.io/docs/)
- [DigitalOcean Kubernetes Documentation](https://docs.digitalocean.com/products/kubernetes/)
- [Nginx Ingress Controller Docs](https://kubernetes.github.io/ingress-nginx/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Troubleshooting Applications](https://kubernetes.io/docs/tasks/debug/)

{{< callout type="tip" >}}
**Practice Lab**: Clone repository [doks-examples](https://github.com/digitalocean/kubernetes-sample-apps) để practice các scenarios trong bài viết này!
{{< /callout >}}

---

Bạn đã sẵn sàng để deploy và debug ứng dụng trên DOKS một cách tự tin! Hẹn gặp lại ở Phần 5 với chủ đề Security & RBAC. 🚀
