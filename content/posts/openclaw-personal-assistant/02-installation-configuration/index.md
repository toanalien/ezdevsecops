---
title: "Phần 2: Cài đặt và cấu hình OpenClaw"
date: 2026-02-15
draft: false
description: "Hướng dẫn chi tiết cài đặt OpenClaw daemon với Ollama local LLM, cấu hình multi-provider routing, setup systemd services và expose web UI qua Caddy"
categories: ["AI Assistant"]
tags: ["openclaw", "ollama", "llm", "systemd", "caddy"]
series: ["OpenClaw Personal Assistant"]
weight: 2
mermaid: true
---

## Giới thiệu

Sau khi chuẩn bị xong hạ tầng VPS, giờ chúng ta sẽ cài đặt OpenClaw và các thành phần cốt lõi. Bài viết này hướng dẫn deploy một AI assistant hoàn chỉnh với local LLM và cloud fallback.

**Bạn sẽ học được:**

- ✓ Cài đặt Ollama và pull LLM models (qwen2.5:7b, llama3.1:8b)
- ✓ Tạo systemd service cho Ollama daemon
- ✓ Cài đặt OpenClaw qua official installer
- ✓ Cấu hình multi-LLM provider routing
- ✓ Setup OpenClaw systemd service với auto-restart
- ✓ Expose web UI qua Caddy hoặc direct access
- ✓ Verify và troubleshoot toàn bộ hệ thống

**Điều kiện tiên quyết:**

- Hoàn thành [Phần 1: Chuẩn bị hạ tầng VPS](../01-infrastructure-preparation/)
- User `openclaw` đã tạo với sudo privileges
- Node.js 22+ và pnpm đã cài đặt
- (Tùy chọn) API key của Anthropic/OpenAI cho cloud fallback

## Kiến trúc tổng quan

{{< mermaid >}}
graph TB
    User[User Browser/API]
    Caddy[Caddy :443]
    OpenClaw[OpenClaw Gateway :18789]
    Ollama[Ollama :11434]
    Anthropic[Anthropic API]
    Workspace[Workspace Files]

    User -->|HTTPS| Caddy
    Caddy -->|Proxy| OpenClaw
    OpenClaw -->|Primary| Ollama
    OpenClaw -->|Fallback| Anthropic
    OpenClaw -->|Read/Write| Workspace

    subgraph VPS - openclaw user
        OpenClaw
        Ollama
        Workspace
    end

    subgraph External
        Anthropic
    end

    style OpenClaw fill:#FF6B6B
    style Ollama fill:#4ECDC4
    style Anthropic fill:#FFE66D
{{< /mermaid >}}

**LLM Routing Strategy:**

- **Local Ollama** - Primary cho tất cả tasks (free, private)
- **Anthropic API** - Fallback khi task phức tạp hoặc Ollama fail
- **Token limit aware** - Auto switch dựa vào context size

## Bước 1: Cài đặt Ollama

Ollama là runtime để chạy LLM models locally với inference tối ưu.

### Download và cài đặt

```bash
# Switch sang user openclaw
su - openclaw

# Download Ollama installer
curl -fsSL https://ollama.com/install.sh | sh

# Verify installation
ollama --version
```

**Output mong đợi:**

```
ollama version is 0.4.5
```

### Test Ollama CLI

```bash
# Start Ollama server (tạm thời)
ollama serve &

# List available models (rỗng ban đầu)
ollama list

# Stop server
pkill ollama
```

## Bước 2: Pull LLM Models

### Chọn models phù hợp

| Model | Size | RAM cần | Use case |
|-------|------|---------|----------|
| qwen2.5:7b | 4.7GB | 6GB+ | General purpose, code |
| llama3.1:8b | 4.9GB | 6GB+ | Reasoning, conversation |
| codestral:22b | 13GB | 16GB+ | Advanced coding (nếu đủ RAM) |
| gemma2:2b | 1.6GB | 3GB+ | Lightweight fallback |

{{< callout type="info" >}}
**Khuyến nghị cho VPS 4GB RAM:** Pull cả qwen2.5:7b và llama3.1:8b. OpenClaw sẽ load model theo nhu cầu.
{{< /callout >}}

### Pull models

```bash
# Start Ollama server trong tmux (download lâu)
tmux new -s ollama
ollama serve

# Mở terminal mới
tmux split-window -h

# Pull primary model (4-5 phút)
ollama pull qwen2.5:7b

# Pull secondary model
ollama pull llama3.1:8b

# (Tùy chọn) Pull lightweight model cho low-memory fallback
ollama pull gemma2:2b

# Verify downloaded models
ollama list
```

**Output mong đợi:**

```
NAME                ID              SIZE      MODIFIED
qwen2.5:7b          a67f5c0c89e7    4.7 GB    2 minutes ago
llama3.1:8b         f66f3c5c89e7    4.9 GB    4 minutes ago
gemma2:2b           1a2b3c4d5e6f    1.6 GB    6 minutes ago
```

{{< callout type="tip" >}}
**Dùng tmux để tránh timeout:** Download model qua SSH có thể bị disconnect. `tmux attach -t ollama` để reconnect session.
{{< /callout >}}

### Test model inference

```bash
# Test chat với qwen2.5
ollama run qwen2.5:7b "Viết hàm Python tính fibonacci"

# Test với llama3.1
ollama run llama3.1:8b "Explain Docker in Vietnamese"

# Exit chat: /bye
```

## Bước 3: Tạo Ollama systemd service

Để Ollama tự động start khi boot và restart nếu crash.

### Tạo user service file

```bash
# Tạo systemd user directory
mkdir -p ~/.config/systemd/user

# Tạo service file
cat > ~/.config/systemd/user/ollama.service <<'EOF'
[Unit]
Description=Ollama Local LLM Server
Documentation=https://ollama.com/docs
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/ollama serve
Environment="OLLAMA_HOST=127.0.0.1:11434"
Environment="OLLAMA_MODELS=/home/openclaw/.ollama/models"
Restart=on-failure
RestartSec=5
StandardOutput=journal
StandardError=journal

# Security hardening
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=default.target
EOF
```

{{< callout type="warning" >}}
**Bind localhost only:** `OLLAMA_HOST=127.0.0.1` đảm bảo Ollama chỉ accessible từ localhost, không expose ra internet.
{{< /callout >}}

### Enable và start service

```bash
# Reload systemd daemon
systemctl --user daemon-reload

# Enable auto-start
systemctl --user enable ollama.service

# Start service
systemctl --user start ollama.service

# Check status
systemctl --user status ollama.service

# View logs
journalctl --user -u ollama.service -f
```

**Service phải ở trạng thái `active (running)`:**

```
● ollama.service - Ollama Local LLM Server
     Loaded: loaded (~/.config/systemd/user/ollama.service; enabled)
     Active: active (running) since Sat 2026-02-15 10:30:15 +07
```

### Enable linger (persistent user services)

```bash
# Cho phép user services chạy khi user logout
sudo loginctl enable-linger openclaw

# Verify
loginctl show-user openclaw | grep Linger
```

## Bước 4: Cài đặt OpenClaw

### Chạy official installer

```bash
# Download và chạy installer
curl -fsSL https://openclaw.ai/install.sh | bash

# Hoặc manual install via npm
# npm install -g @openclaw/cli
```

**Installer sẽ:**

1. Install `@openclaw/cli` globally
2. Tạo directory `~/.openclaw/`
3. Generate initial config
4. Prompt onboarding wizard

### Chạy onboarding wizard

```bash
# Start interactive setup
openclaw onboard --install-daemon
```

**Wizard sẽ hỏi:**

```
? Select installation mode:
  ❯ Server daemon (recommended for VPS)
    Desktop app

? Choose workspace directory:
  ❯ /home/openclaw/openclaw/workspace (default)
    Custom path...

? Enable web UI?
  ❯ Yes, on port 18789
    No, CLI only

? Generate gateway token:
  ❯ Auto-generate secure token
    Custom token...

? Install default skills?
  ❯ Yes (git, file-manager, web-search, code-executor)
    Minimal (file-manager only)
```

**Chọn:**

- Server daemon mode
- Default workspace path
- Web UI on port 18789
- Auto-generate token
- Install default skills

{{< callout type="danger" >}}
**Lưu gateway token:** Token này dùng để authenticate API requests. Copy và lưu vào password manager ngay!
{{< /callout >}}

### Verify installation

```bash
# Check CLI version
openclaw --version

# Check config file
cat ~/.openclaw/openclaw.json

# List installed skills
openclaw skills list

# Check workspace
ls -la ~/openclaw/workspace/
```

## Bước 5: Cấu hình LLM providers

### Edit openclaw.json

```bash
# Backup config
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak

# Edit config
vim ~/.openclaw/openclaw.json
```

### Config với Ollama primary + Anthropic fallback

```json
{
  "version": "1.0",
  "gateway": {
    "port": 18789,
    "host": "0.0.0.0",
    "token": "YOUR_GENERATED_TOKEN_HERE",
    "cors": {
      "enabled": true,
      "origins": ["https://your-domain.com"]
    }
  },
  "workspace": {
    "root": "/home/openclaw/openclaw/workspace",
    "maxSize": "10GB"
  },
  "llm": {
    "providers": [
      {
        "name": "ollama-primary",
        "type": "ollama",
        "enabled": true,
        "priority": 1,
        "config": {
          "baseUrl": "http://127.0.0.1:11434",
          "defaultModel": "qwen2.5:7b",
          "models": [
            {
              "id": "qwen2.5:7b",
              "contextWindow": 32768,
              "maxTokens": 4096,
              "capabilities": ["chat", "code", "reasoning"]
            },
            {
              "id": "llama3.1:8b",
              "contextWindow": 131072,
              "maxTokens": 8192,
              "capabilities": ["chat", "reasoning", "long-context"]
            }
          ],
          "timeout": 120000,
          "retries": 2
        }
      },
      {
        "name": "anthropic-fallback",
        "type": "anthropic",
        "enabled": false,
        "priority": 2,
        "config": {
          "apiKey": "${ANTHROPIC_API_KEY}",
          "defaultModel": "claude-3-5-sonnet-20241022",
          "models": [
            {
              "id": "claude-3-5-sonnet-20241022",
              "contextWindow": 200000,
              "maxTokens": 8192,
              "capabilities": ["chat", "code", "reasoning", "vision"]
            }
          ],
          "timeout": 60000
        }
      }
    ],
    "routing": {
      "strategy": "priority-fallback",
      "rules": [
        {
          "condition": "context_size > 32000",
          "provider": "ollama-primary",
          "model": "llama3.1:8b"
        },
        {
          "condition": "task_type == 'vision'",
          "provider": "anthropic-fallback"
        },
        {
          "condition": "ollama_failed",
          "provider": "anthropic-fallback"
        }
      ],
      "fallbackChain": [
        "ollama-primary",
        "anthropic-fallback"
      ]
    }
  },
  "skills": {
    "enabled": true,
    "autoLoad": true,
    "allowCustom": true,
    "sandboxMode": true
  },
  "logging": {
    "level": "info",
    "file": "/home/openclaw/.openclaw/logs/openclaw.log",
    "maxSize": "100MB",
    "maxFiles": 5
  },
  "security": {
    "rateLimit": {
      "enabled": true,
      "requests": 100,
      "window": "15m"
    },
    "allowedIPs": [],
    "blockedIPs": []
  }
}
```

### Thêm Anthropic API key (nếu dùng)

```bash
# Tạo .env file
cat > ~/.openclaw/.env <<'EOF'
ANTHROPIC_API_KEY=sk-ant-xxx-your-api-key-here
EOF

# Secure permissions
chmod 600 ~/.openclaw/.env

# Load env vars cho session hiện tại
export $(cat ~/.openclaw/.env | xargs)
```

{{< callout type="info" >}}
**Free tier Anthropic:** Nếu không có API key, set `enabled: false` cho anthropic provider. OpenClaw chỉ dùng Ollama local.
{{< /callout >}}

### Validate config

```bash
# Test config syntax
openclaw config validate

# Test LLM connectivity
openclaw llm test --provider ollama-primary
openclaw llm test --provider anthropic-fallback
```

**Output mong đợi:**

```
✓ ollama-primary: Connected (qwen2.5:7b ready)
✓ anthropic-fallback: Connected (claude-3-5-sonnet available)
```

## Bước 6: Tạo OpenClaw systemd service

### Tạo service file

```bash
cat > ~/.config/systemd/user/openclaw.service <<'EOF'
[Unit]
Description=OpenClaw AI Assistant Gateway
Documentation=https://docs.openclaw.ai
After=network-online.target ollama.service
Wants=network-online.target
Requires=ollama.service

[Service]
Type=simple
WorkingDirectory=/home/openclaw
ExecStart=/usr/bin/openclaw daemon start
EnvironmentFile=/home/openclaw/.openclaw/.env
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=/home/openclaw/.openclaw /home/openclaw/openclaw/workspace

# Resource limits
LimitNOFILE=65536
MemoryMax=2G

[Install]
WantedBy=default.target
EOF
```

### Enable và start service

```bash
# Reload daemon
systemctl --user daemon-reload

# Enable auto-start
systemctl --user enable openclaw.service

# Start service
systemctl --user start openclaw.service

# Check status
systemctl --user status openclaw.service

# View real-time logs
journalctl --user -u openclaw.service -f
```

**Service phải active:**

```
● openclaw.service - OpenClaw AI Assistant Gateway
     Loaded: loaded (~/.config/systemd/user/openclaw.service; enabled)
     Active: active (running) since Sat 2026-02-15 11:05:42 +07
```

### Verify listening port

```bash
# Check port 18789 listening
ss -tlnp | grep 18789

# Test local access
curl http://localhost:18789/health
```

**Response mong đợi:**

```json
{
  "status": "healthy",
  "version": "1.0.0",
  "uptime": 127,
  "llm": {
    "ollama-primary": "connected",
    "anthropic-fallback": "connected"
  }
}
```

## Bước 7: Cập nhật Caddy / Web Access

### Kịch bản A: Có domain với Caddy

Caddyfile đã được config ở Phần 1. Verify reverse proxy hoạt động:

```bash
# Test qua domain (thay your-domain.com)
curl https://your-domain.com/health

# Hoặc test từ browser
# https://your-domain.com
```

**Web UI sẽ load với:**

- Login page yêu cầu gateway token
- Dashboard sau khi authenticated
- Chat interface với model selector

### Kịch bản B: Chỉ có IP

**Option 1: Direct access (không bảo mật)**

```bash
# Allow port qua UFW (trên VPS)
sudo ufw allow 18789/tcp comment 'OpenClaw Gateway'

# Test từ máy local
curl http://YOUR_VPS_IP:18789/health
```

{{< callout type="warning" >}}
**HTTP không mã hóa:** Gateway token sẽ bị lộ qua plaintext. Chỉ dùng cho testing!
{{< /callout >}}

**Option 2: SSH Tunnel (khuyến nghị)**

```bash
# Từ máy local, tạo tunnel
ssh -L 8789:localhost:18789 openclaw@YOUR_VPS_IP -N

# Access trên browser local
# http://localhost:8789
```

**Option 3: Tailscale VPN (best practice)**

```bash
# Cài Tailscale trên VPS
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Access qua Tailscale IP (100.x.y.z:18789)
# Encrypted, không cần expose port
```

## Bước 8: Verification & Testing

### Health checks

```bash
# Service status
systemctl --user status openclaw.service
systemctl --user status ollama.service

# Port listening
ss -tlnp | grep -E '18789|11434'

# Process running
ps aux | grep -E 'openclaw|ollama'

# Disk usage
du -sh ~/.openclaw
du -sh ~/.ollama/models
df -h ~/openclaw/workspace
```

### Functional tests

```bash
# Test CLI chat
openclaw chat "Write a bash script to backup /etc"

# Test API endpoint
curl -X POST http://localhost:18789/v1/chat \
  -H "Authorization: Bearer YOUR_GATEWAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [
      {"role": "user", "content": "Hello OpenClaw!"}
    ]
  }'

# Test skill execution
openclaw run git status --workspace ~/openclaw/workspace

# Test file operations
openclaw workspace create test-project
openclaw workspace list
```

### Web UI testing

1. **Login:** Navigate to `https://your-domain.com` (hoặc localhost:8789)
2. **Authenticate:** Enter gateway token from `openclaw.json`
3. **Test chat:** Send message "Analyze ~/openclaw/workspace structure"
4. **Check model:** Verify qwen2.5:7b được sử dụng (hiển thị ở header)
5. **Test skill:** Run `/skill git status` trong chat
6. **Check logs:** View real-time logs trong Settings panel

### Performance monitoring

```bash
# Check resource usage
htop

# Ollama GPU usage (nếu có GPU)
ollama ps

# OpenClaw metrics
curl http://localhost:18789/metrics

# Log analysis
journalctl --user -u openclaw.service --since "10 minutes ago"
```

## Troubleshooting

### Ollama không start

```bash
# Check service logs
journalctl --user -u ollama.service -n 50

# Common issues:
# - Port 11434 đã bị dùng: lsof -i :11434
# - Permission denied: chown -R openclaw ~/.ollama
# - Model corrupted: ollama pull qwen2.5:7b --force
```

### OpenClaw không kết nối Ollama

```bash
# Test Ollama connectivity
curl http://127.0.0.1:11434/api/tags

# Check firewall không block localhost
sudo iptables -L -n | grep 11434

# Verify config baseUrl
grep baseUrl ~/.openclaw/openclaw.json
```

### Web UI không load

```bash
# Check Caddy logs
sudo journalctl -u caddy -f

# Verify domain DNS
dig your-domain.com

# Test direct access
curl http://localhost:18789

# Check CORS settings trong openclaw.json
```

### High memory usage

```bash
# Check model loaded
ollama ps

# Unload unused models
ollama stop qwen2.5:7b

# Reduce concurrent requests
# Edit openclaw.json -> security.rateLimit
```

{{< callout type="tip" >}}
**Debug mode:** Start OpenClaw manually với `openclaw daemon start --debug` để xem chi tiết logs.
{{< /callout >}}

## Tổng kết

Bạn đã deploy thành công OpenClaw AI assistant với:

- ✅ Ollama local LLM runtime với 2+ models
- ✅ OpenClaw gateway với systemd auto-restart
- ✅ Multi-provider routing (Ollama primary + Anthropic fallback)
- ✅ Web UI access qua HTTPS/SSH tunnel
- ✅ Rate limiting và security hardening
- ✅ Workspace isolation và skill sandboxing

**Kiến trúc hoàn chỉnh:**

```
User → Caddy HTTPS → OpenClaw Gateway
                         ├─→ Ollama (qwen2.5, llama3.1)
                         ├─→ Anthropic API (fallback)
                         ├─→ Skills (git, file, code-exec)
                         └─→ Workspace (isolated storage)
```

**Điểm checklist:**

- [ ] Ollama service active và models loaded
- [ ] OpenClaw service running với gateway token secured
- [ ] Web UI accessible qua domain hoặc tunnel
- [ ] LLM providers test passed
- [ ] Skills functional (git, file-manager tested)
- [ ] Logs monitoring setup
- [ ] Resource usage trong ngưỡng (< 80% RAM)

## Bước tiếp theo

Trong **Phần 3: Tích hợp kênh nhắn tin**, chúng ta sẽ:

- Tạo Telegram bot và kết nối với OpenClaw
- Setup Discord bot với slash commands
- Integrate WhatsApp Business API (nâng cao)
- Cấu hình multi-channel routing
- Implement conversation context persistence

Trong **Phần 4: Tăng cường bảo mật**, chúng ta sẽ:

- Setup authentication layers (OAuth, API keys)
- Implement audit logging và intrusion detection
- Network isolation với Podman containers
- Secret management với Vault
- Compliance và GDPR considerations

Hẹn gặp lại! 🤖
