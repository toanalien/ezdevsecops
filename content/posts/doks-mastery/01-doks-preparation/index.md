---
title: "DOKS Mastery Phần 1: Chuẩn bị Kubernetes trên DigitalOcean"
date: 2026-02-14
draft: false
description: "Hướng dẫn toàn diện thiết lập DigitalOcean Kubernetes (DOKS) từ đầu - prerequisites, CLI tools, và cluster đầu tiên"
categories: ["Kubernetes"]
tags: ["kubernetes", "digitalocean", "doks", "kubectl", "doctl", "cluster-setup"]
series: ["DOKS Mastery"]
weight: 1
mermaid: true
---

## Giới thiệu

Chào mừng bạn đến với serie **DOKS Mastery**! Trong phần đầu tiên này, chúng ta sẽ cùng nhau thiết lập một Kubernetes cluster trên DigitalOcean từ con số 0.

**DigitalOcean Kubernetes (DOKS)** là dịch vụ Kubernetes được quản lý hoàn toàn (fully managed) bởi DigitalOcean. Khác với việc tự cài đặt Kubernetes từ đầu (kubeadm, kops, hay các công cụ khác), DOKS giúp bạn tập trung vào việc deploy ứng dụng thay vì lo lắng về việc vận hành control plane.

### Sau bài viết này, bạn sẽ có thể:

- ✅ Hiểu kiến trúc cơ bản của DOKS và sự khác biệt với Kubernetes tự quản lý
- ✅ Cài đặt và cấu hình các công cụ CLI cần thiết (`doctl`, `kubectl`)
- ✅ Tạo cluster Kubernetes đầu tiên trên DigitalOcean
- ✅ Kết nối và tương tác với cluster thông qua `kubectl`
- ✅ Kiểm tra sức khỏe và khám phá tài nguyên của cluster

### Prerequisites

Trước khi bắt đầu, hãy đảm bảo bạn có:

- 💳 **Tài khoản DigitalOcean** (đăng ký tại [digitalocean.com](https://digitalocean.com))
- 💵 **Thẻ tín dụng hoặc PayPal** đã liên kết (DOKS tính phí theo giờ)
- 💻 **Terminal/Command line** cơ bản (bash, zsh, PowerShell)
- 🧠 **Kiến thức cơ bản về containers** (Docker, containerization concepts)
- ⏱️ **Thời gian ước tính**: ~20-30 phút

{{< callout type="info" >}}
**Lưu ý về chi phí**: DOKS tính phí cho worker nodes (droplets) chạy cluster của bạn. Control plane được DigitalOcean quản lý miễn phí. Một cluster nhỏ với 2 nodes (2GB RAM mỗi node) tốn khoảng $24/tháng ($0.033/giờ). Chi tiết giá tại [DigitalOcean Pricing](https://www.digitalocean.com/pricing/kubernetes).
{{< /callout >}}

---

## Kiến trúc DOKS

Để hiểu rõ hơn về DOKS, chúng ta cần phân biệt giữa **control plane** và **data plane** (worker nodes):

{{< mermaid >}}
graph TB
    subgraph DO_Managed["DigitalOcean Managed (Free)"]
        API[API Server]
        ETCD[etcd]
        SCHED[Scheduler]
        CM[Controller Manager]
    end

    subgraph User_Managed["User Managed (Billed)"]
        subgraph NodePool1["Node Pool 1"]
            N1[Worker Node 1<br/>2GB RAM]
            N2[Worker Node 2<br/>2GB RAM]
        end
        subgraph NodePool2["Node Pool 2 (Optional)"]
            N3[Worker Node 3<br/>4GB RAM]
        end
    end

    subgraph Workloads["Your Applications"]
        P1[Pod: App A]
        P2[Pod: App B]
        P3[Pod: Database]
    end

    API --> N1
    API --> N2
    API --> N3
    N1 --> P1
    N2 --> P2
    N3 --> P3

    ETCD -.stores cluster state.-> API
    SCHED -.schedules pods.-> API
    CM -.manages controllers.-> API
{{< /mermaid >}}

### Control Plane (Được DigitalOcean quản lý - MIỄN PHÍ)

Control plane bao gồm các thành phần cốt lõi của Kubernetes:

- **API Server**: Điểm trung tâm giao tiếp, xử lý tất cả REST requests
- **etcd**: Database phân tán lưu trữ toàn bộ trạng thái cluster
- **Scheduler**: Quyết định pod nào chạy trên node nào
- **Controller Manager**: Quản lý các controllers (ReplicaSet, Deployment, Service, etc.)

DigitalOcean chịu trách nhiệm:
- ✅ High availability cho control plane (multi-master setup)
- ✅ Automatic backups của etcd
- ✅ Patching và upgrades
- ✅ Monitoring và alerting

### Data Plane / Worker Nodes (Bạn quản lý - CÓ PHÍ)

Worker nodes là nơi các container/pods thực sự chạy:

- **Kubelet**: Agent chạy trên mỗi node, giao tiếp với API server
- **Container Runtime**: Docker/containerd để chạy containers
- **kube-proxy**: Quản lý network rules cho Services
- **Your Pods**: Ứng dụng của bạn

Bạn có toàn quyền:
- ✅ Chọn số lượng nodes và instance types
- ✅ Scale up/down node pools
- ✅ Deploy bất kỳ workload nào lên nodes
- ✅ Cài đặt add-ons (ingress controllers, monitoring, etc.)

{{< callout type="warning" >}}
**Quan trọng**: Bạn chỉ bị tính phí cho worker nodes (droplets), KHÔNG phải control plane. Tuy nhiên, control plane cũng tiêu tốn tài nguyên, nên DigitalOcean giới hạn số lượng free control planes theo account tier.
{{< /callout >}}

---

## Bước 1: Tài khoản DigitalOcean & API Token

### 1.1. Tạo tài khoản DigitalOcean

Nếu chưa có tài khoản, truy cập [digitalocean.com](https://www.digitalocean.com) và đăng ký:

1. Click **Sign Up** ở góc trên bên phải
2. Nhập email, tạo password, hoặc đăng nhập bằng GitHub/Google
3. Xác thực email
4. Thêm phương thức thanh toán (credit card hoặc PayPal)

{{< callout type="info" >}}
**Tip**: DigitalOcean thường có promo code cho người dùng mới (ví dụ: $200 credit trong 60 ngày). Tìm kiếm "DigitalOcean promo code" trước khi đăng ký.
{{< /callout >}}

### 1.2. Tạo API Token

API Token cho phép `doctl` CLI tương tác với DigitalOcean API thay mặt bạn. Có 2 cách tạo token:

#### Cách 1: Qua DigitalOcean Web Console (Khuyến nghị cho lần đầu)

1. Đăng nhập vào [cloud.digitalocean.com](https://cloud.digitalocean.com)
2. Click vào **API** trong menu bên trái (hoặc truy cập trực tiếp [cloud.digitalocean.com/account/api/tokens](https://cloud.digitalocean.com/account/api/tokens))
3. Click **Generate New Token**
4. Điền thông tin:
   - **Token Name**: `doks-mastery-cli` (hoặc tên bạn muốn)
   - **Scopes**: Chọn **Read** và **Write** (full access)
   - **Expiration**: Tùy chọn (30 days, 90 days, no expiry)
5. Click **Generate Token**
6. **QUAN TRỌNG**: Copy token ngay lập tức (bạn chỉ thấy nó một lần duy nhất!)

{{< callout type="warning" >}}
⚠️ **Bảo mật Token**:
- Token này có quyền truy cập TOÀN BỘ tài khoản DigitalOcean của bạn
- Không commit token vào Git
- Không chia sẻ token qua email/chat
- Sử dụng environment variables hoặc secret managers
- Rotate token định kỳ (30-90 ngày)
- Nếu lộ token, revoke ngay tại API page
{{< /callout >}}

#### Cách 2: Qua doctl CLI (Sau khi đã cài doctl)

```bash
# Sẽ mở browser để authenticate, sau đó tự động tạo token
doctl auth init
```

### 1.3. Lưu Token vào Environment Variable

Sau khi có token, export nó vào environment variable để sử dụng sau này:

```bash
# Linux/macOS
export DIGITALOCEAN_ACCESS_TOKEN="dop_v1_abc123xyz456..."

# Windows PowerShell
$env:DIGITALOCEAN_ACCESS_TOKEN="dop_v1_abc123xyz456..."

# Windows CMD
set DIGITALOCEAN_ACCESS_TOKEN=dop_v1_abc123xyz456...
```

Để token tồn tại sau khi đóng terminal, thêm vào shell profile:

```bash
# Linux/macOS - Thêm vào ~/.bashrc, ~/.zshrc, hoặc ~/.bash_profile
echo 'export DIGITALOCEAN_ACCESS_TOKEN="dop_v1_abc123xyz456..."' >> ~/.bashrc
source ~/.bashrc

# Hoặc tốt hơn, lưu vào file riêng và source
echo 'export DIGITALOCEAN_ACCESS_TOKEN="dop_v1_abc123xyz456..."' > ~/.do_token
echo 'source ~/.do_token' >> ~/.bashrc
chmod 600 ~/.do_token  # Chỉ owner đọc được
```

Verify token hoạt động:

```bash
curl -X GET \
  -H "Authorization: Bearer $DIGITALOCEAN_ACCESS_TOKEN" \
  "https://api.digitalocean.com/v2/account" | jq
```

Kết quả mong đợi:

```json
{
  "account": {
    "droplet_limit": 25,
    "floating_ip_limit": 5,
    "email": "your-email@example.com",
    "uuid": "abc123...",
    "email_verified": true,
    "status": "active",
    "status_message": ""
  }
}
```

---

## Bước 2: Cài đặt & Cấu hình doctl

`doctl` là official CLI tool của DigitalOcean, cho phép quản lý toàn bộ resources (droplets, Kubernetes, volumes, databases, etc.) từ command line.

### 2.1. Cài đặt doctl

Chọn phương pháp phù hợp với hệ điều hành:

#### macOS

```bash
# Sử dụng Homebrew (khuyến nghị)
brew install doctl

# Verify
doctl version
```

#### Linux (Ubuntu/Debian)

```bash
# Sử dụng Snap
sudo snap install doctl

# Hoặc download binary trực tiếp
cd ~
wget https://github.com/digitalocean/doctl/releases/download/v1.104.0/doctl-1.104.0-linux-amd64.tar.gz
tar xf doctl-1.104.0-linux-amd64.tar.gz
sudo mv doctl /usr/local/bin

# Verify
doctl version
```

#### Windows

```powershell
# Sử dụng Chocolatey
choco install doctl

# Hoặc download binary từ GitHub releases
# https://github.com/digitalocean/doctl/releases
# Giải nén và thêm vào PATH

# Verify
doctl version
```

Kết quả mong đợi:

```text
doctl version 1.104.0-release
Git commit hash: a1b2c3d4
```

### 2.2. Authenticate doctl

Sau khi cài đặt, cần authenticate `doctl` với API token:

```bash
doctl auth init
```

Khi được hỏi, paste API token bạn đã tạo ở Bước 1:

```text
Please authenticate doctl for use with your DigitalOcean account. You can generate a token in the control panel at https://cloud.digitalocean.com/account/api/tokens

Enter your access token: dop_v1_abc123xyz456...

Validating token... OK
```

{{< callout type="info" >}}
**Tip**: `doctl` lưu token tại `~/.config/doctl/config.yaml` (Linux/macOS) hoặc `%APPDATA%\doctl\config.yaml` (Windows). File này được protect bởi file permissions, nhưng vẫn nên cẩn thận khi backup/share config.
{{< /callout >}}

### 2.3. Verify Authentication

Kiểm tra xem `doctl` đã kết nối thành công:

```bash
doctl account get
```

Kết quả mong đợi:

```text
Email                    Droplet Limit    Email Verified    UUID                                      Status
your-email@example.com   25               true              abc12345-6789-0def-ghij-klmnopqrstuv    active
```

Nếu thấy thông tin account, bạn đã sẵn sàng sử dụng `doctl`!

### 2.4. Khám phá doctl commands (Optional)

```bash
# List tất cả regions
doctl compute region list

# List tất cả droplet sizes (instance types)
doctl compute size list

# List Kubernetes versions khả dụng
doctl kubernetes options versions

# List Kubernetes cluster sizes
doctl kubernetes options sizes
```

---

## Bước 3: Cài đặt kubectl

`kubectl` là CLI tool chính thức để tương tác với bất kỳ Kubernetes cluster nào (DOKS, EKS, GKE, self-hosted).

### 3.1. Cài đặt kubectl

#### macOS

```bash
# Sử dụng Homebrew
brew install kubectl

# Hoặc download binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify
kubectl version --client
```

#### Linux (Ubuntu/Debian)

```bash
# Cách 1: Sử dụng native package manager
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Cách 2: Download binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify
kubectl version --client
```

#### Windows

```powershell
# Sử dụng Chocolatey
choco install kubernetes-cli

# Hoặc Scoop
scoop install kubectl

# Hoặc download binary
curl.exe -LO "https://dl.k8s.io/release/v1.29.0/bin/windows/amd64/kubectl.exe"
# Thêm vào PATH

# Verify
kubectl version --client
```

Kết quả mong đợi:

```yaml
Client Version: v1.29.2
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
```

{{< callout type="info" >}}
**Lưu ý về version compatibility**: `kubectl` nên match hoặc gần với version của Kubernetes cluster. Ví dụ: kubectl v1.29 có thể quản lý cluster v1.28, v1.29, v1.30. DigitalOcean DOKS hỗ trợ nhiều versions, bạn sẽ chọn khi tạo cluster.
{{< /callout >}}

### 3.2. Enable kubectl autocompletion (Optional nhưng rất hữu ích)

Autocompletion giúp bạn tab-complete commands và resource names:

```bash
# Bash
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
source ~/.bashrc

# Zsh
echo 'source <(kubectl completion zsh)' >> ~/.zshrc
echo 'alias k=kubectl' >> ~/.zshrc
echo 'compdef __start_kubectl k' >> ~/.zshrc
source ~/.zshrc

# Fish
kubectl completion fish | source
```

Test autocompletion:

```bash
kubectl get po<TAB>  # Autocomplete thành 'pods'
k get no<TAB>        # Autocomplete thành 'nodes' (nếu dùng alias k)
```

---

## Bước 4: Tạo DOKS Cluster

Đây là bước quan trọng nhất - tạo cluster Kubernetes đầu tiên! Có 2 cách:

### 4.1. Cách 1: Sử dụng doctl CLI (Khuyến nghị cho DevOps)

```bash
doctl kubernetes cluster create doks-mastery \
  --region sgp1 \
  --version 1.29.1-do.0 \
  --node-pool "name=worker-pool;size=s-2vcpu-2gb;count=2;auto-scale=false" \
  --wait
```

**Giải thích từng flag:**

- `doks-mastery`: Tên cluster (dùng cho identify, không ảnh hưởng DNS)
- `--region sgp1`: Region (Singapore 1). List regions: `doctl compute region list`
  - Chọn region gần users để giảm latency
  - Popular regions: `sgp1` (Singapore), `sfo3` (San Francisco), `nyc1` (New York), `lon1` (London)
- `--version 1.29.1-do.0`: Kubernetes version. List versions: `doctl kubernetes options versions`
  - Khuyến nghị dùng stable version, tránh latest vì có thể có bugs
- `--node-pool`: Cấu hình node pool (worker nodes)
  - `name=worker-pool`: Tên node pool
  - `size=s-2vcpu-2gb`: Instance type (2 vCPU, 2GB RAM, ~$18/tháng per node)
    - List sizes: `doctl kubernetes options sizes`
    - Popular sizes: `s-2vcpu-2gb` (basic), `s-4vcpu-8gb` (production)
  - `count=2`: Số lượng nodes (khuyến nghị ít nhất 2 cho high availability)
  - `auto-scale=false`: Tắt autoscaling (sẽ bật ở phần sau của series)
- `--wait`: Block command cho đến khi cluster ready (thay vì return ngay)

{{< callout type="warning" >}}
⏱️ **Thời gian tạo cluster**: Quá trình này mất khoảng **4-6 phút**. DigitalOcean sẽ:
1. Provision control plane (API server, etcd, scheduler, controller manager)
2. Tạo và boot worker nodes (droplets)
3. Join nodes vào cluster
4. Deploy core add-ons (CoreDNS, kube-proxy, DigitalOcean CSI driver)

Bạn sẽ thấy output tương tự:
```text
Notice: Cluster is provisioning, waiting for cluster to be running
..................................
Notice: Cluster created, fetching credentials
Notice: Adding cluster credentials to kubeconfig file found in "/home/user/.kube/config"
Notice: Setting current-context to do-sgp1-doks-mastery
ID                                      Name            Region    Version        Auto Upgrade    Status     Node Pools
abc12345-6789-0def-ghij-klmnopqrstuv   doks-mastery    sgp1      1.29.1-do.0    false           running    worker-pool
```
{{< /callout >}}

### 4.2. Cách 2: Sử dụng DigitalOcean Web Console (Trực quan hơn)

Nếu bạn thích UI thay vì CLI:

1. Đăng nhập [cloud.digitalocean.com](https://cloud.digitalocean.com)
2. Click **Kubernetes** trong left sidebar
3. Click **Create a Kubernetes Cluster**
4. Cấu hình cluster:
   - **Datacenter region**: Chọn `Singapore - SGP1`
   - **Kubernetes version**: Chọn `1.29.1-do.0` (hoặc latest stable)
   - **Choose a node plan**:
     - Click **Basic nodes**
     - Chọn `2 GB / 1 vCPU` ($12/month per node)
   - **Node pool**:
     - **Node pool name**: `worker-pool`
     - **Node count**: `2` (dùng slider hoặc type)
     - **Autoscale**: Tắt (toggle off)
   - **Cluster name**: `doks-mastery`
   - **Project**: Chọn project (hoặc để default)
   - **Tags**: Optional (ví dụ: `tutorial`, `doks-mastery`)
5. Click **Create Cluster** (nút xanh ở góc dưới bên phải)
6. Chờ 4-6 phút cho cluster provisioning

Khi cluster status chuyển từ `provisioning` sang `running`, bạn sẽ thấy:

- **Overview tab**: Cluster info, resource usage, node pool status
- **Insights tab**: Logs và metrics (cần enable DigitalOcean Monitoring)
- **Settings tab**: Upgrade, autoscaling, destroy cluster

### 4.3. Verify Cluster Creation

```bash
# List tất cả clusters
doctl kubernetes cluster list

# Output mong đợi:
ID                                      Name            Region    Version        Auto Upgrade    Status     Node Pools
abc12345-6789-0def-ghij-klmnopqrstuv   doks-mastery    sgp1      1.29.1-do.0    false           running    worker-pool

# List nodes trong cluster (qua DigitalOcean API)
doctl kubernetes cluster node-pool list doks-mastery

# Output mong đợi:
ID                                      Name           Size             Count
pool-abc123                             worker-pool    s-2vcpu-2gb      2
```

---

## Bước 5: Kết nối với Cluster

Sau khi cluster đã `running`, cần tải kubeconfig file để `kubectl` biết cách kết nối.

### 5.1. Download kubeconfig

```bash
# doctl tự động thêm credentials vào ~/.kube/config khi cluster create xong
# Nếu bạn tạo bằng web console, chạy:
doctl kubernetes cluster kubeconfig save doks-mastery
```

Output:

```text
Notice: Adding cluster credentials to kubeconfig file found in "/home/user/.kube/config"
Notice: Setting current-context to do-sgp1-doks-mastery
```

**Kubeconfig file** (`~/.kube/config`) chứa:
- **Clusters**: Thông tin API server endpoints, CA certificates
- **Users**: Authentication credentials (token, client certs)
- **Contexts**: Mapping giữa cluster + user + namespace
- **Current-context**: Context đang active

{{< callout type="info" >}}
**Quản lý multiple clusters**: Bạn có thể có nhiều clusters (DOKS, minikube, EKS, GKE) trong cùng 1 kubeconfig file. Dùng `kubectl config` để switch giữa chúng:

```bash
# List tất cả contexts
kubectl config get-contexts

# Switch sang context khác
kubectl config use-context do-sgp1-doks-mastery

# Xem current context
kubectl config current-context
```
{{< /callout >}}

### 5.2. Verify Current Context

```bash
kubectl config current-context
```

Output:

```text
do-sgp1-doks-mastery
```

Nếu không phải context bạn muốn:

```bash
kubectl config use-context do-sgp1-doks-mastery
```

### 5.3. Xem kubeconfig details (Optional)

```bash
# Xem toàn bộ kubeconfig
kubectl config view

# Xem chỉ current context
kubectl config view --minify
```

Output (minified):

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://abc12345-6789-0def-ghij-klmnopqrstuv.k8s.ondigitalocean.com
  name: do-sgp1-doks-mastery
contexts:
- context:
    cluster: do-sgp1-doks-mastery
    user: do-sgp1-doks-mastery-admin
  name: do-sgp1-doks-mastery
current-context: do-sgp1-doks-mastery
kind: Config
preferences: {}
users:
- name: do-sgp1-doks-mastery-admin
  user:
    token: REDACTED
```

---

## Bước 6: Kiểm tra sức khỏe Cluster

Bây giờ đã kết nối, hãy verify cluster hoạt động đúng.

### 6.1. Cluster Info

```bash
kubectl cluster-info
```

Output:

```text
Kubernetes control plane is running at https://abc12345-6789-0def-ghij-klmnopqrstuv.k8s.ondigitalocean.com
CoreDNS is running at https://abc12345-6789-0def-ghij-klmnopqrstuv.k8s.ondigitalocean.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

**Giải thích:**
- **Control plane URL**: Endpoint để kubectl giao tiếp với API server (được DigitalOcean host)
- **CoreDNS**: DNS service cho service discovery trong cluster

### 6.2. Check Nodes

```bash
kubectl get nodes
```

Output:

```text
NAME                       STATUS   ROLES    AGE     VERSION
worker-pool-abc1           Ready    <none>   5m30s   v1.29.1
worker-pool-abc2           Ready    <none>   5m28s   v1.29.1
```

**Ý nghĩa:**
- **NAME**: Hostname của node (auto-generated bởi DigitalOcean)
- **STATUS**: `Ready` = node healthy và sẵn sàng nhận pods
- **ROLES**: `<none>` = worker node (control plane nodes không hiển thị vì managed)
- **AGE**: Thời gian node đã join cluster
- **VERSION**: Kubelet version chạy trên node

{{< callout type="warning" >}}
🚨 **Troubleshooting: Node NotReady**

Nếu thấy status `NotReady`, `SchedulingDisabled`, hoặc các vấn đề khác:

```bash
# Xem chi tiết node
kubectl describe node worker-pool-abc1

# Check events (phần dưới cùng của output)
# Look for errors như:
# - Network plugin issues
# - Disk pressure
# - Memory pressure
# - Unschedulable

# Check kubelet logs (nếu có SSH access - DOKS không expose)
# Thường thì DigitalOcean tự fix, chờ vài phút
```

Nếu node vẫn `NotReady` sau 10 phút:
1. Xem DigitalOcean console > Kubernetes > Cluster > Node Pools
2. Thử recycle node (delete và recreate)
3. Contact DigitalOcean support
{{< /callout >}}

### 6.3. Check Namespaces

```bash
kubectl get namespaces
```

Output:

```text
NAME              STATUS   AGE
default           Active   6m
kube-node-lease   Active   6m
kube-public       Active   6m
kube-system       Active   6m
```

**Namespaces mặc định:**
- **default**: Namespace mặc định khi không specify namespace
- **kube-system**: Chứa core system components (CoreDNS, kube-proxy, CSI drivers)
- **kube-public**: Publicly accessible (thường chứa cluster info)
- **kube-node-lease**: Heartbeats từ nodes (node liveness)

### 6.4. Extended Checks

```bash
# Xem nodes với nhiều thông tin hơn
kubectl get nodes -o wide

# Output bổ sung INTERNAL-IP, EXTERNAL-IP, OS-IMAGE, KERNEL-VERSION, CONTAINER-RUNTIME
NAME                       STATUS   ROLES    AGE   VERSION   INTERNAL-IP    EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
worker-pool-abc1           Ready    <none>   8m    v1.29.1   10.XXX.0.2     143.XXX.XXX.1    Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.11
worker-pool-abc2           Ready    <none>   8m    v1.29.1   10.XXX.0.3     143.XXX.XXX.2    Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.11
```

```bash
# Verify API server responsiveness
kubectl get --raw /healthz

# Output: ok

# Verify component status (deprecated in K8s 1.19+ nhưng vẫn có thể chạy)
kubectl get componentstatuses

# Output (có thể thấy "Unhealthy" cho scheduler/controller-manager vì managed):
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE   ERROR
scheduler            Healthy   ok
controller-manager   Healthy   ok
etcd-0               Healthy   ok
```

---

## Bước 7: Khám phá tài nguyên Cluster

Giờ cluster đã healthy, hãy xem DigitalOcean đã deploy những gì.

### 7.1. List All Pods

```bash
kubectl get pods --all-namespaces

# Hoặc dùng shorthand:
kubectl get pods -A
```

Output:

```text
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   cilium-4vt8n                               1/1     Running   0          10m
kube-system   cilium-g9xqw                               1/1     Running   0          10m
kube-system   cilium-operator-5d4b6c7f9d-7lqkx           1/1     Running   0          10m
kube-system   coredns-76f75df574-8xzkr                   1/1     Running   0          10m
kube-system   coredns-76f75df574-k2pqm                   1/1     Running   0          10m
kube-system   csi-do-node-6xrpb                          2/2     Running   0          10m
kube-system   csi-do-node-bnm8s                          2/2     Running   0          10m
kube-system   do-node-agent-fqz7d                        1/1     Running   0          10m
kube-system   do-node-agent-w8xhr                        1/1     Running   0          10m
kube-system   kube-proxy-n4xkv                           1/1     Running   0          10m
kube-system   kube-proxy-z9mxp                           1/1     Running   0          10m
```

**Core components DigitalOcean deploy:**

- **Cilium** (`cilium-*`): CNI plugin cho networking và network policies
  - Mỗi node chạy 1 cilium agent (DaemonSet)
  - Cilium operator quản lý cluster-wide logic
- **CoreDNS** (`coredns-*`): DNS server cho service discovery
  - 2 replicas để high availability
- **CSI Driver** (`csi-do-node-*`): DigitalOcean CSI (Container Storage Interface)
  - Cho phép pods sử dụng DigitalOcean Block Storage volumes
- **DigitalOcean Node Agent** (`do-node-agent-*`): Monitoring và metrics collection
- **kube-proxy** (`kube-proxy-*`): Network proxy cho Services

### 7.2. Xem kube-system Resources

```bash
# List deployments
kubectl get deployments -n kube-system

# Output:
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
cilium-operator   1/1     1            1           12m
coredns           2/2     2            2           12m

# List daemonsets (chạy trên MỌI nodes)
kubectl get daemonsets -n kube-system

# Output:
NAME            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
cilium          2         2         2       2            2           <none>          12m
csi-do-node     2         2         2       2            2           <none>          12m
do-node-agent   2         2         2       2            2           <none>          12m
kube-proxy      2         2         2       2            2           <none>          12m

# List services
kubectl get services -n kube-system

# Output:
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.245.0.10     <none>        53/UDP,53/TCP,9153/TCP   12m
```

### 7.3. Resource Usage (Cần metrics-server)

DOKS clusters có metrics-server enabled mặc định:

```bash
# Xem CPU/Memory usage của nodes
kubectl top nodes
```

Output:

```text
NAME               CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
worker-pool-abc1   89m          4%     945Mi           48%
worker-pool-abc2   76m          3%     892Mi           45%
```

```bash
# Xem CPU/Memory usage của pods
kubectl top pods -A
```

Output:

```text
NAMESPACE     NAME                                       CPU(cores)   MEMORY(bytes)
kube-system   cilium-4vt8n                               12m          142Mi
kube-system   cilium-g9xqw                               10m          138Mi
kube-system   cilium-operator-5d4b6c7f9d-7lqkx           3m           45Mi
kube-system   coredns-76f75df574-8xzkr                   2m           18Mi
kube-system   coredns-76f75df574-k2pqm                   2m           17Mi
...
```

{{< callout type="info" >}}
**Hiểu Resource Units:**
- **CPU**: `1000m` (millicores) = 1 vCPU. Ví dụ: `89m` = 0.089 vCPU
- **Memory**: `Mi` (Mebibytes) ≈ MB. `945Mi` ≈ 991 MB
- **Percentage**: So với allocatable resources trên node (không phải total)

Node `s-2vcpu-2gb` có:
- 2 vCPU = 2000m cores
- 2GB RAM ≈ 1907Mi (OS dùng ~100Mi)
{{< /callout >}}

### 7.4. Explore API Resources

```bash
# List tất cả resource types cluster hỗ trợ
kubectl api-resources

# Output (excerpt):
NAME                     SHORTNAMES   APIVERSION              NAMESPACED   KIND
pods                     po           v1                      true         Pod
services                 svc          v1                      true         Service
deployments              deploy       apps/v1                 true         Deployment
statefulsets             sts          apps/v1                 true         StatefulSet
persistentvolumes        pv           v1                      false        PersistentVolume
persistentvolumeclaims   pvc          v1                      true         PersistentVolumeClaim
...
```

---

## Tổng kết & Bước tiếp theo

🎉 **Chúc mừng!** Bạn đã hoàn thành phần 1 và có:

✅ Tài khoản DigitalOcean với API token
✅ `doctl` và `kubectl` CLI tools được cấu hình
✅ DOKS cluster đang chạy với 2 worker nodes
✅ Kubeconfig được setup và verified
✅ Hiểu biết cơ bản về kiến trúc DOKS và core components

### Recap các lệnh quan trọng:

```bash
# Cluster management
doctl kubernetes cluster list
doctl kubernetes cluster kubeconfig save <cluster-name>
kubectl config current-context

# Health checks
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
kubectl top nodes

# Explore resources
kubectl get all -A
kubectl describe node <node-name>
kubectl logs <pod-name> -n <namespace>
```

### Trong **DOKS Mastery Phần 2**, chúng ta sẽ:

- 🚀 Deploy ứng dụng đầu tiên lên cluster (Deployment, Service)
- 🌐 Expose ứng dụng ra ngoài internet với LoadBalancer
- 📦 Sử dụng DigitalOcean Block Storage làm persistent volumes
- 🔄 Scale ứng dụng lên/xuống
- 🛡️ Cấu hình health checks và rolling updates

### Cleanup (Nếu muốn xóa cluster để tránh phí)

{{< callout type="warning" >}}
⚠️ **Lưu ý**: Lệnh này sẽ XÓA cluster vĩnh viễn và tất cả resources trong đó!
{{< /callout >}}

```bash
# Cách 1: CLI
doctl kubernetes cluster delete doks-mastery

# Confirm khi được hỏi
Warning: Are you sure you want to delete this Kubernetes cluster? (y/N) ? y

# Cách 2: Web Console
# DigitalOcean Console > Kubernetes > doks-mastery > Settings > Destroy
```

Sau khi delete, verify:

```bash
doctl kubernetes cluster list

# Output: ID    Name    Region    Version    Auto Upgrade    Status    Node Pools
# (empty)
```

### Tài nguyên tham khảo:

- 📖 [DigitalOcean Kubernetes Documentation](https://docs.digitalocean.com/products/kubernetes/)
- 📖 [Kubernetes Official Docs](https://kubernetes.io/docs/home/)
- 📖 [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- 📖 [doctl Reference](https://docs.digitalocean.com/reference/doctl/)

---

**Hẹn gặp lại ở Phần 2!** 🚀

Nếu có câu hỏi hoặc gặp vấn đề, để lại comment bên dưới hoặc tham gia [DigitalOcean Community](https://www.digitalocean.com/community/questions).
