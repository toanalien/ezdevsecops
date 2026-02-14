---
title: "ISO 27001 cho SME Phần 8: Đánh giá nội bộ và Cải tiến liên tục"
date: 2026-02-14
draft: false
description: "Hướng dẫn đánh giá nội bộ ISMS theo ISO 27001:2022 cho SME - lập kế hoạch audit, thực hiện audit, xử lý non-conformity, và management review"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "internal-audit", "management-review", "continual-improvement", "clause-9", "clause-10"]
series: ["ISO 27001 cho SME"]
weight: 8
mermaid: true
---

## Giới thiệu

Chúc mừng bạn đã đi được 8/10 chặng đường! Sau khi triển khai ISMS và các biện pháp kiểm soát, bây giờ là lúc kiểm tra xem hệ thống của bạn có thực sự hoạt động tốt hay không. **Đánh giá nội bộ (Internal Audit)** chính là "bài kiểm tra sức khỏe" định kỳ cho ISMS của bạn.

Internal audit không chỉ là yêu cầu bắt buộc của ISO 27001, mà còn là cơ hội vàng để phát hiện và sửa lỗi **trước khi auditor bên ngoài đến**. Hãy nghĩ về nó như việc chạy thử trước kỳ thi chính thức - bạn sẽ biết mình yếu ở đâu và còn thời gian để cải thiện.

{{< callout type="info" >}}
**Thông tin**: Đánh giá nội bộ giúp bạn phát hiện và sửa lỗi trước khi auditor bên ngoài đến. Đây là cơ hội để hoàn thiện ISMS và tăng tỷ lệ đỗ chứng nhận.
{{< /callout >}}

Trong phần này, chúng ta sẽ tìm hiểu:
- ✅ Yêu cầu của Clause 9 (Đánh giá hiệu suất) và Clause 10 (Cải tiến)
- ✅ Cách lập kế hoạch và thực hiện đánh giá nội bộ
- ✅ Xử lý các phát hiện không phù hợp (non-conformity)
- ✅ Tiến hành management review
- ✅ Xây dựng văn hóa cải tiến liên tục

### Thời gian ước tính
- **Lập kế hoạch audit**: 1-2 ngày
- **Thực hiện audit nội bộ**: 2-5 ngày (tùy quy mô)
- **Xử lý findings**: 1-4 tuần
- **Management review**: nửa ngày - 1 ngày

---

## Yêu cầu Clause 9: Đánh giá hiệu suất

Clause 9 của ISO 27001:2022 quy định tổ chức phải đánh giá hiệu suất và hiệu quả của ISMS. Đây là phần "Check" trong chu trình PDCA (Plan-Do-Check-Act).

### 9.1: Giám sát, đo lường, phân tích và đánh giá

Tổ chức phải xác định:
- **Cái gì** cần được giám sát và đo lường
- **Phương pháp** giám sát, đo lường, phân tích và đánh giá
- **Khi nào** thực hiện
- **Ai** thực hiện
- **Khi nào** phân tích và đánh giá kết quả

Ví dụ các metric cho SME:
- Số lượng sự cố bảo mật/tháng
- Thời gian phản ứng trung bình với sự cố
- Tỷ lệ hoàn thành đào tạo bảo mật
- Kết quả kiểm tra lỗ hổng bảo mật
- Uptime của hệ thống quan trọng
- Số lần vi phạm chính sách bảo mật

### 9.2: Đánh giá nội bộ

Tổ chức phải tiến hành đánh giá nội bộ theo các khoảng thời gian đã lập kế hoạch để cung cấp thông tin về ISMS có:
- Phù hợp với các yêu cầu của tổ chức và ISO 27001
- Được triển khai và duy trì một cách hiệu quả

**Yêu cầu bắt buộc:**
- Lập kế hoạch audit (audit program)
- Đảm bảo tính khách quan và độc lập của auditor
- Báo cáo kết quả audit cho lãnh đạo liên quan
- Lưu giữ hồ sơ làm bằng chứng

### 9.3: Management review

Lãnh đạo cấp cao phải xem xét ISMS của tổ chức theo các khoảng thời gian đã lập kế hoạch.

**Input bắt buộc:**
- Kết quả đánh giá nội bộ trước đó
- Phản hồi từ các bên liên quan
- Thông tin về hiệu suất bảo mật thông tin
- Phản hồi và xu hướng từ sự cố, non-conformity, corrective actions
- Kết quả giám sát và đo lường
- Cơ hội cải tiến

**Output bắt buộc:**
- Quyết định về cơ hội cải tiến liên tục
- Nhu cầu thay đổi ISMS
- Nhu cầu về nguồn lực

{{< mermaid >}}
graph TB
    subgraph "Clause 9: Performance Evaluation"
        A[9.1: Monitoring & Measurement] --> B[Thu thập dữ liệu metric]
        B --> C[Phân tích xu hướng]
        C --> D[9.2: Internal Audit]

        D --> E[Lập kế hoạch audit]
        E --> F[Thực hiện audit]
        F --> G[Báo cáo findings]
        G --> H[Corrective Actions]

        H --> I[9.3: Management Review]
        I --> J[Đánh giá hiệu quả ISMS]
        J --> K[Quyết định cải tiến]
        K --> L[Phân bổ nguồn lực]

        L --> M[Clause 10: Improvement]
        M --> N[Xử lý non-conformity]
        N --> O[Root cause analysis]
        O --> P[Triển khai corrective action]
        P --> Q[Kiểm tra hiệu quả]

        Q --> R[Cải tiến liên tục]
        R --> S[Cập nhật ISMS]
        S --> A
    end

    style D fill:#e1f5ff
    style I fill:#fff4e1
    style M fill:#ffe1e1
{{< /mermaid >}}

---

## Lập kế hoạch đánh giá nội bộ

Kế hoạch đánh giá nội bộ (Internal Audit Program) là tài liệu **bắt buộc** theo ISO 27001. Nó xác định phạm vi, tần suất, phương pháp và trách nhiệm cho các hoạt động audit.

### Xác định phạm vi và tần suất

**Phạm vi audit** cho SME thường bao gồm:
- Tất cả các clause từ 4-10 của ISO 27001
- Tất cả các biện pháp kiểm soát trong Statement of Applicability
- Tất cả các đơn vị/phòng ban trong phạm vi ISMS
- Các quy trình và tài liệu bắt buộc

**Tần suất audit:**
- **Năm đầu tiên** (trước chứng nhận): ít nhất 1 lần đánh giá toàn bộ ISMS
- **Sau chứng nhận**: ít nhất 1 lần/năm cho toàn bộ ISMS
- **Audit bổ sung**: khi có thay đổi lớn, sau sự cố nghiêm trọng, hoặc theo yêu cầu management

### Template: Kế hoạch Đánh giá nội bộ 2026

| Khu vực/Quy trình | Clause/Control | Auditor | Ngày dự kiến | Trạng thái | Ghi chú |
|-------------------|----------------|---------|--------------|------------|---------|
| Bối cảnh tổ chức | Clause 4.1-4.4 | Nguyễn Văn A | 15/03/2026 | Chưa thực hiện | Audit toàn bộ scope |
| Leadership & Policy | Clause 5.1-5.3 | Trần Thị B | 15/03/2026 | Chưa thực hiện | Interview CEO/CTO |
| Lập kế hoạch | Clause 6.1-6.3 | Nguyễn Văn A | 20/03/2026 | Chưa thực hiện | Xem xét risk assessment |
| Hỗ trợ (nguồn lực, năng lực) | Clause 7.1-7.5 | Trần Thị B | 20/03/2026 | Chưa thực hiện | Kiểm tra training records |
| Vận hành | Clause 8.1-8.3 | Nguyễn Văn A | 25/03/2026 | Chưa thực hiện | Kiểm tra change management |
| Access control | A.5.15-5.18, A.8.2-8.5 | Trần Thị B | 27/03/2026 | Chưa thực hiện | Test user provisioning |
| Cryptography | A.8.24 | Nguyễn Văn A | 27/03/2026 | Chưa thực hiện | Xem xét encryption policy |
| Physical security | A.7.1-7.14 | Trần Thị B | 01/04/2026 | Chưa thực hiện | On-site inspection |
| Operations security | A.8.1-8.34 | Nguyễn Văn A | 03/04/2026 | Chưa thực hiện | Review logs & backups |
| Communications security | A.5.9-5.14 | Trần Thị B | 03/04/2026 | Chưa thực hiện | Test network segmentation |
| Incident management | A.5.24-5.28 | Nguyễn Văn A | 08/04/2026 | Chưa thực hiện | Review incident logs |
| Supplier security | A.5.19-5.23 | Trần Thị B | 08/04/2026 | Chưa thực hiện | Audit supplier contracts |
| Management review | Clause 9.3 | Nguyễn Văn A | 10/04/2026 | Chưa thực hiện | Review last meeting records |

### Đảm bảo tính độc lập của auditor

{{< callout type="warning" >}}
**Cảnh báo**: Người đánh giá không được tự đánh giá công việc của chính mình - phải đảm bảo tính độc lập và khách quan.
{{< /callout >}}

**Nguyên tắc độc lập:**
- Auditor **không được** audit công việc mà chính họ chịu trách nhiệm
- Ví dụ: IT Manager không được audit các biện pháp kiểm soát IT mà họ triển khai

**Giải pháp cho SME:**

1. **Cross-audit giữa các phòng ban:**
   - HR Manager audit IT controls
   - IT Manager audit HR/Admin controls
   - Operations Manager audit business processes

2. **Thuê auditor bên ngoài:**
   - Cho các khu vực quan trọng hoặc nhạy cảm
   - Khi thiếu chuyên môn nội bộ
   - Khi không thể đảm bảo độc lập (công ty quá nhỏ)
   - Chi phí: $5,000-$15,000 cho audit đầy đủ

3. **Hybrid approach:**
   - Nhân viên nội bộ audit các phần đơn giản
   - Chuyên gia bên ngoài audit các phần kỹ thuật/phức tạp

---

## Thực hiện đánh giá nội bộ

### Quy trình 6 bước

{{< mermaid >}}
graph TD
    A[1. Opening Meeting] --> B[Giới thiệu team audit]
    B --> C[Giải thích mục đích & phạm vi]
    C --> D[Xác nhận lịch trình]

    D --> E[2. Document Review]
    E --> F[Xem xét chính sách & quy trình]
    F --> G[Kiểm tra tài liệu bắt buộc]
    G --> H[So sánh với yêu cầu ISO 27001]

    H --> I[3. Interviews]
    I --> J[Phỏng vấn nhân viên]
    J --> K[Kiểm tra hiểu biết về vai trò]
    K --> L[Xác minh đào tạo awareness]

    L --> M[4. Evidence Examination]
    M --> N[Kiểm tra logs & records]
    N --> O[Test thực tế controls]
    O --> P[Xác minh implementation]

    P --> Q[5. Finding Classification]
    Q --> R{Phát hiện vấn đề?}
    R -->|Có| S[Major NC]
    R -->|Có| T[Minor NC]
    R -->|Có| U[Observation]
    R -->|Không| V[Conformity]

    S --> W[6. Closing Meeting]
    T --> W
    U --> W
    V --> W

    W --> X[Trình bày findings]
    X --> Y[Giải thích evidence]
    Y --> Z[Thống nhất corrective actions]
    Z --> AA[Ký audit report]
{{< /mermaid >}}

### Bước 1: Opening Meeting (15-30 phút)

**Mục đích:**
- Giới thiệu audit team và auditee
- Xác nhận mục đích, phạm vi, tiêu chí audit
- Giải thích phương pháp và lịch trình
- Trả lời câu hỏi

**Ai tham dự:**
- Lead auditor
- Audit team members
- Auditee representatives (người chịu trách nhiệm khu vực được audit)
- Management representative (nếu cần)

### Bước 2: Document Review

**Tài liệu cần xem xét:**
- Chính sách bảo mật thông tin
- Quy trình liên quan đến khu vực audit
- Risk assessment & treatment plan
- Statement of Applicability
- Training records
- Incident logs
- Change management records
- Access review logs
- Backup & recovery logs

**Câu hỏi cần trả lời:**
- ✅ Tài liệu có đầy đủ và cập nhật?
- ✅ Quy trình có tuân thủ yêu cầu ISO 27001?
- ✅ Có bằng chứng approval từ lãnh đạo?
- ✅ Có lịch xem xét định kỳ?

### Bước 3: Interviews với nhân viên

{{< callout type="tip" >}}
**Mẹo**: Chuẩn bị danh sách câu hỏi theo từng clause - giúp audit có cấu trúc và không bỏ sót nội dung quan trọng.
{{< /callout >}}

**Câu hỏi mẫu theo Clause:**

**Clause 5 (Leadership):**
- Bạn có biết chính sách bảo mật thông tin của công ty không?
- Ai chịu trách nhiệm về ISMS trong tổ chức?
- Bạn có được phân công vai trò và trách nhiệm về bảo mật không?

**Clause 6 (Planning):**
- Làm thế nào công ty xác định rủi ro bảo mật?
- Bạn có được tham gia vào việc đánh giá rủi ro không?
- Ai quyết định biện pháp xử lý rủi ro?

**Clause 7 (Support):**
- Bạn có được đào tạo về bảo mật thông tin không? Khi nào?
- Bạn biết cách báo cáo sự cố bảo mật không?
- Bạn có quyền truy cập vào hệ thống nào? Đã được phê duyệt chưa?

**Clause 8 (Operation):**
- Khi thay đổi hệ thống, bạn làm theo quy trình nào?
- Backup được thực hiện như thế nào và bao lâu một lần?
- Bạn có kiểm tra backup thường xuyên không?

**Controls (A.5-A.8):**
- Mật khẩu của bạn đáp ứng yêu cầu chính sách không? (không yêu cầu tiết lộ)
- Bạn có khóa máy tính khi rời khỏi bàn làm việc không?
- Bạn có mã hóa dữ liệu nhạy cảm trước khi gửi email không?

### Bước 4: Evidence Examination

**Kiểm tra thực tế:**
- Truy cập hệ thống để test access controls
- Xem xét logs (authentication, security events, system logs)
- Kiểm tra physical security (khóa cửa, camera, visitor logs)
- Test backup restore process
- Xem xét firewall rules, network segmentation
- Kiểm tra antivirus/endpoint protection status

**Thu thập bằng chứng:**
- Screenshots
- Log files exports
- Photos (physical security)
- Configuration files (sanitized)
- Records và forms đã hoàn thành

### Bước 5: Finding Classification

| Loại Finding | Định nghĩa | Ví dụ | Hành động yêu cầu |
|--------------|-----------|-------|-------------------|
| **Major Non-conformity** | Vi phạm nghiêm trọng yêu cầu ISO 27001, hoặc control hoàn toàn không được triển khai | Không có risk assessment; không có internal audit; không có management review | Phải corrective action ngay, xác minh hiệu quả trước Stage 2 |
| **Minor Non-conformity** | Vi phạm một phần yêu cầu, hoặc lỗi đơn lẻ | Một số nhân viên chưa được đào tạo; một vài tài liệu chưa được approve; backup test không đầy đủ | Corrective action plan, xác minh tại surveillance audit |
| **Observation** | Không phải non-conformity nhưng có tiềm năng trở thành vấn đề | Quy trình chưa tối ưu; tài liệu khó hiểu; metric chưa được phân tích thường xuyên | Không bắt buộc, nhưng nên cải tiến |
| **Opportunity for Improvement** | Cơ hội cải thiện hiệu quả ISMS | Tự động hóa quy trình manual; consolidate tài liệu; tăng tần suất training | Tùy chọn, xem xét trong management review |

### Template: Audit Finding Form

| Field | Mô tả |
|-------|-------|
| **Finding #** | AF-2026-001 |
| **Date** | 15/03/2026 |
| **Auditor** | Nguyễn Văn A |
| **Area/Process** | User Access Management |
| **Clause/Control** | A.5.18: Access rights |
| **Severity** | Minor Non-conformity |
| **Description** | Phát hiện 5 tài khoản nhân viên đã nghỉ việc vẫn còn active trong hệ thống ERP. Tài khoản chưa bị vô hiệu hóa sau khi nhân viên rời công ty (vi phạm quy trình offboarding). |
| **Evidence** | - Screenshot user list từ ERP system (15/03/2026)<br>- HR termination list (nhân viên nghỉ từ 01/01-01/03/2026)<br>- So sánh cho thấy 5/12 tài khoản không được deactivate |
| **Root Cause** | Không có quy trình tự động thông báo từ HR sang IT khi nhân viên nghỉ việc. IT phụ thuộc vào email manual từ HR (đôi khi bị bỏ sót). |
| **Corrective Action** | 1. Deactivate 5 tài khoản ngay lập tức (hoàn thành: 16/03/2026)<br>2. Tạo checklist offboarding chính thức (deadline: 30/03/2026)<br>3. Thiết lập shared spreadsheet HR-IT để track terminations (deadline: 30/03/2026)<br>4. Review tất cả user accounts để tìm orphan accounts khác (deadline: 15/04/2026) |
| **Responsible Person** | Lê Văn C (IT Manager) |
| **Due Date** | 15/04/2026 |
| **Follow-up** | Sẽ xác minh tại management review 10/04/2026 |

### Bước 6: Closing Meeting (30-60 phút)

**Nội dung:**
- Tóm tắt phạm vi và hoạt động audit
- Trình bày findings (Major NC, Minor NC, Observations)
- Giải thích evidence hỗ trợ từng finding
- Thảo luận timeline cho corrective actions
- Trả lời câu hỏi từ auditee
- Cảm ơn sự hợp tác

**Kết quả:**
- Audit report ký bởi lead auditor và auditee
- Danh sách corrective actions với deadline
- Lịch follow-up audit (nếu cần)

---

## Xử lý Non-conformity (Clause 10)

Clause 10 của ISO 27001 yêu cầu tổ chức phải:
- Phản ứng với non-conformity và thực hiện corrective action
- Đánh giá nhu cầu hành động để loại bỏ nguyên nhân gốc rễ
- Thực hiện corrective action cần thiết
- Xem xét hiệu quả của corrective action
- Cập nhật rủi ro và cơ hội nếu cần
- Thay đổi ISMS nếu cần

### Quy trình Corrective Action

{{< mermaid >}}
graph TD
    A[Phát hiện Non-conformity] --> B[Ghi nhận & Mô tả]
    B --> C{Severity?}

    C -->|Major| D[Immediate Action]
    C -->|Minor| E[Plan Correction]

    D --> F[Root Cause Analysis]
    E --> F

    F --> G[5 Whys Technique]
    G --> H[Xác định nguyên nhân gốc]

    H --> I[Định nghĩa Corrective Action]
    I --> J[Phân công trách nhiệm]
    J --> K[Đặt deadline]

    K --> L[Triển khai Corrective Action]
    L --> M[Cập nhật quy trình/tài liệu]
    M --> N[Đào tạo nhân viên liên quan]

    N --> O[Kiểm tra hiệu quả]
    O --> P{Hiệu quả?}

    P -->|Có| Q[Đóng CAR]
    P -->|Không| R[Xem xét lại root cause]
    R --> F

    Q --> S[Lưu records]
    S --> T[Báo cáo Management Review]
{{< /mermaid >}}

### Kỹ thuật 5 Whys - Root Cause Analysis

**Ví dụ thực tế:**

**Non-conformity:** 5 tài khoản nhân viên đã nghỉ việc vẫn còn active

**Why #1:** Tại sao tài khoản không bị deactivate?
- Vì IT không nhận được thông báo từ HR

**Why #2:** Tại sao IT không nhận được thông báo?
- Vì quy trình offboarding không có bước bắt buộc HR thông báo IT

**Why #3:** Tại sao quy trình không có bước này?
- Vì quy trình offboarding chỉ tập trung vào HR tasks (thu hồi tài sản, exit interview), không liên quan đến IT

**Why #4:** Tại sao IT không được bao gồm trong quy trình?
- Vì khi thiết kế quy trình offboarding, HR và IT không cùng ngồi lại để map toàn bộ tasks cần thiết

**Why #5:** Tại sao các phòng ban không collaboration khi thiết kế quy trình?
- Vì không có culture review quy trình cross-functional, mỗi phòng ban tự thiết kế quy trình riêng

**Root Cause:** Thiếu collaboration cross-functional khi thiết kế quy trình, dẫn đến gaps giữa các phòng ban

**Corrective Action:**
- Ngắn hạn: Tạo checklist offboarding có bước IT deactivate accounts
- Dài hạn: Thiết lập quarterly cross-functional review cho tất cả quy trình quan trọng

{{< callout type="danger" >}}
**Nguy hiểm**: Non-conformity chưa được xử lý = rào cản chứng nhận. Phải giải quyết hoàn toàn trước Stage 2 audit (đặc biệt Major NC).
{{< /callout >}}

### Template: Corrective Action Request (CAR)

```
CAR #: CAR-2026-001
Ngày phát hiện: 15/03/2026
Phát hiện bởi: Internal Audit
Liên quan đến: Finding AF-2026-001

NON-CONFORMITY:
5 tài khoản user của nhân viên đã nghỉ việc vẫn còn active trong hệ thống ERP,
vi phạm control A.5.18 (Access rights) và quy trình offboarding.

ROOT CAUSE ANALYSIS (5 Whys):
1. Tài khoản không bị deactivate vì IT không nhận thông báo
2. IT không nhận thông báo vì quy trình offboarding không có bước này
3. Quy trình không có bước vì chỉ tập trung HR tasks
4. IT không được bao gồm vì thiếu collaboration khi design
5. Thiếu collaboration vì không có culture review cross-functional

NGUYÊN NHÂN GỐC RỄ:
Thiếu quy trình review cross-functional dẫn đến gaps giữa phòng ban

CORRECTIVE ACTION:
1. Immediate (hoàn thành 16/03/2026):
   - Deactivate 5 tài khoản ngay
   - Review toàn bộ user accounts để tìm orphan accounts khác

2. Short-term (hoàn thành 30/03/2026):
   - Tạo offboarding checklist với IT tasks
   - Thiết lập shared tracker HR-IT cho terminations

3. Long-term (hoàn thành 30/04/2026):
   - Establish quarterly cross-functional process review
   - Map tất cả quy trình quan trọng với dependencies giữa phòng ban
   - Update ISMS documentation để include cross-functional review requirement

NGƯỜI CHỊU TRÁCH NHIỆM: Lê Văn C (IT Manager)
DUE DATE: 30/04/2026 (hoàn toàn)

VERIFICATION:
- Date: 05/05/2026
- Method: Re-audit user accounts, review new offboarding checklist records
- Result: [Sẽ cập nhật]
- Effective: [Yes/No]

STATUS: In Progress
```

---

## Management Review (Clause 9.3)

Management review là cuộc họp định kỳ của lãnh đạo cấp cao để xem xét hiệu quả ISMS và quyết định cải tiến. Đây là yêu cầu **bắt buộc** và phải có sự tham gia của top management.

{{< callout type="info" >}}
**Thông tin**: Management review phải có sự tham gia của lãnh đạo cấp cao (CEO/CTO/founders cho SME) - đây là yêu cầu bắt buộc của ISO 27001.
{{< /callout >}}

### Ai phải tham dự?

**Bắt buộc:**
- Top management (CEO, Managing Director)
- Information Security Manager / ISMS Owner
- CTO / IT Director (nếu có)

**Nên tham dự:**
- Head of departments trong phạm vi ISMS
- HR Manager (cho training, awareness topics)
- Compliance Officer (nếu có)

### Input bắt buộc (Clause 9.3.2)

ISO 27001 yêu cầu management review phải xem xét:

1. **Status của actions từ management review trước**
   - Corrective actions đã hoàn thành chưa?
   - Improvement initiatives tiến độ như thế nào?

2. **Thay đổi trong các vấn đề nội bộ và bên ngoài liên quan đến ISMS**
   - Thay đổi cấu trúc tổ chức
   - Thay đổi công nghệ
   - Thay đổi luật pháp (ví dụ: Decree 13/2023)
   - Thay đổi mối đe dọa bảo mật

3. **Feedback về hiệu suất bảo mật thông tin**
   - Số lượng sự cố bảo mật
   - Kết quả monitoring và measurement
   - Compliance với legal/regulatory requirements

4. **Feedback từ các bên liên quan**
   - Khách hàng, đối tác
   - Nhân viên
   - Cơ quan quản lý

5. **Kết quả đánh giá rủi ro và status của risk treatment plan**
   - Rủi ro mới xuất hiện
   - Rủi ro đã được xử lý hiệu quả chưa

6. **Cơ hội cải tiến liên tục**
   - Từ internal audit findings
   - Từ lessons learned của incidents
   - Từ industry best practices mới

### Output bắt buộc (Clause 9.3.3)

Management review phải tạo ra quyết định liên quan đến:

1. **Cơ hội cải tiến liên tục**
   - Quy trình nào cần optimize
   - Controls nào cần strengthen

2. **Nhu cầu thay đổi ISMS**
   - Cập nhật scope
   - Revise policies, procedures
   - Thay đổi risk treatment decisions

3. **Nhu cầu về nguồn lực**
   - Budget cho security tools
   - Nhân sự bổ sung
   - Training budget

### Template: Management Review Agenda

```
MANAGEMENT REVIEW MEETING
ISO 27001:2022 ISMS

Date: 10/04/2026
Time: 09:00 - 12:00
Location: Meeting Room A / Zoom
Chair: Nguyễn Văn Đức (CEO)
Secretary: Lê Thị Hoa (ISM)

ATTENDEES:
- Nguyễn Văn Đức (CEO)
- Trần Văn Bình (CTO)
- Lê Thị Hoa (Information Security Manager)
- Phạm Văn Khánh (Operations Manager)
- Nguyễn Thị Lan (HR Manager)

AGENDA:

1. Opening (5 phút)
   - Giới thiệu mục đích meeting
   - Xác nhận agenda

2. Review of Previous Actions (15 phút)
   - Status các action items từ management review 10/10/2025
   - Corrective actions từ internal audit Q4/2025

3. Changes Affecting ISMS (20 phút)
   - Thay đổi tổ chức: mở văn phòng mới tại Hà Nội (01/2026)
   - Thay đổi công nghệ: migrate lên AWS (02/2026)
   - Thay đổi pháp lý: Decree 13/2023 compliance status

4. Information Security Performance (30 phút)
   - Security incidents Q1/2026: 3 incidents (1 medium, 2 low)
   - Key metrics:
     * Uptime: 99.7% (target: 99.5%)
     * Backup success rate: 100%
     * Training completion: 95% (target: 100%)
     * Vulnerability patching: 92% within SLA
   - Compliance status: ISO 27001, Decree 13/2023

5. Feedback from Interested Parties (15 phút)
   - Customer feedback: 2 requests về data residency
   - Employee feedback: request VPN for remote work
   - Partner audit findings: none

6. Internal Audit Results (30 phút)
   - Audit conducted: 15-20/03/2026
   - Findings:
     * 0 Major NC
     * 3 Minor NC
     * 5 Observations
   - Corrective actions status

7. Risk Assessment Review (20 phút)
   - Rủi ro mới: ransomware targeting industry
   - Risk treatment status: 85% completed
   - Residual risks acceptable?

8. Opportunities for Improvement (20 phút)
   - Proposal: Implement SIEM tool
   - Proposal: Automate user provisioning
   - Proposal: Quarterly security awareness phishing tests

9. Decisions & Actions (20 phút)
   - Approve budget $15k cho SIEM tool
   - Approve hire 1 Security Analyst (Q3/2026)
   - Update ISMS scope để bao gồm Hà Nội office
   - Schedule next management review: 10/10/2026

10. Closing (5 phút)
```

### Template: Management Review Minutes

```
MANAGEMENT REVIEW MEETING MINUTES
ISO 27001:2022 ISMS

Meeting Date: 10/04/2026
Meeting Time: 09:00 - 12:00
Location: Meeting Room A

ATTENDEES:
Present:
- Nguyễn Văn Đức (CEO) - Chair
- Trần Văn Bình (CTO)
- Lê Thị Hoa (Information Security Manager) - Secretary
- Phạm Văn Khánh (Operations Manager)
- Nguyễn Thị Lan (HR Manager)

Absent: None

1. PREVIOUS ACTIONS REVIEW

| Action | Owner | Due Date | Status | Notes |
|--------|-------|----------|--------|-------|
| Implement MFA for all users | IT Team | 31/12/2025 | ✅ Complete | Deployed 15/12/2025 |
| Update BCP annually | Ops Manager | 31/01/2026 | ✅ Complete | Updated 20/01/2026 |
| Increase training frequency | HR | 01/03/2026 | ⚠️ In Progress | Scheduled for Q2/2026 |

2. CHANGES AFFECTING ISMS

- **Organizational:** Opened Hanoi office (20 employees) on 15/01/2026
  - Decision: Extend ISMS scope to include Hanoi office by 30/06/2026
  - Action: Update scope document, conduct risk assessment for new office

- **Technology:** Migrated production systems to AWS on 01/02/2026
  - Decision: Update asset inventory and risk assessment
  - Action: Review AWS security controls, update SoA

- **Legal:** Decree 13/2023 compliance
  - Status: PDPIA submitted to Department of Cybersecurity on 20/03/2026
  - Action: Monitor for guidance updates

3. INFORMATION SECURITY PERFORMANCE

Security Incidents Q1/2026:
- Total: 3 incidents (1 medium severity, 2 low)
- Incident #2026-001 (Medium): Phishing email clicked by 1 user, credentials compromised
  - Response: Password reset within 2 hours, additional training conducted
- All incidents resolved within SLA

Key Performance Indicators:
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| System uptime | 99.5% | 99.7% | ✅ Met |
| Backup success rate | 100% | 100% | ✅ Met |
| Security training completion | 100% | 95% | ⚠️ Below |
| Patch deployment (critical) | 100% within 7 days | 92% | ⚠️ Below |

Decision: Improve training completion and patching compliance

4. INTERNAL AUDIT RESULTS

Audit Date: 15-20/03/2026
Auditor: External consultant (ABC Security Co.)

Findings Summary:
- Major Non-conformities: 0
- Minor Non-conformities: 3
  - MNC-001: 5 orphan user accounts found
  - MNC-002: Backup restore test not documented for Q4/2025
  - MNC-003: 5 employees not completed mandatory training
- Observations: 5 (automation opportunities)

Corrective Actions: All MNCs have action plans, due by 30/04/2026

Decision: Accept CAR plans, verify at next review

5. RISK ASSESSMENT REVIEW

New Risks Identified:
- R-2026-015: Ransomware targeting software companies in Vietnam (High)
  - Treatment: Implement SIEM tool, enhance backup testing

Risk Treatment Status:
- 85% of planned treatments completed
- 3 treatments delayed due to budget (approved today)

Decision: All residual risks accepted by management

6. OPPORTUNITIES FOR IMPROVEMENT

Approved Improvements:
1. **SIEM Implementation**
   - Budget: $15,000
   - Owner: CTO
   - Timeline: Q2/2026

2. **User Provisioning Automation**
   - Budget: $5,000
   - Owner: IT Manager
   - Timeline: Q3/2026

3. **Quarterly Phishing Tests**
   - Budget: $2,000/year
   - Owner: ISM
   - Timeline: Start Q2/2026

7. DECISIONS & ACTIONS

| Decision/Action | Owner | Due Date | Priority |
|----------------|-------|----------|----------|
| Approve SIEM budget ($15k) | CFO | Immediate | High |
| Approve Security Analyst hire | HR | 01/07/2026 | High |
| Update ISMS scope for Hanoi office | ISM | 30/06/2026 | High |
| Conduct Hanoi office risk assessment | ISM | 31/05/2026 | High |
| Improve training completion to 100% | HR | 30/06/2026 | Medium |
| Enhance patch management process | IT | 30/05/2026 | Medium |
| Schedule next management review | ISM | 10/10/2026 | Low |

8. RESOURCE NEEDS

Approved Resources:
- Budget: $22,000 for security tools (SIEM, automation, phishing tests)
- Headcount: 1 Security Analyst (Q3/2026)
- Training: Additional security awareness budget $5,000

9. CONTINUAL IMPROVEMENT COMMITMENT

Management reaffirms commitment to continual improvement of ISMS effectiveness.
All decisions and actions documented above will be tracked and reviewed at next meeting.

NEXT MANAGEMENT REVIEW: 10/10/2026

Meeting adjourned: 12:00

APPROVAL:
Chair: _________________________ Date: _________
       Nguyễn Văn Đức (CEO)

Secretary: ______________________ Date: _________
           Lê Thị Hoa (ISM)
```

---

## Cải tiến liên tục

ISO 27001 không chỉ yêu cầu duy trì ISMS mà còn phải **liên tục cải tiến** (continual improvement). Đây là tinh thần của chu trình PDCA.

### Chu trình PDCA cho ISMS

{{< mermaid >}}
graph LR
    subgraph "PLAN - Lập kế hoạch"
        A[Establish ISMS scope] --> B[Risk assessment]
        B --> C[Risk treatment plan]
        C --> D[Select controls - SoA]
    end

    subgraph "DO - Thực hiện"
        D --> E[Implement controls]
        E --> F[Train employees]
        F --> G[Operate ISMS]
    end

    subgraph "CHECK - Kiểm tra"
        G --> H[Monitor & measure]
        H --> I[Internal audit]
        I --> J[Management review]
    end

    subgraph "ACT - Hành động"
        J --> K[Corrective actions]
        K --> L[Improvement decisions]
        L --> M[Update ISMS]
    end

    M --> N{Cycle lại}
    N --> A

    style A fill:#e3f2fd
    style E fill:#fff3e0
    style H fill:#f3e5f5
    style K fill:#e8f5e9
{{< /mermaid >}}

### Nguồn cải tiến

**1. Từ Internal Audit:**
- Observations và opportunities for improvement
- Process inefficiencies phát hiện
- Best practices từ auditor suggestions

**2. Từ Incidents:**
- Root cause analysis findings
- Lessons learned
- Near-miss events

**3. Từ Feedback:**
- Employee suggestions
- Customer requirements
- Partner audit findings
- Industry trends

**4. Từ Metrics:**
- Performance indicators trends
- SLA violations
- Security event patterns

### Theo dõi cải tiến

{{< callout type="tip" >}}
**Mẹo**: Tạo bảng theo dõi cải tiến - ghi lại mọi thay đổi và kết quả để chứng minh ISMS đang cải thiện theo thời gian.
{{< /callout >}}

**Template: Improvement Tracker**

| ID | Nguồn | Cải tiến | Lý do | Owner | Start | Complete | Kết quả đo được |
|----|-------|----------|-------|-------|-------|----------|----------------|
| IMP-001 | Internal Audit | Tự động user provisioning | Giảm lỗi manual, tăng tốc độ | IT Mgr | 01/04/26 | 30/06/26 | Provisioning time: 3 days → 2 hours |
| IMP-002 | Incident #2026-001 | Quarterly phishing tests | Tăng awareness | ISM | 01/05/26 | Ongoing | Click rate: 15% → target <5% |
| IMP-003 | Management Review | Implement SIEM | Improve detection | CTO | 01/04/26 | 30/06/26 | Detection time: 48h → target 4h |
| IMP-004 | Employee feedback | Deploy VPN for remote | Secure remote access | IT Mgr | 15/04/26 | 15/05/26 | 100% remote workers use VPN |
| IMP-005 | Metrics analysis | Enhance patch mgmt | Tăng compliance từ 92% | IT Mgr | 01/05/26 | 31/05/26 | Compliance: 92% → target 98% |

**Cách sử dụng:**
- Review tracker hàng tháng trong team meeting
- Báo cáo trong management review
- Chứng minh continual improvement cho auditor
- Xác định improvement có hiệu quả không (bằng metrics)

---

## Chi phí đánh giá nội bộ

### Option 1: Tự thực hiện (DIY)

**Chi phí:**
- Nhân sự: 2-5 ngày cho auditor (salary cost)
- Training: $500-$1,000 cho auditor training course
- Tổng: ~$2,000-$5,000 (chủ yếu staff time)

**Phù hợp khi:**
- Có nhân viên có kỹ năng audit
- Có thể đảm bảo independence (cross-audit)
- Budget hạn chế
- Muốn build internal capability

**Rủi ro:**
- Thiếu kinh nghiệm → miss findings
- Bias (quen biết đồng nghiệp)
- Không đủ technical depth

### Option 2: Thuê auditor bên ngoài

**Chi phí:**
- External auditor: $5,000-$15,000 cho full ISMS audit
- Auditor day rate: ~$1,500/day
- Typical 3-5 days cho SME

**Phù hợp khi:**
- Lần audit đầu tiên
- Thiếu expertise nội bộ
- Không đảm bảo independence
- Cần objective assessment trước certification

**Ưu điểm:**
- Professional expertise
- Objective perspective
- Comprehensive findings
- "Mock certification audit" experience

### Option 3: Hybrid

**Cách thực hiện:**
- Internal team audit các phần đơn giản (policies, training, documentation)
- External expert audit các phần kỹ thuật (infrastructure, controls implementation)

**Chi phí:**
- External: $2,000-$5,000 (1-2 days cho technical areas)
- Internal: 2-3 days staff time

**Phù hợp khi:**
- Muốn cân bằng cost và quality
- Có một số capability nội bộ
- Cần expert review cho critical areas

### So sánh

| Yếu tố | DIY | External | Hybrid |
|--------|-----|----------|--------|
| **Cost** | $2k-$5k | $5k-$15k | $3k-$8k |
| **Quality** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Independence** | ⚠️ Risk | ✅ Strong | ✅ Good |
| **Learning** | ✅ High | ⭐ Low | ⭐⭐⭐ Medium |
| **Timeline** | 1-2 weeks | 2-3 weeks | 2 weeks |
| **Best for** | Subsequent audits | First audit | Most SMEs |

**Khuyến nghị cho SME:**
- **First year:** External or Hybrid (build foundation)
- **Subsequent years:** DIY or Hybrid (cost savings)
- **Before certification:** External review (mock audit)

---

## Kết luận & Bước tiếp theo

Đánh giá nội bộ và cải tiến liên tục là trái tim của ISMS. Chúng đảm bảo hệ thống của bạn không chỉ tồn tại trên giấy tờ mà thực sự hoạt động và ngày càng tốt hơn.

### Checklist sẵn sàng audit

**Trước khi bắt đầu internal audit:**

- [ ] Audit program đã được approve bởi management
- [ ] Auditor đã được chỉ định (đảm bảo independence)
- [ ] Auditor đã được đào tạo về ISO 27001 và audit techniques
- [ ] Audit checklist/questions đã được chuẩn bị theo từng clause
- [ ] Lịch audit đã được thông báo cho auditee (ít nhất 2 tuần trước)
- [ ] Audit report templates đã sẵn sàng
- [ ] Phòng họp và resources đã được book

**Trong quá trình audit:**

- [ ] Opening meeting đã thực hiện
- [ ] Tất cả mandatory documents đã được review
- [ ] Interviews với representatives từ mỗi phòng ban
- [ ] Evidence đã được thu thập và ghi chép
- [ ] Findings đã được classify (Major/Minor/Observation)
- [ ] Closing meeting đã present findings
- [ ] Audit report đã được ký

**Sau audit:**

- [ ] Corrective Action Requests đã được issue
- [ ] Root cause analysis đã thực hiện cho mọi NC
- [ ] Corrective actions đã được triển khai
- [ ] Hiệu quả của CARs đã được verify
- [ ] Kết quả đã được báo cáo trong management review
- [ ] Lessons learned đã được document
- [ ] ISMS documents đã được update (nếu cần)

### Bước tiếp theo

Xin chúc mừng! Bạn đã hoàn thành việc vận hành và kiểm tra ISMS. Giờ là lúc chuẩn bị cho **đích đến cuối cùng: Chứng nhận ISO 27001**.

👉 **[Phần 9: Chuẩn bị đánh giá chứng nhận ISO 27001](/posts/iso27001-sme/09-chuan-bi-chung-nhan/)** sẽ hướng dẫn bạn:
- Chọn tổ chức chứng nhận phù hợp tại Việt Nam
- Hiểu quy trình Stage 1 và Stage 2 audit
- Chuẩn bị để đạt chứng nhận
- Chi phí và timeline certification

**Các phần trước:**
- [Phần 7: Đào tạo nhận thức bảo mật và Quản lý nhân sự](/posts/iso27001-sme/07-dao-tao-nhan-su/)

---

**Tài liệu tham khảo:**
- ISO/IEC 27001:2022 Clause 9 & 10
- ISO 19011:2018 - Guidelines for auditing management systems
- ISO/IEC 27007:2020 - Guidelines for ISMS auditing
