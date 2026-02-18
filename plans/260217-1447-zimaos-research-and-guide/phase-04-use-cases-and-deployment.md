# Phase 04: Kịch bản sử dụng & Triển khai ZimaOS

> **Ngôn ngữ:** Tiếng Việt | **Trạng thái:** Hoàn thành | **Phiên bản ZimaOS:** 1.3.x (02/2026)

---

## Tổng quan

Phần này hướng dẫn 7 kịch bản triển khai thực tế, mỗi kịch bản bao gồm: apps cần cài, cấu hình, phần cứng khuyến nghị và lưu ý vận hành.

---

## 1. Personal NAS — Lưu trữ cá nhân

### Mô tả
Biến ZimaOS thành ổ cứng mạng gia đình, thay thế Google Drive/iCloud/OneDrive. Lưu trữ file, ảnh, tài liệu tại nhà với quyền kiểm soát hoàn toàn.

### Apps cần cài
- **Files** (tích hợp sẵn) — quản lý file qua web
- **Samba** (tích hợp sẵn) — chia sẻ file LAN
- **Tailscale** — truy cập từ xa an toàn

### Cấu hình

**Storage:**
- 2 ổ HDD → RAID 1 (mirror, chịu 1 ổ hỏng)
- Hoặc 3+ ổ → RAID 5 (cân bằng dung lượng/an toàn)
- Tạo thư mục: `/Documents`, `/Photos`, `/Backups`

**Samba:**
- Bật sharing cho các thư mục cần truy cập từ PC/laptop
- Đặt quyền read/write theo user

**Remote Access:**
- Cài Tailscale → truy cập file từ bất kỳ đâu qua VPN
- Hoặc dùng Zima Client cho đơn giản

### Phần cứng khuyến nghị

| Mức | CPU | RAM | Storage | Ước tính |
|-----|-----|-----|---------|----------|
| Tối thiểu | Intel Celeron/N5105 | 4GB | 2x 2TB HDD | ~$150-200 |
| Khuyến nghị | Intel i3/N100 | 8GB | 2x 4TB HDD + 128GB SSD (OS) | ~$300-400 |

### Điện năng & Vận hành
- Tiêu thụ: ~10-15W idle → ~$2-3/tháng điện (24/7)
- Auto sleep HDD khi không dùng → tiết kiệm thêm

---

## 2. Media Server — Server phát media

### Mô tả
Stream phim, nhạc, ảnh cho gia đình qua TV, điện thoại, tablet. Thay thế Netflix cho nội dung cá nhân.

### Apps cần cài
- **Jellyfin** (khuyến nghị, miễn phí) hoặc **Plex**
- **Immich** — quản lý ảnh kiểu Google Photos
- **qBittorrent** hoặc **aria2** — tải nội dung

### Cấu hình

**Jellyfin:**
1. Cài từ App Store
2. Tạo thư viện: Movies, TV Shows, Music, Photos
3. Mount volume media vào Jellyfin container
4. Bật Hardware Transcoding:
   - Settings → Playback → Transcoding
   - Chọn Intel QSV (nếu CPU Intel Gen 7+) hoặc VAAPI
5. Cài Jellyfin client trên Smart TV, Fire Stick, Apple TV, điện thoại

**Immich:**
1. Cài từ App Store
2. Cài Immich app trên iOS/Android
3. Bật auto-backup ảnh → ảnh tự upload về NAS
4. AI nhận diện khuôn mặt chạy local (riêng tư)

### Phần cứng khuyến nghị

| Mức | CPU | RAM | Storage | GPU |
|-----|-----|-----|---------|-----|
| 1-2 stream | Intel N100/N5105 | 8GB | 4TB+ HDD | Intel iGPU (QSV) |
| 3-5 stream 4K | Intel i5 | 16GB | 8TB+ HDD + SSD cache | Intel iGPU hoặc NVIDIA |

> **Lưu ý:** Hardware transcoding rất quan trọng cho media server. CPU Intel thế hệ 7+ có Quick Sync hỗ trợ H.264/H.265/AV1 encode/decode.

---

## 3. Docker App Hosting — Nền tảng chạy ứng dụng

### Mô tả
Dùng ZimaOS làm nền tảng chạy nhiều dịch vụ tự host: web server, database, automation, monitoring.

### Apps gợi ý
- **Portainer** — quản lý Docker nâng cao
- **Uptime Kuma** — giám sát uptime dịch vụ
- **n8n** hoặc **Huginn** — automation workflow
- **Vaultwarden** — password manager (tự host Bitwarden)
- **Gitea** — Git server riêng
- **Nginx Proxy Manager** — reverse proxy + SSL

### Cấu hình

**Portainer (nếu cần quản lý Docker nâng cao):**
1. Cài từ App Store
2. Truy cập `http://<ip>:9443`
3. Xem logs, restart containers, quản lý networks/volumes

**Nginx Proxy Manager:**
1. Cài từ App Store
2. Tạo proxy host cho từng dịch vụ (ví dụ: `git.local` → Gitea port 3000)
3. Cấu hình SSL nếu expose ra internet

**Resource Monitoring:**
- ZimaOS Dashboard hiển thị CPU, RAM, disk usage
- Portainer cho chi tiết per-container

### Phần cứng khuyến nghị

| Mức | CPU | RAM | Storage |
|-----|-----|-----|---------|
| 5-10 containers | Intel N100 | 8GB | 256GB SSD |
| 10-20 containers | Intel i3/i5 | 16GB | 512GB SSD |
| 20+ containers | Intel i5/i7 | 32GB | 1TB SSD |

---

## 4. Home Automation — Nhà thông minh

### Mô tả
ZimaOS làm trung tâm điều khiển nhà thông minh: quản lý thiết bị IoT, chặn quảng cáo mạng, phát media khắp nhà.

### Apps cần cài
- **Home Assistant** — nền tảng smart home số 1
- **Pi-hole** hoặc **AdGuard Home** — chặn quảng cáo DNS
- **Mosquitto** — MQTT broker cho IoT

### Cấu hình

**Home Assistant:**
1. Cài từ App Store (Docker version)
2. Truy cập `http://<ip>:8123`
3. Thêm thiết bị: Zigbee, Z-Wave, WiFi devices
4. Tạo automation rules (ví dụ: bật đèn khi về nhà)

> **Lưu ý:** Home Assistant trên Docker không hỗ trợ Add-ons natively. Nếu cần Add-ons, cân nhắc chạy Home Assistant OS trong ZVM.

**Pi-hole (Chặn quảng cáo):**
1. Cài từ App Store
2. Đổi DNS của router sang IP ZimaOS → chặn quảng cáo toàn mạng
3. Dashboard Pi-hole: xem thống kê queries, blocked domains

**MQTT + IoT:**
- Cài Mosquitto → làm MQTT broker
- Kết nối sensor/thiết bị IoT → Home Assistant xử lý automation

### Phần cứng khuyến nghị

| Mức | CPU | RAM | Storage | Phụ kiện |
|-----|-----|-----|---------|----------|
| Cơ bản | Intel Celeron | 4GB | 128GB SSD | USB Zigbee dongle |
| Đầy đủ | Intel N100 | 8GB | 256GB SSD | Zigbee + Z-Wave dongles |

---

## 5. Dev/Homelab — Môi trường phát triển

### Mô tả
Dùng ZimaOS làm lab cá nhân: chạy dev containers, test VMs, học DevOps, thử nghiệm công nghệ mới.

### Apps gợi ý
- **VS Code Server** — IDE từ xa qua trình duyệt
- **Gitea** — Git server
- **Docker Compose** stacks tùy chỉnh
- **ZVM** — máy ảo để test OS, Kubernetes, etc.

### Cấu hình

**VS Code Server:**
1. Cài từ App Store
2. Truy cập `http://<ip>:8443`
3. Code từ bất kỳ thiết bị nào qua trình duyệt

**ZVM cho Lab:**
1. Tạo VM Ubuntu/Debian cho test
2. Phân bổ 2-4 cores, 4-8GB RAM per VM
3. Dùng cho: test Kubernetes (k3s), CI/CD pipelines, network lab

**PCIe Expansion (ZimaCube):**
- Gắn NVMe SSD qua PCIe cho storage nhanh
- Gắn GPU cho AI/ML workloads
- Gắn 10GbE NIC cho network lab

### Phần cứng khuyến nghị

| Mức | CPU | RAM | Storage | Mở rộng |
|-----|-----|-----|---------|---------|
| Dev nhẹ | Intel i3 | 16GB | 512GB SSD | — |
| Homelab | Intel i5/i7 | 32GB | 1TB NVMe + HDD | PCIe GPU/NIC |
| Lab nặng | Intel i7/Xeon | 64GB | 2TB NVMe + RAID HDD | Multi PCIe |

---

## 6. Backup Solution — Giải pháp sao lưu

### Mô tả
ZimaOS làm trung tâm backup cho tất cả thiết bị trong nhà: Mac, Windows, điện thoại, server khác.

### Chiến lược backup: Nguyên tắc 3-2-1

| Nguyên tắc | Ý nghĩa | Ví dụ |
|-----------|---------|-------|
| **3** bản copy | Dữ liệu gốc + 2 bản sao | Laptop + NAS + Cloud |
| **2** loại media | Lưu trên 2 loại thiết bị khác nhau | SSD (NAS) + HDD (external) |
| **1** bản offsite | 1 bản ở vị trí khác | Cloud storage hoặc NAS ở nơi khác |

### Apps & Tính năng

**Time Machine (macOS):**
- ZimaOS hỗ trợ Time Machine backup qua Samba
- Mac tự backup hàng giờ qua mạng LAN
- Cấu hình: bật Time Machine share trong Samba settings

**Syncthing (Cross-platform sync):**
- Cài từ App Store
- Đồng bộ folder giữa PC/laptop/điện thoại và NAS
- End-to-end encrypted, peer-to-peer

**Duplicati (Cloud backup):**
- Backup từ NAS lên cloud (Backblaze B2, Google Drive, S3)
- Mã hóa trước khi upload
- Lên lịch backup tự động

### Cấu hình RAID cho backup

| Tình huống | RAID khuyến nghị |
|-----------|-----------------|
| 2 ổ, backup quan trọng | RAID 1 |
| 4+ ổ, lưu trữ lớn | RAID 5 hoặc RAID 6 |
| Không cần redundancy (đã có backup khác) | JBOD |

### Phần cứng khuyến nghị

| Mức | CPU | RAM | Storage |
|-----|-----|-----|---------|
| Backup gia đình | Intel Celeron | 4GB | 2x 4TB HDD (RAID 1) |
| Backup + archive | Intel N100 | 8GB | 4x 4TB HDD (RAID 5) + SSD OS |

---

## 7. AI/LLM Local — Chạy AI tại nhà

### Mô tả
Chạy Large Language Models (LLM) và AI tools local, riêng tư 100%, không gửi dữ liệu lên cloud.

### Apps cần cài
- **Ollama** — runtime chạy LLM local
- **Open WebUI** — giao diện chat giống ChatGPT
- **Stable Diffusion WebUI** — tạo ảnh AI (cần GPU)

### Cấu hình

**Ollama + Open WebUI (Chat AI):**
1. Cài **Ollama** từ App Store
2. Cài **Open WebUI** từ App Store
3. Trong Open WebUI, chọn model: `llama3.2`, `mistral`, `phi-3`, `qwen2.5`
4. Chat AI local, dữ liệu không rời khỏi máy

**Model recommendations:**

| Model | RAM cần | Tốc độ | Chất lượng | Ghi chú |
|-------|---------|--------|------------|---------|
| Phi-3 Mini (3.8B) | 4GB | Nhanh | Tốt cho tasks đơn giản | Chạy tốt trên CPU |
| Llama 3.2 (8B) | 8GB | Trung bình | Tốt | Cần 8GB+ RAM |
| Mistral (7B) | 8GB | Trung bình | Tốt | Coding & reasoning |
| Llama 3.1 (70B) | 48GB+ | Chậm | Rất tốt | Cần GPU 24GB+ VRAM |

**GPU Passthrough (nâng cao):**
- ZimaCube có PCIe slot → gắn NVIDIA GPU
- Cấu hình GPU passthrough trong Docker/ZVM
- NVIDIA Container Toolkit cho Docker containers
- Cần thiết cho Stable Diffusion và model >13B parameters

### Phần cứng khuyến nghị

| Mức | CPU | RAM | GPU | Khả năng |
|-----|-----|-----|-----|----------|
| Chat AI cơ bản | Intel i3+ | 16GB | Không cần | Model 3-8B, CPU inference |
| Chat AI tốt | Intel i5+ | 32GB | NVIDIA RTX 3060+ (12GB) | Model 7-13B, GPU inference |
| AI nâng cao | Intel i7+ | 64GB | NVIDIA RTX 4090 (24GB) | Model 70B, Stable Diffusion |

### Lưu ý bảo mật
- Mặc định Ollama chỉ listen trên localhost → an toàn
- Nếu expose Open WebUI ra internet → bật authentication
- Dữ liệu chat và model files lưu hoàn toàn local

---

## Bảng tổng hợp phần cứng theo kịch bản

| Kịch bản | CPU tối thiểu | RAM | Storage | GPU | Điện (~) |
|----------|--------------|-----|---------|-----|----------|
| NAS | Celeron/N5105 | 4GB | 2x HDD | Không | 10-15W |
| Media Server | N100/N5105 | 8GB | 4TB+ HDD | Intel iGPU | 15-25W |
| Docker Host | N100 | 8-16GB | 256GB+ SSD | Không | 15-20W |
| Home Automation | Celeron | 4GB | 128GB SSD | Không | 10-15W |
| Dev/Homelab | i3-i5 | 16-32GB | 512GB+ SSD | Tùy | 25-65W |
| Backup | Celeron | 4GB | 2-4x HDD | Không | 10-20W |
| AI/LLM | i5+ | 16-64GB | SSD + HDD | NVIDIA | 50-300W |

### Chi phí điện ước tính (24/7, giá điện VN ~2,000 VNĐ/kWh)

| Mức tiêu thụ | Chi phí/tháng |
|-------------|---------------|
| 10W (NAS nhẹ) | ~14,400 VNĐ (~$0.6) |
| 25W (media server) | ~36,000 VNĐ (~$1.5) |
| 65W (homelab) | ~93,600 VNĐ (~$3.9) |
| 150W (AI workload) | ~216,000 VNĐ (~$9) |

---

## Tài liệu tham khảo

- [Remote Access Guide](https://www.zimaspace.com/blog/access-jellyfin-and-more-remotely-using-tailscale-zerotier-or-cloudflare.html)
- [Hardware Transcoding](https://shop.zimaspace.com/blogs/zima-campaign-hub/hardware-accelerated-streaming-plex-jellyfin-emby-zimaos)
- [Build Custom Apps](https://www.zimaspace.com/docs/zimaos/Build-Apps)
- [ZimaCube Review (ItsFoss)](https://itsfoss.com/zimacube-review/)
- [Ollama](https://ollama.com/)
