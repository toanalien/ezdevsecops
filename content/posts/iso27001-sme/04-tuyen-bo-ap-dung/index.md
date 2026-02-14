---
title: "ISO 27001 cho SME Phần 4: Xây dựng Tuyên bố Áp dụng (Statement of Applicability)"
date: 2026-02-14
draft: false
description: "Hướng dẫn tạo Tuyên bố Áp dụng (SoA) theo ISO 27001:2022 - cách chọn kiểm soát Annex A phù hợp cho SME, template và ví dụ thực tế"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "soa", "annex-a", "controls", "statement-of-applicability", "clause-6"]
series: ["ISO 27001 cho SME"]
weight: 4
mermaid: true
---

## Giới thiệu

Sau khi hoàn thành đánh giá rủi ro trong [Phần 3](/posts/iso27001-sme/03-danh-gia-rui-ro/), bước tiếp theo là tạo **Tuyên bố Áp dụng** (Statement of Applicability - SoA). Nếu đánh giá rủi ro là bản đồ cho thấy những mối nguy hiểm, thì SoA là kế hoạch hành động cụ thể để đối phó với chúng.

SoA là tài liệu trung tâm của ISMS, kết nối kết quả đánh giá rủi ro với 93 kiểm soát trong Annex A của ISO 27001:2022. Đây là tài liệu đầu tiên mà auditor sẽ kiểm tra khi đánh giá hệ thống ISMS của bạn.

{{< callout type="info" >}}
**Thông tin**: SoA là tài liệu quan trọng nhất của ISMS - auditor sẽ xem xét nó đầu tiên để hiểu phạm vi và cách bạn xử lý rủi ro bảo mật thông tin.
{{< /callout >}}

### Sau bài viết này, bạn sẽ có thể:

- ✅ Hiểu SoA là gì và vai trò của nó trong ISMS
- ✅ Nắm được cấu trúc và nội dung của SoA
- ✅ Phân loại 93 kiểm soát Annex A theo 4 nhóm
- ✅ Xác định kiểm soát ưu tiên cho SME
- ✅ Tạo SoA hoàn chỉnh cho tổ chức của bạn

---

## SoA là gì và tại sao quan trọng?

**Statement of Applicability (SoA)** - Tuyên bố Áp dụng - là tài liệu bắt buộc theo Clause 6.1.3 của ISO 27001:2022. SoA liệt kê tất cả 93 kiểm soát trong Annex A và cho biết:

- Kiểm soát nào **áp dụng** cho tổ chức của bạn
- Kiểm soát nào **không áp dụng** và lý do tại sao
- Trạng thái triển khai của mỗi kiểm soát
- Người chịu trách nhiệm cho từng kiểm soát

### Mục đích của SoA

1. **Liên kết rủi ro với kiểm soát**: Mỗi kiểm soát được chọn phải dựa trên kết quả đánh giá rủi ro
2. **Minh bạch với auditor**: Cho thấy bạn đã xem xét đầy đủ các kiểm soát
3. **Công cụ quản lý**: Theo dõi tiến độ triển khai ISMS
4. **Cơ sở cho audit**: Auditor sẽ kiểm tra evidence cho các kiểm soát bạn đánh dấu "Áp dụng"

### Auditor tìm gì trong SoA?

- ✓ Tất cả 93 kiểm soát đều được xem xét (không bỏ sót)
- ✓ Lý do hợp lý cho các kiểm soát không áp dụng
- ✓ Sự liên kết rõ ràng giữa rủi ro và kiểm soát được chọn
- ✓ Evidence cho các kiểm soát đã triển khai

{{< mermaid >}}
graph TB
    subgraph Input["Đầu vào"]
        RA[Đánh giá Rủi ro<br/>Phần 3]
        CTX[Ngữ cảnh Tổ chức<br/>Phần 1]
        SCOPE[Phạm vi ISMS<br/>Phần 2]
    end

    subgraph SoA_Process["Quy trình tạo SoA"]
        REVIEW[Xem xét 93<br/>kiểm soát Annex A]
        MAP[Ánh xạ kiểm soát<br/>với rủi ro]
        JUSTIFY[Biện minh<br/>áp dụng/không áp dụng]
        ASSIGN[Gán người<br/>chịu trách nhiệm]
        STATUS[Cập nhật<br/>trạng thái triển khai]
    end

    subgraph Output["Đầu ra"]
        SOA[Statement of<br/>Applicability]
        PLAN[Kế hoạch<br/>triển khai kiểm soát]
    end

    subgraph Next["Bước tiếp theo"]
        POL[Xây dựng<br/>chính sách<br/>Phần 5]
        IMPL[Triển khai<br/>kiểm soát<br/>Phần 6]
    end

    RA --> REVIEW
    CTX --> REVIEW
    SCOPE --> REVIEW

    REVIEW --> MAP
    MAP --> JUSTIFY
    JUSTIFY --> ASSIGN
    ASSIGN --> STATUS

    STATUS --> SOA
    STATUS --> PLAN

    SOA --> POL
    PLAN --> IMPL

    style SOA fill:#e1f5dd
    style REVIEW fill:#fff4e6
    style MAP fill:#fff4e6
{{< /mermaid >}}

---

## Cấu trúc SoA

SoA thường được tạo dưới dạng bảng Excel hoặc Google Sheets với các cột sau:

| Cột | Mô tả | Bắt buộc? |
|-----|-------|-----------|
| **Control ID** | Mã kiểm soát (A.5.1, A.8.5, v.v.) | ✓ |
| **Control Name** | Tên kiểm soát bằng tiếng Việt/Anh | ✓ |
| **Applicable?** | Có/Không | ✓ |
| **Justification** | Lý do áp dụng hoặc không áp dụng | ✓ |
| **Risk Reference** | Liên kết với rủi ro từ risk register | Khuyến nghị |
| **Owner** | Người chịu trách nhiệm triển khai | ✓ |
| **Status** | Not Started / In Progress / Implemented | ✓ |
| **Implementation Date** | Ngày triển khai xong | Khuyến nghị |
| **Last Review Date** | Ngày xem xét gần nhất | Khuyến nghị |
| **Notes** | Ghi chú bổ sung | Tùy chọn |

### Ví dụ template SoA (rút gọn)

| Control ID | Control Name | Applicable? | Justification | Owner | Status |
|------------|--------------|-------------|---------------|-------|--------|
| A.5.1 | Policies for information security | Yes | Required for ISMS baseline | CISO | Implemented |
| A.5.7 | Threat intelligence | Yes | Need to monitor emerging threats | IT Manager | In Progress |
| A.7.4 | Physical security monitoring | No | Office in shared co-working space, landlord manages CCTV | N/A | N/A |
| A.8.5 | Secure authentication | Yes | Protect against unauthorized access | IT Manager | Implemented |
| A.8.24 | Use of cryptography | Yes | Encrypt sensitive data in transit/at rest | DevOps Lead | In Progress |

{{< callout type="tip" >}}
**Mẹo**: Sử dụng Excel hoặc Google Sheets - không cần phần mềm đắt tiền. Nhiều tổ chức nhỏ quản lý SoA thành công bằng Google Sheets với version control.
{{< /callout >}}

---

## Tổng quan 93 kiểm soát Annex A

ISO 27001:2022 tổ chức 93 kiểm soát thành 4 nhóm chính:

### A.5: Kiểm soát Tổ chức (Organizational Controls) - 37 kiểm soát

Tập trung vào chính sách, quy trình, vai trò và quản lý tài sản.

| Control ID | Tên kiểm soát | Mô tả ngắn |
|------------|---------------|------------|
| A.5.1 | Policies for information security | Chính sách bảo mật thông tin cấp cao |
| A.5.2 | Information security roles & responsibilities | Phân công vai trò ISMS |
| A.5.7 | Threat intelligence | Thu thập thông tin về mối đe dọa mới |
| A.5.10 | Acceptable use of information & assets | Quy định sử dụng hợp lý tài sản CNTT |
| A.5.12 | Classification of information | Phân loại độ nhạy cảm thông tin |
| A.5.14 | Information transfer | Chuyển giao thông tin an toàn |
| A.5.15 | Access control | Chính sách kiểm soát truy cập |
| A.5.16 | Identity management | Quản lý danh tính người dùng |
| A.5.17 | Authentication information | Quản lý thông tin xác thực (mật khẩu, token) |
| A.5.18 | Access rights | Quản lý quyền truy cập |
| A.5.19 | Information security in supplier relationships | Bảo mật với nhà cung cấp/vendor |
| A.5.20 | Addressing security in supplier agreements | Điều khoản bảo mật trong hợp đồng |
| A.5.21 | Managing security in ICT supply chain | Quản lý chuỗi cung ứng CNTT |
| A.5.23 | Information security for cloud services | Bảo mật dịch vụ cloud **(Mới 2022)** |
| A.5.24 | Information security incident management planning | Kế hoạch xử lý sự cố bảo mật |
| A.5.25 | Assessment & decision on information security events | Đánh giá và phân loại sự cố |
| A.5.26 | Response to information security incidents | Ứng phó sự cố bảo mật |
| A.5.27 | Learning from incidents | Học hỏi từ sự cố |
| A.5.28 | Collection of evidence | Thu thập chứng cứ |
| A.5.29 | Information security during disruption | Bảo mật trong gián đoạn hoạt động |
| A.5.30 | ICT readiness for business continuity | Sẵn sàng CNTT cho liên tục kinh doanh |
| A.5.33 | Protection of records | Bảo vệ hồ sơ/bản ghi |
| A.5.34 | Privacy & protection of PII | Bảo vệ dữ liệu cá nhân **(Mới 2022)** |

*(Còn 14 kiểm soát khác trong A.5 - xem Annex A đầy đủ)*

### A.6: Kiểm soát Con người (People Controls) - 8 kiểm soát

Tập trung vào nhân sự: tuyển dụng, đào tạo, kỷ luật, offboarding.

| Control ID | Tên kiểm soát | Mô tả ngắn |
|------------|---------------|------------|
| A.6.1 | Screening | Sàng lọc ứng viên (background check) |
| A.6.2 | Terms & conditions of employment | Điều khoản bảo mật trong hợp đồng lao động |
| A.6.3 | Information security awareness, education & training | Đào tạo nhận thức bảo mật |
| A.6.4 | Disciplinary process | Quy trình kỷ luật vi phạm bảo mật |
| A.6.5 | Responsibilities after termination or change | Trách nhiệm khi nghỉ việc/chuyển vai trò |
| A.6.6 | Confidentiality or non-disclosure agreements | Thỏa thuận bảo mật (NDA) |
| A.6.7 | Remote working | Bảo mật làm việc từ xa **(Mới 2022)** |
| A.6.8 | Information security event reporting | Báo cáo sự cố bảo mật |

### A.7: Kiểm soát Vật lý (Physical Controls) - 14 kiểm soát

Tập trung vào bảo vệ cơ sở vật chất, thiết bị, phương tiện lưu trữ.

| Control ID | Tên kiểm soát | Mô tả ngắn |
|------------|---------------|------------|
| A.7.1 | Physical security perimeters | Ranh giới vật lý an toàn |
| A.7.2 | Physical entry | Kiểm soát ra vào vật lý |
| A.7.3 | Securing offices, rooms & facilities | Bảo vệ văn phòng, phòng máy |
| A.7.4 | Physical security monitoring | Giám sát vật lý (camera, cảm biến) |
| A.7.5 | Protecting against physical & environmental threats | Chống thiên tai, hỏa hoạn |
| A.7.6 | Working in secure areas | Làm việc trong khu vực bảo mật |
| A.7.7 | Clear desk & clear screen | Bàn làm việc và màn hình sạch |
| A.7.8 | Equipment siting & protection | Đặt và bảo vệ thiết bị |
| A.7.9 | Security of assets off-premises | Bảo mật tài sản ngoài văn phòng |
| A.7.10 | Storage media | Quản lý phương tiện lưu trữ (USB, HDD) |
| A.7.11 | Supporting utilities | Tiện ích hỗ trợ (điện, điều hòa) |
| A.7.12 | Cabling security | Bảo mật cáp mạng |
| A.7.13 | Equipment maintenance | Bảo trì thiết bị |
| A.7.14 | Secure disposal or re-use of equipment | Hủy bỏ hoặc tái sử dụng thiết bị an toàn |

### A.8: Kiểm soát Công nghệ (Technological Controls) - 34 kiểm soát

Nhóm lớn nhất, tập trung vào bảo mật kỹ thuật: truy cập, mã hóa, malware, backup, logging, v.v.

| Control ID | Tên kiểm soát | Mô tả ngắn |
|------------|---------------|------------|
| A.8.1 | User endpoint devices | Bảo mật thiết bị đầu cuối (laptop, điện thoại) |
| A.8.2 | Privileged access rights | Quản lý quyền truy cập đặc quyền |
| A.8.3 | Information access restriction | Hạn chế truy cập thông tin |
| A.8.4 | Access to source code | Kiểm soát truy cập mã nguồn |
| A.8.5 | Secure authentication | Xác thực an toàn (MFA) |
| A.8.6 | Capacity management | Quản lý dung lượng hệ thống |
| A.8.7 | Protection against malware | Chống phần mềm độc hại |
| A.8.8 | Management of technical vulnerabilities | Quản lý lỗ hổng kỹ thuật |
| A.8.9 | Configuration management | Quản lý cấu hình hệ thống |
| A.8.10 | Information deletion | Xóa thông tin an toàn |
| A.8.11 | Data masking | Che giấu dữ liệu nhạy cảm **(Mới 2022)** |
| A.8.12 | Data leakage prevention | Ngăn chặn rò rỉ dữ liệu **(Mới 2022)** |
| A.8.13 | Information backup | Sao lưu dữ liệu |
| A.8.14 | Redundancy of information processing facilities | Dự phòng hệ thống xử lý |
| A.8.15 | Logging | Ghi log hoạt động hệ thống |
| A.8.16 | Monitoring activities | Giám sát hoạt động |
| A.8.17 | Clock synchronization | Đồng bộ đồng hồ hệ thống |
| A.8.18 | Use of privileged utility programs | Sử dụng chương trình tiện ích đặc quyền |
| A.8.19 | Installation of software on operational systems | Cài đặt phần mềm trên hệ thống vận hành |
| A.8.20 | Networks security | Bảo mật mạng |
| A.8.21 | Security of network services | Bảo mật dịch vụ mạng |
| A.8.22 | Segregation of networks | Phân tách mạng |
| A.8.23 | Web filtering | Lọc web **(Mới 2022)** |
| A.8.24 | Use of cryptography | Sử dụng mã hóa |
| A.8.25 | Secure development lifecycle | Vòng đời phát triển an toàn **(Mới 2022)** |
| A.8.26 | Application security requirements | Yêu cầu bảo mật ứng dụng |
| A.8.27 | Secure system architecture & engineering | Kiến trúc hệ thống an toàn |
| A.8.28 | Secure coding | Lập trình an toàn **(Mới 2022)** |
| A.8.29 | Security testing in development & acceptance | Kiểm thử bảo mật |
| A.8.30 | Outsourced development | Phát triển thuê ngoài |
| A.8.31 | Separation of development, test & production | Tách môi trường dev/test/prod |
| A.8.32 | Change management | Quản lý thay đổi |
| A.8.33 | Test information | Quản lý dữ liệu test |
| A.8.34 | Protection of information systems during audit | Bảo vệ hệ thống trong audit |

{{< mermaid >}}
graph TB
    subgraph Annex_A["Annex A: 93 Kiểm soát"]
        A5[A.5 Organizational<br/>37 kiểm soát]
        A6[A.6 People<br/>8 kiểm soát]
        A7[A.7 Physical<br/>14 kiểm soát]
        A8[A.8 Technological<br/>34 kiểm soát]
    end

    subgraph A5_Sub["A.5 Chi tiết"]
        A5_POL[Chính sách & Vai trò<br/>A.5.1, A.5.2, A.5.3]
        A5_ASSET[Quản lý Tài sản<br/>A.5.9-A.5.14]
        A5_ACCESS[Kiểm soát Truy cập<br/>A.5.15-A.5.18]
        A5_VENDOR[Nhà cung cấp<br/>A.5.19-A.5.23]
        A5_INC[Sự cố & BCP<br/>A.5.24-A.5.30]
        A5_COMP[Tuân thủ<br/>A.5.31-A.5.37]
    end

    subgraph A6_Sub["A.6 Chi tiết"]
        A6_HIRE[Tuyển dụng<br/>A.6.1, A.6.2]
        A6_TRAIN[Đào tạo<br/>A.6.3]
        A6_EXIT[Nghỉ việc<br/>A.6.4, A.6.5]
        A6_OTHER[Khác<br/>A.6.6, A.6.7, A.6.8]
    end

    subgraph A7_Sub["A.7 Chi tiết"]
        A7_PERI[Ranh giới & Giám sát<br/>A.7.1-A.7.4]
        A7_ENV[Môi trường<br/>A.7.5, A.7.11]
        A7_WORK[Làm việc An toàn<br/>A.7.6, A.7.7]
        A7_EQUIP[Thiết bị<br/>A.7.8-A.7.14]
    end

    subgraph A8_Sub["A.8 Chi tiết"]
        A8_ACC[Truy cập & Xác thực<br/>A.8.1-A.8.5]
        A8_OPS[Vận hành Hệ thống<br/>A.8.6-A.8.14]
        A8_MON[Giám sát & Log<br/>A.8.15-A.8.19]
        A8_NET[Bảo mật Mạng<br/>A.8.20-A.8.24]
        A8_DEV[Phát triển An toàn<br/>A.8.25-A.8.34]
    end

    A5 --> A5_Sub
    A6 --> A6_Sub
    A7 --> A7_Sub
    A8 --> A8_Sub

    style A5 fill:#e3f2fd
    style A6 fill:#fff3e0
    style A7 fill:#f3e5f5
    style A8 fill:#e8f5e9
{{< /mermaid >}}

---

## Kiểm soát ưu tiên cho SME

Không cần triển khai cả 93 kiểm soát cùng lúc. Dưới đây là danh sách **20-25 kiểm soát quan trọng nhất** cho SME (công ty công nghệ 10-50 người):

### Nhóm Must-Have (Critical) - 12 kiểm soát

| Control ID | Tên kiểm soát | Tại sao quan trọng cho SME | Độ khó |
|------------|---------------|----------------------------|--------|
| **A.5.1** | Information security policies | Nền tảng ISMS, bắt buộc | Dễ |
| **A.5.15** | Access control policy | Chính sách kiểm soát truy cập cơ bản | Dễ |
| **A.5.24** | Incident management planning | Xử lý sự cố (ransomware, breach) | Trung bình |
| **A.6.3** | Security awareness training | Nhân viên = lớp phòng thủ đầu tiên | Dễ |
| **A.8.2** | Privileged access rights | Ngăn chặn lạm dụng quyền admin | Dễ |
| **A.8.5** | Secure authentication | MFA bắt buộc, chống chiếm tài khoản | Dễ |
| **A.8.7** | Protection against malware | Chống virus, ransomware | Dễ |
| **A.8.8** | Technical vulnerability management | Patch lỗ hổng, quét bảo mật | Trung bình |
| **A.8.13** | Information backup | Phục hồi sau sự cố, ransomware | Dễ |
| **A.8.15** | Logging | Audit trail, forensics | Trung bình |
| **A.8.16** | Monitoring activities | Phát hiện tấn công sớm | Trung bình |
| **A.8.24** | Use of cryptography | Mã hóa dữ liệu nhạy cảm | Trung bình |

### Nhóm Should-Have (Important) - 8 kiểm soát

| Control ID | Tên kiểm soát | Tại sao quan trọng cho SME | Độ khó |
|------------|---------------|----------------------------|--------|
| **A.5.7** | Threat intelligence | Cập nhật mối đe dọa mới | Dễ |
| **A.5.19** | Security in supplier relationships | Quản lý rủi ro vendor/cloud | Trung bình |
| **A.5.23** | Cloud services security | SME dùng nhiều SaaS/cloud | Trung bình |
| **A.5.30** | ICT readiness for business continuity | Disaster recovery, RTO/RPO | Khó |
| **A.6.1** | Screening | Background check nhân viên | Dễ |
| **A.6.7** | Remote working | Bảo mật WFH, VPN | Dễ |
| **A.8.20** | Networks security | Firewall, network segmentation | Trung bình |
| **A.8.28** | Secure coding | Tránh lỗi bảo mật trong code | Trung bình |

### Nhóm Nice-to-Have (Expand Later) - 5 kiểm soát

| Control ID | Tên kiểm soát | Khi nào cần | Độ khó |
|------------|---------------|-------------|--------|
| **A.8.11** | Data masking | Khi có dữ liệu sản xuất dùng để test | Trung bình |
| **A.8.12** | Data leakage prevention | Khi xử lý dữ liệu rất nhạy cảm (PII, tài chính) | Khó |
| **A.8.23** | Web filtering | Ngăn nhân viên truy cập web nguy hiểm | Dễ |
| **A.8.25** | Secure development lifecycle | Khi phát triển ứng dụng phức tạp | Khó |
| **A.8.31** | Separation dev/test/prod | Khi có nguồn lực triển khai CI/CD đầy đủ | Trung bình |

{{< callout type="warning" >}}
**Cảnh báo**: Không cần triển khai tất cả 93 kiểm soát cùng lúc - tập trung vào những gì quan trọng nhất với rủi ro của bạn. Ưu tiên 12 kiểm soát Must-Have trước, sau đó mở rộng theo phased approach.
{{< /callout >}}

---

## Cách điền SoA

### Quy trình 5 bước

**Bước 1: Xem xét từng kiểm soát**

Đọc kỹ mô tả của cả 93 kiểm soát trong Annex A. Tham khảo tài liệu ISO/IEC 27002:2022 để hiểu chi tiết.

**Bước 2: Xác định tính áp dụng**

Cho mỗi kiểm soát, hỏi:
- Rủi ro nào trong risk register liên quan đến kiểm soát này?
- Kiểm soát này có giảm thiểu rủi ro đó không?
- Có yêu cầu pháp lý/hợp đồng bắt buộc kiểm soát này không?
- Chi phí triển khai có hợp lý với giá trị bảo vệ không?

**Bước 3: Biện minh quyết định**

- **Nếu ÁP DỤNG**: Ghi rõ kiểm soát này giải quyết rủi ro nào (tham chiếu Risk ID)
- **Nếu KHÔNG ÁP DỤNG**: Ghi rõ lý do (ví dụ: không liên quan, đã có kiểm soát thay thế, chấp nhận rủi ro)

{{< callout type="tip" >}}
**Mẹo**: Với mọi kiểm soát "Không áp dụng", hãy giải thích rõ ràng tại sao - auditor sẽ hỏi. Lý do hợp lệ như "Công ty không có datacenter riêng, toàn bộ hạ tầng trên AWS" cho A.7.11 (Supporting utilities).
{{< /callout >}}

**Bước 4: Gán người chịu trách nhiệm**

Chỉ định owner cho mỗi kiểm soát áp dụng. Owner không cần triển khai tất cả, nhưng chịu trách nhiệm đảm bảo kiểm soát hoạt động.

**Bước 5: Cập nhật trạng thái**

Theo dõi tiến độ:
- **Not Started**: Chưa bắt đầu triển khai
- **In Progress**: Đang triển khai (X% hoàn thành)
- **Implemented**: Đã triển khai xong, có evidence
- **Under Review**: Đang xem xét lại do thay đổi rủi ro/ngữ cảnh

### Ví dụ chi tiết: 5 kiểm soát hoàn chỉnh

| Control ID | Control Name | Applicable? | Justification | Risk Ref | Owner | Status | Notes |
|------------|--------------|-------------|---------------|----------|-------|--------|-------|
| **A.5.7** | Threat intelligence | **Yes** | Cần giám sát các mối đe dọa mới nổi (ransomware variants, zero-days) để cập nhật phòng thủ. Liên kết với R-003 (Cyber attack). | R-003 | IT Manager | **Implemented** | Đăng ký OTX AlienVault + MITRE ATT&CK feeds. Review hàng tuần. |
| **A.7.4** | Physical security monitoring | **No** | Văn phòng thuê tại tòa nhà chung, chủ tòa nhà quản lý hệ thống camera giám sát toàn bộ. Công ty không kiểm soát được hạ tầng vật lý này. | N/A | N/A | N/A | Đã xác nhận với landlord có CCTV 24/7 và security guard. |
| **A.8.5** | Secure authentication | **Yes** | Bảo vệ tài khoản khỏi bị chiếm đoạt. Liên kết với R-007 (Unauthorized access). Áp dụng MFA cho tất cả tài khoản công ty (email, VPN, AWS, GitHub). | R-007 | IT Manager | **Implemented** | Google Workspace với 2FA bắt buộc. AWS MFA. GitHub 2FA. |
| **A.8.11** | Data masking | **No** | Hiện tại không sử dụng dữ liệu production cho môi trường test. Nếu trong tương lai cần, sẽ xem xét lại. Chấp nhận rủi ro ở mức thấp. | R-015 (accepted) | N/A | N/A | Sẽ review lại trong audit nội bộ 6 tháng tới. |
| **A.8.13** | Information backup | **Yes** | Đảm bảo phục hồi dữ liệu sau sự cố (ransomware, hardware failure). Liên kết với R-010 (Data loss). Áp dụng quy tắc 3-2-1. | R-010 | DevOps Lead | **Implemented** | Daily backup to S3, weekly to Glacier, monthly offsite tape. RPO: 24h, RTO: 4h. |

---

## Ví dụ SoA cho công ty phần mềm 25 người

**Ngữ cảnh:**
- Công ty: DevSecOps Solutions Vietnam
- Nhân sự: 25 người (15 devs, 5 ops, 3 sales, 2 admin)
- Hạ tầng: 100% trên AWS
- Sản phẩm: SaaS platform cho quản lý bảo mật
- Văn phòng: Thuê tại tòa nhà shared office

**Tổng kiểm soát:**
- **Áp dụng**: 32 kiểm soát
- **Không áp dụng**: 61 kiểm soát (với biện minh)

**Danh sách kiểm soát áp dụng (rút gọn):**

| Control ID | Control Name | Justification | Owner | Status |
|------------|--------------|---------------|-------|--------|
| A.5.1 | Information security policies | Nền tảng ISMS | CISO | Implemented |
| A.5.2 | Information security roles | Phân công trách nhiệm | CISO | Implemented |
| A.5.7 | Threat intelligence | Giám sát mối đe dọa mới | IT Mgr | Implemented |
| A.5.10 | Acceptable use of information | Quy định sử dụng tài sản CNTT | IT Mgr | Implemented |
| A.5.15 | Access control | Chính sách kiểm soát truy cập | IT Mgr | Implemented |
| A.5.19 | Security in supplier relationships | AWS, GitHub, Slack vendors | CISO | Implemented |
| A.5.23 | Cloud services security | 100% trên AWS | DevOps | In Progress |
| A.5.24 | Incident management planning | Xử lý sự cố bảo mật | IT Mgr | Implemented |
| A.5.30 | ICT readiness for business continuity | DR plan, RTO/RPO | DevOps | In Progress |
| A.6.1 | Screening | Background check nhân viên mới | HR | Implemented |
| A.6.3 | Security awareness training | Đào tạo hàng năm + onboarding | CISO | Implemented |
| A.6.7 | Remote working | 50% nhân viên WFH | IT Mgr | Implemented |
| A.7.7 | Clear desk and clear screen | Chính sách bàn làm việc sạch | IT Mgr | Implemented |
| A.7.10 | Storage media | Quản lý USB, external HDD | IT Mgr | Implemented |
| A.8.1 | User endpoint devices | MDM cho laptop công ty | IT Mgr | In Progress |
| A.8.2 | Privileged access rights | Least privilege, sudo audit | DevOps | Implemented |
| A.8.5 | Secure authentication | MFA cho tất cả hệ thống | IT Mgr | Implemented |
| A.8.7 | Protection against malware | Endpoint protection | IT Mgr | Implemented |
| A.8.8 | Technical vulnerability management | Quét bảo mật định kỳ | DevOps | Implemented |
| A.8.13 | Information backup | 3-2-1 backup rule | DevOps | Implemented |
| A.8.15 | Logging | Centralized logging (ELK) | DevOps | Implemented |
| A.8.16 | Monitoring activities | SIEM, alerting | DevOps | In Progress |
| A.8.20 | Networks security | AWS Security Groups, NACLs | DevOps | Implemented |
| A.8.24 | Use of cryptography | TLS 1.3, AES-256 encryption | DevOps | Implemented |
| A.8.28 | Secure coding | OWASP Top 10, code review | Dev Lead | In Progress |

**Ví dụ kiểm soát KHÔNG áp dụng (với biện minh):**

| Control ID | Control Name | Justification for Exclusion |
|------------|--------------|----------------------------|
| A.7.1 | Physical security perimeters | Văn phòng thuê, landlord quản lý ranh giới vật lý |
| A.7.4 | Physical security monitoring | Chủ tòa nhà có CCTV 24/7, không kiểm soát trực tiếp |
| A.7.11 | Supporting utilities | Không có datacenter riêng, 100% cloud AWS |
| A.8.11 | Data masking | Không sử dụng dữ liệu production cho test, risk accepted |
| A.8.12 | Data leakage prevention | Chưa có dữ liệu nhạy cảm mức độ cần DLP, sẽ review lại Q3 |

**Đặc thù Vietnam:**
- **Decree 13/2023/NĐ-CP**: Bảo vệ dữ liệu cá nhân → Tăng cường A.5.34 (Privacy & PII protection)
- **Circular 03/2017/TT-BTTTT**: Bảo mật website → A.8.20, A.8.24 bắt buộc cho website công ty

---

## Công cụ và Template

### Template miễn phí

1. **GitHub Toolkits**
   - [PeterGeelen/ISO27001-2022](https://github.com/PeterGeelen/ISO27001-2022) - Excel SoA template
   - [PehanIn/ISO27001-2022-toolkit](https://github.com/PehanIn/ISO27001-2022-toolkit) - Bộ toolkit đầy đủ

2. **Vendor Free Templates**
   - [Secureframe ISO 27001 Toolkit](https://secureframe.com/hub/iso-27001-templates) - 20+ templates
   - [ISEOBlue Lite](https://www.iseo.blue/lite) - Free tier với SoA generator
   - [DataGuard Free Resources](https://www.dataguard.co.uk/resources/iso-27001)

3. **AI-Powered Generators**
   - [ISMSpolicyGenerator.com](https://www.ismspolicygenerator.com) - Tạo SoA tự động từ risk profile

{{< callout type="info" >}}
**Thông tin**: Các toolkit GitHub ở trên là mã nguồn mở, có thể tùy chỉnh tự do. Tải về, điều chỉnh theo tổ chức của bạn, tiết kiệm hàng nghìn USD so với thuê consultant.
{{< /callout >}}

### Cách sử dụng template

1. **Download** Excel template từ GitHub hoặc Secureframe
2. **Customize** các cột theo nhu cầu (thêm Risk Reference, Evidence Link, v.v.)
3. **Translate** control names sang tiếng Việt nếu cần
4. **Populate** dựa trên risk assessment từ Phần 3
5. **Review** với management và key stakeholders
6. **Approve** chính thức bởi Top Management
7. **Version control** trên Google Drive hoặc SharePoint

---

## Kết luận & Bước tiếp theo

SoA là "bản đồ hành trình" cho việc triển khai ISMS của bạn. Nó kết nối đánh giá rủi ro với các biện pháp kiểm soát cụ thể, đồng thời cho auditor thấy bạn đã xem xét toàn diện các yêu cầu bảo mật.

### Checklist SoA

- ✅ Đã xem xét tất cả 93 kiểm soát trong Annex A
- ✅ Biện minh rõ ràng cho cả kiểm soát áp dụng và không áp dụng
- ✅ Liên kết kiểm soát với rủi ro trong risk register
- ✅ Gán owner cho từng kiểm soát áp dụng
- ✅ Cập nhật trạng thái triển khai
- ✅ Được Top Management phê duyệt
- ✅ Lưu trữ có version control

### Điểm nhấn quan trọng

- SoA là **tài liệu sống** - cập nhật khi rủi ro thay đổi, ngữ cảnh tổ chức thay đổi, hoặc khi có sự cố bảo mật
- Ưu tiên **20-25 kiểm soát** quan trọng nhất trước, mở rộng dần
- **Biện minh** exclusion cẩn thận - auditor sẽ thách thức quyết định này
- Sử dụng **công cụ miễn phí** - không cần đầu tư phần mềm đắt tiền

Trong **[Phần 5](/posts/iso27001-sme/05-chinh-sach-tai-lieu/)**, chúng ta sẽ xây dựng các chính sách và tài liệu ISMS bắt buộc - từ Information Security Policy cấp cao đến các quy trình cụ thể.

### Tài liệu tham khảo

- ISO/IEC 27001:2022 - Clause 6.1.3: Statement of Applicability
- ISO/IEC 27002:2022 - Annex A Control Descriptions
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework) - Mapping to ISO 27001
- [CIS Controls v8](https://www.cisecurity.org/controls/v8) - Complementary control framework
