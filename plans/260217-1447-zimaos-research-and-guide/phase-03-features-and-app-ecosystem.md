# Phase 03: Tính năng & Hệ sinh thái ứng dụng ZimaOS

> **Ngôn ngữ:** Tiếng Việt | **Trạng thái:** Hoàn thành | **Phiên bản ZimaOS:** 1.3.x (02/2026)

---

## 1. App Store — Kho ứng dụng

### Tổng quan

ZimaOS cung cấp **800+ ứng dụng Docker** cài đặt 1 click qua giao diện web, không cần kiến thức Docker CLI.

### Cách sử dụng App Store

**Duyệt & Cài đặt:**
1. Mở Dashboard → vào **App Store**
2. Duyệt theo danh mục: Media, Productivity, Networking, Development, AI...
3. Click vào app → xem mô tả, yêu cầu tài nguyên
4. Click **Install** → ZimaOS tự pull Docker image, mount volume, cấu hình port
5. App xuất hiện trên Dashboard, sẵn sàng sử dụng

**Cập nhật App:**
- Dashboard thông báo khi có phiên bản mới
- Click **Update** → ZimaOS pull image mới, giữ nguyên dữ liệu/config

**Gỡ App:**
- Click vào app → **Uninstall**
- Tùy chọn xóa hoặc giữ lại dữ liệu (volumes)

### Ứng dụng phổ biến theo danh mục

| Danh mục | Ứng dụng nổi bật | Mô tả |
|----------|------------------|-------|
| **Media** | Jellyfin, Plex, Emby | Streaming video/nhạc cho gia đình |
| **Ảnh** | Immich, PhotoPrism | Backup & quản lý ảnh từ điện thoại |
| **File** | Nextcloud, FileBrowser | Quản lý file qua web, sync đa thiết bị |
| **Download** | qBittorrent, aria2 | Tải torrent, download manager |
| **Ad-block** | Pi-hole, AdGuard Home | Chặn quảng cáo mạng toàn nhà |
| **Smart Home** | Home Assistant | Tự động hóa nhà thông minh |
| **Dev** | Gitea, VS Code Server | Git server, IDE từ xa |
| **AI** | Ollama, Open WebUI | Chạy LLM local, chat AI riêng tư |
| **Monitoring** | Uptime Kuma, Portainer | Giám sát server & Docker containers |

---

## 2. Third-Party App Stores — Kho ứng dụng bên thứ 3

### Tổng quan

Ngoài App Store chính thức, ZimaOS hỗ trợ **8 kho ứng dụng cộng đồng** với tổng cộng ~500 app bổ sung.

### Cách thêm kho bên thứ 3

1. Mở **App Store** → **Settings** (biểu tượng bánh răng)
2. Chọn **Third-party Sources**
3. Bật các kho muốn sử dụng từ danh sách có sẵn
4. App Store tự cập nhật danh mục sau khi bật

### Lưu ý quan trọng

- Kho cộng đồng **không được IceWhaleTech kiểm duyệt** trực tiếp
- Kiểm tra README/docs của app trước khi cài
- Một số app có thể không tương thích hoàn toàn với phiên bản ZimaOS hiện tại
- Ưu tiên dùng App Store chính thức khi có cùng ứng dụng

---

## 3. Custom Docker Containers — Container tùy chỉnh

### Khi nào cần custom container?

- App không có trong App Store
- Cần cấu hình Docker đặc biệt (network mode, privileged, etc.)
- Muốn deploy stack Docker Compose phức tạp

### Cách tạo custom container

**Phương pháp 1: Qua giao diện Web UI**
1. Dashboard → **App Store** → **Custom Install**
2. Điền thông tin:
   - **Docker Image**: tên image (ví dụ: `nginx:latest`)
   - **Ports**: mapping port (host:container)
   - **Volumes**: mount thư mục dữ liệu
   - **Environment**: biến môi trường
3. Click **Install** → ZimaOS pull và chạy container

**Phương pháp 2: Docker Compose**
1. Tạo file `docker-compose.yml` với cấu hình mong muốn
2. Upload qua giao diện hoặc SSH
3. ZimaOS quản lý compose stack qua UI

**Tham khảo:** [Build Apps Guide](https://www.zimaspace.com/docs/zimaos/Build-Apps) — hướng dẫn chính thức tạo custom apps cho ZimaOS.

---

## 4. RAID & Quản lý lưu trữ

### RAID Levels được hỗ trợ

| RAID Level | Số ổ tối thiểu | Dung lượng sử dụng | Chịu lỗi | Phù hợp cho |
|-----------|----------------|---------------------|-----------|-------------|
| **RAID 0** | 2 | 100% | Không | Tốc độ tối đa (không an toàn) |
| **RAID 1** | 2 | 50% | 1 ổ hỏng | Dữ liệu quan trọng, 2 ổ |
| **RAID 5** | 3 | (N-1)/N | 1 ổ hỏng | Cân bằng dung lượng & an toàn |
| **RAID 6** | 4 | (N-2)/N | 2 ổ hỏng | An toàn cao, nhiều ổ |
| **RAID 10** | 4 | 50% | 1 ổ/mirror | Tốc độ + an toàn |
| **JBOD** | 1+ | 100% | Không | Gộp ổ đơn giản, archive |

### Cách setup RAID (3 bước)

1. **Vào Storage:** Dashboard → **Storage** → thấy danh sách ổ cứng được nhận diện
2. **Tạo RAID:** Click **Create Storage Pool** → chọn RAID level → chọn các ổ cứng
3. **Xác nhận:** Review cấu hình → **Create** → đợi quá trình khởi tạo (phút → giờ tùy dung lượng)

### Chọn RAID level nào?

| Nhu cầu | RAID khuyến nghị | Lý do |
|---------|-----------------|-------|
| 2 ổ, muốn an toàn | RAID 1 | Mirror đơn giản, chịu 1 ổ hỏng |
| 3-4 ổ, cân bằng | RAID 5 | Tốt nhất về dung lượng/an toàn |
| 4+ ổ, cần rất an toàn | RAID 6 | Chịu 2 ổ hỏng đồng thời |
| Chỉ cần gộp dung lượng | JBOD | Đơn giản nhất, không bảo vệ |

> **⚠️ RAID không phải backup!** RAID bảo vệ khỏi lỗi phần cứng ổ cứng, KHÔNG bảo vệ khỏi xóa nhầm, ransomware, hay hỏng file. Luôn có backup riêng (xem Phase 04).

---

## 5. ZVM — Máy ảo

### Tổng quan

**ZVM (Zima Virtual Machine)** là hệ thống máy ảo nhẹ tích hợp trong ZimaOS, dựa trên QEMU/KVM.

### Tính năng

- Cài đặt Windows/Linux guest OS 1 click
- Phân bổ CPU, RAM, storage qua giao diện đồ họa
- Hỗ trợ USB passthrough, GPU passthrough (tùy phần cứng)
- Quản lý snapshot và backup VM

### Cách tạo máy ảo

1. Dashboard → **ZVM** → **Create Virtual Machine**
2. Chọn OS: Windows 10/11, Ubuntu, Debian, hoặc ISO tùy chỉnh
3. Cấu hình tài nguyên:
   - **CPU:** số core phân bổ
   - **RAM:** dung lượng RAM
   - **Storage:** tạo virtual disk (kích thước tùy chọn)
4. Boot → cài OS → sử dụng qua VNC trong trình duyệt

### Khi nào dùng VM vs Docker?

| Tiêu chí | Docker Container | ZVM (Máy ảo) |
|----------|-----------------|---------------|
| **Tốc độ** | Nhanh, nhẹ | Chậm hơn (full OS) |
| **Tài nguyên** | Ít | Nhiều (cần RAM/CPU riêng) |
| **Cách ly** | Mức process | Mức OS (hoàn toàn) |
| **Dùng khi** | App Linux/server | Cần Windows, test OS, full isolation |

---

## 6. Remote Access — Truy cập từ xa

ZimaOS hỗ trợ 4 phương thức truy cập từ xa:

### 6.1 Zima Client (Native)

- App chính hãng cho Windows, macOS, iOS, Android
- Kết nối tự động qua mạng Zima (relay server)
- Không cần cấu hình router/firewall
- **Ưu điểm:** Đơn giản nhất, cài là dùng
- **Hạn chế:** Phụ thuộc vào server Zima, tốc độ qua relay có thể chậm

### 6.2 Tailscale (Khuyến nghị)

[Tailscale](https://tailscale.com/) tạo VPN mesh network mã hóa giữa các thiết bị.

**Cài đặt:**
1. Tạo tài khoản Tailscale (miễn phí cho cá nhân, tối đa 100 thiết bị)
2. Trong ZimaOS: App Store → cài **Tailscale** → đăng nhập
3. Trên máy client: cài Tailscale app → đăng nhập cùng tài khoản
4. Truy cập ZimaOS qua IP Tailscale (100.x.x.x)

**Ưu điểm:**
- Mã hóa end-to-end (WireGuard)
- Kết nối peer-to-peer trực tiếp (không qua relay nếu có thể)
- Không cần mở port trên router
- Hoạt động xuyên NAT

### 6.3 Cloudflare Tunnels (Zero-Trust)

[Cloudflare Tunnels](https://www.cloudflare.com/products/tunnel/) tạo tunnel bảo mật từ ZimaOS ra Cloudflare network.

**Cài đặt:**
1. Cần có tên miền (domain) trỏ về Cloudflare DNS
2. Tạo tunnel trong Cloudflare Zero Trust Dashboard
3. Cài `cloudflared` trên ZimaOS (Docker hoặc native)
4. Truy cập qua subdomain (ví dụ: `nas.yourdomain.com`)

**Ưu điểm:**
- Zero-Trust: không mở port, Cloudflare làm reverse proxy
- HTTPS tự động
- Có thể thêm authentication layer (Access policies)
- **Hạn chế:** Cần tên miền, cấu hình phức tạp hơn Tailscale

### 6.4 ZeroTier

[ZeroTier](https://www.zerotier.com/) — mesh VPN tương tự Tailscale.

**Cài đặt:**
1. Tạo network trên [my.zerotier.com](https://my.zerotier.com/)
2. Cài ZeroTier trên ZimaOS và các thiết bị client
3. Join cùng network ID
4. Truy cập qua IP ZeroTier

**So sánh Tailscale vs ZeroTier:** Tailscale dễ dùng hơn và có UI quản lý tốt hơn. ZeroTier linh hoạt hơn về cấu hình network.

### Bảng so sánh Remote Access

| Phương thức | Độ khó | Cần domain | Mở port | Mã hóa | Tốc độ |
|-------------|--------|------------|---------|--------|--------|
| **Zima Client** | Rất dễ | Không | Không | Có | Trung bình |
| **Tailscale** | Dễ | Không | Không | WireGuard | Nhanh (P2P) |
| **Cloudflare** | Trung bình | Có | Không | TLS | Nhanh |
| **ZeroTier** | Trung bình | Không | Không | Có | Nhanh (P2P) |

> **Khuyến nghị:** Dùng **Tailscale** cho hầu hết người dùng — cân bằng tốt giữa dễ dùng, bảo mật và tốc độ.

---

## 7. Samba — Chia sẻ file trên mạng LAN

### Tổng quan

ZimaOS tích hợp **Samba** cho chia sẻ file trên mạng LAN, tương thích với Windows, macOS và Linux.

### Cách thiết lập

1. Dashboard → **Files** → chọn thư mục muốn chia sẻ
2. Bật **Share via Samba**
3. Đặt tên share và quyền truy cập (read/write)

### Truy cập từ client

**Windows:**
- File Explorer → thanh địa chỉ → gõ `\\<ip-zima>` → nhập username/password

**macOS:**
- Finder → **Go → Connect to Server** → `smb://<ip-zima>` → nhập thông tin
- Hoặc: Time Machine backup qua Samba (xem Phase 04)

**Linux:**
- File manager → gõ `smb://<ip-zima>` hoặc mount bằng lệnh `mount -t cifs`

---

## 8. Media Server — Server phát media

### Jellyfin (Miễn phí, Mã nguồn mở — Khuyến nghị)

**Cài đặt:**
1. App Store → tìm **Jellyfin** → **Install**
2. Truy cập Jellyfin qua `http://<ip-zima>:8096`
3. Tạo tài khoản admin → thêm thư viện media (Movies, TV Shows, Music)
4. Jellyfin tự quét và lấy metadata (poster, synopsis, etc.)

**Hardware Transcoding (Chuyển mã phần cứng):**
- Nếu CPU hỗ trợ Intel Quick Sync hoặc có GPU:
  - Jellyfin Settings → **Playback → Transcoding**
  - Chọn **Hardware acceleration**: Intel QSV / VAAPI / NVENC
  - Giúp stream 4K mượt mà mà không gánh nặng CPU

### Plex (Freemium)

- Cài đặt tương tự qua App Store
- Plex Pass ($5/tháng hoặc $120 lifetime) mở khóa HW transcoding
- Hỗ trợ nhiều client apps (TV, mobile, web) hơn Jellyfin

### Immich — Thay thế Google Photos

- Backup ảnh/video từ điện thoại tự động
- Nhận diện khuôn mặt, tìm kiếm bằng AI (local, riêng tư)
- App mobile cho iOS/Android

---

## 9. OpenAPI — Tích hợp nâng cao

ZimaOS cung cấp **OpenAPI** cho phép:
- Tích hợp với các công cụ automation (n8n, Home Assistant, etc.)
- Xây dựng script tùy chỉnh để quản lý hệ thống
- Kết nối với dịch vụ bên ngoài

Tham khảo tài liệu API tại [Zimaspace Docs](https://www.zimaspace.com/docs/zimaos/).

---

## Tài liệu tham khảo

- [App Store Guide](https://shop.zimaspace.com/blogs/zima-campaign-hub/explore-power-zimaos-app-store)
- [Build Custom Apps](https://www.zimaspace.com/docs/zimaos/Build-Apps)
- [Hardware Transcoding Guide](https://shop.zimaspace.com/blogs/zima-campaign-hub/hardware-accelerated-streaming-plex-jellyfin-emby-zimaos)
- [Remote Access Guide](https://www.zimaspace.com/blog/access-jellyfin-and-more-remotely-using-tailscale-zerotier-or-cloudflare.html)
- [Zimaspace Docs](https://www.zimaspace.com/docs/zimaos/)
