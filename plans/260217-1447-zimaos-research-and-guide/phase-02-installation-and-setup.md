# Phase 02: Cài đặt & Thiết lập ZimaOS

> **Ngôn ngữ:** Tiếng Việt | **Trạng thái:** Hoàn thành | **Phiên bản ZimaOS:** 1.3.x (02/2026)

---

## 1. Yêu cầu hệ thống

### Phần cứng tối thiểu

| Thành phần | Yêu cầu tối thiểu | Khuyến nghị |
|------------|-------------------|-------------|
| **CPU** | x86-64 (Intel/AMD) | Intel i3 trở lên hoặc tương đương |
| **RAM** | 4GB | 8GB+ (nếu chạy nhiều Docker apps) |
| **Ổ cứng** | 25GB (hệ thống) | SSD 128GB+ (hệ thống) + HDD cho dữ liệu |
| **USB** | 4GB+ (để flash bộ cài) | USB 3.0 cho tốc độ flash nhanh hơn |
| **BIOS** | UEFI boot | — |
| **Mạng** | Ethernet (khuyến nghị) | Gigabit Ethernet |

### Yêu cầu BIOS

- **UEFI boot**: Bật (ZimaOS không hỗ trợ Legacy/CSM boot)
- **Secure Boot**: Tắt (bắt buộc)
- **Boot order**: USB trước ổ cứng nội bộ

> **Lưu ý bảo mật:** Việc tắt Secure Boot có nghĩa hệ thống không xác minh chữ ký boot loader. Đây là yêu cầu kỹ thuật của ZimaOS, không phải lỗ hổng bảo mật nghiêm trọng trong môi trường homelab.

---

## 2. Tải ZimaOS

### Nguồn tải chính thức

| Nguồn | URL | Ghi chú |
|-------|-----|---------|
| **Trang chủ** | [zimaspace.com/zimaos/download](https://www.zimaspace.com/zimaos/download) | Khuyến nghị, luôn phiên bản ổn định mới nhất |
| **GitHub Releases** | [github.com/IceWhaleTech/ZimaOS/releases](https://github.com/IceWhaleTech/ZimaOS/releases) | Có cả bản stable và pre-release |

### Chọn phiên bản

- **Stable (Ổn định):** Dùng cho sử dụng hàng ngày — tải từ trang chủ
- **Pre-release:** Dùng để thử tính năng mới — tải từ GitHub, có thể không ổn định

File tải về có định dạng `.img` (hoặc `.img.gz` nén), kích thước khoảng 1-2GB.

---

## 3. Tạo USB cài đặt

### Công cụ flash: Balena Etcher

[Balena Etcher](https://etcher.balena.io/) là công cụ được khuyến nghị chính thức, hoạt động trên Windows, macOS và Linux.

### Các bước thực hiện

**Bước 1: Tải và cài Balena Etcher**
- Truy cập [etcher.balena.io](https://etcher.balena.io/)
- Tải phiên bản phù hợp với hệ điều hành đang dùng
- Cài đặt và mở ứng dụng

**Bước 2: Flash file ZimaOS vào USB**
1. Cắm USB vào máy tính (dữ liệu trên USB sẽ bị xóa)
2. Mở Balena Etcher
3. Click **"Flash from file"** → chọn file `.img` hoặc `.img.gz` đã tải
4. Click **"Select target"** → chọn USB drive (kiểm tra kỹ để không chọn nhầm ổ)
5. Click **"Flash!"** → đợi quá trình flash hoàn tất (3-10 phút tùy tốc độ USB)
6. Etcher tự động verify sau khi flash — đợi verify xong mới rút USB

> **Công cụ thay thế:** Rufus (Windows), `dd` command (Linux/macOS) — nhưng Balena Etcher an toàn và dễ dùng nhất.

---

## 4. Cấu hình BIOS/UEFI

Trước khi boot từ USB, cần cấu hình BIOS. Cách vào BIOS tùy theo hãng:

| Hãng máy | Phím vào BIOS | Phím Boot Menu |
|-----------|---------------|----------------|
| **Dell** | F2 | F12 |
| **HP** | F10 | F9 |
| **Lenovo** | F1 / F2 | F12 |
| **ASUS** | Del / F2 | F8 |
| **Intel NUC** | F2 | F10 |
| **ZimaCube/Board** | Del / F2 | F7 / F11 |

### Các thiết lập cần kiểm tra

1. **Boot Mode:** Đặt thành **UEFI** (không phải Legacy/CSM)
2. **Secure Boot:** Chuyển sang **Disabled**
3. **Boot Order:** Đưa **USB** lên đầu danh sách boot
4. **Save & Exit:** Lưu cấu hình và khởi động lại

---

## 5. Cài đặt ZimaOS

### Quy trình cài đặt

**Bước 1: Boot từ USB**
- Cắm USB đã flash vào máy đích
- Khởi động máy → vào Boot Menu (xem bảng phím ở trên) → chọn USB
- Hoặc: đã đặt USB first trong BIOS → máy tự boot từ USB

**Bước 2: Installer tự động**
- ZimaOS installer sẽ tự chạy sau khi boot
- Chọn ổ cứng đích để cài đặt (⚠️ dữ liệu trên ổ này sẽ bị xóa)
- Xác nhận và đợi quá trình cài đặt (5-15 phút)

**Bước 3: Khởi động lại**
- Sau khi cài xong, rút USB
- Máy tự khởi động vào ZimaOS

> **Lưu ý:** Ổ cứng dùng cài hệ thống (25GB+) nên là SSD để đảm bảo hiệu suất. Các ổ HDD dữ liệu sẽ được cấu hình RAID/JBOD sau.

---

## 6. Thiết lập lần đầu

### Truy cập Dashboard

Sau khi ZimaOS boot thành công:

1. **Kết nối mạng:** Máy ZimaOS cần kết nối cùng mạng LAN với máy tính bạn dùng
2. **Tìm địa chỉ IP:**
   - Nếu có màn hình gắn vào máy ZimaOS → IP hiện trên màn hình
   - Hoặc kiểm tra trong router (danh sách DHCP clients)
   - Hoặc dùng app [Zima Client](https://www.zimaspace.com/zimaos/download) để tự tìm
3. **Mở trình duyệt:** Truy cập `http://<ip-address>` (ví dụ: `http://192.168.1.100`)

### Tạo tài khoản quản trị

- Dashboard yêu cầu tạo tài khoản admin ở lần truy cập đầu tiên
- **Đặt mật khẩu mạnh** — đây là tài khoản admin duy nhất

### Cấu hình mạng

- Kiểm tra kết nối mạng trong Settings
- Đặt IP tĩnh nếu muốn (khuyến nghị cho NAS để IP không đổi sau khi restart router)
- Hostname: đặt tên dễ nhớ (ví dụ: `zima-nas`)

---

## 7. Sau cài đặt

### Cập nhật hệ thống

- Vào **Settings → System Update** để kiểm tra phiên bản mới
- ZimaOS hỗ trợ **OTA update** — cập nhật trực tiếp không cần cài lại
- Có khả năng **rollback** nếu bản cập nhật gặp lỗi

### Cấu hình lưu trữ

- Vào **Storage** để xem các ổ cứng được nhận diện
- Tạo RAID array nếu có nhiều ổ (xem Phase 03 để chọn RAID level phù hợp)
- Hoặc chọn JBOD cho lưu trữ đơn giản

### Cài ứng dụng đầu tiên

- Vào **App Store** → duyệt danh mục
- Khuyến nghị cài đầu tiên:
  - **Files** — quản lý file qua web
  - **Jellyfin** hoặc **Plex** — nếu làm media server
  - **Immich** — nếu muốn backup ảnh từ điện thoại

### Thiết lập remote access (tùy chọn)

- **Zima Client:** Cài app trên máy tính/điện thoại để truy cập từ xa qua mạng Zima
- **Tailscale:** VPN mesh network miễn phí cho cá nhân (xem Phase 03)
- **Cloudflare Tunnels:** Zero-Trust, không cần mở port (xem Phase 03)

---

## 8. Xử lý sự cố thường gặp

### Không boot được từ USB

| Triệu chứng | Nguyên nhân | Giải pháp |
|-------------|-------------|-----------|
| Máy boot thẳng vào Windows/OS cũ | Boot order sai | Vào BIOS → đặt USB first |
| Màn hình đen sau khi chọn USB | Secure Boot đang bật | Vào BIOS → tắt Secure Boot |
| USB không xuất hiện trong Boot Menu | Flash lỗi hoặc USB hỏng | Flash lại bằng Balena Etcher, thử USB khác |
| "No bootable device" | UEFI không bật | Vào BIOS → chuyển sang UEFI mode |

### Không truy cập được Dashboard

| Triệu chứng | Nguyên nhân | Giải pháp |
|-------------|-------------|-----------|
| Trình duyệt báo "connection refused" | ZimaOS chưa boot xong | Đợi 2-3 phút sau khi khởi động |
| Không tìm được IP | DHCP không cấp IP | Kiểm tra cáp mạng, thử cổng mạng khác |
| IP đúng nhưng không load | Firewall trên máy client | Tạm tắt firewall hoặc cho phép HTTP |

### Ổ cứng không được nhận diện

- Kiểm tra kết nối SATA/NVMe
- Một số HDD cũ cần format trước — vào Storage → chọn ổ → Format
- ZimaOS hỗ trợ ổ SATA, NVMe, USB external

---

## Tài liệu tham khảo

- [Hướng dẫn cài đặt chính thức](https://www.zimaspace.com/docs/zimaos/how-to-install-zimaos)
- [ZimaOS Download](https://www.zimaspace.com/zimaos/download)
- [GitHub Releases](https://github.com/IceWhaleTech/ZimaOS/releases)
- [Balena Etcher](https://etcher.balena.io/)
- [Zimaspace Docs](https://www.zimaspace.com/docs/zimaos/)
