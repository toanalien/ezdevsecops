# Phase 05: Cộng đồng & Tài nguyên ZimaOS

> **Ngôn ngữ:** Tiếng Việt | **Trạng thái:** Hoàn thành | **Phiên bản ZimaOS:** 1.3.x (02/2026)

---

## 1. Kênh chính thức

### GitHub Repository

- **URL:** [github.com/IceWhaleTech/ZimaOS](https://github.com/IceWhaleTech/ZimaOS)
- **Nội dung:** Mã nguồn, issue tracker, release notes
- **Dùng khi:** Báo lỗi, theo dõi phiên bản mới, đọc changelog
- **Lưu ý:** Star repo để nhận thông báo release

### Tài liệu chính thức (Docs)

- **URL:** [zimaspace.com/docs/zimaos](https://www.zimaspace.com/docs/zimaos/)
- **Nội dung:** Hướng dẫn cài đặt, cấu hình tính năng, API reference, Build Apps guide
- **Dùng khi:** Cần hướng dẫn chính xác, reference kỹ thuật

### Diễn đàn cộng đồng (Forum)

- **URL:** [community.zimaspace.com](https://community.zimaspace.com/c/zimaos/)
- **Nội dung:** Hỏi đáp, chia sẻ kinh nghiệm, thảo luận tính năng
- **Dùng khi:** Cần hỗ trợ từ cộng đồng, chia sẻ setup, yêu cầu tính năng
- **Ngôn ngữ:** Chủ yếu tiếng Anh

### Blog Zimaspace

- **URL:** [zimaspace.com/blog](https://www.zimaspace.com/blog)
- **Nội dung:** Tutorials, so sánh sản phẩm, hardware guides, tips & tricks
- **Bài viết nổi bật:**
  - [CasaOS vs ZimaOS](https://www.zimaspace.com/blog/casaos-vs-zimaos-which-one-will-be-your-choice.html)
  - [ZimaOS vs Synology DSM](https://www.zimaspace.com/blog/zimaos-vs-synology-dsm-nas-os-comparison.html)
  - [Remote Access Guide](https://www.zimaspace.com/blog/access-jellyfin-and-more-remotely-using-tailscale-zerotier-or-cloudflare.html)

---

## 2. Tài nguyên bên thứ 3

### YouTube

| Kênh | Nội dung | Link |
|------|---------|------|
| **Zimaspace Official** | Unboxing, tutorials, feature demos | Tìm "Zimaspace" trên YouTube |
| **ItsFoss** | Review ZimaCube, so sánh NAS OS | [itsfoss.com](https://itsfoss.com/zimacube-review/) |
| **Techno Tim** | Homelab tutorials, self-hosting | Tìm "ZimaOS" hoặc "CasaOS" |
| **Jeff Geerling** | Hardware reviews, SBC testing | Có review ZimaBoard |
| **NetworkChuck** | Networking, Docker, self-hosting | Tutorials liên quan |

### Reddit

- **r/homelab** — Thảo luận homelab, có posts về ZimaOS
- **r/selfhosted** — Cộng đồng self-hosting lớn nhất, so sánh NAS OS
- **r/DataHoarder** — Storage, backup, RAID discussions
- Tìm: "ZimaOS" hoặc "ZimaCube" trên Reddit

### Tech Review Sites

- [ItsFoss - ZimaCube Review](https://itsfoss.com/zimacube-review/) — Review chi tiết ZimaCube + ZimaOS
- [NASCompares](https://nascompares.com/) — So sánh NAS hardware & software
- [ServeTheHome](https://www.servethehome.com/) — Review server hardware

---

## 3. Cách nhận hỗ trợ

### Khi gặp vấn đề kỹ thuật

**Bước 1: Kiểm tra tài liệu**
- Đọc [docs chính thức](https://www.zimaspace.com/docs/zimaos/) trước
- Tìm trong FAQ và troubleshooting sections

**Bước 2: Tìm trên Forum**
- Vào [community.zimaspace.com](https://community.zimaspace.com/c/zimaos/)
- Search vấn đề — có thể đã được giải đáp

**Bước 3: Đặt câu hỏi trên Forum**
- Mô tả rõ: phiên bản ZimaOS, phần cứng, triệu chứng, bước tái tạo
- Đính kèm log nếu có (Dashboard → Settings → Logs)
- **Không bao giờ** đăng mật khẩu, API key, hoặc thông tin mạng nhạy cảm

**Bước 4: Báo lỗi trên GitHub**
- Nếu xác định là bug → tạo Issue trên [GitHub](https://github.com/IceWhaleTech/ZimaOS/issues)
- Dùng template issue có sẵn
- Cung cấp: phiên bản, phần cứng, steps to reproduce, logs

### Khi cần tư vấn chọn phần cứng

- Forum Zimaspace → mục Hardware
- r/homelab trên Reddit
- Blog Zimaspace có nhiều bài so sánh phần cứng

---

## 4. Đóng góp cho dự án

### Đóng góp App

- Tạo Docker app template theo [Build Apps Guide](https://www.zimaspace.com/docs/zimaos/Build-Apps)
- Submit lên App Store cộng đồng
- Chia sẻ Docker Compose configs trên Forum

### Báo lỗi & Đề xuất tính năng

- **Bug reports:** GitHub Issues với chi tiết đầy đủ
- **Feature requests:** GitHub Issues hoặc Forum → mục Feature Requests
- **Feedback:** Forum → General Discussion

### Đóng góp tài liệu

- Docs trên GitHub — có thể submit pull requests
- Viết tutorials trên Blog cá nhân/Medium
- Chia sẻ trải nghiệm trên Forum

### Đóng góp mã nguồn

- Fork repo trên GitHub
- Đọc contributing guidelines
- Submit pull request với description rõ ràng
- Tuân thủ coding standards của dự án

---

## 5. Lộ trình học ZimaOS

### Cấp độ 1: Người mới (1-2 ngày)

| Bước | Nội dung | Tham khảo |
|------|---------|-----------|
| 1 | Hiểu ZimaOS là gì, so sánh với alternatives | Phase 01 |
| 2 | Cài đặt ZimaOS lên phần cứng | Phase 02 |
| 3 | Thiết lập lần đầu, tạo tài khoản | Phase 02 |
| 4 | Cài 1-2 app từ App Store (Files, Jellyfin) | Phase 03 |
| 5 | Thiết lập Samba chia sẻ file trên LAN | Phase 03 |

### Cấp độ 2: Trung bình (1 tuần)

| Bước | Nội dung | Tham khảo |
|------|---------|-----------|
| 1 | Cấu hình RAID cho storage | Phase 03 |
| 2 | Thiết lập remote access (Tailscale) | Phase 03 |
| 3 | Triển khai media server (Jellyfin + transcoding) | Phase 04 |
| 4 | Cài Pi-hole chặn quảng cáo | Phase 04 |
| 5 | Thiết lập backup (Time Machine, Syncthing) | Phase 04 |
| 6 | Thêm third-party app stores | Phase 03 |

### Cấp độ 3: Nâng cao (2-4 tuần)

| Bước | Nội dung | Tham khảo |
|------|---------|-----------|
| 1 | Deploy custom Docker containers | Phase 03 |
| 2 | Tạo VM trong ZVM | Phase 03 |
| 3 | Setup Home Assistant + IoT | Phase 04 |
| 4 | Chạy AI/LLM local (Ollama) | Phase 04 |
| 5 | Cấu hình Cloudflare Tunnels | Phase 03 |
| 6 | Xây dựng custom app cho ZimaOS | [Build Apps Guide](https://www.zimaspace.com/docs/zimaos/Build-Apps) |
| 7 | Đóng góp cho cộng đồng | Phase 05 |

---

## 6. Dự án liên quan

### CasaOS

- **URL:** [github.com/IceWhaleTech/CasaOS](https://github.com/IceWhaleTech/CasaOS)
- **Quan hệ:** ZimaOS tiến hóa từ CasaOS. CasaOS là NAS layer cài trên bất kỳ Linux nào; ZimaOS là OS đầy đủ
- **Chọn CasaOS khi:** Đã có Linux server, muốn thêm NAS UI, dùng ARM (Raspberry Pi)
- **Chọn ZimaOS khi:** Muốn OS chuyên dụng, x86-64, RAID management, VMs

### IceWhaleTech Ecosystem

- **ZimaCube** — NAS hardware chính hãng
- **ZimaBoard 2** — SBC (Single Board Computer) cho NAS nhẹ
- **ZimaBlade** — Rack-mount server
- **Zima Client** — App truy cập remote

### Công cụ bổ sung phổ biến

| Công cụ | Mục đích | URL |
|---------|---------|-----|
| **Tailscale** | VPN mesh network | [tailscale.com](https://tailscale.com/) |
| **Cloudflare Tunnels** | Zero-Trust remote access | [cloudflare.com](https://www.cloudflare.com/products/tunnel/) |
| **Home Assistant** | Smart home platform | [home-assistant.io](https://www.home-assistant.io/) |
| **Jellyfin** | Media server | [jellyfin.org](https://jellyfin.org/) |
| **Immich** | Photo management | [immich.app](https://immich.app/) |
| **Ollama** | Local LLM runtime | [ollama.com](https://ollama.com/) |

---

## 7. Cập nhật & Theo dõi

### Nhận thông báo phiên bản mới

- **GitHub Watch:** Star + Watch repo [IceWhaleTech/ZimaOS](https://github.com/IceWhaleTech/ZimaOS) → nhận email khi có release
- **RSS Feed:** Dùng RSS reader theo dõi GitHub releases feed
- **Forum:** Subscribe mục Announcements trên [community.zimaspace.com](https://community.zimaspace.com/)
- **ZimaOS Dashboard:** Settings → System Update tự kiểm tra và thông báo

### Kiểm tra cập nhật định kỳ

- **Hàng tuần:** Kiểm tra app updates trong App Store
- **Hàng tháng:** Kiểm tra system updates
- **Hàng quý:** Review setup, dọn dẹp containers không dùng, kiểm tra RAID health

---

## Tài liệu tham khảo

- [GitHub - IceWhaleTech/ZimaOS](https://github.com/IceWhaleTech/ZimaOS)
- [Zimaspace Docs](https://www.zimaspace.com/docs/zimaos/)
- [Community Forum](https://community.zimaspace.com/c/zimaos/)
- [Zimaspace Blog](https://www.zimaspace.com/blog)
- [CasaOS GitHub](https://github.com/IceWhaleTech/CasaOS)
- [Build Apps Guide](https://www.zimaspace.com/docs/zimaos/Build-Apps)

---

> **Ngày xác minh link:** 02/2026. Các link có thể thay đổi theo thời gian — kiểm tra lại nếu gặp lỗi 404.
