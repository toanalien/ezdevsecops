---
title: "ISO 27001 cho SME Phần 3: Đánh giá rủi ro và Kế hoạch xử lý rủi ro"
date: 2026-02-14
draft: false
description: "Hướng dẫn đánh giá rủi ro theo ISO 27001:2022 cho SME - phương pháp định tính, ma trận rủi ro, kế hoạch xử lý rủi ro với template sẵn dùng"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "risk-assessment", "risk-treatment", "clause-6", "rui-ro", "isms"]
series: ["ISO 27001 cho SME"]
weight: 3
mermaid: true
---

## Giới thiệu

Chào mừng bạn trở lại với series **ISO 27001 cho SME**! Trong [Phần 1](/posts/iso27001-sme/01-gioi-thieu-iso27001/), chúng ta đã tìm hiểu tổng quan về ISO 27001:2022. Trong [Phần 2](/posts/iso27001-sme/02-pham-vi-isms-boi-canh/), bạn đã xác định được phạm vi ISMS và phân tích bối cảnh tổ chức.

Bây giờ đến phần **quan trọng nhất** của toàn bộ hành trình: **Risk Assessment** (Đánh giá rủi ro) theo **Clause 6.1** của ISO 27001:2022.

Tại sao đánh giá rủi ro lại quan trọng?
- ✅ Nó quyết định **bạn cần triển khai kiểm soát nào** trong Annex A
- ✅ Nó tạo cơ sở cho **Statement of Applicability (SoA)** - tài liệu quan trọng nhất khi audit
- ✅ Nó giúp bạn **ưu tiên nguồn lực** cho những rủi ro lớn nhất
- ✅ Nó chứng minh bạn hiểu rõ **mối đe dọa thực tế** đối với tổ chức

{{< callout type="info" >}}
**Thông tin cốt lõi:** Đánh giá rủi ro là bước quan trọng nhất - nó quyết định bạn cần triển khai kiểm soát nào.

ISO 27001 không bắt buộc bạn triển khai tất cả 93 kiểm soát. Thay vào đó, bạn **dựa trên rủi ro** để chọn những kiểm soát phù hợp. Không có risk assessment tốt = không biết cần bảo vệ cái gì = waste tiền và công sức.
{{< /callout >}}

---

## Phương pháp đánh giá rủi ro

ISO 27001 không quy định phương pháp cụ thể - bạn có thể chọn **định tính** (qualitative) hoặc **định lượng** (quantitative). Đối với SME, chúng tôi **strongly recommend định tính** vì:

### So sánh Qualitative vs Quantitative

| Tiêu chí | Định tính (Qualitative) | Định lượng (Quantitative) |
|----------|------------------------|--------------------------|
| **Độ phức tạp** | Đơn giản, dễ hiểu | Phức tạp, cần chuyên gia |
| **Thời gian** | 2-4 tuần | 2-3 tháng |
| **Chi phí** | Thấp (có thể tự làm) | Cao ($10k-$30k cho consultant) |
| **Công cụ cần thiết** | Excel/Google Sheets | Phần mềm chuyên dụng (RiskLens, FAIR) |
| **Phù hợp cho** | SME 10-50 nhân viên | Enterprise >500 nhân viên, ngân hàng, tài chính |
| **Kết quả** | Rủi ro xếp hạng: Thấp/Trung bình/Cao/Rất cao | Rủi ro tính bằng tiền: "Expected annual loss = $125,000" |
| **Ví dụ** | "Rủi ro ransomware: Likelihood=4, Impact=4, Risk Score=16 (Cao)" | "ALE = SLE × ARO = $50,000 × 2.5 = $125,000" |

**Lựa chọn cho SME:** Định tính (qualitative) - đủ tốt, được auditor chấp nhận, tiết kiệm thời gian và chi phí.

### Định nghĩa tiêu chí rủi ro

Trước khi bắt đầu, bạn cần định nghĩa:
- **Risk Acceptance Criteria:** Ngưỡng rủi ro nào là chấp nhận được? (Ví dụ: Score ≤6 = chấp nhận)
- **Likelihood Scale:** Xác suất xảy ra (1-5: Rất thấp → Rất cao)
- **Impact Scale:** Mức độ tác động (1-5: Không đáng kể → Nghiêm trọng)
- **Risk Score Formula:** Risk = Likelihood × Impact

{{< mermaid >}}
graph TB
    START[Bắt đầu Risk Assessment]

    START --> DEFINE[Định nghĩa tiêu chí rủi ro<br/>Likelihood & Impact scales]
    DEFINE --> IDENTIFY[Bước 1: Nhận diện rủi ro<br/>Asset + Threat + Vulnerability]
    IDENTIFY --> ANALYZE[Bước 2: Phân tích rủi ro<br/>Tính Likelihood & Impact]
    ANALYZE --> EVALUATE[Bước 3: Đánh giá rủi ro<br/>So sánh với ngưỡng chấp nhận]
    EVALUATE --> TREAT[Bước 4: Xử lý rủi ro<br/>Avoid/Reduce/Share/Accept]

    TREAT --> REGISTER[Tạo Risk Register<br/>Lưu trữ tất cả rủi ro]
    TREAT --> PLAN[Tạo Risk Treatment Plan<br/>Hành động cụ thể cho từng rủi ro]

    REGISTER --> REVIEW[Review định kỳ<br/>6 tháng/lần hoặc khi có thay đổi lớn]
    PLAN --> IMPLEMENT[Triển khai kiểm soát<br/>Annex A controls]

    REVIEW -.Update.-> IDENTIFY
    IMPLEMENT --> SOA[Tạo Statement of Applicability<br/>Phần 4 của series]

    style START fill:#e3f2fd
    style IDENTIFY fill:#fff9c4
    style ANALYZE fill:#fff9c4
    style EVALUATE fill:#fff9c4
    style TREAT fill:#c8e6c9
    style SOA fill:#f8bbd0
{{< /mermaid >}}

---

## Bước 1: Nhận diện rủi ro

Rủi ro = **Tài sản** (Asset) + **Mối đe dọa** (Threat) + **Lỗ hổng** (Vulnerability)

### 1.1 Nhận diện tài sản thông tin

Tài sản thông tin bao gồm:
- **Information assets:** Dữ liệu khách hàng, source code, tài liệu thiết kế, hợp đồng
- **IT systems:** Servers, databases, applications, cloud accounts
- **People:** Nhân viên có kiến thức chuyên môn (key person risk)
- **Physical assets:** Laptop, điện thoại, USB, văn phòng

### Template: Asset Register

| ID | Tên tài sản | Loại | Chủ sở hữu | Giá trị (C-I-A) | Vị trí | Ghi chú |
|----|-------------|------|------------|----------------|--------|---------|
| **AS-001** | Customer Database PostgreSQL | Hệ thống | CTO | Confidentiality=5, Integrity=5, Availability=4 | AWS RDS ap-southeast-1 | 500K records, PII data |
| **AS-002** | Source Code Repository | Thông tin | Dev Lead | C=5, I=5, A=3 | GitHub Enterprise | Proprietary algorithms |
| **AS-003** | AWS Production Account | Hệ thống | DevOps Lead | C=4, I=5, A=5 | Cloud | Hosts all services |
| **AS-004** | Employee Laptops (20 cái) | Vật lý | IT Manager | C=4, I=3, A=3 | Di động | MacBook Pro, Windows |
| **AS-005** | Backup Storage S3 | Hệ thống | DevOps | C=5, I=5, A=3 | AWS S3 us-west-2 | Daily backups, encrypted |
| **AS-006** | API Keys và Secrets | Thông tin | CTO | C=5, I=5, A=4 | AWS Secrets Manager | Stripe, SendGrid, DB credentials |
| **AS-007** | Customer Support Portal | Hệ thống | Product Manager | C=3, I=4, A=4 | AWS EC2 | Zendesk integration |
| **AS-008** | SSL/TLS Certificates | Thông tin | DevOps | C=3, I=5, A=5 | AWS Certificate Manager | Wildcard cert *.company.com |

**Giải thích C-I-A (Confidentiality-Integrity-Availability):**
- **Confidentiality (Tính bảo mật):** 1=Public, 5=Top Secret
- **Integrity (Tính toàn vẹn):** 1=Không quan trọng, 5=Critical (sai số liệu = thảm họa)
- **Availability (Tính sẵn sàng):** 1=Downtime 1 tuần OK, 5=Phải 99.99% uptime

{{< callout type="tip" >}}
**Mẹo tiết kiệm thời gian:** Liệt kê tài sản quan trọng nhất trước - không cần liệt kê tất cả cùng một lúc.

**20% tài sản chiếm 80% rủi ro.** Bắt đầu với:
- Customer data (PII, payment info)
- Production systems (app, database, API)
- Source code và IP
- Admin credentials và secrets

Sau khi hoàn thành 10-15 tài sản quan trọng, bạn đã có đủ để tiếp tục risk assessment. Mở rộng dần về sau.
{{< /callout >}}

### 1.2 Nhận diện mối đe dọa (Threats)

Mối đe dọa phổ biến cho SME công nghệ Việt Nam:

**Cyber threats:**
- Ransomware (WannaCry, LockBit, BlackCat)
- Phishing/Spear phishing targeting CEO, finance team
- DDoS attacks từ đối thủ cạnh tranh
- SQL injection, XSS trên web applications
- Supply chain attacks (compromised npm packages)
- Credential stuffing (leaked passwords)

**Human threats:**
- Nhân viên nghỉ việc mang theo dữ liệu khách hàng
- Nhân viên bất mãn phá hoại hệ thống
- Lỗi cấu hình do thiếu kiến thức (misconfiguration)
- Social engineering targeting support team

**Physical threats:**
- Mất/mất cắp laptop chứa source code
- Cháy/ngập văn phòng
- Mất điện kéo dài

**Environmental threats:**
- AWS region outage (ap-southeast-1 down)
- GitHub outage
- Nhà cung cấp SaaS ngừng hoạt động

### 1.3 Nhận diện lỗ hổng (Vulnerabilities)

Lỗ hổng là **điểm yếu** cho phép threat khai thác:

- **Technical vulnerabilities:**
  - Unpatched systems (OS, libraries, frameworks)
  - Weak passwords (123456, company@2023)
  - No MFA on admin accounts
  - Publicly exposed S3 buckets
  - Hardcoded secrets trong source code
  - No rate limiting trên API

- **Process vulnerabilities:**
  - Không có quy trình incident response
  - Không test backup recovery
  - Không review access rights định kỳ
  - Không background check nhân viên mới

- **People vulnerabilities:**
  - Nhân viên không biết phishing như thế nào
  - Dùng USB lạ vào laptop công ty
  - Share passwords qua Slack/email

---

## Bước 2: Phân tích rủi ro

### 2.1 Thang đo Likelihood (Xác suất xảy ra)

| Mức | Tên | Mô tả | Tần suất dự kiến |
|-----|-----|-------|------------------|
| **1** | Rất thấp (Rare) | Hầu như không thể xảy ra, chưa từng nghe trong ngành | <1% xác suất/năm (>10 năm 1 lần) |
| **2** | Thấp (Unlikely) | Có thể xảy ra nhưng rất hiếm | 1-10% (5-10 năm 1 lần) |
| **3** | Trung bình (Possible) | Có thể xảy ra, đã xảy ra với công ty khác trong ngành | 10-50% (2-5 năm 1 lần) |
| **4** | Cao (Likely) | Có khả năng cao, đã xảy ra 1-2 lần trong quá khứ | 50-90% (1-2 năm 1 lần) |
| **5** | Rất cao (Almost Certain) | Gần như chắc chắn, xảy ra thường xuyên | >90% (nhiều lần/năm) |

### 2.2 Thang đo Impact (Mức độ tác động)

| Mức | Tên | Tác động tài chính | Tác động hoạt động | Tác động pháp lý | Tác động danh tiếng |
|-----|-----|-------------------|-------------------|-----------------|-------------------|
| **1** | Không đáng kể (Insignificant) | <$1,000 | Gián đoạn <4 giờ | Không | Không ảnh hưởng |
| **2** | Nhỏ (Minor) | $1K-$10K | Gián đoạn 4-24 giờ | Cảnh cáo | 1-2 khách hàng phàn nàn |
| **3** | Trung bình (Moderate) | $10K-$50K | Gián đoạn 1-3 ngày | Phạt <$10K | Tin tức âm ở báo ngành |
| **4** | Lớn (Major) | $50K-$200K | Gián đoạn 3-7 ngày | Phạt $10K-$50K, mất hợp đồng lớn | Tin tức âm trên báo chính thống |
| **5** | Nghiêm trọng (Severe) | >$200K | Gián đoạn >7 ngày hoặc phá sản | Kiện tụng, phạt >$50K, đóng cửa | Mất 30%+ khách hàng, phá sản |

### 2.3 Ma trận rủi ro 5×5

{{< mermaid >}}
graph TB
    subgraph LEGEND[Chú thích màu sắc]
        LOW[Rủi ro Thấp<br/>Score 1-6<br/>Chấp nhận được]
        MEDIUM[Rủi ro Trung bình<br/>Score 8-12<br/>Giảm thiểu]
        HIGH[Rủi ro Cao<br/>Score 15-25<br/>Ưu tiên xử lý]
    end

    subgraph MATRIX[Ma trận Rủi ro 5x5]
        direction TB

        subgraph ROW5[Impact = 5 Nghiêm trọng]
            C51[5×1=5<br/>MEDIUM]
            C52[5×2=10<br/>MEDIUM]
            C53[5×3=15<br/>HIGH]
            C54[5×4=20<br/>HIGH]
            C55[5×5=25<br/>HIGH]
        end

        subgraph ROW4[Impact = 4 Lớn]
            C41[4×1=4<br/>LOW]
            C42[4×2=8<br/>MEDIUM]
            C43[4×3=12<br/>MEDIUM]
            C44[4×4=16<br/>HIGH]
            C45[4×5=20<br/>HIGH]
        end

        subgraph ROW3[Impact = 3 Trung bình]
            C31[3×1=3<br/>LOW]
            C32[3×2=6<br/>LOW]
            C33[3×3=9<br/>MEDIUM]
            C34[3×4=12<br/>MEDIUM]
            C35[3×5=15<br/>HIGH]
        end

        subgraph ROW2[Impact = 2 Nhỏ]
            C21[2×1=2<br/>LOW]
            C22[2×2=4<br/>LOW]
            C23[2×3=6<br/>LOW]
            C24[2×4=8<br/>MEDIUM]
            C25[2×5=10<br/>MEDIUM]
        end

        subgraph ROW1[Impact = 1 Không đáng kể]
            C11[1×1=1<br/>LOW]
            C12[1×2=2<br/>LOW]
            C13[1×3=3<br/>LOW]
            C14[1×4=4<br/>LOW]
            C15[1×5=5<br/>MEDIUM]
        end

        LIKELIHOOD[Likelihood: 1=Rất thấp, 2=Thấp, 3=Trung bình, 4=Cao, 5=Rất cao]
        LIKELIHOOD -.Trục X.-> ROW1
    end

    style LOW fill:#c8e6c9
    style MEDIUM fill:#fff9c4
    style HIGH fill:#ffccbc

    style C11 fill:#c8e6c9
    style C12 fill:#c8e6c9
    style C13 fill:#c8e6c9
    style C14 fill:#c8e6c9
    style C15 fill:#fff9c4
    style C21 fill:#c8e6c9
    style C22 fill:#c8e6c9
    style C23 fill:#c8e6c9
    style C24 fill:#fff9c4
    style C25 fill:#fff9c4
    style C31 fill:#c8e6c9
    style C32 fill:#c8e6c9
    style C33 fill:#fff9c4
    style C34 fill:#fff9c4
    style C35 fill:#ffccbc
    style C41 fill:#c8e6c9
    style C42 fill:#fff9c4
    style C43 fill:#fff9c4
    style C44 fill:#ffccbc
    style C45 fill:#ffccbc
    style C51 fill:#fff9c4
    style C52 fill:#fff9c4
    style C53 fill:#ffccbc
    style C54 fill:#ffccbc
    style C55 fill:#ffccbc
{{< /mermaid >}}

### 2.4 Risk Scoring Table

| Risk Level | Score Range | Màu | Hành động yêu cầu |
|------------|-------------|-----|-------------------|
| **Thấp (Low)** | 1-6 | 🟢 Xanh lá | Chấp nhận với giám sát định kỳ |
| **Trung bình (Medium)** | 8-12 | 🟡 Vàng | Giảm thiểu trong 3-6 tháng |
| **Cao (High)** | 15-25 | 🔴 Đỏ | Xử lý ngay lập tức, ưu tiên cao nhất |

---

## Bước 3: Đánh giá rủi ro

Sau khi tính risk score, bạn so sánh với **ngưỡng chấp nhận rủi ro** (risk acceptance criteria).

### Tiêu chí chấp nhận rủi ro (Risk Acceptance Criteria)

**Ví dụ cho SME công nghệ:**
- ✅ **Score ≤6:** Chấp nhận (Accept) - không cần hành động ngay, giám sát 6 tháng/lần
- ⚠️ **Score 8-12:** Giảm thiểu (Reduce) - triển khai kiểm soát trong 3-6 tháng
- 🚨 **Score ≥15:** Không thể chấp nhận (Unacceptable) - phải xử lý ngay trong 1-3 tháng

{{< callout type="warning" >}}
**Cảnh báo quan trọng:** Mọi rủi ro được chấp nhận phải có lý do và được lãnh đạo phê duyệt.

Auditor sẽ hỏi: "Tại sao bạn chấp nhận rủi ro này?" Bạn phải có câu trả lời hợp lý:
- ✅ "Chi phí triển khai kiểm soát ($20K) cao hơn tác động tài chính dự kiến ($5K)"
- ✅ "Kiểm soát bù (compensating control) đã được triển khai"
- ✅ "Rủi ro này nằm ngoài phạm vi ISMS (out of scope)"
- ❌ "Chúng tôi không có thời gian" ← Không chấp nhận!
{{< /callout >}}

---

## Bước 4: Xử lý rủi ro

ISO 27001 yêu cầu chọn một trong **4 phương án xử lý** cho mỗi rủi ro:

### 4 Treatment Options

{{< mermaid >}}
graph TD
    RISK[Rủi ro được xác định<br/>Score = L × I]

    RISK --> DECISION{Đánh giá<br/>Risk Score}

    DECISION -->|Score ≥20<br/>Cực kỳ cao| AVOID[TRÁNH Avoid<br/>Ngừng hoạt động gây rủi ro]
    DECISION -->|Score 12-20<br/>Cao| REDUCE[GIẢM Reduce<br/>Triển khai kiểm soát Annex A]
    DECISION -->|Score 8-12<br/>Trung bình| SHARE[CHIA SẺ Share/Transfer<br/>Bảo hiểm, outsource]
    DECISION -->|Score ≤6<br/>Thấp| ACCEPT[CHẤP NHẬN Accept<br/>Giám sát, không hành động]

    AVOID --> EX_AVOID[Ví dụ: Ngừng lưu trữ<br/>dữ liệu thẻ tín dụng,<br/>dùng Stripe thay thế]
    REDUCE --> EX_REDUCE[Ví dụ: Triển khai MFA,<br/>encryption, backup,<br/>vulnerability scanning]
    SHARE --> EX_SHARE[Ví dụ: Mua cyber insurance,<br/>outsource SOC cho VNPT,<br/>dùng AWS Shield cho DDoS]
    ACCEPT --> EX_ACCEPT[Ví dụ: Rủi ro mất USB<br/>chứa tài liệu công khai<br/>Score=2, chấp nhận]

    AVOID -.Document trong.-> RTP[Risk Treatment Plan]
    REDUCE -.Document trong.-> RTP
    SHARE -.Document trong.-> RTP
    ACCEPT -.Document trong.-> RTP

    RTP --> SOA[Statement of Applicability<br/>Phần 4 của series]

    style AVOID fill:#ffccbc
    style REDUCE fill:#c8e6c9
    style SHARE fill:#fff9c4
    style ACCEPT fill:#e3f2fd
{{< /mermaid >}}

### Chi tiết 4 phương án

#### 1. Tránh (Avoid)

**Khi nào dùng:** Rủi ro quá lớn, không có cách nào giảm xuống mức chấp nhận được

**Ví dụ thực tế:**
- **Rủi ro:** Lưu trữ số thẻ tín dụng khách hàng (PCI-DSS compliance cost $50K+)
- **Xử lý:** Ngừng lưu trữ, dùng Stripe/PayPal xử lý payment → Rủi ro biến mất hoàn toàn
- **Kết quả:** Không cần PCI-DSS, giảm liability

#### 2. Giảm (Reduce) ⭐ Phổ biến nhất

**Khi nào dùng:** Hầu hết các rủi ro trung bình-cao

**Ví dụ thực tế:**
- **Rủi ro:** Tấn công ransomware vào production database (L=4, I=5, Score=20)
- **Kiểm soát triển khai:**
  - A.8.13: Backup hàng ngày, test recovery hàng tháng
  - A.8.24: Encryption at rest cho RDS
  - A.8.3: Restrict database access, principle of least privilege
  - A.8.8: Vulnerability scanning với AWS Inspector
  - A.6.3: Phishing awareness training cho nhân viên
- **Residual Risk:** L=2, I=4, Score=8 (giảm từ 20 xuống 8) ✅

#### 3. Chia sẻ/Chuyển giao (Share/Transfer)

**Khi nào dùng:** Rủi ro có thể mua bảo hiểm hoặc outsource cho chuyên gia

**Ví dụ thực tế:**
- **Rủi ro:** DDoS attack làm website down 3 ngày (L=3, I=4, Score=12)
- **Xử lý:**
  - Subscribe AWS Shield Advanced ($3,000/tháng)
  - Mua cyber insurance ($5,000/năm, cover up to $500K)
  - Outsource 24/7 SOC monitoring cho VNPT ($2,000/tháng)
- **Residual Risk:** L=2, I=2, Score=4 (financial impact transferred to insurance)

#### 4. Chấp nhận (Accept)

**Khi nào dùng:** Rủi ro thấp, chi phí xử lý lớn hơn tác động

**Ví dụ thực tế:**
- **Rủi ro:** Nhân viên marketing mất USB chứa brochure sản phẩm (public info)
- **Phân tích:** L=3, I=1, Score=3 (Thấp)
- **Quyết định:** Chấp nhận
- **Lý do:** Dữ liệu công khai, không có thông tin nhạy cảm. Chi phí encrypted USB ($50/cái × 10 người = $500) > Expected loss ($0)
- **Phê duyệt:** CTO signed off on 2024-12-15

---

## Kế hoạch xử lý rủi ro (Risk Treatment Plan)

### Template: Risk Treatment Plan

| Risk ID | Mô tả rủi ro | Asset | Threat | Vuln | L | I | Score | Treatment | Annex A Control | Owner | Deadline | Cost | Status |
|---------|--------------|-------|--------|------|---|---|-------|-----------|----------------|-------|----------|------|--------|
| **R-001** | Ransomware tấn công customer DB | AS-001 (Customer DB) | Ransomware | No backup testing | 4 | 5 | 20 | Reduce | A.8.13 (Backup)<br/>A.8.24 (Encryption) | DevOps Lead | 2026-03-31 | $2,000 | In Progress |
| **R-002** | Phishing lấy cắp CEO credentials | AS-006 (Admin credentials) | Spear phishing | No MFA | 4 | 4 | 16 | Reduce | A.8.5 (Secure auth)<br/>A.6.3 (Training) | IT Manager | 2026-02-28 | $500 | Completed ✅ |
| **R-003** | AWS region outage | AS-003 (AWS Production) | Infrastructure failure | Single region | 3 | 4 | 12 | Reduce | A.5.30 (BC planning) | CTO | 2026-06-30 | $8,000 | Planned |
| **R-004** | Nhân viên nghỉ việc mang data | AS-002 (Source code) | Insider threat | No DLP | 3 | 4 | 12 | Reduce | A.8.12 (DLP)<br/>A.6.4 (Termination) | HR Manager | 2026-04-30 | $3,000 | Planned |
| **R-005** | SQL injection trên web app | AS-007 (Support Portal) | Cyber attack | No WAF | 3 | 3 | 9 | Reduce | A.8.8 (Vuln mgmt)<br/>A.8.28 (Secure coding) | Dev Lead | 2026-03-15 | $1,000 | In Progress |
| **R-006** | Unpatched servers bị exploit | AS-003 (AWS EC2) | Zero-day exploit | Manual patching | 3 | 4 | 12 | Reduce | A.8.8 (Patch mgmt) | DevOps | 2026-02-20 | $0 (automation) | In Progress |
| **R-007** | GitHub account compromise | AS-002 (Source code) | Credential theft | Weak password | 3 | 5 | 15 | Reduce | A.8.5 (MFA + passkeys)<br/>A.5.18 (Access rights) | CTO | 2026-02-15 | $0 | Completed ✅ |
| **R-008** | Laptop mất cắp chứa code | AS-004 (Laptops) | Physical theft | No disk encryption | 2 | 3 | 6 | Accept | A.7.7 (Clear desk)<br/>Monitoring | IT Manager | N/A | $0 | Accepted (Low risk, FileVault đã bật) |
| **R-009** | DDoS tấn công website | AS-007 (Web) | DDoS | No DDoS protection | 3 | 3 | 9 | Share | A.8.6 (Network security) | DevOps | 2026-03-01 | $5,000/year (insurance) | Planned |
| **R-010** | Lưu trữ credit card data | N/A (proposed feature) | PCI-DSS violation | Would need compliance | 5 | 5 | 25 | Avoid | N/A - Use Stripe instead | CEO | 2026-02-10 | $0 (don't implement) | Completed ✅ |

### Liên kết rủi ro với Annex A controls

{{< callout type="tip" >}}
**Mẹo cực kỳ quan trọng:** Liên kết mỗi rủi ro với kiểm soát Annex A tương ứng - điều này cung cấp cơ sở cho Tuyên bố Áp dụng (Statement of Applicability - SoA) ở Phần 4.

**Quy trình:**
1. Trong Risk Treatment Plan, cột "Annex A Control" liệt kê các kiểm soát sẽ giảm thiểu rủi ro này
2. Khi viết SoA (Phần 4), bạn giải thích: "Chúng tôi triển khai A.8.13 để xử lý rủi ro R-001 (ransomware)"
3. Auditor sẽ kiểm tra: Risk → Treatment → Control → Implementation evidence

**Ví dụ ánh xạ:**
- R-001 (Ransomware) → A.8.13 (Backup), A.8.24 (Encryption), A.6.3 (Training)
- R-002 (Phishing CEO) → A.8.5 (MFA), A.6.3 (Awareness), A.5.18 (Privileged access)
{{< /callout >}}

---

## Ví dụ thực tế: Walkthrough đầy đủ

Hãy đi qua một ví dụ hoàn chỉnh từ đầu đến cuối:

### Kịch bản: Rủi ro mất dữ liệu khách hàng do tấn công ransomware

**Công ty:** DevStudio Vietnam (20 nhân viên, phát triển SaaS)

#### Step 1: Nhận diện rủi ro

- **Asset:** Customer Database PostgreSQL (AS-001)
  - Chứa 50,000 customer records
  - PII: họ tên, email, số điện thoại, địa chỉ
  - Value: C=5, I=5, A=4

- **Threat:** Ransomware attack (LockBit, BlackCat variants)
  - Phổ biến tại Việt Nam (>100 SME bị tấn công năm 2025)
  - Entry vector: Phishing email với malicious attachment

- **Vulnerability:**
  - Backup có, nhưng chưa bao giờ test restore
  - Database chưa mã hóa at rest
  - Một số nhân viên có quyền admin không cần thiết
  - Chưa có phishing training

#### Step 2: Phân tích rủi ro

**Likelihood (Xác suất):**
- SME tại VN có 30-40% xác suất bị ransomware trong 2 năm tới
- DevStudio chưa bị tấn công, nhưng industry trend cao
- **Rating: 4 (Likely)**

**Impact (Tác động):**
- **Tài chính:** Ransom demand $50K + recovery cost $30K + mất doanh thu 1 tuần $20K = **$100K**
- **Hoạt động:** Service down 5-7 ngày (restore from backup chưa test)
- **Pháp lý:** Vi phạm Nghị định 13/2023 → Phạt 2-5% doanh thu hàng năm = $20K-$50K
- **Danh tiếng:** Khách hàng mất niềm tin, 20% cancel subscriptions
- **Rating: 5 (Severe)**

**Risk Score = 4 × 5 = 20 (HIGH - Không thể chấp nhận)**

#### Step 3: Đánh giá rủi ro

- Score = 20 > Ngưỡng chấp nhận (6)
- **Kết luận:** Phải xử lý ngay lập tức

#### Step 4: Xử lý rủi ro

**Treatment Option:** Reduce (Giảm thiểu)

**Kiểm soát triển khai:**

1. **A.8.13 - Information Backup**
   - Daily automated backup to AWS S3 (separate account)
   - Backup retention: 30 days daily, 12 months monthly
   - **Quan trọng:** Test restore hàng tháng, document kết quả
   - **Chi phí:** $200/tháng S3 storage

2. **A.8.24 - Use of Cryptography**
   - Enable encryption at rest cho RDS (AES-256)
   - Enable encryption in transit (SSL/TLS)
   - **Chi phí:** $0 (included in RDS)

3. **A.8.3 - Information Access Restriction**
   - Remove unnecessary admin access (10 users → 2 users)
   - Implement principle of least privilege
   - Quarterly access review
   - **Chi phí:** $0 (internal effort)

4. **A.8.8 - Management of Technical Vulnerabilities**
   - Deploy AWS Inspector cho vulnerability scanning
   - Patch critical CVEs trong 7 ngày
   - **Chi phí:** $300/tháng

5. **A.6.3 - Information Security Awareness**
   - Phishing simulation training (KnowBe4 hoặc tương tự)
   - Quarterly security awareness sessions
   - **Chi phí:** $500/năm

**Tổng chi phí triển khai:** ~$6,000/năm

#### Residual Risk (Rủi ro còn lại)

Sau khi triển khai các kiểm soát:
- **Likelihood giảm:** 4 → 2 (Unlikely, vì có backup tested + awareness training)
- **Impact giảm:** 5 → 4 (Major, vì có thể restore trong 24-48h thay vì 7 ngày)
- **Residual Risk Score = 2 × 4 = 8 (MEDIUM - Chấp nhận được với giám sát)**

**Chấp thuận:** CTO approved residual risk on 2026-02-14

#### Document trong Risk Register

```
Risk ID: R-001
Risk Title: Ransomware attack on customer database
Asset: AS-001 (Customer Database PostgreSQL)
Threat: Ransomware (LockBit, BlackCat)
Vulnerability: Untested backup, no encryption, lack of awareness

Inherent Risk: L=4, I=5, Score=20 (HIGH)

Treatment: Reduce
Controls Implemented:
  - A.8.13: Daily backup to S3, monthly restore testing
  - A.8.24: RDS encryption at rest (AES-256)
  - A.8.3: Least privilege access (10→2 admins)
  - A.8.8: AWS Inspector vulnerability scanning
  - A.6.3: Quarterly phishing training

Residual Risk: L=2, I=4, Score=8 (MEDIUM)
Status: Accepted by CTO on 2026-02-14

Owner: DevOps Lead
Deadline: 2026-03-31
Budget: $6,000/year
```

---

## Template và công cụ miễn phí

### 1. Risk Register Templates

**Excel/Google Sheets:**
- [UpGuard ISO 27001 Risk Assessment Template](https://www.upguard.com/blog/iso-27001-risk-assessment) - Free Excel với risk matrix
- [Glocert Risk Register Template](https://www.glocert.com/) - Đầy đủ likelihood/impact scales
- [ISMS.online Free Risk Assessment Tool](https://www.isms.online/) - 30-day free trial, sau đó export Excel

**Jira:**
Nếu công ty đã dùng Jira, có thể tạo:
- **Project:** "ISMS Risk Management"
- **Issue Type:** Risk (custom type)
- **Custom Fields:** Asset, Threat, Vulnerability, Likelihood, Impact, Score, Treatment, Status
- **Workflow:** Identified → Analyzed → Treated → Accepted/Mitigated

### 2. Công cụ đánh giá lỗ hổng (Vulnerability Assessment)

**Miễn phí:**
- **OWASP ZAP** - Web application security scanner
- **Trivy** - Container và IaC vulnerability scanner
- **Dependabot** (GitHub) - Dependency vulnerability alerts
- **AWS Inspector** - Free tier cho EC2 vulnerability scanning
- **Lynis** - Linux security auditing

**Trả phí (khuyến nghị cho SME):**
- **Qualys VMDR** - Comprehensive vulnerability management ($1,500/year)
- **Nessus Professional** - Network vulnerability scanner ($2,990/year)

### 3. GitHub Repositories với templates

Search GitHub cho "ISO 27001 toolkit":
- 100+ free templates (policies, procedures, risk registers)
- Markdown format, dễ customize
- Version control bằng Git

{{< callout type="info" >}}
**Tài nguyên hữu ích:**

**Templates miễn phí:**
- [ISO 27001 Templates GitHub](https://github.com/search?q=iso27001+templates) - 50+ repos với templates
- [OpenISMS](https://github.com/openisms) - Open-source ISMS documentation

**Công cụ:**
- **Jira** - Risk register + Issue tracking (đã có sẵn ở hầu hết SME)
- **Confluence** - Documentation (policies, procedures)
- **Google Sheets** - Risk matrix, asset register (miễn phí, collaborative)

**Đào tạo miễn phí:**
- Cybersecurity & Infrastructure Security Agency (CISA) - Free risk assessment training
- SANS Reading Room - White papers về risk management
{{< /callout >}}

---

## Kết luận & Bước tiếp theo

Chúc mừng! Bạn vừa hoàn thành phần **quan trọng nhất** của ISO 27001 implementation. Bây giờ bạn đã có:

### Deliverables từ giai đoạn này

- ✅ **Asset Register:** Danh sách 10-20 tài sản thông tin quan trọng nhất
- ✅ **Risk Assessment Methodology:** Định nghĩa likelihood/impact scales, risk matrix 5×5
- ✅ **Risk Register:** Danh sách 15-30 rủi ro với scoring
- ✅ **Risk Treatment Plan:** Kế hoạch cụ thể cho từng rủi ro (avoid/reduce/share/accept)
- ✅ **Ánh xạ rủi ro → Annex A controls:** Cơ sở cho Statement of Applicability

### Checklist tự kiểm tra

- [ ] Đã xác định ít nhất 15 rủi ro quan trọng
- [ ] Mỗi rủi ro có đầy đủ: Asset, Threat, Vulnerability, L, I, Score
- [ ] Đã phân loại rủi ro theo ngưỡng chấp nhận (Low/Medium/High)
- [ ] Đã chọn treatment option cho tất cả rủi ro Medium/High
- [ ] Risk Treatment Plan có owner, deadline, budget
- [ ] Mỗi rủi ro "Reduce" đã liên kết với ít nhất 1 kiểm soát Annex A
- [ ] Rủi ro "Accept" có lý do và phê duyệt từ lãnh đạo
- [ ] Tài liệu lưu trữ có version control (Google Drive/SharePoint/Git)

### Bước tiếp theo

Trong **Phần 4: Statement of Applicability (SoA)**, chúng ta sẽ:

- **Hiểu SoA là gì:** Tại sao đây là tài liệu quan trọng nhất khi audit
- **Đi qua 93 kiểm soát Annex A:** Phân tích từng control, quyết định Applicable/Not Applicable
- **Viết justification:** Lập luận tại sao chọn/không chọn từng kiểm soát
- **Ánh xạ controls với risks:** Link từ Risk Treatment Plan sang SoA
- **Template và ví dụ:** SoA hoàn chỉnh cho công ty phát triển phần mềm SME

👉 **[Đọc tiếp Phần 4: Xây dựng Tuyên bố Áp dụng (Statement of Applicability) →](/posts/iso27001-sme/04-tuyen-bo-ap-dung/)**

---

**Câu hỏi thường gặp:**

**Q: Phải đánh giá bao nhiêu rủi ro?**
A: Không có số tối thiểu. Thông thường SME 10-50 người có **15-30 rủi ro** là hợp lý. Đừng quá ít (<10, auditor sẽ nghi ngờ), đừng quá nhiều (>50, khó quản lý).

**Q: Bao lâu phải review lại risk assessment?**
A: ISO 27001 yêu cầu "định kỳ" (at planned intervals). Best practice cho SME: **6 tháng/lần** hoặc khi có thay đổi lớn (new service, new technology, major incident).

**Q: Residual risk phải bằng 0 không?**
A: **Không.** Rủi ro 0 là không thể. Mục tiêu là giảm xuống mức **chấp nhận được** (acceptable level). Ví dụ: từ score 20 xuống 8 là OK.

**Q: Nếu không đủ ngân sách để xử lý tất cả rủi ro High thì sao?**
A: Ưu tiên từng rủi ro theo ROI (return on investment). Xử lý những rủi ro có cost/benefit ratio tốt nhất trước. Những rủi ro còn lại có thể "Accept" **tạm thời** với justification rõ ràng và commitment sẽ xử lý trong 12 tháng tới. Auditor sẽ chấp nhận nếu bạn có roadmap cụ thể.
