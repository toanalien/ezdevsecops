---
title: "Tích Hợp OpenClaw với Telegram, WhatsApp, Discord và Zalo"
date: 2026-02-15
draft: false
description: "Hướng dẫn kết nối OpenClaw AI Assistant với các nền tảng nhắn tin như Telegram, WhatsApp, Discord, Zalo để điều khiển trợ lý AI từ điện thoại"
categories: ["AI Assistant"]
tags: ["openclaw", "telegram", "discord", "whatsapp", "chatbot"]
series: ["OpenClaw Personal Assistant"]
weight: 3
---

## Giới thiệu

Sau khi cài đặt OpenClaw thành công ở [Phần 01](/posts/openclaw-personal-assistant/01-infrastructure-preparation/) và [Phần 02](/posts/openclaw-personal-assistant/02-installation-configuration/), bạn đã có AI assistant chạy trên server. Nhưng để sử dụng tiện lợi từ điện thoại, bạn cần tích hợp với các ứng dụng nhắn tin quen thuộc.

Bài này hướng dẫn chi tiết cách kết nối OpenClaw với **Telegram** (khuyến nghị chính), **WhatsApp**, **Discord**, và **Zalo**.

### Mục tiêu học tập

Sau bài này bạn sẽ:

- ✅ Tạo và cấu hình Telegram bot để chat với OpenClaw
- ✅ Thiết lập xác thực người dùng (allowedUsers) để bảo vệ API keys
- ✅ Tùy chọn: tích hợp WhatsApp, Discord, Zalo
- ✅ Hiểu rõ rủi ro bảo mật khi không giới hạn truy cập

### Yêu cầu trước khi bắt đầu

- ✅ OpenClaw đã cài đặt và chạy (xem Phần 02)
- ✅ Tài khoản Telegram (khuyến nghị)
- ✅ Quyền sudo trên server
- ✅ (Khuyến nghị) Xem [Phần 04](/posts/openclaw-personal-assistant/04-security-hardening/) về bảo mật sau khi hoàn thành

---

## 1. Tích Hợp Telegram Bot (Khuyến Nghị Chính)

Telegram là lựa chọn tốt nhất vì:

- API ổn định, không bị ngắt kết nối
- Dễ cài đặt, không cần số điện thoại
- Hỗ trợ file, hình ảnh, voice messages
- Không giới hạn tin nhắn

### Bước 1a: Tạo Bot qua BotFather

1. Mở Telegram, tìm kiếm `@BotFather`
2. Gửi lệnh `/newbot`
3. Nhập tên bot (ví dụ: "My OpenClaw Assistant")
4. Nhập username bot (phải kết thúc bằng `bot`, ví dụ: `my_openclaw_bot`)
5. **Lưu token** nhận được (dạng `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`)

{{< callout type="danger" >}}
**NGUY HIỂM:** Bot token tương đương mật khẩu truy cập đầy đủ tài khoản bot. KHÔNG chia sẻ hoặc commit lên Git!
{{< /callout >}}

### Bước 1b: Cấu Hình OpenClaw Sử Dụng Bot

**Phương pháp 1: Sử dụng CLI (khuyến nghị)**

```bash
# Đăng nhập vào server với user openclaw
sudo -u openclaw -i

# Thêm channel Telegram
openclaw channel add telegram \
  --token "1234567890:ABCdefGHIjklMNOpqrsTUVwxyz" \
  --name "telegram-main"
```

**Phương pháp 2: Chỉnh sửa file cấu hình**

```bash
# Mở file config
nano ~/.openclaw/openclaw.json
```

Thêm vào phần `channels`:

```json
{
  "channels": [
    {
      "type": "telegram",
      "name": "telegram-main",
      "enabled": true,
      "config": {
        "token": "1234567890:ABCdefGHIjklMNOpqrsTUVwxyz",
        "allowedUsers": []
      }
    }
  ]
}
```

Lưu file với `Ctrl+O`, thoát với `Ctrl+X`.

### Bước 1c: Giới Hạn Người Dùng (BẮT BUỘC)

{{< callout type="danger" >}}
**CẢNH BÁO NGHIÊM TRỌNG:** Nếu không thiết lập `allowedUsers`, BẤT KỲ AI trên
Telegram đều có thể chat với bot và tiêu tốn LLM credits của bạn!
{{< /callout >}}

**Lấy Telegram User ID:**

1. Mở Telegram, tìm `@userinfobot`
2. Gửi tin nhắn bất kỳ
3. Bot sẽ trả về ID (ví dụ: `123456789`)

**Cập nhật allowedUsers:**

```bash
# Cách 1: CLI
openclaw channel update telegram-main \
  --allowed-users 123456789,987654321

# Cách 2: Chỉnh sửa openclaw.json
nano ~/.openclaw/openclaw.json
```

Trong `openclaw.json`:

```json
{
  "config": {
    "token": "1234567890:ABCdefGHIjklMNOpqrsTUVwxyz",
    "allowedUsers": [123456789, 987654321]
  }
}
```

### Bước 1d: Khởi Động Lại và Kiểm Tra

```bash
# Restart service
systemctl --user restart openclaw

# Kiểm tra logs
sudo journalctl -u openclaw -f --no-pager
```

Bạn sẽ thấy dòng:

```
[INFO] Telegram channel 'telegram-main' initialized
[INFO] Allowed users: [123456789, 987654321]
```

**Kiểm tra hoạt động:**

1. Mở Telegram, tìm bot của bạn (`@my_openclaw_bot`)
2. Gửi tin nhắn: `Hello, what can you do?`
3. Bot sẽ trả lời giới thiệu khả năng

{{< callout type="tip" >}}
**MẸO:** Nếu bot không phản hồi, kiểm tra logs với `journalctl -u openclaw -n
50`. Lỗi phổ biến: token sai hoặc user ID không đúng định dạng.
{{< /callout >}}

---

## 2. Tích Hợp WhatsApp (Tùy Chọn)

WhatsApp phức tạp hơn vì Meta không cung cấp API miễn phí cho cá nhân. Có 2
cách:

- **WhatsApp Business API** (trả phí, dành cho doanh nghiệp)
- **WhatsApp Web Bridge** (miễn phí, không chính thức)

### Yêu Cầu Trước Khi Bắt Đầu

- Node.js 18+ đã cài đặt
- Điện thoại có WhatsApp đã đăng ký

### Bước 2a: Cài Đặt WhatsApp Web Bridge

```bash
# Cài đặt whatsapp-web.js
npm install -g whatsapp-openclaw-bridge

# Hoặc dùng OpenClaw plugin (nếu hỗ trợ)
openclaw plugin install whatsapp-web
```

### Bước 2b: Cấu Hình trong OpenClaw

```bash
openclaw channel add whatsapp \
  --name "whatsapp-main" \
  --bridge-port 3001
```

Hoặc chỉnh sửa `openclaw.json`:

```json
{
  "channels": [
    {
      "type": "whatsapp",
      "name": "whatsapp-main",
      "enabled": true,
      "config": {
        "bridgeUrl": "http://localhost:3001",
        "allowedNumbers": ["+84901234567"]
      }
    }
  ]
}
```

### Bước 2c: Kết Nối Qua QR Code

```bash
# Khởi động bridge
whatsapp-openclaw-bridge --port 3001

# Mở trình duyệt, vào http://YOUR_SERVER_IP:3001
# Quét QR code bằng WhatsApp trên điện thoại
```

{{< callout type="warning" >}}
**CẢNH BÁO:** WhatsApp Web bridge sẽ ngắt kết nối sau 14 ngày không hoạt động.
Không khuyến nghị làm kênh chính.
{{< /callout >}}

### Bước 2d: Giới Hạn Số Điện Thoại

Luôn thiết lập `allowedNumbers`:

```json
{
  "config": {
    "allowedNumbers": ["+84901234567", "+84987654321"]
  }
}
```

---

## 3. Tích Hợp Discord (Tùy Chọn)

Discord phù hợp nếu bạn muốn bot phục vụ team/cộng đồng.

### Bước 3a: Tạo Discord Bot

1. Vào [Discord Developer Portal](https://discord.com/developers/applications)
2. Click **New Application**, đặt tên (ví dụ: "OpenClaw Bot")
3. Vào tab **Bot** → **Add Bot**
4. Copy **Token** (click Reset Token nếu cần)
5. Tắt **Public Bot** (chỉ bạn mời được)
6. Bật **Message Content Intent** (để đọc tin nhắn)

### Bước 3b: Mời Bot Vào Server

1. Vào tab **OAuth2** → **URL Generator**
2. Chọn scopes: `bot`, `applications.commands`
3. Chọn permissions: `Send Messages`, `Read Message History`,
`Use Slash Commands`
4. Copy URL tạo ra, mở trong trình duyệt
5. Chọn server muốn thêm bot

### Bước 3c: Cấu Hình OpenClaw

```bash
openclaw channel add discord \
  --token "YOUR_DISCORD_BOT_TOKEN" \
  --name "discord-main"
```

Hoặc chỉnh sửa `openclaw.json`:

```json
{
  "channels": [
    {
      "type": "discord",
      "name": "discord-main",
      "enabled": true,
      "config": {
        "token": "YOUR_DISCORD_BOT_TOKEN",
        "allowedServers": ["1234567890123456789"],
        "allowedUsers": ["987654321098765432"],
        "commandPrefix": "!"
      }
    }
  ]
}
```

**Lấy Server ID và User ID:**

- Bật Developer Mode trong Discord Settings → Advanced
- Click phải server/user → Copy ID

### Bước 3d: Kiểm Tra

```bash
systemctl --user restart openclaw
sudo journalctl -u openclaw -f --no-pager
```

Trong Discord, gõ: `!help` hoặc mention bot `@OpenClaw Bot what can you do?`

---

## 4. Tích Hợp Zalo (Tùy Chọn - Dành Cho Người Việt)

Zalo Official Account (Zalo OA) cho phép tạo chatbot.

### Bước 4a: Đăng Ký Zalo OA

1. Vào [https://oa.zalo.me](https://oa.zalo.me)
2. Đăng ký tài khoản OA (cần giấy tờ doanh nghiệp hoặc cá nhân)
3. Sau khi duyệt, vào **Cài đặt** → **API Key**
4. Copy **OA ID**, **App ID**, **App Secret**

### Bước 4b: Thiết Lập Webhook

OpenClaw cần public URL để nhận webhook từ Zalo. Dùng reverse proxy:

```bash
# Cài đặt Caddy (nếu chưa có)
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] \
  https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" \
  | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy

# Cấu hình reverse proxy
sudo nano /etc/caddy/Caddyfile
```

Thêm vào Caddyfile:

```caddyfile
openclaw.yourdomain.com {
    reverse_proxy localhost:8080
}
```

```bash
sudo systemctl restart caddy
```

### Bước 4c: Cấu Hình OpenClaw

```json
{
  "channels": [
    {
      "type": "zalo",
      "name": "zalo-main",
      "enabled": true,
      "config": {
        "oaId": "1234567890123456789",
        "appId": "9876543210987654321",
        "appSecret": "your_app_secret_here",
        "webhookUrl": "https://openclaw.yourdomain.com/webhook/zalo",
        "allowedUsers": ["zalo_user_id_1", "zalo_user_id_2"]
      }
    }
  ]
}
```

{{< callout type="info" >}}
**THÔNG TIN:** Zalo OA cá nhân có giới hạn 1000 tin nhắn/tháng miễn phí. Vượt
quá cần nâng cấp tài khoản.
{{< /callout >}}

---

## 5. Bảo Mật Token và Khởi Động Lại

### Bước 5a: Bảo Vệ File Cấu Hình

```bash
# Đảm bảo chỉ user openclaw đọc được
sudo chmod 600 /home/openclaw/.openclaw/openclaw.json
sudo chown openclaw:openclaw /home/openclaw/.openclaw/openclaw.json
```

{{< callout type="danger" >}}
**NGUY HIỂM:** Các bot token có quyền TOÀN BỘ tài khoản bot. Lưu trữ an toàn
với quyền 600 và KHÔNG commit lên Git!
{{< /callout >}}

### Bước 5b: Kiểm Tra Toàn Bộ Cấu Hình

```bash
# Xem config hiện tại (ẩn sensitive data)
openclaw channel list

# Output mẫu:
# NAME            TYPE        ENABLED  ALLOWED_USERS
# telegram-main   telegram    ✓        2 users
# whatsapp-main   whatsapp    ✓        1 number
# discord-main    discord     ✓        1 server, 3 users
```

### Bước 5c: Khởi Động Lại Service

```bash
systemctl --user restart openclaw
systemctl --user status openclaw

# Kiểm tra logs chi tiết
sudo journalctl -u openclaw --since "5 minutes ago" --no-pager
```

### Bước 5d: Kiểm Tra Từng Channel

**Telegram:**

```
Bạn: Hello
Bot: Hi! I'm your OpenClaw assistant. How can I help you today?
```

**WhatsApp:**

```
Bạn: Test message
Bot: (phản hồi tương tự)
```

**Discord:**

```
Bạn: !help
Bot: Available commands: !ask, !summarize, !code, !image...
```

**Zalo:**

```
Bạn: Xin chào
Bot: Chào bạn! Tôi là trợ lý AI OpenClaw...
```

---

## 6. Quản Lý và Bảo Trì

### Vô Hiệu Hóa Channel Tạm Thời

```bash
openclaw channel disable whatsapp-main
```

### Xóa Channel

```bash
openclaw channel remove discord-main
```

### Thay Đổi Token (Rotation)

{{< callout type="tip" >}}
**MẸO:** Nên thay token 3-6 tháng/lần để tăng bảo mật.
{{< /callout >}}

```bash
# Telegram: vào @BotFather → /revoke → tạo token mới
# Cập nhật trong OpenClaw
openclaw channel update telegram-main --token "NEW_TOKEN_HERE"

systemctl --user restart openclaw
```

### Giám Sát Logs

```bash
# Theo dõi real-time
sudo journalctl -u openclaw -f

# Xem 100 dòng cuối
sudo journalctl -u openclaw -n 100

# Lọc theo channel
sudo journalctl -u openclaw | grep "telegram-main"
```

---

## Tổng Kết

Bạn đã hoàn thành:

- ✅ Tích hợp Telegram bot với xác thực người dùng
- ✅ Tùy chọn: WhatsApp, Discord, Zalo
- ✅ Bảo vệ token và giới hạn truy cập
- ✅ Kiểm tra và giám sát channels

**Khuyến nghị:**

1. **Telegram** làm kênh chính (ổn định nhất)
2. **Discord** nếu dùng chung team
3. **WhatsApp/Zalo** chỉ dùng bổ sung (dễ ngắt kết nối)

{{< callout type="warning" >}}
**QUAN TRỌNG:** LUÔN thiết lập `allowedUsers` hoặc `allowedNumbers`. Đây là
hàng rào bảo vệ quan trọng nhất!
{{< /callout >}}

### Bước Tiếp Theo

- **[Phần 04: Tăng Cường Bảo Mật](/posts/openclaw-personal-assistant/04-security-hardening/)** - Hardening hệ thống với fail2ban, audit, và network security
- **[Phần 05: Kỹ năng và tùy chỉnh](/posts/openclaw-personal-assistant/05-skills-customization/)** - Cài đặt skills và tùy chỉnh persona cho OpenClaw

---

**Câu hỏi thường gặp:**

**Q: Bot Telegram không phản hồi?**
A: Kiểm tra `journalctl -u openclaw -n 50`, lỗi thường do token sai hoặc user
ID không đúng định dạng số.

**Q: WhatsApp bridge bị disconnect?**
A: Bình thường nếu không dùng >14 ngày. Quét lại QR code là được.

**Q: Có giới hạn số lượng tin nhắn không?**
A: Telegram không giới hạn. WhatsApp Web bridge không giới hạn. Zalo OA miễn
phí 1000/tháng.

**Q: Có thể dùng nhiều bot Telegram cùng lúc?**
A: Được, thêm nhiều channels với tên khác nhau (`telegram-personal`,
`telegram-work`).
