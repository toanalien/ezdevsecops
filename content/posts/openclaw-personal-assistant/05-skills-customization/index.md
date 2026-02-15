---
title: "Bài 05: Cài đặt Skills và Tùy chỉnh OpenClaw"
date: 2026-02-15
draft: false
description: "Hướng dẫn cài đặt skills, cấu hình tính năng proactive, persistent memory và cá nhân hóa OpenClaw Personal Assistant phù hợp với nhu cầu DevSecOps."
categories: ["AI Assistant"]
tags: ["openclaw", "skills", "customization", "ollama", "automation"]
series: ["OpenClaw Personal Assistant"]
weight: 5
---

## Giới thiệu

Sau khi cài đặt và cấu hình cơ bản OpenClaw, bước tiếp theo là biến nó thành trợ lý cá nhân thực sự hữu ích thông qua việc cài đặt skills và tùy chỉnh hành vi.

**Mục tiêu học tập:**

- ✅ Tìm kiếm và cài đặt skills từ ClawHub
- ✅ Cấu hình system prompt và persona phù hợp
- ✅ Thiết lập persistent memory để ghi nhớ ngữ cảnh
- ✅ Kích hoạt tính năng proactive (morning briefing, reminders)
- ✅ Cấu hình workspace để truy cập file
- ✅ Tối ưu hóa model routing cho từng loại task

**Yêu cầu trước khi bắt đầu:**

- ✅ Đã hoàn thành Bài 04 (OpenClaw hoạt động, Ollama + Caddy đã cấu hình)
- ✅ Telegram bot đã kết nối thành công
- ✅ Có quyền truy cập SSH vào VPS

## 1. Duyệt và Cài đặt Core Skills

OpenClaw sử dụng hệ thống skills để mở rộng khả năng. Skills được quản lý qua ClawHub (tương tự npm registry).

### Tìm kiếm skills khả dụng

```bash
openclaw skills search
```

Output mẫu:

```
Available Skills from ClawHub:
- web-search: Search the web using multiple engines
- calendar: Manage calendar events (Google Calendar integration)
- notes: Create and manage markdown notes
- weather: Get weather forecasts and current conditions
- reminders: Set and manage reminders with notifications
- file-ops: Advanced file operations
- code-analyzer: Analyze code and suggest improvements
```

### Cài đặt skills cần thiết

{{< callout type="warning" >}}
**QUAN TRỌNG:** Chỉ cài đặt skills từ ClawHub chính thức. Skills bên thứ ba có thể chứa mã độc hoặc lỗ hổng bảo mật.
{{< /callout >}}

Cài đặt 5 skills cơ bản:

```bash
# Cài từng skill
openclaw skills install web-search
openclaw skills install calendar
openclaw skills install notes
openclaw skills install weather
openclaw skills install reminders
```

Hoặc cài tất cả cùng lúc:

```bash
openclaw skills install web-search calendar notes weather \
  reminders
```

### Xác minh skills đã cài đặt

```bash
openclaw skills list
```

Output mẫu:

```
Installed Skills:
✓ web-search (v1.2.0)
✓ calendar (v1.0.5)
✓ notes (v0.9.2)
✓ weather (v1.1.0)
✓ reminders (v1.0.3)
```

{{< callout type="tip" >}}
**MẸO:** Bắt đầu với 3-5 skills cốt lõi, sau đó thêm dần khi cần. Quá nhiều skills có thể làm model bị "confused" về công cụ nào nên dùng.
{{< /callout >}}

## 2. Cấu hình System Prompt và Persona

System prompt định nghĩa vai trò và tính cách của assistant. Chỉnh sửa file cấu hình:

```bash
nano ~/.openclaw/config/openclaw.json
```

Tìm section `persona` và cập nhật:

```json
{
  "persona": {
    "role": "DevSecOps Engineer Assistant",
    "language": "Vietnamese and English bilingual",
    "tone": "professional-friendly",
    "specialization": [
      "Infrastructure automation",
      "Security best practices",
      "CI/CD pipeline optimization",
      "Cloud architecture (AWS, GCP, Azure)",
      "Container orchestration (Kubernetes, Docker)"
    ],
    "communication_style": {
      "default_language": "vi",
      "use_technical_terms": "english_lowercase",
      "explanation_depth": "detailed_with_examples",
      "code_comments": "vietnamese"
    },
    "proactive_behaviors": {
      "suggest_improvements": true,
      "security_warnings": "always",
      "cost_optimization_tips": true
    }
  }
}
```

**Giải thích các tham số:**

- `role`: Vai trò chính của assistant
- `language`: Ngôn ngữ hỗ trợ
- `tone`: Giọng điệu giao tiếp (professional, friendly, casual, formal)
- `specialization`: Danh sách lĩnh vực chuyên môn
- `communication_style`: Phong cách giao tiếp chi tiết
- `proactive_behaviors`: Hành vi chủ động (đề xuất, cảnh báo)

Lưu file (`Ctrl+O`, `Enter`, `Ctrl+X`) và restart OpenClaw:

```bash
systemctl --user restart openclaw
```

Kiểm tra log để đảm bảo không có lỗi cú pháp JSON:

```bash
journalctl --user -u openclaw -n 20
```

## 3. Cấu hình Persistent Memory

Persistent memory giúp OpenClaw ghi nhớ ngữ cảnh qua các phiên làm việc.

### Xác minh thư mục memory

```bash
ls -la ~/.openclaw/memory/
```

Nếu chưa tồn tại, tạo thư mục:

```bash
mkdir -p ~/.openclaw/memory/{conversations,preferences,context}
```

### Cấu hình memory settings

Thêm vào `openclaw.json`:

```json
{
  "memory": {
    "enabled": true,
    "storage_path": "~/.openclaw/memory",
    "max_conversation_history": 50,
    "persist_preferences": true,
    "context_retention_days": 30,
    "auto_summarize_old_conversations": true,
    "privacy": {
      "exclude_patterns": ["password", "api_key", "secret", "token"],
      "encrypt_sensitive_data": true
    }
  }
}
```

**Tham số quan trọng:**

- `max_conversation_history`: Số tin nhắn lưu trữ trong context window
- `persist_preferences`: Ghi nhớ preferences người dùng
- `context_retention_days`: Thời gian lưu trữ context (30 ngày)
- `auto_summarize_old_conversations`: Tự động tóm tắt hội thoại cũ
- `exclude_patterns`: Regex patterns để loại trừ dữ liệu nhạy cảm

{{< callout type="info" >}}
**LƯU Ý:** Memory encryption yêu cầu `encryption_key` trong config. OpenClaw sẽ tự động tạo key khi khởi động lần đầu.
{{< /callout >}}

Restart service:

```bash
systemctl --user restart openclaw
```

## 4. Thiết lập Proactive Features

Proactive features cho phép OpenClaw chủ động gửi thông tin hữu ích.

### Cấu hình morning briefing

Thêm vào `openclaw.json`:

```json
{
  "proactive": {
    "morning_briefing": {
      "enabled": true,
      "schedule": "0 7 * * *",
      "timezone": "Asia/Ho_Chi_Minh",
      "delivery_channel": "telegram",
      "components": [
        "weather_forecast",
        "calendar_today",
        "news_summary",
        "pending_reminders",
        "security_alerts"
      ],
      "news_sources": [
        "https://news.ycombinator.com",
        "https://thehackernews.com"
      ]
    },
    "reminders": {
      "enabled": true,
      "check_interval_minutes": 5,
      "notification_channels": ["telegram", "web"]
    },
    "security_monitoring": {
      "enabled": true,
      "check_cve_databases": true,
      "alert_on_critical": true,
      "scan_dependencies_daily": true
    }
  }
}
```

**Giải thích:**

- `schedule`: Cron expression (7:00 AM mỗi ngày)
- `timezone`: Múi giờ Việt Nam
- `components`: Các thành phần trong briefing
- `check_interval_minutes`: Kiểm tra reminders mỗi 5 phút

### Test morning briefing thủ công

```bash
openclaw proactive trigger morning-briefing
```

Kiểm tra Telegram để xem briefing.

{{< callout type="tip" >}}
**MẸO:** Điều chỉnh `schedule` phù hợp với giờ làm việc của bạn. Ví dụ `0 8 * * 1-5` cho 8:00 AM các ngày trong tuần.
{{< /callout >}}

## 5. Cấu hình Workspace cho File Access

Workspace là nơi OpenClaw có quyền đọc/ghi files.

### Tạo cấu trúc thư mục

```bash
mkdir -p ~/openclaw/workspace/{documents,notes,downloads,code}
```

### Thêm reference files

```bash
# Ví dụ: cheatsheets, templates
cat > ~/openclaw/workspace/documents/kubectl-cheatsheet.md \
  <<'EOF'
# Kubectl Cheatsheet

## Pods
- List pods: `kubectl get pods`
- Describe pod: `kubectl describe pod <name>`
- Logs: `kubectl logs <pod> -f`

## Deployments
- Scale: `kubectl scale deployment <name> --replicas=3`
- Rollout status: `kubectl rollout status deployment/<name>`
EOF
```

### Cấu hình workspace trong openclaw.json

```json
{
  "workspace": {
    "base_path": "~/openclaw/workspace",
    "allowed_operations": ["read", "write", "create", "delete"],
    "restricted_paths": [
      "~/.ssh",
      "~/.aws",
      "~/.openclaw/config"
    ],
    "auto_organize": {
      "enabled": true,
      "categorize_downloads": true,
      "archive_old_files_days": 90
    }
  }
}
```

Restart service:

```bash
systemctl --user restart openclaw
```

### Test file access

Gửi tin nhắn qua Telegram:

```
Tạo file note mới về deployment checklist
```

OpenClaw sẽ tạo file trong `~/openclaw/workspace/notes/`.

## 6. Test Từng Skill Riêng Lẻ

Sau khi cài đặt skills, cần test từng skill để đảm bảo hoạt động.

### Test web-search skill

```
Tìm kiếm "kubernetes security best practices 2026"
```

### Test weather skill

```
Thời tiết Hồ Chí Minh hôm nay
```

### Test calendar skill

**Lần đầu cần authorize Google Calendar:**

```
Kết nối với Google Calendar
```

OpenClaw sẽ trả về OAuth URL. Mở trong browser và authorize.

Sau đó test:

```
Thêm meeting "Sprint Planning" vào 10:00 ngày mai
```

### Test notes skill

```
Tạo note về "Kubernetes NetworkPolicy examples"
```

### Test reminders skill

```
Nhắc tôi "Review pull requests" lúc 2:00 PM
```

### Kiểm tra logs nếu có lỗi

```bash
journalctl --user -u openclaw -f
```

{{< callout type="info" >}}
**LƯU Ý:** Một số skills yêu cầu API keys (ví dụ: web-search có thể cần SerpAPI key). Xem documentation của từng skill trong `~/.openclaw/skills/<skill-name>/README.md`.
{{< /callout >}}

{{< callout type="tip" >}}
**MẸO:** Model qwen2.5:7b hoạt động rất tốt cho tool-calling tasks. Nếu skills không được gọi đúng, thử chuyển sang qwen2.5:14b hoặc claude-sonnet.
{{< /callout >}}

## 7. Fine-tune Model Selection cho Từng Task

OpenClaw hỗ trợ routing queries đến model phù hợp.

### Cấu hình model routing

Thêm vào `openclaw.json`:

```json
{
  "model_routing": {
    "enabled": true,
    "default_model": "ollama/qwen2.5:7b",
    "routing_rules": [
      {
        "condition": "complexity:high OR tokens>2000",
        "model": "anthropic/claude-sonnet-4-5"
      },
      {
        "condition": "task:code_generation",
        "model": "ollama/qwen2.5-coder:14b"
      },
      {
        "condition": "task:simple_qa OR tokens<500",
        "model": "ollama/llama3.1:8b"
      },
      {
        "condition": "requires:tools",
        "model": "ollama/qwen2.5:7b"
      },
      {
        "condition": "language:vietnamese",
        "model": "ollama/qwen2.5:7b"
      }
    ],
    "fallback_model": "ollama/qwen2.5:7b"
  }
}
```

**Giải thích routing logic:**

- Queries phức tạp (>2000 tokens) → claude-sonnet (chất lượng cao)
- Code generation → qwen2.5-coder:14b (chuyên code)
- Q&A đơn giản (<500 tokens) → llama3.1:8b (nhanh, tiết kiệm)
- Tool-calling (skills) → qwen2.5:7b (tốt nhất cho function calling)
- Tiếng Việt → qwen2.5:7b (hỗ trợ đa ngôn ngữ tốt)

### Monitor routing decisions

Bật debug logs:

```bash
openclaw config set log_level debug
systemctl --user restart openclaw
```

Kiểm tra routing trong logs:

```bash
journalctl --user -u openclaw | grep "model_routing"
```

Output mẫu:

```
[INFO] model_routing: Query complexity=low, tokens=234
  → ollama/llama3.1:8b
[INFO] model_routing: Query requires tools → ollama/qwen2.5:7b
[INFO] model_routing: Query complexity=high, tokens=3456
  → anthropic/claude-sonnet-4-5
```

## 8. Custom Automations (Tùy chọn)

Tạo automation tùy chỉnh cho workflows cụ thể.

### Ví dụ: Daily Security Digest

Tạo file automation config:

```bash
nano ~/.openclaw/automations/security-digest.yaml
```

Nội dung:

```yaml
name: Daily Security Digest
description: Aggregate security news and CVEs every morning
schedule: "0 8 * * 1-5"  # 8 AM weekdays
timezone: Asia/Ho_Chi_Minh

steps:
  - name: Fetch CVEs
    skill: web-search
    query: "latest CVEs site:nvd.nist.gov published:24h"

  - name: Fetch Security News
    skill: web-search
    query: "cybersecurity news site:thehackernews.com
      OR site:bleepingcomputer.com published:24h"

  - name: Check Dependencies
    skill: code-analyzer
    action: scan_dependencies
    path: ~/openclaw/workspace/code

  - name: Generate Summary
    prompt: |
      Tóm tắt các security updates sau bằng tiếng Việt:
      - CVEs: {{steps.0.result}}
      - News: {{steps.1.result}}
      - Dependency alerts: {{steps.2.result}}

      Format: bullet points, ưu tiên critical/high severity.

  - name: Send Report
    action: send_message
    channel: telegram
    message: "{{steps.3.result}}"
```

Activate automation:

```bash
openclaw automations reload
openclaw automations list
```

Test thủ công:

```bash
openclaw automations run security-digest
```

{{< callout type="tip" >}}
**MẸO:** Automations mạnh mẽ nhưng cần giám sát. Bắt đầu với dry-run mode và kiểm tra output trước khi enable production.
{{< /callout >}}

## 9. Security Audit sau khi Cài Skills

{{< callout type="info" >}}
**QUAN TRỌNG:** Sau mỗi lần cài skill mới, chạy security audit để phát hiện quyền truy cập đáng ngờ.
{{< /callout >}}

Chạy audit:

```bash
openclaw skills audit
```

Output mẫu:

```
Security Audit Report:
✓ web-search: No suspicious permissions
✓ calendar: Requires Google OAuth (expected)
✓ notes: File write access to workspace (expected)
✓ weather: External API calls to openweathermap.org (expected)
✓ reminders: No suspicious permissions

⚠ Warnings:
- calendar skill requests network access (Google Calendar API)
- notes skill can write to workspace directory

Recommendations:
- Review OAuth scopes for calendar skill
- Limit workspace write access if not needed
```

Nếu thấy warning bất thường, uninstall skill:

```bash
openclaw skills uninstall <skill-name>
```

## Tổng kết

Bạn đã hoàn thành việc tùy chỉnh OpenClaw thành trợ lý cá nhân mạnh mẽ:

✅ Cài đặt 5+ skills cốt lõi
✅ Cấu hình persona phù hợp với role DevSecOps
✅ Kích hoạt persistent memory
✅ Thiết lập morning briefing và reminders
✅ Cấu hình workspace cho file access
✅ Tối ưu model routing (cost + performance)
✅ Tạo custom automation cho security digest
✅ Chạy security audit

**Checklist tự kiểm tra:**

- [ ] `openclaw skills list` hiển thị đủ skills
- [ ] Morning briefing đến Telegram đúng giờ
- [ ] Test ít nhất 3 skills thành công
- [ ] Memory ghi nhớ preferences qua sessions
- [ ] Model routing logs cho thấy routing đúng
- [ ] Security audit không có critical warnings

## Bước tiếp theo

**[Bài 06: Vận hành và Bảo trì OpenClaw →](/posts/openclaw-personal-assistant/06-operations-maintenance)**

Trong bài tiếp theo, bạn sẽ học:

- Thiết lập backup tự động hàng ngày
- Cấu hình health check và monitoring
- Quy trình update an toàn
- Theo dõi chi phí API usage
- Disaster recovery procedures
- Maintenance calendar

**Câu hỏi thường gặp:**

**Q: Skills không được gọi, assistant trả lời thông thường?**
A: Kiểm tra model có hỗ trợ function calling không. Qwen2.5:7b và Claude Sonnet hỗ trợ tốt. Llama3.1:8b có thể kém hơn.

**Q: Morning briefing không gửi đúng giờ?**
A: Kiểm tra timezone trong config và systemd timer. Chạy `systemctl --user list-timers` để xem schedule.

**Q: Làm sao biết query nào dùng model nào?**
A: Bật `log_level: debug` và theo dõi logs `journalctl --user -u openclaw -f | grep model_routing`.

**Q: Có thể dùng OpenAI thay vì Ollama?**
A: Có, thay `ollama/qwen2.5:7b` bằng `openai/gpt-4o` trong `default_model`. Nhưng tốn phí hơn nhiều.
