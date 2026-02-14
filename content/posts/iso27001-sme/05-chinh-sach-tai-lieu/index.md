---
title: "ISO 27001 cho SME Phần 5: Xây dựng Chính sách và Tài liệu ISMS"
date: 2026-02-14
draft: false
description: "Hướng dẫn tạo bộ tài liệu ISMS bắt buộc theo ISO 27001:2022 - chính sách bảo mật, quy trình, biểu mẫu với template sẵn dùng cho SME"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "isms", "policy", "documentation", "chinh-sach", "tai-lieu"]
series: ["ISO 27001 cho SME"]
weight: 5
mermaid: true
---

## Giới thiệu

Sau khi hoàn thành SoA trong [Phần 4](/posts/iso27001-sme/04-tuyen-bo-ap-dung/), bước tiếp theo là xây dựng **bộ tài liệu ISMS** - xương sống của hệ thống quản lý bảo mật thông tin. Tài liệu ISMS không chỉ là yêu cầu bắt buộc cho chứng nhận mà còn là công cụ thực tế để vận hành ISMS hàng ngày.

Thách thức lớn nhất với SME: **cân bằng giữa đủ tài liệu để đạt compliance và không quá nhiều đến mức không quản lý nổi**. Nhiều tổ chức nhỏ thất bại vì tạo quá nhiều tài liệu phức tạp mà không ai đọc hoặc tuân thủ.

{{< callout type="warning" >}}
**Cảnh báo**: Thiếu tài liệu bắt buộc = non-conformity nghiêm trọng - không thể đạt chứng nhận. Auditor sẽ dừng audit ngay nếu phát hiện thiếu tài liệu mandatory trong Clause 7.5.
{{< /callout >}}

### Sau bài viết này, bạn sẽ có thể:

- ✅ Biết chính xác 11 tài liệu bắt buộc cần tạo
- ✅ Viết Information Security Policy cấp cao
- ✅ Xây dựng 7 topic-specific policies quan trọng nhất
- ✅ Thiết lập quy trình quản lý tài liệu đơn giản
- ✅ Tìm và tùy chỉnh template miễn phí

---

## Tài liệu bắt buộc theo ISO 27001:2022

ISO 27001:2022 yêu cầu **tối thiểu 11 tài liệu documented information**. Thiếu bất kỳ tài liệu nào sẽ gây non-conformity và trì hoãn chứng nhận 1-4 tuần.

### Danh sách 11 tài liệu bắt buộc

| STT | Tài liệu | Clause | Mục đích | Priority |
|-----|----------|--------|----------|----------|
| 1 | **Scope of ISMS** | 4.3 | Phạm vi áp dụng ISMS (đã làm Phần 2) | P0 |
| 2 | **Information Security Policy** | 5.2 | Chính sách bảo mật cấp cao, commitment từ Top Mgmt | P0 |
| 3 | **Risk Assessment Process** | 6.1.2 | Quy trình đánh giá rủi ro | P0 |
| 4 | **Risk Treatment Process** | 6.1.3 | Quy trình xử lý rủi ro | P0 |
| 5 | **Statement of Applicability (SoA)** | 6.1.3d | Danh sách kiểm soát áp dụng (đã làm Phần 4) | P0 |
| 6 | **Risk Treatment Plan** | 6.2 | Kế hoạch triển khai kiểm soát | P0 |
| 7 | **Information Security Objectives** | 6.2 | Mục tiêu bảo mật đo lường được | P0 |
| 8 | **Evidence of Competence** | 7.2 | Hồ sơ đào tạo, chứng chỉ nhân viên | P1 |
| 9 | **Operational Planning & Control** | 8.1 | Quy trình vận hành ISMS | P1 |
| 10 | **Results of Risk Assessments** | 8.2 | Risk register (đã làm Phần 3) | P0 |
| 11 | **Results of Risk Treatment** | 8.3 | Báo cáo triển khai kiểm soát | P1 |

**Ngoài 11 tài liệu trên, còn cần:**
- **Internal Audit Program** (Clause 9.2)
- **Management Review Records** (Clause 9.3)
- **Nonconformity & Corrective Action Records** (Clause 10.1)

{{< callout type="info" >}}
**Thông tin**: Đây là danh sách tối thiểu - bạn có thể cần thêm tài liệu tùy theo phạm vi ISMS và kết quả SoA (ví dụ: BCP, Incident Response Plan, Acceptable Use Policy).
{{< /callout >}}

### Phân cấp tài liệu ISMS

{{< mermaid >}}
graph TB
    subgraph Level_1["Cấp 1: Policy - Chính sách"]
        POL[Information Security Policy<br/>Chính sách cấp cao<br/>2-4 trang, phê duyệt bởi CEO]
    end

    subgraph Level_2["Cấp 2: Topic Policies - Chính sách chuyên đề"]
        POL_ACC[Access Control Policy]
        POL_AUP[Acceptable Use Policy]
        POL_DATA[Data Retention Policy]
        POL_INC[Incident Response Policy]
        POL_BCP[Business Continuity Policy]
        POL_BYOD[BYOD Policy]
        POL_VENDOR[Vendor Management Policy]
    end

    subgraph Level_3["Cấp 3: Procedures - Quy trình"]
        PROC_RA[Risk Assessment Procedure]
        PROC_DOC[Document Control Procedure]
        PROC_AUDIT[Internal Audit Procedure]
        PROC_CA[Corrective Action Procedure]
        PROC_CHANGE[Change Management Procedure]
        PROC_BACKUP[Backup & Recovery Procedure]
        PROC_ACC_REV[Access Review Procedure]
        PROC_VULN[Vulnerability Management Procedure]
    end

    subgraph Level_4["Cấp 4: Work Instructions - Hướng dẫn"]
        WI_ONBOARD[Onboarding Security Checklist]
        WI_OFFBOARD[Offboarding Security Checklist]
        WI_PATCH[Patching Instructions]
        WI_RESTORE[Restore from Backup Instructions]
    end

    subgraph Level_5["Cấp 5: Records - Bản ghi"]
        REC_RISK[Risk Register]
        REC_SOA[Statement of Applicability]
        REC_TRAIN[Training Records]
        REC_AUDIT[Audit Reports]
        REC_INC[Incident Reports]
        REC_REVIEW[Management Review Minutes]
    end

    POL --> Level_2
    Level_2 --> Level_3
    Level_3 --> Level_4
    Level_4 --> Level_5

    style POL fill:#ff6b6b
    style Level_2 fill:#4ecdc4
    style Level_3 fill:#ffe66d
    style Level_4 fill:#95e1d3
    style Level_5 fill:#f3a683
{{< /mermaid >}}

**Giải thích phân cấp:**

- **Level 1 (Policy)**: Tầm nhìn, cam kết leadership, áp dụng toàn tổ chức
- **Level 2 (Topic Policies)**: Chính sách chuyên đề cho từng lĩnh vực bảo mật
- **Level 3 (Procedures)**: Quy trình chi tiết "ai làm gì, khi nào, như thế nào"
- **Level 4 (Work Instructions)**: Hướng dẫn từng bước cụ thể
- **Level 5 (Records)**: Bản ghi, evidence, audit trail

---

## Chính sách Bảo mật Thông tin (Top-level Policy)

**Information Security Policy** là tài liệu quan trọng nhất, thể hiện cam kết của Top Management với ISMS.

### Yêu cầu theo Clause 5.2

Chính sách phải:
- Phù hợp với mục đích và ngữ cảnh tổ chức
- Bao gồm **Information Security Objectives** hoặc framework để thiết lập objectives
- Cam kết **tuân thủ** yêu cầu liên quan đến bảo mật thông tin
- Cam kết **cải tiến liên tục** ISMS
- Được **documented, communicated, available** cho các bên liên quan

### Template outline: Information Security Policy

```markdown
# CHÍNH SÁCH BẢO MẬT THÔNG TIN
## [Tên Công ty]

### 1. Mục đích (Purpose)
- Bảo vệ tính bí mật, toàn vẹn và khả dụng của thông tin
- Tuân thủ ISO 27001:2022 và yêu cầu pháp lý
- Xây dựng văn hóa bảo mật trong tổ chức

### 2. Phạm vi áp dụng (Scope)
- Áp dụng cho: toàn bộ nhân viên, nhà thầu, đối tác
- Bao gồm: tất cả thông tin thuộc [phạm vi ISMS từ Phần 2]

### 3. Cam kết của Ban Lãnh đạo (Management Commitment)
Ban Giám đốc cam kết:
- Cung cấp nguồn lực đầy đủ cho ISMS
- Đảm bảo tuân thủ chính sách bảo mật
- Xem xét định kỳ hiệu quả ISMS
- Thúc đẩy văn hóa bảo mật trong toàn tổ chức

### 4. Mục tiêu Bảo mật Thông tin (Information Security Objectives)
- Không có sự cố bảo mật nghiêm trọng (severity: critical) > 2 lần/năm
- 100% nhân viên hoàn thành đào tạo nhận thức bảo mật hàng năm
- 95% lỗ hổng bảo mật critical được vá trong vòng 7 ngày
- RTO ≤ 4 giờ, RPO ≤ 24 giờ cho hệ thống core business

### 5. Nguyên tắc Bảo mật (Security Principles)
- **Confidentiality (Bí mật)**: Thông tin chỉ truy cập bởi người được ủy quyền
- **Integrity (Toàn vẹn)**: Thông tin chính xác, đầy đủ, không bị thay đổi trái phép
- **Availability (Khả dụng)**: Thông tin sẵn sàng khi cần thiết

### 6. Trách nhiệm (Responsibilities)
- **Ban Giám đốc**: Phê duyệt chính sách, cung cấp nguồn lực
- **CISO/Information Security Manager**: Quản lý ISMS, xem xét rủi ro
- **IT Manager**: Triển khai kiểm soát kỹ thuật
- **Tất cả nhân viên**: Tuân thủ chính sách, báo cáo sự cố

### 7. Tuân thủ (Compliance)
Công ty tuân thủ:
- ISO/IEC 27001:2022
- Nghị định 13/2023/NĐ-CP (Bảo vệ dữ liệu cá nhân - Việt Nam)
- Thông tư 03/2017/TT-BTTTT (Bảo mật website)
- Các điều khoản hợp đồng với khách hàng

### 8. Xem xét và Cập nhật (Review and Update)
- Chính sách được xem xét **tối thiểu hàng năm**
- Cập nhật khi có thay đổi rủi ro, pháp lý, hoặc ngữ cảnh kinh doanh
- Phiên bản hiện tại: 1.2
- Ngày ban hành: 14/02/2026
- Ngày xem xét tiếp theo: 14/02/2027

### 9. Phê duyệt (Approval)
- **Người phê duyệt**: [CEO/General Director Name]
- **Chức danh**: Tổng Giám đốc
- **Chữ ký**: _________________
- **Ngày**: 14/02/2026
```

{{< callout type="tip" >}}
**Mẹo**: Chính sách cấp cao nên ngắn gọn (2-3 trang) - chi tiết để trong quy trình cụ thể. Mục tiêu là document dễ đọc, dễ communicate, và được mọi người nhớ.
{{< /callout >}}

---

## Chính sách theo Chủ đề (Topic-specific Policies)

Ngoài top-level policy, SME cần **7 topic-specific policies** ưu tiên để cover các kiểm soát quan trọng.

### 1. Chính sách Kiểm soát Truy cập (Access Control Policy)

**Liên kết:** A.5.15, A.5.16, A.5.17, A.5.18, A.8.2, A.8.3

**Mục đích:** Đảm bảo chỉ người được ủy quyền truy cập thông tin và hệ thống.

**Nội dung chính:**
- **Least Privilege**: Mỗi user chỉ có quyền tối thiểu cần thiết
- **Need-to-Know**: Truy cập dựa trên nhu cầu công việc
- **Separation of Duties**: Phân tách vai trò quan trọng
- **User Registration**: Quy trình cấp/thu hồi tài khoản
- **Privileged Access Management**: Quản lý admin/root access
- **Password Requirements**: Độ dài ≥12 ký tự, complexity, rotation
- **MFA**: Bắt buộc cho email, VPN, AWS, production systems
- **Access Review**: Xem xét quyền truy cập mỗi 6 tháng

**Template outline:**
```
1. Scope
2. User Access Provisioning (onboarding)
3. User Access Modification (role change)
4. User Access Revocation (offboarding)
5. Privileged Access Management
6. Password Policy
7. Multi-Factor Authentication
8. Access Review Process
9. Exceptions and Approvals
```

### 2. Chính sách Sử dụng Chấp nhận được (Acceptable Use Policy - AUP)

**Liên kết:** A.5.10

**Mục đích:** Quy định cách sử dụng tài sản CNTT của công ty.

**Nội dung chính:**
- **Permitted Use**: Sử dụng cho mục đích công việc
- **Prohibited Activities**:
  - Tải/chia sẻ nội dung bất hợp pháp
  - Truy cập website độc hại, phishing
  - Sử dụng tài nguyên cho mục đích cá nhân quá mức
  - Cài đặt phần mềm lậu
- **Email & Internet**: Không spam, không gửi thông tin nhạy cảm qua email không mã hóa
- **Personal Use**: Cho phép sử dụng cá nhân hợp lý (lunch break, v.v.)
- **Monitoring**: Công ty có quyền giám sát hoạt động
- **BYOD**: Nếu cho phép, phải tuân thủ chính sách BYOD riêng

### 3. Chính sách Lưu trữ & Xóa Dữ liệu (Data Retention & Deletion Policy)

**Liên kết:** A.5.33, A.8.10

**Mục đích:** Quản lý vòng đời dữ liệu, tuân thủ pháp lý.

**Nội dung chính:**
- **Data Classification**: Phân loại dữ liệu (Public, Internal, Confidential, Restricted)
- **Retention Periods**:
  - Customer data: 3 năm sau khi hợp đồng kết thúc
  - Employee records: 10 năm sau khi nghỉ việc (theo pháp luật VN)
  - Financial records: 10 năm
  - Logs: 1 năm
- **Secure Deletion**: Phương pháp xóa an toàn (DoD 5220.22-M, NIST SP 800-88)
- **Data Disposal**: Hủy vật lý (shred paper, wipe HDD)

### 4. Kế hoạch Ứng phó Sự cố (Incident Response Plan)

**Liên kết:** A.5.24, A.5.25, A.5.26, A.5.27, A.5.28

**Mục đích:** Phát hiện, ứng phó, phục hồi sau sự cố bảo mật.

**Nội dung chính:**
- **Incident Definition**: Sự cố bảo mật là gì?
- **Incident Classification**:
  - Critical: Ransomware, data breach, system compromise
  - High: Malware infection, DDoS
  - Medium: Phishing attempt, policy violation
  - Low: Lost device, minor config issue
- **Response Team**: Ai làm gì? (Incident Manager, IT Team, Legal, PR)
- **Response Process**: Detect → Contain → Eradicate → Recover → Lessons Learned
- **Communication Plan**: Thông báo cho ai, khi nào? (customers, regulators, media)
- **Evidence Collection**: Preserve logs, forensics

### 5. Kế hoạch Liên tục Kinh doanh (Business Continuity Plan - BCP)

**Liên kết:** A.5.29, A.5.30

**Mục đích:** Đảm bảo hoạt động tiếp tục khi gặp gián đoạn.

**Nội dung chính:**
- **Business Impact Analysis (BIA)**: Xác định critical processes
- **Recovery Objectives**:
  - RTO (Recovery Time Objective): Thời gian tối đa downtime chấp nhận được
  - RPO (Recovery Point Objective): Dữ liệu mất tối đa chấp nhận được
- **Disaster Recovery**: Backup & restore procedures
- **Alternate Site**: Văn phòng/datacenter dự phòng
- **Communication**: Emergency contact list
- **Testing**: DR drill ít nhất 1 lần/năm

### 6. Chính sách BYOD (Bring Your Own Device)

**Liên kết:** A.6.7, A.8.1

**Mục đích:** Bảo mật khi nhân viên dùng thiết bị cá nhân cho công việc.

**Nội dung chính:**
- **Scope**: Áp dụng cho smartphone, laptop, tablet cá nhân
- **Security Requirements**:
  - Cài đặt MDM (Mobile Device Management)
  - Screen lock (PIN/biometric)
  - Full disk encryption
  - Auto-update OS & apps
  - Remote wipe capability
- **Prohibited**: Jailbreak/root devices
- **Data Separation**: Containerization (work data riêng biệt)
- **Lost/Stolen**: Báo cáo ngay, remote wipe

### 7. Chính sách Quản lý Nhà cung cấp (Vendor Management Policy)

**Liên kết:** A.5.19, A.5.20, A.5.21, A.5.23

**Mục đích:** Quản lý rủi ro từ third-party vendors.

**Nội dung chính:**
- **Vendor Risk Assessment**: Đánh giá rủi ro trước khi ký hợp đồng
- **Security Requirements**: Điều khoản bảo mật trong hợp đồng
- **SLA**: Yêu cầu về uptime, response time, data protection
- **Vendor Access**: Kiểm soát vendor truy cập hệ thống
- **Auditing**: Quyền audit vendor compliance
- **Data Processing Agreements (DPA)**: Bắt buộc cho vendor xử lý dữ liệu cá nhân
- **Termination**: Xóa dữ liệu khi kết thúc hợp đồng

{{< callout type="tip" >}}
**Mẹo**: Không cần viết tất cả cùng lúc - ưu tiên theo kết quả đánh giá rủi ro. Bắt đầu với Access Control, AUP, Incident Response (3 policies quan trọng nhất).
{{< /callout >}}

---

## Quy trình và Biểu mẫu (Procedures & Forms)

### Phân biệt: Policy vs Procedure vs Work Instruction vs Record

| Loại tài liệu | Mô tả | Ví dụ |
|---------------|-------|-------|
| **Policy** | "Cái gì" và "Tại sao" - nguyên tắc chung, áp dụng toàn tổ chức | Access Control Policy |
| **Procedure** | "Ai làm gì, khi nào" - quy trình từng bước | Access Review Procedure |
| **Work Instruction** | "Làm như thế nào" - hướng dẫn chi tiết kỹ thuật | How to Grant AWS IAM Access |
| **Record** | "Evidence" - bản ghi đã thực hiện | Access Review Report Q1 2026 |

### 4 quy trình bắt buộc cho SME

#### 1. Risk Assessment Procedure

**Mục đích:** Quy trình đánh giá rủi ro định kỳ (đã làm Phần 3).

**Nội dung:**
- Tần suất: Hàng năm + khi có thay đổi lớn
- Người thực hiện: CISO + IT Manager + key stakeholders
- Phương pháp: Asset-based approach
- Công cụ: Excel risk register
- Output: Risk register, Risk treatment plan

#### 2. Document Control Procedure

**Mục đích:** Quản lý version, approval, distribution của tài liệu ISMS.

**Nội dung:**
- **Naming Convention**: `[Category]-[Name]-v[Version].docx` (ví dụ: `POL-AccessControl-v1.2.docx`)
- **Version Control**: Major change = +1.0, Minor = +0.1
- **Approval Workflow**: Author → Reviewer → Approver (CISO/CEO)
- **Distribution**: Lưu trên SharePoint/Google Drive, email thông báo
- **Review Schedule**: Policies: 1 năm, Procedures: 1 năm, Records: theo retention policy
- **Obsolete Documents**: Archive, không xóa (giữ lại 1 cycle cho audit trail)

#### 3. Internal Audit Procedure

**Mục đích:** Kiểm tra ISMS định kỳ (Clause 9.2).

**Nội dung:**
- **Frequency**: Tối thiểu 1 lần/năm, cover toàn bộ ISMS scope trong 3 năm
- **Audit Team**: Internal auditor (đã đào tạo ISO 27001 Lead Auditor)
- **Audit Plan**: Lập kế hoạch 1 tháng trước, thông báo auditee
- **Audit Checklist**: Dựa trên SoA và Clause 4-10
- **Finding Classification**: Major NC / Minor NC / Observation
- **Corrective Action**: Close findings trong 30-90 ngày
- **Audit Report**: Gửi Top Management trong 2 tuần

#### 4. Corrective Action Procedure

**Mục đích:** Xử lý nonconformities và sự cố (Clause 10.1).

**Nội dung:**
- **Trigger**: Internal audit finding, external audit finding, incident, management review
- **Process**:
  1. Identify nonconformity
  2. Root cause analysis (5 Whys, Fishbone)
  3. Define corrective action
  4. Implement action
  5. Verify effectiveness
  6. Update ISMS documents if needed
- **Timeline**: 30 ngày cho minor NC, 90 ngày cho major NC
- **Tracking**: Corrective action register (Excel)

---

## Quản lý Tài liệu (Document Control)

### Vòng đời tài liệu ISMS

{{< mermaid >}}
graph LR
    subgraph Create["1. Tạo mới"]
        DRAFT[Soạn thảo<br/>Draft v0.1]
    end

    subgraph Review["2. Xem xét"]
        REVIEW_TECH[Technical Review<br/>IT Manager/CISO]
        REVIEW_LEGAL[Legal Review<br/>nếu cần]
        FEEDBACK[Nhận phản hồi<br/>Sửa đổi]
    end

    subgraph Approve["3. Phê duyệt"]
        APPROVE_CISO[CISO Approval<br/>cho Procedures]
        APPROVE_CEO[CEO Approval<br/>cho Policies]
        VERSION[Đánh version<br/>v1.0]
    end

    subgraph Distribute["4. Phân phối"]
        PUBLISH[Đăng lên<br/>SharePoint/Drive]
        NOTIFY[Email thông báo<br/>stakeholders]
        TRAIN[Đào tạo<br/>nếu cần]
    end

    subgraph Use["5. Sử dụng"]
        IMPLEMENT[Triển khai<br/>trong thực tế]
        COLLECT[Thu thập<br/>evidence/records]
    end

    subgraph Review_Cycle["6. Xem xét định kỳ"]
        ANNUAL[Annual Review<br/>hoặc khi cần]
        CHANGE[Có thay đổi?]
        UPDATE[Cập nhật<br/>v1.1, v2.0...]
        NOCHANGE[Xác nhận<br/>vẫn còn hiệu lực]
    end

    subgraph Archive["7. Lưu trữ"]
        OBSOLETE[Document hết hạn]
        ARCHIVE_DOC[Lưu archive<br/>theo retention period]
    end

    DRAFT --> REVIEW_TECH
    REVIEW_TECH --> REVIEW_LEGAL
    REVIEW_LEGAL --> FEEDBACK
    FEEDBACK --> REVIEW_TECH
    FEEDBACK --> APPROVE_CISO

    APPROVE_CISO --> APPROVE_CEO
    APPROVE_CEO --> VERSION

    VERSION --> PUBLISH
    PUBLISH --> NOTIFY
    NOTIFY --> TRAIN

    TRAIN --> IMPLEMENT
    IMPLEMENT --> COLLECT

    COLLECT --> ANNUAL
    ANNUAL --> CHANGE
    CHANGE -->|Có| UPDATE
    CHANGE -->|Không| NOCHANGE
    UPDATE --> REVIEW_TECH
    NOCHANGE --> Use

    IMPLEMENT --> OBSOLETE
    OBSOLETE --> ARCHIVE_DOC

    style DRAFT fill:#fff4e6
    style VERSION fill:#e7f5ff
    style PUBLISH fill:#d3f9d8
    style ANNUAL fill:#ffe3e3
    style ARCHIVE_DOC fill:#f3f0ff
{{< /mermaid >}}

### Công cụ quản lý tài liệu cho SME

#### Option 1: Google Drive + Naming Convention (Miễn phí, đủ dùng)

**Cấu trúc thư mục:**
```
ISMS Documents/
├── 01-Policies/
│   ├── POL-InfoSec-v1.2-20260214.pdf
│   ├── POL-AccessControl-v1.0-20260115.pdf
│   └── POL-IncidentResponse-v2.1-20260201.pdf
├── 02-Procedures/
│   ├── PROC-RiskAssessment-v1.0-20260101.pdf
│   ├── PROC-DocumentControl-v1.1-20260214.pdf
│   └── PROC-InternalAudit-v1.0-20260101.pdf
├── 03-Work Instructions/
│   ├── WI-Onboarding-Checklist-v1.0.xlsx
│   └── WI-BackupRestore-v1.2.pdf
├── 04-Records/
│   ├── 2026/
│   │   ├── REC-RiskRegister-2026Q1.xlsx
│   │   ├── REC-AuditReport-2026-02.pdf
│   │   └── REC-TrainingAttendance-2026-01.xlsx
│   └── 2025/
└── 05-Templates/
    ├── TMPL-RiskAssessment.xlsx
    └── TMPL-IncidentReport.docx
```

**Quy tắc đặt tên:**
- Format: `[TYPE]-[Name]-v[Version]-[Date].ext`
- Type: POL, PROC, WI, REC, TMPL
- Version: Major.Minor (1.0, 1.1, 2.0)
- Date: YYYYMMDD

**Access Control:**
- Policies/Procedures: Read-only cho toàn công ty
- Work Instructions: Edit cho team leaders
- Records: Restricted, chỉ ISMS team

#### Option 2: Microsoft SharePoint (Nếu đã có M365)

**Ưu điểm:**
- Version control tự động
- Approval workflow
- Metadata & tagging
- Integration với Teams

#### Option 3: Confluence/Notion (Tech-friendly)

**Ưu điểm:**
- Wiki-style, dễ tìm kiếm
- Version history
- Comments & collaboration
- Free tier đủ dùng

{{< callout type="info" >}}
**Thông tin**: Google Drive + quy ước đặt tên file = hệ thống quản lý tài liệu đủ tốt cho SME. Không cần đầu tư phần mềm Document Management System đắt tiền như SharePoint Server hay Alfresco.
{{< /callout >}}

---

## Template và Công cụ

### GitHub Toolkits (Open Source)

1. **[PeterGeelen/ISO27001-2022](https://github.com/PeterGeelen/ISO27001-2022)**
   - 40+ Word templates (policies, procedures)
   - Excel SoA, Risk Register
   - Hoàn toàn miễn phí, tùy chỉnh thoải mái

2. **[PehanIn/ISO27001-2022-toolkit](https://github.com/PehanIn/ISO27001-2022-toolkit)**
   - Full ISMS documentation set
   - Markdown format, dễ version control
   - CI/CD scripts để generate PDF

3. **[ukncsc/ISO27001-ISMS-Policies](https://github.com/ukncsc/ISO27001-ISMS-Policies)**
   - UK National Cyber Security Centre templates
   - UK-focused nhưng dễ adapt cho Vietnam

### Vendor Free Templates

| Provider | Link | Nội dung |
|----------|------|----------|
| **Secureframe** | [secureframe.com/hub/iso-27001-templates](https://secureframe.com/hub/iso-27001-templates) | 20+ templates (policies, SoA, audit checklist) |
| **ISEOBlue Lite** | [iseo.blue/lite](https://www.iseo.blue/lite) | Free tier: policy generator, SoA template |
| **DataGuard** | [dataguard.co.uk/resources/iso-27001](https://www.dataguard.co.uk/resources/iso-27001) | Free guides + template samples |
| **Vanta** | [vanta.com/resources/iso-27001](https://www.vanta.com/resources/iso-27001) | Gap analysis checklist, policy templates |

### AI Policy Generators

- **[ISMSpolicyGenerator.com](https://www.ismspolicygenerator.com)**: Nhập thông tin công ty → tạo policies tự động
- **ChatGPT/Claude**: Prompt engineering để tạo policy drafts
  ```
  Prompt: "Write an Access Control Policy for a 25-person software company
  in Vietnam, compliant with ISO 27001:2022 A.5.15. Include password
  requirements, MFA, privileged access management, and access review process."
  ```

{{< callout type="tip" >}}
**Mẹo**: Tải toolkit miễn phí từ GitHub, tùy chỉnh theo tổ chức của bạn - tiết kiệm hàng nghìn USD so với thuê consultant viết tài liệu. Chỉ cần customize, không cần viết từ đầu.
{{< /callout >}}

### So sánh chi phí: DIY vs Consultant

| Cách tiếp cận | Chi phí | Thời gian | Pros | Cons |
|---------------|---------|-----------|------|------|
| **DIY với free templates** | ~$500 (đào tạo + review) | 2-3 tháng | Tiết kiệm, hiểu rõ tài liệu | Tốn thời gian, cần tự học |
| **Consultant** | $5k - $40k | 1-2 tháng | Chuyên nghiệp, nhanh | Đắt, phụ thuộc consultant |
| **Hybrid** | $2k - $10k | 1.5-2 tháng | Cân bằng cost/quality | Vẫn cần involvement cao |

**Khuyến nghị cho SME:** Bắt đầu với DIY, thuê consultant review 1-2 ngày trước certification audit.

---

## Sai lầm Thường gặp

### 1. Sao chép template mà không tùy chỉnh

**Vấn đề:** Copy nguyên si từ internet, không thay đổi tên công ty, scope, v.v.

**Hậu quả:** Auditor nhận ra ngay (vì họ thấy template đó hàng trăm lần). Major NC.

**Giải pháp:** Customize ít nhất:
- Tên công ty, scope ISMS
- Roles & responsibilities (phù hợp với org chart)
- Technical details (tools, systems thực tế đang dùng)
- Examples cụ thể từ tổ chức

{{< callout type="danger" >}}
**Nguy hiểm**: Sao chép tài liệu mẫu mà không tùy chỉnh = auditor nhận ra ngay và đánh non-conformity. Họ sẽ hỏi chi tiết về nội dung - nếu bạn không trả lời được vì không phải do mình viết, audit sẽ fail.
{{< /callout >}}

### 2. Viết policies quá phức tạp mà không ai đọc

**Vấn đề:** Policies 50 trang, đầy thuật ngữ kỹ thuật, không ai nhớ.

**Hậu quả:** Nhân viên không tuân thủ vì không biết nội dung.

**Giải pháp:**
- Keep policies < 5 trang
- Dùng ngôn ngữ đơn giản, ví dụ thực tế
- Visual aids (flowcharts, checklists)
- Summary 1-pager cho nhân viên

### 3. Không có sign-off từ Top Management

**Vấn đề:** Chính sách không có chữ ký CEO/GM.

**Hậu quả:** Auditor hỏi "Liệu leadership có thực sự committed?"

**Giải pháp:**
- Tất cả policies phải có chữ ký Top Management
- Present policies tại Management Review meeting
- Email announcement từ CEO khi công bố policy mới

### 4. Không có lịch review/update

**Vấn đề:** Viết xong rồi bỏ quên, không update.

**Hậu quả:** Policies lỗi thời, không phản ánh thực tế. Minor NC.

**Giải pháp:**
- Đặt "Next Review Date" trong mỗi document
- Calendar reminder trước 1 tháng
- Annual review mandatory cho tất cả policies

### 5. Tài liệu và thực tế không khớp

**Vấn đề:** Policy viết "MFA bắt buộc" nhưng thực tế chưa triển khai.

**Hậu quả:** Major NC - say what you do, do what you say.

**Giải pháp:**
- Chỉ document những gì đã/đang thực hiện
- Nếu chưa triển khai, đánh dấu "Planned - Target Q3 2026"

---

## Kết luận & Bước tiếp theo

Xây dựng bộ tài liệu ISMS không khó, nhưng cần **đầu tư thời gian để tùy chỉnh cho phù hợp** với tổ chức. Tài liệu tốt là tài liệu thực tế, dễ hiểu, và được tuân thủ.

### Checklist tài liệu ISMS

- ✅ 11 tài liệu bắt buộc đã tạo
- ✅ Information Security Policy có chữ ký CEO
- ✅ 7 topic-specific policies ưu tiên đã viết
- ✅ 4 quy trình bắt buộc (Risk Assessment, Document Control, Internal Audit, Corrective Action)
- ✅ Document control system đã setup (Google Drive/SharePoint)
- ✅ Version control và naming convention đã áp dụng
- ✅ Review schedule đã thiết lập
- ✅ Templates đã customize theo tổ chức
- ✅ Tất cả policies/procedures đã communicate cho nhân viên

### Điểm nhấn quan trọng

- **11 tài liệu bắt buộc** - thiếu 1 = major NC
- **Top-level policy** cần chữ ký Top Management
- **7 topic-specific policies** ưu tiên: Access Control, AUP, Data Retention, Incident Response, BCP, BYOD, Vendor Management
- **Document control** đơn giản: Google Drive + naming convention = đủ
- **Customize templates** - không copy nguyên si
- **Say what you do, do what you say** - tài liệu phải match thực tế

Trong **[Phần 6](/posts/iso27001-sme/06-trien-khai-kiem-soat/)**, chúng ta sẽ triển khai các kiểm soát Annex A trong thực tế - từ công cụ miễn phí đến cấu hình cụ thể cho từng nhóm kiểm soát.

### Tài liệu tham khảo

- ISO/IEC 27001:2022 - Clause 7.5: Documented Information
- ISO/IEC 27002:2022 - Implementation Guidance
- [PeterGeelen ISO 27001:2022 Toolkit](https://github.com/PeterGeelen/ISO27001-2022)
- [Secureframe ISO 27001 Templates](https://secureframe.com/hub/iso-27001-templates)
- NIST SP 800-12 Rev. 1 - Information Security Handbook
