---
title: "Bài 06: Vận hành và Bảo trì OpenClaw"
date: 2026-02-15
draft: false
description: "Hướng dẫn vận hành OpenClaw: backup tự động, monitoring, update an toàn, quản lý chi phí API, disaster recovery và maintenance calendar cho production."
categories: ["AI Assistant"]
tags: ["openclaw", "backup", "monitoring", "maintenance", "disaster-recovery"]
series: ["OpenClaw Personal Assistant"]
weight: 6
mermaid: true
---

## Giới thiệu

Sau khi cài đặt và tùy chỉnh OpenClaw, bước quan trọng tiếp theo là thiết lập quy trình vận hành để đảm bảo hệ thống hoạt động ổn định, an toàn và tối ưu chi phí.

**Mục tiêu học tập:**

- ✅ Thiết lập backup tự động hàng ngày với retention policy
- ✅ Cấu hình health check monitoring liên tục
- ✅ Thực hiện update an toàn với rollback plan
- ✅ Theo dõi và tối ưu chi phí API usage
- ✅ Xây dựng disaster recovery procedure
- ✅ Tạo maintenance calendar và checklist

**Yêu cầu trước khi bắt đầu:**

- ✅ Đã hoàn thành Bài 05 (OpenClaw đã cấu hình đầy đủ)
- ✅ Có quyền sudo trên VPS (cho cấu hình cron)
- ✅ Hiểu biết cơ bản về bash scripting
- ✅ Có storage cho backup (local hoặc remote)

## 1. Automated Daily Backups

Backup là phòng tuyến đầu tiên chống data loss.

### Tạo backup script

```bash
nano ~/openclaw/scripts/backup-openclaw.sh
```

Nội dung script:

```bash
#!/bin/bash
set -euo pipefail

# Configuration
BACKUP_DIR="/var/backups/openclaw"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="openclaw_backup_${TIMESTAMP}.tar.gz"

# Directories to backup
CONFIG_DIR="$HOME/.openclaw"
WORKSPACE_DIR="$HOME/openclaw/workspace"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create temporary staging directory
STAGING_DIR=$(mktemp -d)
trap 'rm -rf "$STAGING_DIR"' EXIT

echo "[$(date)] Starting OpenClaw backup..."

# Copy files to staging (exclude cache and temp files)
rsync -a --exclude='cache/' --exclude='*.log' \
  --exclude='*.tmp' "$CONFIG_DIR" "$STAGING_DIR/"
rsync -a "$WORKSPACE_DIR" "$STAGING_DIR/"

# Create compressed archive
cd "$STAGING_DIR"
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" .

# Calculate backup size
BACKUP_SIZE=$(du -h "${BACKUP_DIR}/${BACKUP_NAME}" | cut -f1)
echo "[$(date)] Backup created: ${BACKUP_NAME} (${BACKUP_SIZE})"

# Remove old backups (keep last N days)
find "$BACKUP_DIR" -name "openclaw_backup_*.tar.gz" \
  -mtime +${RETENTION_DAYS} -delete

# Count remaining backups
BACKUP_COUNT=$(find "$BACKUP_DIR" -name "openclaw_backup_*.tar.gz" \
  | wc -l)
echo "[$(date)] Backup retention: ${BACKUP_COUNT} backups"

# Optional: Verify backup integrity
if tar -tzf "${BACKUP_DIR}/${BACKUP_NAME}" > /dev/null 2>&1; then
  echo "[$(date)] Backup integrity verified ✓"
else
  echo "[$(date)] ERROR: Backup integrity check failed!" >&2
  exit 1
fi

echo "[$(date)] Backup completed successfully"
```

Cấp quyền thực thi:

```bash
chmod +x ~/openclaw/scripts/backup-openclaw.sh
```

Test backup thủ công:

```bash
~/openclaw/scripts/backup-openclaw.sh
```

Kiểm tra backup:

```bash
ls -lh /var/backups/openclaw/
```

{{< callout type="warning" >}}
**CẢNH BÁO:** Backups chứa API keys và sensitive data. Đảm bảo chmod 600 hoặc encrypt backups.
{{< /callout >}}

### Encrypt backups (khuyến nghị)

Sửa script để thêm encryption:

```bash
# After tar creation, add encryption
gpg --symmetric --cipher-algo AES256 \
  -o "${BACKUP_DIR}/${BACKUP_NAME}.gpg" \
  "${BACKUP_DIR}/${BACKUP_NAME}"

# Remove unencrypted backup
rm "${BACKUP_DIR}/${BACKUP_NAME}"

# Update cleanup to target .gpg files
find "$BACKUP_DIR" -name "openclaw_backup_*.tar.gz.gpg" \
  -mtime +${RETENTION_DAYS} -delete
```

Khi restore, decrypt trước:

```bash
gpg -d /var/backups/openclaw/openclaw_backup_20260215.tar.gz.gpg \
  | tar -xz -C /tmp/restore/
```

### Schedule backup với cron

Tạo cron job chạy lúc 2:00 AM mỗi ngày:

```bash
crontab -e
```

Thêm dòng:

```
0 2 * * * /home/yourusername/openclaw/scripts/backup-openclaw.sh \
  >> /var/log/openclaw-backup.log 2>&1
```

Verify cron job:

```bash
crontab -l | grep backup-openclaw
```

Test cron execution (đợi 2 phút):

```bash
# Tạm thời set chạy sau 2 phút
# Sau test, đổi lại 0 2 * * *
```

## 2. Off-site Backup (Tùy chọn)

Backup local không bảo vệ khỏi disk failure hoặc VPS termination.

### Option 1: Rclone to Object Storage

Cài đặt rclone:

```bash
sudo apt install rclone -y
```

Configure remote (ví dụ: AWS S3):

```bash
rclone config
# Follow prompts to add S3 remote named "s3backup"
```

Thêm vào backup script (sau khi tạo backup local):

```bash
# Sync to S3
rclone copy "${BACKUP_DIR}/${BACKUP_NAME}.gpg" \
  s3backup:openclaw-backups/ --progress

echo "[$(date)] Backup synced to S3"
```

### Option 2: Rsync to Remote Server

```bash
# Setup SSH key authentication first
ssh-copy-id backup-server

# Add to backup script
rsync -avz -e "ssh -i ~/.ssh/backup_key" \
  "${BACKUP_DIR}/${BACKUP_NAME}.gpg" \
  backup-server:/backups/openclaw/

echo "[$(date)] Backup synced to remote server"
```

{{< callout type="tip" >}}
**MẸO:** Cho production, nên có 3-2-1 backup strategy: 3 copies, 2 media types, 1 off-site.
{{< /callout >}}

## 3. Health Check Script

Monitoring liên tục phát hiện sớm vấn đề.

### Tạo healthcheck script

```bash
nano ~/openclaw/scripts/healthcheck-openclaw.sh
```

Nội dung:

```bash
#!/bin/bash
set -eo pipefail

# Configuration
ALERT_TELEGRAM=true
TELEGRAM_BOT_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"
WEB_UI_URL="http://localhost:3000"

# Health check functions
check_service() {
  local service=$1
  if systemctl --user is-active --quiet "$service"; then
    echo "✓ $service is running"
    return 0
  else
    echo "✗ $service is NOT running"
    return 1
  fi
}

check_disk_usage() {
  local threshold=80
  local usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

  if [ "$usage" -lt "$threshold" ]; then
    echo "✓ Disk usage: ${usage}% (OK)"
    return 0
  else
    echo "✗ Disk usage: ${usage}% (WARNING: >${threshold}%)"
    return 1
  fi
}

check_memory_usage() {
  local threshold=90
  local usage=$(free | awk 'NR==2 {printf "%.0f", $3/$2*100}')

  if [ "$usage" -lt "$threshold" ]; then
    echo "✓ Memory usage: ${usage}% (OK)"
    return 0
  else
    echo "✗ Memory usage: ${usage}% (WARNING: >${threshold}%)"
    return 1
  fi
}

check_web_ui() {
  local http_code=$(curl -s -o /dev/null -w "%{http_code}" \
    "$WEB_UI_URL")

  if [ "$http_code" -eq 200 ]; then
    echo "✓ Web UI responding (HTTP $http_code)"
    return 0
  else
    echo "✗ Web UI not responding (HTTP $http_code)"
    return 1
  fi
}

send_alert() {
  local message=$1

  if [ "$ALERT_TELEGRAM" = true ]; then
    curl -s -X POST \
      "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
      -d "chat_id=${TELEGRAM_CHAT_ID}" \
      -d "text=🚨 OpenClaw Alert: $message" > /dev/null
  fi
}

# Run all checks
FAILED_CHECKS=0

echo "=== OpenClaw Health Check $(date) ==="

check_service openclaw || { FAILED_CHECKS=$((FAILED_CHECKS+1)); }
check_service ollama || { FAILED_CHECKS=$((FAILED_CHECKS+1)); }
check_service caddy || { FAILED_CHECKS=$((FAILED_CHECKS+1)); }
check_disk_usage || { FAILED_CHECKS=$((FAILED_CHECKS+1)); }
check_memory_usage || { FAILED_CHECKS=$((FAILED_CHECKS+1)); }
check_web_ui || { FAILED_CHECKS=$((FAILED_CHECKS+1)); }

# Report results
if [ "$FAILED_CHECKS" -eq 0 ]; then
  echo "=== All checks passed ✓ ==="
  exit 0
else
  echo "=== $FAILED_CHECKS check(s) failed ✗ ==="
  send_alert "$FAILED_CHECKS health check(s) failed. Check logs."
  exit 1
fi
```

Cấp quyền và test:

```bash
chmod +x ~/openclaw/scripts/healthcheck-openclaw.sh
~/openclaw/scripts/healthcheck-openclaw.sh
```

### Schedule health check mỗi 5 phút

```bash
crontab -e
```

Thêm:

```
*/5 * * * * /home/openclaw/scripts/healthcheck-openclaw.sh >> /var/log/openclaw-healthcheck.log 2>&1
```

Xem logs:

```bash
tail -f /var/log/openclaw-healthcheck.log
```

{{< callout type="info" >}}
**LƯU Ý:** Health check mỗi 5 phút đảm bảo phát hiện sự cố trong vòng 5 phút. Điều chỉnh interval tùy SLA.
{{< /callout >}}

## 4. Update Procedure

Updates mang security patches và tính năng mới, nhưng cũng có rủi ro.

### Safe update workflow

**Bước 1: Backup trước khi update**

```bash
# LUÔN backup trước
~/openclaw/scripts/backup-openclaw.sh

# Verify backup exists
ls -lh /var/backups/openclaw/ | tail -1
```

**Bước 2: Update OpenClaw**

```bash
# Check current version
openclaw version

# Check for updates
openclaw update --check

# Download update (don't apply yet)
openclaw update --download-only

# Review changelog
openclaw changelog --since-current
```

Nếu changelog không có breaking changes:

```bash
# Apply update
openclaw update --apply

# Restart service
systemctl --user restart openclaw
```

**Bước 3: Verify after update**

```bash
# Check version
openclaw version

# Run health check
~/openclaw/scripts/healthcheck-openclaw.sh

# Check logs for errors
journalctl --user -u openclaw -n 50
```

**Bước 4: Test critical features**

Test qua Telegram:

```
Bạn còn hoạt động không? (test basic response)
Thời tiết Hà Nội (test skill: weather)
Tạo reminder test lúc 5 PM (test skill: reminders)
```

Nếu tất cả OK, update thành công.

{{< callout type="danger" >}}
**NGUY HIỂM:** KHÔNG BAO GIỜ auto-update trong production. Luôn test trong staging environment trước.
{{< /callout >}}

### Rollback nếu update failed

```bash
# Stop service
systemctl --user stop openclaw

# Restore from backup
LATEST_BACKUP=$(ls -t /var/backups/openclaw/*.tar.gz.gpg \
  | head -1)

# Decrypt and extract
gpg -d "$LATEST_BACKUP" | tar -xz -C /tmp/restore/

# Restore config
rm -rf ~/.openclaw
mv /tmp/restore/.openclaw ~/

# Restart
systemctl --user start openclaw
~/openclaw/scripts/healthcheck-openclaw.sh
```

**Bước 5: Update Ollama models**

```bash
# List installed models
ollama list

# Pull latest versions
ollama pull qwen2.5:7b
ollama pull qwen2.5-coder:14b
ollama pull llama3.1:8b

# Remove old versions if needed
ollama rm qwen2.5:7b-old
```

**Bước 6: Test messaging channels**

```bash
# Test Telegram
openclaw messaging test telegram

# Check delivery
# Should receive test message in Telegram
```

## 5. Cost Monitoring (Cloud API Usage)

Nếu dùng cloud APIs (Anthropic, OpenAI), cần theo dõi chi phí.

### Track usage qua dashboards

**Anthropic Console:**
- https://console.anthropic.com/settings/usage
- Xem requests/day, tokens used, costs

**OpenAI Dashboard:**
- https://platform.openai.com/usage
- Breakdown by model, date, project

### Set billing alerts

**Anthropic:**
1. Settings → Billing → Usage Alerts
2. Set threshold: $50/month
3. Email notification when 80% reached

**OpenAI:**
1. Settings → Billing → Usage limits
2. Hard limit: $100/month
3. Soft limit: $75/month (alert)

### Route simple queries to Ollama

Kiểm tra `model_routing` trong config (đã setup ở Bài 05):

```json
{
  "model_routing": {
    "routing_rules": [
      {
        "condition": "task:simple_qa OR tokens<500",
        "model": "ollama/llama3.1:8b"
      }
    ]
  }
}
```

### Monitor cost trong logs

```bash
# Extract API calls
journalctl --user -u openclaw --since today | \
  grep -E "model:(anthropic|openai)" | \
  awk '{print $NF}' | sort | uniq -c
```

Output mẫu:

```
  15 ollama/qwen2.5:7b
   3 anthropic/claude-sonnet-4-5
   2 openai/gpt-4o
```

**Cost calculation:**
- Ollama: $0 (local)
- Claude Sonnet: ~$3/1M input tokens, $15/1M output
- GPT-4o: ~$5/1M input, $15/1M output

{{< callout type="tip" >}}
**MẸO TIẾT KIỆM:** Route 90%+ queries to Ollama. Chỉ dùng cloud APIs cho tasks phức tạp hoặc khi Ollama không đủ quality.
{{< /callout >}}

### Weekly cost report automation

Thêm vào `openclaw.json`:

```json
{
  "proactive": {
    "weekly_cost_report": {
      "enabled": true,
      "schedule": "0 9 * * 1",
      "delivery_channel": "telegram",
      "include_optimization_tips": true
    }
  }
}
```

## 6. Log Management

Logs tăng nhanh, cần rotation và cleanup.

### Configure systemd journal retention

```bash
sudo nano /etc/systemd/journald.conf
```

Thêm/sửa:

```ini
[Journal]
SystemMaxUse=500M
SystemKeepFree=1G
MaxRetentionSec=2592000
# 30 days = 2592000 seconds
```

Apply changes:

```bash
sudo systemctl restart systemd-journald
```

Vacuum old logs ngay:

```bash
sudo journalctl --vacuum-size=500M
sudo journalctl --vacuum-time=30d
```

### Logrotate cho custom logs

```bash
sudo nano /etc/logrotate.d/openclaw
```

Nội dung:

```
/var/log/openclaw-*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0644 yourusername yourusername
}
```

Test logrotate:

```bash
sudo logrotate -d /etc/logrotate.d/openclaw
```

## 7. Disaster Recovery Procedure

Chuẩn bị cho worst-case scenario: VPS bị xóa, disk failure, etc.

### Document full recovery steps

Tạo runbook:

```bash
nano ~/openclaw/docs/disaster-recovery.md
```

Nội dung:

```markdown
# OpenClaw Disaster Recovery Runbook

## Prerequisites
- Latest backup file (.tar.gz.gpg)
- GPG passphrase for decryption
- API keys (Anthropic, Telegram, etc.)
- DNS/domain credentials

## Recovery Steps

### 1. Provision New VPS
- Provider: Vultr/DigitalOcean/Hetzner
- Specs: 4 vCPU, 8GB RAM, 80GB SSD
- OS: Ubuntu 24.04 LTS
- SSH key setup

### 2. Install Base Dependencies
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git gpg rsync
```

### 3. Install Ollama
```bash
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull qwen2.5:7b
ollama pull llama3.1:8b
```

### 4. Install OpenClaw
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

### 5. Restore from Backup
```bash
# Copy backup to new server
scp backup-server:/backups/openclaw/latest.tar.gz.gpg \
  new-vps:/tmp/

# Decrypt and extract
gpg -d /tmp/latest.tar.gz.gpg | tar -xz -C ~/restore/

# Restore config
cp -r ~/restore/.openclaw ~/

# Restore workspace
cp -r ~/restore/workspace ~/openclaw/
```

### 6. Verify Configuration
```bash
openclaw config validate
openclaw skills list
```

### 7. Start Services
```bash
systemctl --user enable --now openclaw ollama
```

### 8. Restore Domain/SSL
```bash
# Update DNS A record to new VPS IP
# Wait for propagation (5-30 min)

# Caddy auto-renews SSL
systemctl restart caddy
```

### 9. Verify All Systems
```bash
~/openclaw/scripts/healthcheck-openclaw.sh
```

### 10. Test via Telegram
Send: "Bạn có hoạt động không?"

## Recovery Metrics
- **RTO (Recovery Time Objective):** 30 minutes
- **RPO (Recovery Point Objective):** 24 hours (daily backup)

## Post-Recovery
- Update monitoring with new IP
- Verify all integrations (calendar, APIs)
- Review security (SSH keys, API keys rotation)
```

### Test disaster recovery (dry-run)

**Không cần xóa VPS thật**, test trên local:

```bash
# Simulate restore on local machine
mkdir -p /tmp/dr-test
cd /tmp/dr-test

# Extract backup
gpg -d /var/backups/openclaw/latest.tar.gz.gpg | tar -xz

# Verify critical files
ls -la .openclaw/config/
ls -la workspace/

# Check config validity
openclaw config validate --config-dir /tmp/dr-test/.openclaw
```

{{< callout type="tip" >}}
**MẸO:** Test DR procedure mỗi quý (quarterly). DR plan chưa test = chưa có DR plan.
{{< /callout >}}

## 8. Maintenance Calendar

Lịch bảo trì đều đặn giúp phát hiện sớm vấn đề.

{{< mermaid >}}
gantt
    title OpenClaw Maintenance Calendar
    dateFormat  YYYY-MM-DD
    section Daily
    Automated Backup (2 AM)       :done, daily1, 2026-02-15, 1d
    Health Check (Every 5 min)    :active, daily2, 2026-02-15, 1d

    section Weekly
    Security Audit (Mon 9 AM)     :crit, weekly1, 2026-02-17, 1d
    Log Review                    :weekly2, 2026-02-17, 1d
    Cost Report                   :weekly3, 2026-02-17, 1d

    section Monthly
    Update OpenClaw               :milestone, monthly1, 2026-03-15, 0d
    Update Ollama Models          :monthly2, 2026-03-15, 1d
    Review API Costs              :monthly3, 2026-03-15, 1d
    Backup Verification           :monthly4, 2026-03-15, 1d

    section Quarterly
    Disaster Recovery Test        :crit, quarterly1, 2026-05-15, 1d
    Rotate API Keys               :crit, quarterly2, 2026-05-15, 1d
    Skills Audit                  :quarterly3, 2026-05-15, 1d
{{< /mermaid >}}

### Maintenance checklist

**Daily (Automated):**
- [x] Backup config + workspace (2:00 AM)
- [x] Health check services (every 5 min)

**Weekly (Monday 9:00 AM):**
- [ ] Run security audit: `openclaw skills audit`
- [ ] Review logs: `journalctl --user -u openclaw --since "1 week ago"`
- [ ] Check cost report (Telegram delivery automated)
- [ ] Verify backups exist: `ls -lh /var/backups/openclaw/`

**Monthly (15th of month):**
- [ ] Backup first: `~/openclaw/scripts/backup-openclaw.sh`
- [ ] Update OpenClaw: `openclaw update --check && openclaw update`
- [ ] Update Ollama models: `ollama pull qwen2.5:7b && ollama pull llama3.1:8b`
- [ ] Review API costs (Anthropic/OpenAI dashboards)
- [ ] Test backup restore: Extract to `/tmp/test-restore/`
- [ ] Review and clean workspace: `du -sh ~/openclaw/workspace/*`

**Quarterly (Every 3 months):**
- [ ] **Disaster Recovery drill:** Full restore to test VPS
- [ ] **Rotate API keys:** Anthropic, OpenAI, Telegram bot
- [ ] **Security audit:** `openclaw skills audit --deep`
- [ ] **Review & update automations:** Remove unused, optimize schedules
- [ ] **Performance review:** Check response times, identify bottlenecks

### Automation for checklist reminders

Tạo reminder automation:

```bash
nano ~/.openclaw/automations/maintenance-reminders.yaml
```

```yaml
name: Maintenance Reminders
description: Send maintenance task reminders

triggers:
  - schedule: "0 9 * * 1"  # Monday 9 AM
    tasks:
      - Weekly security audit
      - Weekly log review

  - schedule: "0 9 15 * *"  # 15th of month, 9 AM
    tasks:
      - Monthly OpenClaw update
      - Monthly Ollama update
      - Monthly cost review

  - schedule: "0 9 15 */3 *"  # Every 3 months, 15th
    tasks:
      - Quarterly DR test
      - Quarterly API key rotation
      - Quarterly skills audit

action:
  send_message:
    channel: telegram
    template: |
      🔧 **Maintenance Reminder**

      Due today:
      {{#each tasks}}
      - [ ] {{this}}
      {{/each}}
```

Reload automations:

```bash
openclaw automations reload
```

## 9. Advanced Monitoring (Optional)

Cho production-grade monitoring, tích hợp với observability stack.

### Option 1: Export metrics to Prometheus

OpenClaw có thể expose metrics endpoint:

```json
{
  "monitoring": {
    "prometheus": {
      "enabled": true,
      "port": 9090,
      "metrics": [
        "requests_total",
        "request_duration_seconds",
        "model_tokens_used",
        "skill_invocations"
      ]
    }
  }
}
```

Query metrics:

```bash
curl http://localhost:9090/metrics
```

### Option 2: Send alerts to Slack/Discord

```json
{
  "alerts": {
    "channels": [
      {
        "type": "slack",
        "webhook_url": "https://hooks.slack.com/...",
        "severity": ["critical", "warning"]
      }
    ]
  }
}
```

### Option 3: Uptime monitoring (external)

Dùng services như UptimeRobot, Pingdom:

- Monitor: `https://your-domain.com/health`
- Interval: 5 minutes
- Alert: Email/SMS khi down >2 checks

## Tổng kết

Bạn đã xây dựng được quy trình vận hành toàn diện cho OpenClaw:

✅ **Backup strategy:** Daily automated, encrypted, off-site sync, 7-day retention
✅ **Monitoring:** Health checks every 5 min, Telegram alerts, resource tracking
✅ **Update procedure:** Safe workflow với backup → update → verify → rollback
✅ **Cost optimization:** Route 90%+ to Ollama, track cloud API usage, weekly reports
✅ **Log management:** 30-day retention, logrotate, journal vacuum
✅ **Disaster recovery:** Documented runbook, RTO 30min, RPO 24h, quarterly tests
✅ **Maintenance calendar:** Daily/weekly/monthly/quarterly tasks automated

**Post-deployment checklist (sau 1 tháng vận hành ổn định):**

- [ ] Verify backups có thể restore thành công
- [ ] Health check không có false alarms
- [ ] Update workflow smooth (no rollbacks needed)
- [ ] API costs trong ngân sách ($10-30/month expected)
- [ ] Logs không có critical errors lặp lại
- [ ] All automations hoạt động đúng schedule
- [ ] Skills không conflict hoặc crash
- [ ] Response time <2s cho simple queries

**Metrics để đánh giá success:**

| Metric | Target | Current |
|--------|--------|---------|
| Uptime | >99.5% | ___ |
| Backup success rate | 100% | ___ |
| Health check pass rate | >98% | ___ |
| API cost/month | <$30 | ___ |
| DR test success | Pass quarterly | ___ |
| User satisfaction | High | ___ |

## Series Summary

Chúc mừng! Bạn đã hoàn thành series **OpenClaw Personal Assistant**:

**Bài 01:** Chuẩn bị hạ tầng VPS (SSH, UFW, Caddy, Node.js)
**Bài 02:** Cài đặt và cấu hình OpenClaw (Ollama, systemd, LLM routing)
**Bài 03:** Tích hợp kênh nhắn tin (Telegram, Discord, WhatsApp, Zalo)
**Bài 04:** Tăng cường bảo mật (fail2ban, permissions, audit)
**Bài 05:** Kỹ năng và tùy chỉnh (skills, persona, memory, proactive features)
**Bài 06:** Vận hành và bảo trì (backup, monitoring, DR, maintenance) ← **Bạn đang ở đây**

## What's Next?

Sau 1 tháng vận hành ổn định, bạn có thể:

### 1. Advanced Customization
- Viết custom skills cho workflows riêng (API integrations, automation)
- Fine-tune Ollama models trên data domain-specific
- Xây dựng multi-agent workflows (research → code → review)

### 2. Scale Up
- Cluster Ollama cho high availability
- Load balancing nhiều OpenClaw instances
- Distributed memory với Redis

### 3. Enterprise Features
- SSO authentication (OAuth2, SAML)
- Role-based access control (RBAC)
- Audit logs và compliance reporting
- Multi-tenant support

### 4. Integration Projects
- CI/CD pipeline assistant (auto-review PRs, suggest fixes)
- DevSecOps dashboard (aggregate logs, metrics, alerts)
- Incident response automation (PagerDuty, Jira, Slack)

### 5. Community Contribution
- Publish custom skills to ClawHub
- Contribute to OpenClaw core
- Write tutorials cho Vietnamese DevOps community

## Troubleshooting Common Issues

**Q: Backup script fails với "Permission denied"**
A: Check `BACKUP_DIR` permissions. Cần sudo hoặc chuyển sang `~/backups/openclaw`.

**Q: Health check false alarms (service running nhưng báo failed)**
A: Kiểm tra `systemctl --user` vs `systemctl`. User services cần `--user` flag.

**Q: Update broke skills, cần rollback**
A: Follow section 4 rollback procedure. Restore backup, restart services.

**Q: Disk full dù có cleanup**
A: Kiểm tra Ollama models (`ollama list`). Mỗi model 4-14GB. Xóa unused models.

**Q: Backup quá lớn (>5GB)**
A: Exclude workspace downloads: `--exclude='workspace/downloads/*'` trong rsync.

**Q: DR test failed, không restore được**
A: Verify GPG key available trên target server. Copy key trước khi decrypt.

{{< callout type="tip" >}}
**MẸO CUỐI:** Sử dụng SSH tunnel thay vì expose ports ra internet. An toàn hơn nhiều:

```bash
# Local machine
ssh -L 3000:localhost:3000 user@vps-ip

# Access via http://localhost:3000
```
{{< /callout >}}

{{< callout type="info" >}}
**TỐI ƯU CHI PHÍ:** Với setup này (Ollama local + cloud APIs cho complex tasks), chi phí dự kiến:

- VPS: $12-24/month (4vCPU, 8GB RAM)
- Cloud APIs: $5-20/month (tùy usage)
- Total: **$20-45/month** cho AI assistant production-grade

So với ChatGPT Plus ($20/month) nhưng limited, hoặc Claude Pro ($20/month) nhưng không tự động hóa, đây là deal rất tốt!
{{< /callout >}}

---

**Feedback & Questions:**

Nếu bạn có câu hỏi hoặc gặp vấn đề khi triển khai, hãy:

1. Kiểm tra logs: `journalctl --user -u openclaw -n 100`
2. Run health check: `~/openclaw/scripts/healthcheck-openclaw.sh`
3. Search ClawHub docs: https://docs.openclaw.ai
4. Join Discord community: https://discord.gg/openclaw
5. Open issue trên GitHub: https://github.com/openclaw/openclaw

**Happy automating! 🚀**
