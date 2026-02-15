---
title: "Tăng Cường Bảo Mật OpenClaw - Hardening và Audit"
date: 2026-02-15
draft: false
description: "Hướng dẫn hardening OpenClaw AI Assistant: file permissions, fail2ban, audit plugins, API key protection, automated security updates cho self-hosted LLM"
categories: ["AI Assistant"]
tags: ["openclaw", "security", "fail2ban", "hardening", "linux-security"]
series: ["OpenClaw Personal Assistant"]
weight: 4
---

## Giới thiệu

OpenClaw đang chạy trên server của bạn với quyền truy cập hệ thống, LLM API keys, và dữ liệu cá nhân. **Một lỗi bảo mật nhỏ có thể dẫn đến mất tiền, rò rỉ dữ liệu, hoặc server bị chiếm quyền.**

Nghiên cứu bảo mật năm 2025 phát hiện **hàng trăm API keys của OpenClaw và các AI assistants tương tự bị lộ công khai trên GitHub và Pastebin**. Kẻ tấn công quét tự động để tìm keys này và sử dụng LLM credits của nạn nhân.

Bài này hướng dẫn hardening hệ thống vượt xa baseline ở [Phần 01](/posts/openclaw-personal-assistant/01-infrastructure-preparation/) và [Phần 02](/posts/openclaw-personal-assistant/02-installation-configuration/).

### Mục tiêu học tập

Sau bài này bạn sẽ:

- ✅ Hardening file permissions để chỉ user openclaw truy cập
- ✅ Cài đặt fail2ban để chống brute-force SSH
- ✅ Audit plugins/skills trước khi cài đặt
- ✅ Bảo vệ API keys khỏi lộ lọt ra ngoài
- ✅ Thiết lập automated security updates
- ✅ Tạo cron job audit hàng tuần

### Yêu cầu trước khi bắt đầu

- ✅ OpenClaw đã cài đặt (xem Phần 02)
- ✅ Quyền sudo trên server
- ✅ Đã đọc [Phần 03](/posts/openclaw-personal-assistant/03-messaging-channel-integration/) về messaging channels
- ✅ Hiểu cơ bản về Linux permissions và systemd

---

## 1. Xác Minh User Isolation

### Bước 1a: Kiểm Tra OpenClaw Chạy Với User Riêng

```bash
# Kiểm tra process đang chạy
ps aux | grep openclaw

# Output mong đợi:
# openclaw  12345  1.2  3.4  openclaw serve ...
# KHÔNG được: root  12345  ... openclaw serve
```

{{< callout type="danger" >}}
**NGUY HIỂM:** Nếu OpenClaw chạy với quyền root, DỪNG NGAY và cài lại theo
Phần 02. AI có thể thực thi lệnh hệ thống với quyền root!
{{< /callout >}}

### Bước 1b: Kiểm Tra Home Directory Permissions

```bash
# Kiểm tra quyền truy cập
ls -la /home/openclaw

# Output mong đợi:
# drwx------ 5 openclaw openclaw 4096 Feb 15 10:30 .openclaw
# drwx------ 3 openclaw openclaw 4096 Feb 15 10:25 workspace

# Nếu có quyền 'r' hoặc 'x' cho others (------rwx), sửa ngay:
sudo chmod 700 /home/openclaw/.openclaw
sudo chmod 700 /home/openclaw/workspace
```

### Bước 1c: Xác Minh Sudoers Configuration

```bash
# Kiểm tra user openclaw KHÔNG có quyền sudo
sudo -l -U openclaw

# Output an toàn:
# User openclaw is not allowed to run sudo on this host.

# NGUY HIỂM nếu thấy:
# User openclaw may run the following commands: ALL=(ALL) NOPASSWD: ALL
```

Nếu có quyền sudo không cần thiết:

```bash
# Xóa khỏi sudoers
sudo deluser openclaw sudo
```

---

## 2. Hardening File Permissions

### Bước 2a: Bảo Vệ File Cấu Hình

```bash
# Đảm bảo chỉ openclaw user đọc được
sudo -u openclaw chmod 600 /home/openclaw/.openclaw/openclaw.json
sudo -u openclaw chmod 600 /home/openclaw/.openclaw/api-keys.enc

# Kiểm tra
ls -l /home/openclaw/.openclaw/

# Output mong đợi (lưu ý: -rw-------)
# -rw------- 1 openclaw openclaw  2048 Feb 15 openclaw.json
# -rw------- 1 openclaw openclaw  1024 Feb 15 api-keys.enc
```

### Bước 2b: Bảo Vệ Workspace Directory

```bash
# Giới hạn quyền workspace
sudo -u openclaw chmod 700 /home/openclaw/workspace

# Nếu có subdirectories
sudo -u openclaw find /home/openclaw/workspace -type d -exec chmod 700 {} \;
sudo -u openclaw find /home/openclaw/workspace -type f -exec chmod 600 {} \;
```

### Bước 2c: Bảo Vệ Logs

```bash
# Logs có thể chứa sensitive data
sudo chmod 640 /var/log/openclaw/*.log
sudo chown openclaw:adm /var/log/openclaw/*.log

# Chỉ user openclaw và group adm đọc được
```

{{< callout type="info" >}}
**THÔNG TIN:** Quyền 600 = chỉ owner đọc/ghi. Quyền 700 = chỉ owner
đọc/ghi/thực thi. Quyền 640 = owner đọc/ghi, group đọc, others không có quyền.
{{< /callout >}}

---

## 3. Rootless Container Verification

### Bước 3a: Kiểm Tra Ollama Chạy Rootless

```bash
# Nếu dùng Podman (khuyến nghị)
podman info | grep -i rootless

# Output mong đợi:
# rootless: true

# Nếu dùng Docker
docker info | grep -i "Root Dir"

# An toàn: /home/username/.local/share/docker
# NGUY HIỂM: /var/lib/docker (chạy với root)
```

### Bước 3b: Xác Minh Không Dùng Privileged Flags

```bash
# Kiểm tra container flags
podman inspect ollama | grep -i privileged

# Output an toàn:
# "Privileged": false

# NGUY HIỂM nếu thấy:
# "Privileged": true
```

{{< callout type="warning" >}}
**CẢNH BÁO:** Privileged containers có quyền root trên host. Chỉ dùng khi thực
sự cần thiết (ví dụ: GPU passthrough).
{{< /callout >}}

---

## 4. Cài Đặt và Cấu Hình Fail2ban

Fail2ban chống brute-force attacks vào SSH và các services khác.

### Bước 4a: Cài Đặt Fail2ban

```bash
sudo apt update
sudo apt install -y fail2ban

# Kiểm tra status
sudo systemctl status fail2ban
```

### Bước 4b: Cấu Hình SSH Jail

```bash
# Tạo local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Thêm/sửa phần `[sshd]`:

```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
```

**Giải thích:**

- `maxretry = 3`: Ban sau 3 lần đăng nhập sai
- `bantime = 3600`: Ban 1 giờ (3600 giây)
- `findtime = 600`: Đếm retries trong 10 phút

### Bước 4c: Thêm Jail Cho OpenClaw API (Nếu Expose)

Nếu bạn expose OpenClaw API qua internet (KHÔNG khuyến nghị):

```bash
sudo nano /etc/fail2ban/filter.d/openclaw.conf
```

Nội dung:

```ini
[Definition]
failregex = ^.*OpenClaw API: Unauthorized access from <HOST>.*$
ignoreregex =
```

Thêm vào `/etc/fail2ban/jail.local`:

```ini
[openclaw]
enabled = true
port = 8080
filter = openclaw
logpath = /var/log/openclaw/access.log
maxretry = 5
bantime = 7200
```

### Bước 4d: Khởi Động Lại Fail2ban

```bash
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Kiểm tra status
sudo fail2ban-client status

# Output:
# Status
# |- Number of jail:      1
# `- Jail list:   sshd
```

### Bước 4e: Kiểm Tra Banned IPs

```bash
# Xem IPs bị ban
sudo fail2ban-client status sshd

# Unban IP (nếu ban nhầm)
sudo fail2ban-client set sshd unbanip 1.2.3.4
```

{{< callout type="tip" >}}
**MẸO:** Thêm IP của bạn vào whitelist để tránh tự ban:
`ignoreip = 127.0.0.1/8 ::1 YOUR_HOME_IP`
{{< /callout >}}

---

## 5. Bảo Vệ API Keys

### Bước 5a: Audit Environment Variables

```bash
# Kiểm tra env vars (KHÔNG nên lưu keys ở đây)
env | grep -i "api\|key\|token\|secret"

# Nếu thấy keys, xóa ngay:
unset OPENAI_API_KEY
unset ANTHROPIC_API_KEY

# Xóa khỏi .bashrc, .profile, .zshrc
nano ~/.bashrc  # Xóa dòng export API_KEY=...
```

{{< callout type="danger" >}}
**NGUY HIỂM CẤP CAO:** Hàng trăm API keys bị lộ vì:
1. Commit vào Git (.env files)
2. Paste vào bash history
3. Lưu trong env vars rồi screenshot terminal
4. Logs không filter sensitive data
{{< /callout >}}

### Bước 5b: Kiểm Tra Bash History

```bash
# Tìm keys trong history
history | grep -i "api\|key\|token"

# Xóa dòng cụ thể (ví dụ dòng 123)
history -d 123

# Hoặc xóa toàn bộ history
history -c
history -w
```

### Bước 5c: Kiểm Tra Git Repositories

```bash
# Tìm files có thể chứa keys
find ~ -name ".env" -o -name "*.key" -o -name "*secret*" 2>/dev/null

# Kiểm tra nếu đã commit nhầm
cd /home/openclaw/workspace
git log --all --full-history -- .env

# Nếu có, xóa khỏi git history (NGUY HIỂM - backup trước!)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (nếu đã push lên remote)
# git push origin --force --all
```

### Bước 5d: Sử Dụng OpenClaw Secrets Manager

```bash
# Lưu keys vào encrypted vault
openclaw secrets add OPENAI_API_KEY \
  --value "sk-..." \
  --encrypt-with-passphrase

# Kiểm tra secrets
openclaw secrets list

# Output:
# NAME              ENCRYPTED  LAST_MODIFIED
# OPENAI_API_KEY    ✓          2026-02-15 10:30
```

{{< callout type="info" >}}
**THÔNG TIN:** OpenClaw secrets được mã hóa AES-256 với passphrase. Chỉ user
openclaw với passphrase đúng mới giải mã được.
{{< /callout >}}

---

## 6. Plugin và Skill Audit Policy

### Bước 6a: Chỉ Cài Plugins Từ Nguồn Tin Cậy

```bash
# Kiểm tra plugin trước khi cài
openclaw plugin info <plugin-name>

# Output hiển thị:
# - Tác giả
# - Permissions yêu cầu (filesystem, network, shell)
# - Source code repository
# - Số downloads
# - Reviews
```

{{< callout type="danger" >}}
**NGUY HIỂM:** Plugins có quyền thực thi code trên server. Một plugin độc hại
có thể:
- Đánh cắp API keys
- Xóa files
- Cài backdoor
- Gửi dữ liệu ra ngoài
{{< /callout >}}

### Bước 6b: Chạy Security Audit

```bash
# Audit toàn bộ plugins đã cài
openclaw security audit --deep

# Output:
# PLUGIN NAME       RISK   ISSUES
# file-manager      LOW    Uses filesystem access (expected)
# web-scraper       MED    Network access, no HTTPS verification
# shell-executor    HIGH   Can execute arbitrary commands
```

### Bước 6c: Giới Hạn Plugin Permissions

```bash
# Chỉnh sửa plugin config
nano /home/openclaw/.openclaw/plugins/shell-executor/config.json
```

Giới hạn quyền:

```json
{
  "permissions": {
    "filesystem": false,
    "network": false,
    "shell": {
      "allowCommands": ["ls", "cat", "grep"],
      "denyCommands": ["rm", "dd", "curl", "wget"]
    }
  }
}
```

### Bước 6d: Whitelist Chỉ ClawHub Official Plugins

```bash
# Thêm vào openclaw.json
nano /home/openclaw/.openclaw/openclaw.json
```

```json
{
  "pluginPolicy": {
    "allowOnlyOfficial": true,
    "trustedSources": [
      "https://clawhub.io/plugins",
      "https://github.com/openclaw-official"
    ],
    "autoUpdate": false,
    "requireManualApproval": true
  }
}
```

### Bước 6e: Review Plugin Code

```bash
# Xem source code trước khi cài
openclaw plugin download suspicious-plugin --no-install
cd /tmp/suspicious-plugin
cat plugin.py

# Tìm suspicious patterns
grep -r "eval\|exec\|__import__\|subprocess" .
grep -r "api.*key\|token\|secret" .
```

{{< callout type="tip" >}}
**MẸO:** Tạo checklist audit:
- ✅ Plugin từ ClawHub official?
- ✅ Có >1000 downloads?
- ✅ Có reviews tích cực?
- ✅ Source code public trên GitHub?
- ✅ Không yêu cầu permissions không cần thiết?
- ✅ Audit scan không báo HIGH risk?
{{< /callout >}}

---

## 7. Automated Security Updates

### Bước 7a: Cài Đặt Unattended Upgrades

```bash
sudo apt update
sudo apt install -y unattended-upgrades apt-listchanges

# Cấu hình
sudo dpkg-reconfigure -plow unattended-upgrades
```

### Bước 7b: Cấu Hình Auto-Update Security Patches

```bash
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

Đảm bảo có dòng:

```conf
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};

Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Mail "your-email@example.com";
Unattended-Upgrade::Automatic-Reboot "false";
```

### Bước 7c: Kiểm Tra Logs

```bash
# Xem updates tự động
sudo cat /var/log/unattended-upgrades/unattended-upgrades.log

# Kiểm tra có lỗi không
sudo grep -i "error" /var/log/unattended-upgrades/*.log
```

---

## 8. Weekly Security Audit Cron Job

### Bước 8a: Tạo Script Audit

```bash
sudo nano /usr/local/bin/openclaw-security-audit.sh
```

Nội dung:

```bash
#!/bin/bash
# OpenClaw Weekly Security Audit Script

REPORT_DIR="/var/log/openclaw/audit"
REPORT_FILE="$REPORT_DIR/audit-$(date +%Y%m%d-%H%M%S).log"
ADMIN_EMAIL="your-email@example.com"

mkdir -p "$REPORT_DIR"

echo "=== OpenClaw Security Audit Report ===" > "$REPORT_FILE"
echo "Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. Check plugin permissions
echo "=== Plugin Audit ===" >> "$REPORT_FILE"
sudo -u openclaw openclaw security audit --deep >> "$REPORT_FILE" 2>&1

# 2. Check file permissions
echo "" >> "$REPORT_FILE"
echo "=== File Permissions Check ===" >> "$REPORT_FILE"
find /home/openclaw/.openclaw -type f ! -perm 600 >> "$REPORT_FILE" 2>&1

# 3. Check for exposed API keys
echo "" >> "$REPORT_FILE"
echo "=== API Key Exposure Check ===" >> "$REPORT_FILE"
sudo -u openclaw grep -r "sk-\|api_key" /home/openclaw/workspace \
  2>/dev/null | head -20 >> "$REPORT_FILE"

# 4. Check failed login attempts
echo "" >> "$REPORT_FILE"
echo "=== Failed Login Attempts ===" >> "$REPORT_FILE"
sudo fail2ban-client status sshd >> "$REPORT_FILE" 2>&1

# 5. Check system updates
echo "" >> "$REPORT_FILE"
echo "=== Pending Security Updates ===" >> "$REPORT_FILE"
apt list --upgradable 2>/dev/null | grep -i security >> "$REPORT_FILE"

# Email report if issues found
if grep -i "high\|critical\|exposed" "$REPORT_FILE" > /dev/null; then
    mail -s "OpenClaw Security Alert" "$ADMIN_EMAIL" < "$REPORT_FILE"
fi

echo "Audit complete: $REPORT_FILE"
```

Cấp quyền thực thi:

```bash
sudo chmod 755 /usr/local/bin/openclaw-security-audit.sh
```

### Bước 8b: Tạo Cron Job

```bash
sudo crontab -e
```

Thêm dòng (chạy mỗi Chủ nhật 3h sáng):

```cron
0 3 * * 0 /usr/local/bin/openclaw-security-audit.sh
```

### Bước 8c: Test Script

```bash
# Chạy thử
sudo /usr/local/bin/openclaw-security-audit.sh

# Kiểm tra output
cat /var/log/openclaw/audit/audit-*.log
```

---

## 9. Network Security Verification

### Bước 9a: Kiểm Tra Ollama Chỉ Listen Localhost

```bash
# Kiểm tra Ollama port
sudo ss -tlnp | grep 11434

# Output an toàn:
# 127.0.0.1:11434  (chỉ localhost)

# NGUY HIỂM:
# 0.0.0.0:11434  (public internet)
```

Nếu expose ra ngoài:

```bash
# Sửa Ollama config
nano ~/.ollama/config.json
```

Thêm:

```json
{
  "server": {
    "host": "127.0.0.1",
    "port": 11434
  }
}
```

### Bước 9b: Kiểm Tra OpenClaw API

```bash
# OpenClaw cũng chỉ nên listen localhost
sudo ss -tlnp | grep openclaw

# Output an toàn:
# 127.0.0.1:8080
```

### Bước 9c: Cấu Hình UFW (Uncomplicated Firewall)

```bash
# Cài đặt UFW
sudo apt install -y ufw

# Deny tất cả incoming
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Chỉ allow SSH
sudo ufw allow 22/tcp

# Enable firewall
sudo ufw enable

# Kiểm tra status
sudo ufw status verbose

# Output:
# Status: active
# To                         Action      From
# --                         ------      ----
# 22/tcp                     ALLOW       Anywhere
```

{{< callout type="warning" >}}
**CẢNH BÁO:** Nếu expose Ollama/OpenClaw ra internet để access từ xa, BẮT BUỘC
phải dùng VPN (WireGuard, Tailscale) thay vì mở port công khai.
{{< /callout >}}

---

## 10. Log Monitoring Setup

### Bước 10a: Cấu Hình Journal Vacuum

```bash
# Giới hạn journal logs (tránh đầy disk)
sudo journalctl --vacuum-time=30d
sudo journalctl --vacuum-size=500M

# Tự động cleanup
sudo nano /etc/systemd/journald.conf
```

Sửa:

```ini
[Journal]
SystemMaxUse=500M
MaxRetentionSec=30day
```

Restart journald:

```bash
sudo systemctl restart systemd-journald
```

### Bước 10b: Cấu Hình Logrotate

```bash
sudo nano /etc/logrotate.d/openclaw
```

Nội dung:

```conf
/var/log/openclaw/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0640 openclaw adm
    sharedscripts
    postrotate
        systemctl reload openclaw > /dev/null 2>&1 || true
    endscript
}
```

Test:

```bash
sudo logrotate -d /etc/logrotate.d/openclaw
```

### Bước 10c: Monitoring Alerts (Optional)

Cài đặt `logwatch` để nhận email hàng ngày:

```bash
sudo apt install -y logwatch

# Cấu hình
sudo nano /usr/share/logwatch/default.conf/logwatch.conf
```

Sửa:

```conf
MailTo = your-email@example.com
Detail = High
Range = yesterday
Service = All
```

---

## Tổng Kết

Bạn đã hoàn thành hardening:

- ✅ User isolation và file permissions (700/600)
- ✅ Rootless containers
- ✅ Fail2ban chống brute-force
- ✅ API key protection và audit
- ✅ Plugin security policy (chỉ official, manual approval)
- ✅ Automated security updates
- ✅ Weekly audit cron job
- ✅ Network security (localhost-only, UFW)
- ✅ Log rotation và monitoring

**Defense in Depth Strategy:**

1. **OS Layer:** Hardened permissions, fail2ban, UFW
2. **User Layer:** Dedicated user, no sudo
3. **Container Layer:** Rootless, unprivileged
4. **Application Layer:** Plugin audit, secrets encryption
5. **Monitoring Layer:** Audit logs, automated alerts

{{< callout type="danger" >}}
**NHẮC NHỞ QUAN TRỌNG:** Chạy `openclaw security audit --deep` sau MỖI LẦN cài
plugin mới. Đây là hàng phòng thủ cuối cùng chống malicious plugins.
{{< /callout >}}

### Checklist Bảo Trì Hàng Tuần

- ☐ Kiểm tra audit report trong `/var/log/openclaw/audit/`
- ☐ Review fail2ban banned IPs
- ☐ Kiểm tra pending security updates
- ☐ Rotate API keys (nếu đến hạn)
- ☐ Backup `~/.openclaw/` và workspace

### Bước Tiếp Theo

- **[Phần 05: Kỹ năng và tùy chỉnh](/posts/openclaw-personal-assistant/05-skills-customization/)** - Cài đặt skills và tùy chỉnh persona cho OpenClaw
- **[Phần 06: Vận hành và bảo trì](/posts/openclaw-personal-assistant/06-operations-maintenance/)** - Backup, monitoring, disaster recovery

---

**Câu hỏi thường gặp:**

**Q: Audit script báo HIGH risk, làm gì?**
A: Đọc chi tiết trong report file, uninstall plugin nguy hiểm, kiểm tra API
keys có bị lộ không.

**Q: Có nên tắt automated updates không?**
A: KHÔNG. Security patches cần được apply nhanh nhất có thể. Chỉ tắt nếu bạn có
quy trình testing riêng.

**Q: Làm sao biết API key đã bị leak?**
A: Theo dõi usage dashboard của OpenAI/Anthropic. Thấy spike lạ = đổi key ngay.

**Q: UFW chặn Telegram bot?**
A: Không, UFW chỉ chặn INCOMING. Bot connect ra ngoài (OUTGOING) vẫn OK.

**Q: Có cần antivirus trên Linux không?**
A: Thường không cần nếu đã hardening đúng. Nhưng ClamAV không hại nếu muốn
thêm layer.
