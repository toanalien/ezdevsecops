---
title: "ISO 27001 cho SME Phần 1: Giới thiệu ISO 27001:2022 - Tại sao doanh nghiệp nhỏ cần quan tâm?"
date: 2026-02-14
draft: false
description: "Tổng quan về ISO 27001:2022 cho doanh nghiệp SME - lý do cần triển khai, thay đổi từ phiên bản 2013, chi phí và lộ trình thực tế tại Việt Nam"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "isms", "sme", "bao-mat", "chung-nhan", "iso27001-2022"]
series: ["ISO 27001 cho SME"]
weight: 1
mermaid: true
---

## Giới thiệu series

Chào mừng bạn đến với series **ISO 27001 cho SME**! Đây là hành trình 10 phần hướng dẫn toàn diện giúp các doanh nghiệp vừa và nhỏ tại Việt Nam triển khai và đạt chứng nhận ISO 27001:2022 một cách thực tế và hiệu quả.

Series này được viết dành riêng cho:
- **IT Managers** và **Security Leads** tại các công ty công nghệ 10-50 nhân viên
- **Founders** và **CTOs** muốn hiểu rõ quy trình chứng nhận
- **Compliance Officers** cần roadmap cụ thể cho tổ chức

Sau khi hoàn thành series này, bạn sẽ có đầy đủ kiến thức và công cụ để:
- ✅ Xây dựng Hệ thống Quản lý An toàn Thông tin (ISMS) từ đầu
- ✅ Chuẩn bị đầy đủ tài liệu theo yêu cầu ISO 27001:2022
- ✅ Lựa chọn và triển khai các kiểm soát Annex A phù hợp
- ✅ Vượt qua đánh giá chứng nhận với chi phí tối ưu
- ✅ Tuân thủ Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân

---

## ISO 27001 là gì?

**ISO 27001** là tiêu chuẩn quốc tế về **Hệ thống Quản lý An toàn Thông tin** (Information Security Management System - ISMS). Được phát hành bởi Tổ chức Tiêu chuẩn hóa Quốc tế (ISO) và Ủy ban Kỹ thuật Điện tử Quốc tế (IEC), phiên bản mới nhất là **ISO/IEC 27001:2022**.

ISO 27001 không phải là một sản phẩm, công cụ hay phần mềm bạn mua về cài đặt. Nó là một **khung quản lý** (management framework) giúp tổ chức:
- Xác định rủi ro bảo mật thông tin
- Thiết lập các biện pháp kiểm soát để giảm thiểu rủi ro
- Duy trì và cải thiện liên tục hệ thống bảo mật

{{< callout type="info" >}}
**Thông tin quan trọng:** ISO 27001 không yêu cầu bạn mua bất kỳ công cụ nào - nó là khung quản lý giúp bạn tổ chức bảo mật thông tin một cách có hệ thống. Bạn hoàn toàn có thể sử dụng các công cụ miễn phí hoặc công cụ hiện có trong tổ chức.
{{< /callout >}}

ISO 27001 áp dụng cho mọi loại hình tổ chức, từ công ty công nghệ, tài chính, y tế, đến cơ quan chính phủ. Tại Việt Nam, ngày càng nhiều doanh nghiệp SME trong lĩnh vực công nghệ (phát triển phần mềm, cung cấp dịch vụ IT, SaaS) triển khai ISO 27001 để đáp ứng yêu cầu khách hàng và tăng tính cạnh tranh.

---

## Cấu trúc ISO 27001:2022

ISO 27001:2022 gồm hai phần chính:

### Phần 1: Các điều khoản bắt buộc (Clauses 4-10)

Đây là 7 điều khoản quản lý mà **tất cả tổ chức** phải tuân thủ:

{{< mermaid >}}
graph LR
    C4[Clause 4<br/>Bối cảnh tổ chức] --> C5[Clause 5<br/>Lãnh đạo]
    C5 --> C6[Clause 6<br/>Lập kế hoạch]
    C6 --> C7[Clause 7<br/>Hỗ trợ]
    C7 --> C8[Clause 8<br/>Vận hành]
    C8 --> C9[Clause 9<br/>Đánh giá hiệu suất]
    C9 --> C10[Clause 10<br/>Cải tiến]
    C10 -.PDCA Cycle.-> C6

    C4 -.Xác định scope.-> SCOPE[Phạm vi ISMS]
    C5 -.Cam kết lãnh đạo.-> POLICY[Chính sách ATTT]
    C6 -.Đánh giá rủi ro.-> RISK[Đăng ký rủi ro]
    C6 -.Mục tiêu ATTT.-> OBJ[Mục tiêu đo lường]
    C8 -.Triển khai kiểm soát.-> ANNEX[Annex A Controls]
    C9 -.Đánh giá nội bộ.-> AUDIT[Lịch kiểm toán]
    C10 -.Hành động khắc phục.-> CAR[Corrective Actions]

    style C4 fill:#e1f5ff
    style C5 fill:#e1f5ff
    style C6 fill:#fff9c4
    style C7 fill:#fff9c4
    style C8 fill:#c8e6c9
    style C9 fill:#ffccbc
    style C10 fill:#f8bbd0
{{< /mermaid >}}

- **Clause 4:** Hiểu bối cảnh tổ chức, xác định phạm vi ISMS
- **Clause 5:** Vai trò lãnh đạo, chính sách an toàn thông tin
- **Clause 6:** Đánh giá rủi ro, mục tiêu ATTT, kế hoạch xử lý rủi ro
- **Clause 7:** Nguồn lực, năng lực, nhận thức, tài liệu
- **Clause 8:** Triển khai và vận hành các kiểm soát
- **Clause 9:** Giám sát, đo lường, đánh giá nội bộ, rà soát lãnh đạo
- **Clause 10:** Không phù hợp, hành động khắc phục, cải tiến liên tục

### Phần 2: Annex A - 93 kiểm soát bảo mật

Annex A chứa **93 kiểm soát** (controls) được tổ chức thành **4 danh mục**:

{{< mermaid >}}
graph TB
    subgraph ANNEXA[Annex A: 93 Kiểm soát]
        ORG[A.5: Organizational<br/>37 kiểm soát<br/>Chính sách, vai trò, quản lý tài sản]
        PEOPLE[A.6: People<br/>8 kiểm soát<br/>Sàng lọc, đào tạo, kỷ luật]
        PHYSICAL[A.7: Physical<br/>14 kiểm soát<br/>Kiểm soát vật lý, thiết bị]
        TECH[A.8: Technological<br/>34 kiểm soát<br/>Access control, mã hóa, backup]
    end

    ORG --> EXAMPLES1[Ví dụ:<br/>A.5.1 Chính sách ATTT<br/>A.5.9 Inventory tài sản<br/>A.5.23 Cloud services]
    PEOPLE --> EXAMPLES2[Ví dụ:<br/>A.6.1 Screening nhân viên<br/>A.6.3 Awareness training<br/>A.6.8 Thỏa thuận bảo mật]
    PHYSICAL --> EXAMPLES3[Ví dụ:<br/>A.7.2 Physical entry controls<br/>A.7.4 Giám sát vật lý<br/>A.7.7 Clear desk policy]
    TECH --> EXAMPLES4[Ví dụ:<br/>A.8.3 Quản lý quyền truy cập<br/>A.8.8 Quản lý lỗ hổng kỹ thuật<br/>A.8.24 Secure coding]

    style ANNEXA fill:#f5f5f5
    style ORG fill:#e3f2fd
    style PEOPLE fill:#f3e5f5
    style PHYSICAL fill:#fff3e0
    style TECH fill:#e8f5e9
{{< /mermaid >}}

Bạn **không cần triển khai tất cả 93 kiểm soát**. Dựa trên đánh giá rủi ro (Risk Assessment), bạn chỉ chọn các kiểm soát phù hợp với tổ chức mình. Điều này được ghi nhận trong **Statement of Applicability (SoA)** - tài liệu quan trọng giải thích tại sao chọn/không chọn từng kiểm soát.

---

## Thay đổi từ phiên bản 2013 sang 2022

ISO 27001:2022 đánh dấu bản cập nhật lớn đầu tiên sau gần 10 năm. Những thay đổi chính:

### Tái cấu trúc Annex A

- **ISO 27001:2013:** 114 kiểm soát trong 14 domains (A.5 → A.18)
- **ISO 27001:2022:** 93 kiểm soát trong 4 categories (A.5 → A.8)

56 kiểm soát cũ được **gộp lại** (merged) để loại bỏ trùng lặp, 24 kiểm soát được **đổi tên** cho rõ ràng hơn, và quan trọng nhất: **11 kiểm soát hoàn toàn mới** để đối phó với rủi ro hiện đại.

### 11 kiểm soát mới trong ISO 27001:2022

| Mã kiểm soát | Tên kiểm soát | Mô tả (Tiếng Việt) |
|--------------|---------------|-------------------|
| **A.5.7** | Threat intelligence | Thu thập và phân tích thông tin về mối đe dọa mạng |
| **A.5.23** | Information security for use of cloud services | Bảo mật khi sử dụng dịch vụ đám mây (AWS, Azure, GCP) |
| **A.5.30** | ICT readiness for business continuity | Sẵn sàng công nghệ thông tin cho tính liên tục kinh doanh |
| **A.7.4** | Physical security monitoring | Giám sát bảo mật vật lý (camera, báo động) |
| **A.8.9** | Configuration management | Quản lý cấu hình hệ thống (Infrastructure as Code) |
| **A.8.10** | Information deletion | Xóa thông tin an toàn khi hết chu kỳ sử dụng |
| **A.8.11** | Data masking | Che giấu dữ liệu nhạy cảm trong môi trường test/dev |
| **A.8.12** | Data leakage prevention | Ngăn chặn rò rỉ dữ liệu (DLP solutions) |
| **A.8.16** | Monitoring activities | Giám sát hoạt động hệ thống và người dùng |
| **A.8.23** | Web filtering | Lọc web để chặn truy cập các trang web độc hại |
| **A.8.28** | Secure coding | Lập trình an toàn (OWASP Top 10, code review) |

{{< callout type="warning" >}}
**Cảnh báo quan trọng:** Hạn chuyển đổi từ ISO 27001:2013 sang 2022 đã hết vào **31/10/2025**. Nếu tổ chức bạn đang giữ chứng chỉ 2013, phải chuyển đổi ngay. Nếu bạn bắt đầu triển khai mới, phải tuân thủ phiên bản 2022.
{{< /callout >}}

---

## Tại sao SME cần ISO 27001?

### 1. Yêu cầu từ khách hàng và đối tác

Đây là lý do **phổ biến nhất** khiến các SME tại Việt Nam triển khai ISO 27001. Ngày càng nhiều khách hàng, đặc biệt là:
- **Khách hàng B2B quốc tế**: Các công ty Mỹ, EU, Nhật, Singapore yêu cầu nhà cung cấp phải có ISO 27001
- **Tập đoàn lớn tại Việt Nam**: Các ngân hàng, tập đoàn viễn thông, công ty niêm yết đưa ISO 27001 vào tiêu chí đánh giá vendor
- **Hợp đồng chính phủ**: Một số gói thầu công nghệ của Nhà nước ưu tiên hoặc yêu cầu nhà thầu có chứng nhận ISMS

### 2. Lợi thế cạnh tranh

Trong thị trường công nghệ Việt Nam với hơn 70,000 doanh nghiệp IT, chứng nhận ISO 27001 giúp:
- Nổi bật khi tham gia RFP (Request for Proposal)
- Tăng uy tín thương hiệu
- Tạo niềm tin với khách hàng mới
- Dễ dàng mở rộng thị trường quốc tế

### 3. Giảm thiểu rủi ro bảo mật

Việt Nam là một trong những quốc gia chịu nhiều tấn công mạng nhất khu vực. ISO 27001 giúp SME:
- Xác định và quản lý rủi ro một cách có hệ thống
- Ngăn chặn vi phạm dữ liệu (data breach) - trung bình mỗi vụ vi phạm tốn $4.45M (IBM Cost of Data Breach Report 2023)
- Bảo vệ tài sản trí tuệ, source code, dữ liệu khách hàng
- Phát hiện sớm sự cố và phản ứng nhanh

### 4. Tuân thủ Nghị định 13/2023/NĐ-CP

Nghị định 13/2023 về Bảo vệ Dữ liệu Cá nhân (PDPA của Việt Nam) có hiệu lực từ 1/7/2023. ISO 27001 giúp tổ chức:
- Đáp ứng nhiều yêu cầu kỹ thuật của Nghị định 13 (mã hóa, kiểm soát truy cập, giám sát)
- Chứng minh với Bộ Công an rằng tổ chức có biện pháp bảo vệ dữ liệu cá nhân
- Chuẩn bị tốt hơn cho các quy định sắp tới về cybersecurity

{{< callout type="tip" >}}
**Mẹo hữu ích:** Series này sẽ có một phần riêng (Phần 10) hướng dẫn chi tiết cách ánh xạ (mapping) giữa ISO 27001:2022 và Nghị định 13/2023, giúp bạn "đạt hai chứng chỉ với một công sức".
{{< /callout >}}

### 5. Giảm phí bảo hiểm

Một số công ty bảo hiểm mạng (cyber insurance) tại Việt Nam và quốc tế đang giảm 10-15% phí bảo hiểm cho doanh nghiệp có ISO 27001, vì rủi ro thấp hơn.

---

## Thách thức cho SME

Mặc dù lợi ích rõ ràng, các doanh nghiệp nhỏ thường gặp những thách thức sau:

### 1. Ngân sách hạn chế

Không phải SME nào cũng có thể chi $15,000-$30,000 cho tư vấn viên và chứng nhận. Tuy nhiên, có thể giảm chi phí bằng cách:
- Tự triển khai (DIY) với công cụ miễn phí
- Bắt đầu với phạm vi hẹp (1 phòng ban hoặc 1 dịch vụ)
- Sử dụng nhân lực nội bộ kết hợp tư vấn từng giai đoạn

### 2. Thiếu nhân sự chuyên trách

Hầu hết SME không có đội ngũ Information Security riêng. Giải pháp:
- Chỉ định người phụ trách ISMS kiêm nhiệm (thường là IT Manager hoặc DevOps Lead)
- Đào tạo nhân sự hiện tại về ISO 27001 (khóa học 2-3 ngày)
- Thuê part-time security consultant để hướng dẫn

### 3. Thời gian căng thẳng

Vừa làm dự án khách hàng vừa triển khai ISMS rất áp lực. Thời gian thực tế:
- **4-6 tháng** cho SME có sẵn các quy trình cơ bản
- **6-9 tháng** nếu bắt đầu từ đầu
- Cần **4-8 giờ/tuần** từ người phụ trách ISMS

### 4. Thiếu kinh nghiệm

Không biết bắt đầu từ đâu, tài liệu nào cần thiết, kiểm soát nào ưu tiên.

{{< callout type="danger" >}}
**Nguy hiểm:** Những sai lầm thường gặp khiến SME thất bại trong chứng nhận:
- **Đánh giá thấp thời gian cần thiết** - ISO 27001 không phải là dự án 1 tháng
- **Coi như bài tập tích checkbox** - Auditor sẽ phát hiện nếu bạn chỉ làm cho có giấy tờ mà không triển khai thực tế
- **Không có cam kết từ lãnh đạo** - Clause 5 yêu cầu sự tham gia tích cực của top management
- **Copy-paste tài liệu từ internet** - Mỗi tổ chức khác nhau, cần tùy chỉnh theo bối cảnh riêng
{{< /callout >}}

---

## Chi phí thực tế tại Việt Nam

Dưới đây là ước tính chi phí cho một chu kỳ chứng nhận 3 năm (chứng chỉ ISO 27001 có hiệu lực 3 năm với đánh giá giám sát hàng năm):

### Bảng chi phí theo quy mô công ty

| Hạng mục | 10 nhân viên | 20 nhân viên | 50 nhân viên |
|----------|--------------|--------------|--------------|
| **Gap Analysis** (optional) | $2,000 | $3,000 | $5,000 |
| **Tư vấn triển khai** (optional) | $5,000-$8,000 | $8,000-$12,000 | $12,000-$20,000 |
| **Đào tạo nội bộ** | $1,000 | $1,500 | $2,500 |
| **Stage 1 Audit** (documentation) | $2,000 | $2,500 | $3,500 |
| **Stage 2 Audit** (certification) | $3,000 | $4,000 | $6,000 |
| **Surveillance Audit** (năm 2,3) | $1,500/năm | $2,000/năm | $3,000/năm |
| **Công cụ/phần mềm** (3 năm) | $1,000-$3,000 | $2,000-$5,000 | $3,000-$8,000 |
| **Tổng chi phí 3 năm** (DIY) | **$10,000-$12,000** | **$14,000-$18,000** | **$20,000-$28,000** |
| **Tổng chi phí 3 năm** (Full consultant) | **$17,000-$22,000** | **$26,000-$35,000** | **$40,000-$60,000** |

### Chi tiết các khoản chi phí

**1. Certification Body Fees (bắt buộc)**
- Các tổ chức chứng nhận hoạt động tại Việt Nam: BSI Vietnam, SQC, URS Vietnam, NQA, VNCE, TQC
- Chi phí Stage 1 + Stage 2: **$5,000-$10,000** (10-50 nhân viên)
- Surveillance audit hàng năm: **$1,500-$3,000**
- Recertification audit (năm thứ 3): **$4,000-$8,000**

**2. Consultant Fees (tùy chọn)**
- **Gap Analysis:** $2,000-$6,000 (1-2 tuần)
- **Implementation Support:** $8,000-$20,000 (3-5 tháng)
- **Pre-audit Internal Audit:** $2,000-$4,000
- Hoặc thuê theo ngày: **$500-$800/ngày** cho consultant có kinh nghiệm

**3. Training**
- **ISO 27001 Lead Implementer Course:** $800-$1,200/người (5 ngày)
- **Internal Auditor Course:** $500-$800/người (2 ngày)
- **Awareness training cho nhân viên:** $500-$1,000 (in-house)

**4. Công cụ và phần mềm (tùy chọn)**
- **GRC platform** (ISMS.online, Vanta, Drata): $200-$500/tháng
- **Vulnerability scanning** (Qualys, Nessus): $100-$300/tháng
- **SIEM/Log management** (ELK Stack - free, Splunk - paid)
- Có thể dùng công cụ miễn phí: Jira (risk register), Confluence (documentation), GitHub (policy version control)

### Lựa chọn tiết kiệm chi phí

{{< callout type="tip" >}}
**Mẹo tiết kiệm:** Bắt đầu với phạm vi nhỏ, mở rộng dần - giảm chi phí đáng kể.

**Ví dụ:** Thay vì chứng nhận toàn bộ công ty 50 người, hãy bắt đầu với:
- **Phạm vi hẹp:** "Dịch vụ phát triển phần mềm cho khách hàng X" (chỉ team 15 người)
- **Chi phí giảm:** Stage 2 audit chỉ tốn $3,500 thay vì $6,000
- **Sau 1 năm:** Mở rộng scope để bao phủ toàn công ty (recertification với scope lớn hơn)
{{< /callout >}}

---

## Lộ trình tổng quan

Dưới đây là lộ trình 4 giai đoạn mà SME thường đi theo để đạt chứng nhận ISO 27001:

{{< mermaid >}}
graph TB
    subgraph PHASE1[Giai đoạn 1: Lập kế hoạch<br/>4-6 tuần]
        P1A[Xác định scope ISMS<br/>Phần 2]
        P1B[Gap analysis<br/>Phần 2]
        P1C[Phân tích bối cảnh<br/>Phần 2]
        P1D[Đánh giá rủi ro<br/>Phần 3]
        P1E[Chọn kiểm soát Annex A<br/>Phần 4]
    end

    subgraph PHASE2[Giai đoạn 2: Triển khai<br/>8-12 tuần]
        P2A[Viết chính sách & quy trình<br/>Phần 5]
        P2B[Triển khai kiểm soát kỹ thuật<br/>Phần 6-7]
        P2C[Đào tạo nhân viên<br/>Phần 8]
        P2D[Tạo bằng chứng tuân thủ<br/>Phần 5-7]
        P2E[Tài liệu hóa ISMS<br/>Phần 5]
    end

    subgraph PHASE3[Giai đoạn 3: Kiểm tra<br/>3-4 tuần]
        P3A[Internal audit<br/>Phần 9]
        P3B[Management review<br/>Clause 9.3]
        P3C[Corrective actions<br/>Clause 10]
        P3D[Mock audit với consultant<br/>Optional]
    end

    subgraph PHASE4[Giai đoạn 4: Chứng nhận<br/>4-6 tuần]
        P4A[Chọn Certification Body<br/>BSI/SQC/URS...]
        P4B[Stage 1 Audit<br/>Document review]
        P4C[Khắc phục gaps từ Stage 1<br/>1-2 tuần]
        P4D[Stage 2 Audit<br/>On-site assessment]
        P4E[Nhận chứng chỉ ISO 27001<br/>🎉]
    end

    P1A --> P1B --> P1C --> P1D --> P1E
    P1E --> P2A --> P2B --> P2C --> P2D --> P2E
    P2E --> P3A --> P3B --> P3C --> P3D
    P3D --> P4A --> P4B --> P4C --> P4D --> P4E

    P4E -.Surveillance audit năm 2,3.-> MAINTAIN[Duy trì & cải tiến<br/>Continuous improvement]

    style PHASE1 fill:#e3f2fd
    style PHASE2 fill:#fff9c4
    style PHASE3 fill:#ffccbc
    style PHASE4 fill:#c8e6c9
    style P4E fill:#4caf50,color:#fff
{{< /mermaid >}}

### Thời gian thực tế cho SME

- **Nhanh nhất:** 4 tháng (có sẵn quy trình, documentation tốt, IT team mạnh)
- **Trung bình:** 6 tháng (SME điển hình, bắt đầu từ đầu, có một số quy trình cơ bản)
- **Chậm hơn:** 9-12 tháng (tổ chức phức tạp, nhiều vị trí, thiếu nguồn lực)

### Quick Wins trong 30 ngày đầu

Bạn có thể hoàn thành những việc sau trong tháng đầu tiên để tạo động lực:

1. ✅ **Tuần 1-2:** Xác định scope ISMS hẹp (1 dịch vụ hoặc 1 team)
2. ✅ **Tuần 2:** Lập danh sách tài sản thông tin (information asset register)
3. ✅ **Tuần 3:** Viết Information Security Policy (1-2 trang)
4. ✅ **Tuần 4:** Thực hiện đánh giá rủi ro sơ bộ cho 10 rủi ro hàng đầu

### Nội dung các phần tiếp theo trong series

| Phần | Tiêu đề | Nội dung chính |
|------|---------|----------------|
| **Phần 2** | Xác định phạm vi ISMS và Phân tích bối cảnh | Clause 4.1-4.4, SWOT analysis, stakeholder register, scope statement templates |
| **Phần 3** | Đánh giá rủi ro và Kế hoạch xử lý | Clause 6.1, risk assessment methodology, risk matrix, risk treatment plan |
| **Phần 4** | Statement of Applicability (SoA) | Chọn kiểm soát Annex A phù hợp, lập luận SoA, mapping rủi ro-kiểm soát |
| **Phần 5** | Tài liệu hóa ISMS | Viết policies, procedures, work instructions, document control |
| **Phần 6** | Kiểm soát kỹ thuật (Annex A) - Phần 1 | Access control, cryptography, network security, vulnerability management |
| **Phần 7** | Kiểm soát kỹ thuật (Annex A) - Phần 2 | Backup, logging, incident response, business continuity |
| **Phần 8** | Kiểm soát con người & vật lý | Awareness training, background checks, physical security |
| **Phần 9** | Internal Audit & Management Review | Lập kế hoạch audit, thực hiện audit, corrective actions, management review meeting |
| **Phần 10** | Mapping với Nghị định 13/2023 | Compliance với PDPA Việt Nam, data protection impact assessment |

---

## Kết luận & Bước tiếp theo

ISO 27001:2022 không chỉ là một chứng chỉ để "treo tường" - nó là công cụ thực tế giúp doanh nghiệp SME xây dựng nền tảng bảo mật thông tin vững chắc, đáp ứng yêu cầu khách hàng, và tuân thủ pháp luật Việt Nam.

### Điểm chính cần nhớ

- ✅ ISO 27001:2022 có 93 kiểm soát (giảm từ 114), tập trung vào rủi ro hiện đại (cloud, threat intel, secure coding)
- ✅ Chi phí 3 năm cho SME 10-50 người: **$10,000-$28,000** (DIY) hoặc **$17,000-$60,000** (full consultant)
- ✅ Thời gian triển khai: **4-6 tháng** trung bình
- ✅ Bắt đầu với phạm vi hẹp để giảm chi phí và độ phức tạp
- ✅ Hạn chuyển đổi từ ISO 27001:2013 đã hết (31/10/2025)

### Bước tiếp theo

Trong **Phần 2**, chúng ta sẽ đi sâu vào **Clause 4 (Bối cảnh tổ chức)** với hướng dẫn thực hành:
- Phân tích SWOT cho bối cảnh bảo mật của tổ chức bạn
- Xác định các bên liên quan (stakeholders) và yêu cầu của họ
- Viết Scope Statement (tuyên bố phạm vi) cụ thể cho công ty bạn
- Thực hiện Gap Analysis để biết bạn đang ở đâu trên hành trình ISO 27001

👉 **[Đọc tiếp Phần 2: Xác định phạm vi ISMS và Phân tích bối cảnh tổ chức →](/posts/iso27001-sme/02-pham-vi-isms-boi-canh/)**

---

**Bạn có câu hỏi về ISO 27001 cho SME?** Để lại bình luận bên dưới hoặc liên hệ với chúng tôi!
