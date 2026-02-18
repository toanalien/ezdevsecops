# Phase 01: Khái niệm & Kiến trúc ZimaOS

> **Ngôn ngữ:** Tiếng Việt | **Trạng thái:** Hoàn thành | **Phiên bản ZimaOS:** 1.3.x (02/2026)

---

## 1. ZimaOS là gì?

**ZimaOS** là hệ điều hành NAS mã nguồn mở, được thiết kế riêng cho phần cứng x86-64. Được phát triển bởi **IceWhaleTech** — cùng đội ngũ đứng sau [CasaOS](https://github.com/IceWhaleTech/CasaOS) — ZimaOS ra đời nhằm lấp đầy khoảng trống giữa sự phức tạp của TrueNAS và sự đơn giản nhưng hạn chế của CasaOS.

### Triết lý thiết kế

ZimaOS xây dựng trên 3 trụ cột:

| Trụ cột | Ý nghĩa |
|----------|----------|
| **Đơn giản hóa** | Giao diện web trực quan, cài ứng dụng 1 click, RAID setup 3 bước |
| **Tập trung** | Tối ưu cho NAS cá nhân, media server, Docker hosting — không cố gắng làm mọi thứ |
| **Mở** | Mã nguồn mở trên GitHub, cộng đồng đóng góp app, API mở cho tích hợp |

### Ai nên dùng ZimaOS?

- Người dùng cá nhân muốn xây **personal cloud** thay thế Google Drive/iCloud
- Người chơi **homelab** muốn hệ điều hành NAS dễ dùng hơn TrueNAS
- Người thích **self-hosted** apps (Jellyfin, Immich, Pi-hole) không muốn học Docker CLI
- Người dùng **ZimaCube/ZimaBoard** muốn hệ điều hành chính hãng tối ưu cho phần cứng

---

## 2. Kiến trúc hệ thống

ZimaOS được xây dựng theo kiến trúc phân lớp:

```
┌──────────────────────────────────────┐
│           Web UI (Dashboard)         │  ← Giao diện quản lý qua trình duyệt
├──────────────────────────────────────┤
│        App Store + ZVM (VMs)         │  ← 800+ ứng dụng Docker + máy ảo
├──────────────────────────────────────┤
│     Docker Engine + Compose          │  ← Container runtime
├──────────────────────────────────────┤
│    Storage (mdadm RAID + Samba)      │  ← Quản lý ổ cứng, RAID, chia sẻ file
├──────────────────────────────────────┤
│    Buildroot Linux (Base OS)         │  ← Hệ điều hành nền tối giản
├──────────────────────────────────────┤
│     Phần cứng x86-64 + UEFI         │  ← ZimaCube, ZimaBoard, hoặc PC thường
└──────────────────────────────────────┘
```

### Các lớp chi tiết

**Buildroot Linux (Lớp nền)**
- Sử dụng [Buildroot](https://buildroot.org/) — công cụ tạo distro Linux tối giản
- Chỉ bao gồm những thành phần cần thiết → boot nhanh, tài nguyên thấp
- OTA update tự động với khả năng rollback

**Docker Engine (Lớp ứng dụng)**
- Docker + Docker Compose là nền tảng chạy mọi ứng dụng
- Quản lý volume, port, network hoàn toàn qua giao diện web
- Người dùng không cần biết Docker CLI

**Storage (Lớp lưu trữ)**
- mdadm-based RAID: hỗ trợ RAID 0, 1, 5, 6, 10
- JBOD cho nhu cầu lưu trữ đơn giản
- Samba cho chia sẻ file trên LAN (tương thích Windows, macOS, Linux)

**ZVM (Máy ảo)**
- Hệ thống máy ảo nhẹ dựa trên QEMU
- Cài đặt Windows/Linux guest 1 click
- Phân bổ CPU, RAM, storage qua giao diện đồ họa

**Web UI (Giao diện)**
- Dashboard quản lý toàn bộ hệ thống qua trình duyệt
- Truy cập qua `http://<ip-address>` trên mạng LAN
- Responsive, hoạt động tốt trên cả mobile

---

## 3. Phần cứng tương thích

### Phần cứng chính hãng (Zima)

| Thiết bị | Đặc điểm nổi bật | Phù hợp cho |
|----------|------------------|--------------|
| **ZimaCube** | Intel i5, 4x SSD + 6x HDD, 10GbE, PCIe | NAS chuyên nghiệp, AI/LLM, media server |
| **ZimaBoard 2** | Dual 2.5GbE, PCIe slot, nhỏ gọn | Homelab nhỏ, file server, Docker host |
| **ZimaBlade** | Form factor rack, enterprise | Triển khai rack-mount |

### Phần cứng thông dụng (DIY)

ZimaOS chạy được trên mọi hệ thống x86-64 có UEFI:
- **Intel NUC** — gọn nhẹ, tiết kiệm điện
- **PC cũ** — tận dụng phần cứng có sẵn
- **Server mini** — HP MicroServer, Dell OptiPlex
- **Yêu cầu tối thiểu:** CPU x86-64, 4GB RAM, 25GB storage, UEFI boot

---

## 4. So sánh với các NAS OS khác

| Tiêu chí | ZimaOS | TrueNAS | UnRAID | OpenMediaVault | CasaOS |
|-----------|--------|---------|--------|----------------|--------|
| **Độ phức tạp** | Thấp | Cao | Trung bình | Thấp | Thấp |
| **RAID** | mdadm (0/1/5/6/10) | ZFS (đầy đủ) | Parity tùy chỉnh | mdadm/ZFS | Hạn chế |
| **Docker Apps** | 800+ (native) | Hạn chế | Mở rộng (plugins) | Tối thiểu | Có |
| **VM** | ZVM (nhẹ) | Bhyve | KVM | Không | Không |
| **Giao diện** | Hiện đại, đơn giản | Enterprise | Trực quan | Nhẹ | Tương tự ZimaOS |
| **Chi phí** | Miễn phí | Miễn phí | $59 (license) | Miễn phí | Miễn phí |
| **File system** | ext4 | ZFS | XFS/Btrfs | ext4/XFS/ZFS | ext4 |
| **Hardware** | x86-64 only | x86-64 | x86-64 | x86-64 + ARM | Đa nền tảng |
| **Cộng đồng** | Đang phát triển | Lớn, lâu đời | Lớn | Lớn | Trung bình |
| **Remote access** | Native + Tailscale | Không tích hợp | Không tích hợp | Không tích hợp | Hạn chế |

### Phân tích chi tiết từng đối thủ

**TrueNAS (Scale/Core)**
- **Điểm mạnh:** ZFS enterprise-grade, snapshot, replication, plugin jail
- **Điểm yếu:** Học curve cao, cần nhiều RAM cho ZFS (tối thiểu 8-16GB), cấu hình phức tạp
- **Chọn khi:** Cần ZFS, workload enterprise, dữ liệu quan trọng cần data integrity tuyệt đối

**UnRAID**
- **Điểm mạnh:** Hệ thống parity linh hoạt (thêm ổ bất kỳ kích thước), plugin ecosystem lớn, community Docker templates
- **Điểm yếu:** Tốn $59 license, không có RAID truyền thống, boot từ USB bắt buộc
- **Chọn khi:** Muốn linh hoạt về ổ cứng, media server cao cấp, sẵn sàng trả phí

**OpenMediaVault (OMV)**
- **Điểm mạnh:** Siêu nhẹ, chạy trên Raspberry Pi, dựa trên Debian nên mở rộng dễ
- **Điểm yếu:** Docker support tối thiểu, UI cơ bản, ít app tích hợp
- **Chọn khi:** Hardware yếu (RPi, Atom), chỉ cần NAS đơn thuần, quen Debian

**CasaOS**
- **Điểm mạnh:** Cài trên bất kỳ Linux nào, đa nền tảng (ARM + x86), community apps
- **Điểm yếu:** Không có RAID management, không có VM, là "layer" chứ không phải OS đầy đủ
- **Chọn khi:** Muốn thêm NAS UI vào server Linux có sẵn, dùng Raspberry Pi

---

## 5. Khi nào nên chọn ZimaOS?

### ✅ Nên chọn ZimaOS khi:

- **Xây personal cloud** — thay thế Google Drive, iCloud bằng lưu trữ tại nhà
- **Làm media server** — Jellyfin/Plex với transcoding phần cứng, quản lý ảnh Immich
- **Chạy Docker apps** — muốn 800+ apps cài 1 click, không cần biết Docker CLI
- **DIY NAS x86-64** — có PC cũ hoặc Intel NUC, muốn NAS OS dễ dùng
- **Muốn mã nguồn mở** — không muốn phụ thuộc vào Synology/QNAP proprietary
- **Homelab nhẹ** — Docker containers + VM nhẹ, không cần Proxmox phức tạp
- **Truy cập từ xa** — Tailscale/Cloudflare Tunnels tích hợp sẵn, không cần port forwarding

### ❌ Không nên chọn ZimaOS khi:

- **Cần ZFS** → Chọn **TrueNAS** (data integrity enterprise-grade)
- **Cần plugin ecosystem lớn** → Chọn **UnRAID** (community templates phong phú)
- **Hardware yếu (RPi/Atom)** → Chọn **OpenMediaVault** (siêu nhẹ, hỗ trợ ARM)
- **Chỉ cần NAS layer trên Linux có sẵn** → Chọn **CasaOS** (cài lên bất kỳ distro nào)
- **Enterprise/production** → Chọn **TrueNAS** hoặc **Synology** (support chuyên nghiệp)
- **Cần chạy trên ARM** → ZimaOS chỉ hỗ trợ x86-64

---

## 6. Lộ trình phát triển & Tương lai

- **Cập nhật OTA** tự động với rollback — không cần cài lại
- **Mã nguồn mở** trên GitHub — cộng đồng đóng góp tích cực
- **IceWhaleTech** tiếp tục phát triển phần cứng Zima + phần mềm song song
- **Hệ sinh thái app** đang mở rộng nhanh (800+ apps tính đến 2026)
- **Quan hệ CasaOS:** ZimaOS là bước tiến hóa từ CasaOS, hai dự án vẫn song hành

---

## Tài liệu tham khảo

- [ZimaOS Official](https://www.zimaspace.com/zimaos)
- [GitHub - IceWhaleTech/ZimaOS](https://github.com/IceWhaleTech/ZimaOS)
- [Zimaspace Docs](https://www.zimaspace.com/docs/zimaos/)
- [CasaOS vs ZimaOS](https://www.zimaspace.com/blog/casaos-vs-zimaos-which-one-will-be-your-choice.html)
- [ZimaOS vs Synology DSM](https://www.zimaspace.com/blog/zimaos-vs-synology-dsm-nas-os-comparison.html)
- [ZimaCube Review (ItsFoss)](https://itsfoss.com/zimacube-review/)
