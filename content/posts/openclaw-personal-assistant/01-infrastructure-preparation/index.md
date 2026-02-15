---
title: "Phần 1: Chuẩn bị hạ tầng VPS cho OpenClaw"
date: 2026-02-15
draft: false
description: "Hướng dẫn thiết lập VPS Linux bảo mật cho OpenClaw - cấu hình SSH hardening, UFW firewall, Caddy reverse proxy và chuẩn bị môi trường runtime"
categories: ["AI Assistant"]
tags: ["openclaw", "vps", "infrastructure", "linux", "ssh-hardening"]
series: ["OpenClaw Personal Assistant"]
weight: 1
mermaid: true
---

## Giới thiệu

Trước khi cài đặt OpenClaw, chúng ta cần chuẩn bị một VPS Linux bảo mật và tối ưu. Bài viết này hướng dẫn từng bước thiết lập hạ tầng từ cơ bản đến nâng cao.

**Bạn sẽ học được:**

- ✓ Cấu hình VPS Linux cơ bản (swap, timezone, packages)
- ✓ Hardening SSH với key-based authentication
- ✓ Thiết lập UFW firewall bảo mật
- ✓ Cài đặt Podman rootless cho container isolation
- ✓ Deploy Caddy reverse proxy với auto-TLS
- ✓ Tạo dedicated user cho OpenClaw
- ✓ Cài đặt Node.js 22+ và pnpm

**Điều kiện tiên quyết:**

- VPS Linux với 2GB+ RAM, 20GB+ SSD, IPv4 public
- SSH key pair đã tạo sẵn
- (Tùy chọn) Domain name trỏ về VPS IP

## Kiến trúc tổng quan

{{< mermaid >}}
graph TB
    Internet[Internet]
    Caddy[Caddy Reverse Proxy<br/>:443 HTTPS]
    OpenClaw[OpenClaw Daemon<br/>:18789]
    SSH[SSH Server<br/>:22]
    UFW[UFW Firewall]

    Internet -->|443/HTTPS| UFW
    Internet -->|22/SSH| UFW
    UFW -->|Allow 443| Caddy
    UFW -->|Allow 22| SSH
    Caddy -->|Proxy| OpenClaw

    subgraph VPS
        UFW
        Caddy
        OpenClaw
        SSH
    end

    style Caddy fill:#00ADD8
    style OpenClaw fill:#FF6B6B
    style UFW fill:#4ECDC4
{{< /mermaid >}}

**Hai kịch bản triển khai:**

1. **Có domain:** Internet → Caddy (HTTPS:443) → OpenClaw (localhost:18789)
2. **Chỉ IP:** Internet → OpenClaw (IP:18789) hoặc SSH tunnel

## Bước 1: Yêu cầu VPS

### Cấu hình tối thiểu

| Thông số | Yêu cầu | Khuyến nghị |
|----------|---------|-------------|
| CPU | 1 core | 2+ cores |
| RAM | 2GB | 4GB+ |
| SSD | 20GB | 40GB+ |
| OS | Ubuntu 22.04 | Ubuntu 24.04 LTS |
| Network | IPv4 public | IPv4 + IPv6 |

### Nhà cung cấp đề xuất

- **Hetzner Cloud** - €4.15/tháng (CX22: 2 vCPU, 4GB RAM)
- **DigitalOcean** - $12/tháng (Basic: 2 vCPU, 2GB RAM)
- **Vultr** - $12/tháng (Regular Performance)
- **Linode** - $12/tháng (Linode 4GB)

{{< callout type="info" >}}
**Lưu ý về RAM:** LLM model 7B cần ~4-6GB RAM. Nếu VPS chỉ có 2GB, cần cấu hình swap và chấp nhận tốc độ chậm hơn.
{{< /callout >}}

### Tạo SSH key (nếu chưa có)

```bash
# Trên máy local
ssh-keygen -t ed25519 -C "openclaw-vps" -f ~/.ssh/openclaw_ed25519

# Upload public key lên VPS khi tạo
cat ~/.ssh/openclaw_ed25519.pub
```

## Bước 2: Cài đặt OS ban đầu

### Kết nối VPS lần đầu

```bash
# Thay YOUR_VPS_IP bằng IP thực tế
ssh root@YOUR_VPS_IP

# Kiểm tra OS version
cat /etc/os-release
```

### Cập nhật hệ thống

```bash
# Update package lists
apt update && apt upgrade -y

# Cài đặt essential tools
apt install -y curl wget git vim htop ufw fail2ban \
  software-properties-common apt-transport-https \
  ca-certificates gnupg lsb-release
```

### Cấu hình swap (nếu RAM < 4GB)

```bash
# Tạo 4GB swap file
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Persistent qua reboot
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Giảm swappiness để ưu tiên RAM
echo 'vm.swappiness=10' >> /etc/sysctl.conf
sysctl -p

# Verify
free -h
```

{{< callout type="warning" >}}
**Swap không thay thế RAM:** Nếu model thường xuyên sử dụng swap, hiệu năng sẽ giảm mạnh. Nâng cấp RAM nếu có thể.
{{< /callout >}}

### Cấu hình timezone

```bash
# Set timezone (ví dụ Asia/Ho_Chi_Minh)
timedatectl set-timezone Asia/Ho_Chi_Minh

# Enable NTP sync
timedatectl set-ntp true

# Verify
timedatectl status
```

## Bước 3: Hardening SSH

### Cấu hình SSH daemon

```bash
# Backup config gốc
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Edit config
vim /etc/ssh/sshd_config
```

**Các thay đổi cần thiết:**

```ini
# Disable root login
PermitRootLogin no

# Chỉ cho phép key authentication
PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no

# Hạn chế auth attempts
MaxAuthTries 3
MaxSessions 5

# Tắt các tính năng không cần
X11Forwarding no
PermitEmptyPasswords no

# Timeout idle connections
ClientAliveInterval 300
ClientAliveCountMax 2

# Chỉ cho phép user cụ thể (thêm sau khi tạo user)
AllowUsers openclaw
```

{{< callout type="danger" >}}
**QUAN TRỌNG:** Giữ session SSH hiện tại mở. Mở tab mới để test SSH trước khi đóng session gốc!
{{< /callout >}}

### Test và apply SSH config

```bash
# Test config syntax
sshd -t

# Reload SSH service
systemctl reload sshd

# Check status
systemctl status sshd
```

## Bước 4: Cấu hình UFW Firewall

### Enable và cấu hình UFW

```bash
# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (QUAN TRỌNG - làm trước!)
ufw allow 22/tcp comment 'SSH'

# Allow HTTP/HTTPS (nếu dùng domain)
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'

# Hoặc allow port trực tiếp (nếu chỉ dùng IP)
# ufw allow 18789/tcp comment 'OpenClaw'

# Enable firewall
ufw --force enable

# Check status
ufw status verbose
```

**Output mong đợi:**

```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
```

{{< callout type="warning" >}}
**Lưu session SSH:** Nếu vô tình block port 22, bạn sẽ bị khóa ngoài VPS. Luôn giữ 1 session SSH active khi thay đổi firewall!
{{< /callout >}}

### Cấu hình fail2ban

```bash
# Install fail2ban
apt install -y fail2ban

# Tạo local config
cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = 22
logpath = /var/log/auth.log
EOF

# Enable và start
systemctl enable fail2ban
systemctl start fail2ban

# Check status
fail2ban-client status sshd
```

## Bước 5: Cài đặt Podman Rootless

Podman cho phép chạy container không cần root privileges, tăng cường bảo mật.

```bash
# Install Podman
apt install -y podman

# Verify version (cần 4.0+)
podman --version

# Test rootless mode
podman run --rm hello-world
```

### Cấu hình registries

```bash
# Thêm Docker Hub và Quay.io
mkdir -p /etc/containers
cat > /etc/containers/registries.conf <<'EOF'
[registries.search]
registries = ['docker.io', 'quay.io']

[registries.insecure]
registries = []

[registries.block]
registries = []
EOF
```

## Bước 6: Cài đặt Caddy Reverse Proxy

### Kịch bản A: Có domain name

```bash
# Install Caddy
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
  | tee /etc/apt/sources.list.d/caddy-stable.list

apt update
apt install -y caddy

# Verify
caddy version
```

**Cấu hình Caddyfile:**

```bash
# Thay YOUR_DOMAIN bằng domain thực tế
vim /etc/caddy/Caddyfile
```

```caddy
# /etc/caddy/Caddyfile
your-domain.com {
    reverse_proxy localhost:18789

    # Security headers
    header {
        Strict-Transport-Security "max-age=31536000;"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "no-referrer-when-downgrade"
    }

    # Access logging
    log {
        output file /var/log/caddy/openclaw.log
        format json
    }
}
```

```bash
# Reload Caddy
systemctl reload caddy

# Check status
systemctl status caddy
```

{{< callout type="tip" >}}
**Auto-TLS:** Caddy tự động xin Let's Encrypt certificate cho domain. Chờ 1-2 phút để cert được issue.
{{< /callout >}}

### Kịch bản B: Chỉ có IP (không domain)

**Không cần Caddy.** Hai lựa chọn:

1. **Access trực tiếp:** `http://YOUR_VPS_IP:18789` (không HTTPS)
2. **SSH Tunnel (khuyến nghị):**

```bash
# Trên máy local
ssh -L 8789:localhost:18789 openclaw@YOUR_VPS_IP

# Truy cập http://localhost:8789 trên browser
```

{{< callout type="info" >}}
**Tại sao SSH tunnel?** Mã hóa traffic qua SSH, không cần expose port 18789 ra internet.
{{< /callout >}}

## Bước 7: Tạo dedicated user openclaw

```bash
# Tạo user với home directory
useradd -m -s /bin/bash openclaw

# Set password (hoặc chỉ dùng SSH key)
passwd openclaw

# Add SSH key cho user
mkdir -p /home/openclaw/.ssh
chmod 700 /home/openclaw/.ssh

# Copy authorized_keys từ root hoặc paste key mới
cp /root/.ssh/authorized_keys /home/openclaw/.ssh/
chown -R openclaw:openclaw /home/openclaw/.ssh
chmod 600 /home/openclaw/.ssh/authorized_keys

# Add sudo privileges (nếu cần)
usermod -aG sudo openclaw
```

**Test SSH với user mới:**

```bash
# Từ máy local
ssh -i ~/.ssh/openclaw_ed25519 openclaw@YOUR_VPS_IP

# Verify user
whoami
pwd
```

## Bước 8: Cài đặt Node.js 22+ và pnpm

### Cài Node.js qua NodeSource

```bash
# Switch sang user openclaw
su - openclaw

# Download NodeSource setup script
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

# Install Node.js
sudo apt install -y nodejs

# Verify versions
node --version  # v22.x.x
npm --version   # 10.x.x
```

### Cài đặt pnpm

```bash
# Install pnpm globally
npm install -g pnpm

# Verify
pnpm --version

# Configure pnpm store
pnpm config set store-dir ~/.pnpm-store
```

### Cài thêm build tools

```bash
# Cần cho native modules
sudo apt install -y build-essential python3
```

## Bước 9: Verification Checklist

Kiểm tra từng bước trước khi tiếp tục:

**System basics:**
```bash
# OS và packages updated
apt list --upgradable

# Swap active
swapon --show

# Timezone correct
timedatectl status
```

**Security:**
```bash
# SSH hardened
sudo sshd -t
grep "PermitRootLogin no" /etc/ssh/sshd_config

# UFW active
sudo ufw status

# fail2ban running
sudo fail2ban-client status
```

**Runtime environment:**
```bash
# Podman working
podman ps

# Caddy running (nếu có domain)
sudo systemctl status caddy

# Node.js và pnpm installed
node --version
pnpm --version
```

**User setup:**
```bash
# openclaw user exists
id openclaw

# SSH key authentication works
# (test từ máy local)
```

{{< callout type="tip" >}}
**Debug tips:**
- `journalctl -xe` - xem system logs
- `systemctl status <service>` - check service status
- `ss -tlnp` - xem ports đang listening
{{< /callout >}}

## Tổng kết

Bạn đã hoàn thành việc chuẩn bị hạ tầng VPS với:

- ✅ OS Linux bảo mật và tối ưu
- ✅ SSH hardening với key-only authentication
- ✅ UFW firewall và fail2ban
- ✅ Podman rootless container runtime
- ✅ Caddy reverse proxy với auto-TLS (nếu có domain)
- ✅ Dedicated user `openclaw`
- ✅ Node.js 22+ và pnpm runtime

**Kiến trúc hiện tại:**

```
VPS (Ubuntu 24.04)
├── openclaw user
│   ├── Node.js 22+
│   └── pnpm
├── Podman (rootless)
├── Caddy (reverse proxy) [optional]
├── UFW (firewall)
└── fail2ban (intrusion prevention)
```

## Bước tiếp theo

Trong [Phần 2: Cài đặt và cấu hình OpenClaw](../02-installation-configuration/), chúng ta sẽ:

- Cài đặt Ollama và pull LLM models
- Deploy OpenClaw daemon với systemd
- Cấu hình multi-LLM providers
- Setup web UI access
- Verify toàn bộ hệ thống hoạt động

Hẹn gặp lại! 🚀
