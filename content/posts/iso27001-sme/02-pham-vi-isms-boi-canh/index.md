---
title: "ISO 27001 cho SME Phần 2: Xác định phạm vi ISMS và Phân tích bối cảnh tổ chức"
date: 2026-02-14
draft: false
description: "Hướng dẫn thực hành xác định phạm vi ISMS theo Clause 4 ISO 27001:2022 - phân tích bối cảnh, xác định các bên liên quan, và giới hạn phạm vi cho doanh nghiệp nhỏ"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "isms", "scope", "clause-4", "gap-analysis", "stakeholder"]
series: ["ISO 27001 cho SME"]
weight: 2
mermaid: true
---

## Giới thiệu

Chào mừng bạn quay trở lại với series **ISO 27001 cho SME**! Trong [Phần 1](/posts/iso27001-sme/01-gioi-thieu-iso27001/), chúng ta đã tìm hiểu tổng quan về ISO 27001:2022, lý do SME cần chứng nhận, và lộ trình triển khai.

Trong phần này, chúng ta sẽ bắt tay vào bước đầu tiên quan trọng nhất: **xác định phạm vi ISMS** (ISMS Scope). Đây là bước nền tảng quyết định:
- ✅ Những gì bạn cần bảo vệ
- ✅ Chi phí và thời gian triển khai
- ✅ Số ngày đánh giá chứng nhận (audit days)
- ✅ Độ phức tạp của tài liệu và quy trình

{{< callout type="warning" >}}
**Cảnh báo:** Phạm vi quá rộng = chi phí tăng, thời gian kéo dài, khó quản lý. Phạm vi quá hẹp = không bảo vệ đủ tài sản quan trọng, khách hàng có thể không chấp nhận. Cân bằng là chìa khóa!
{{< /callout >}}

Chúng ta sẽ đi qua **Clause 4** của ISO 27001:2022 với các bài tập thực hành giúp bạn tạo ra các tài liệu cụ thể cho tổ chức mình.

---

## Clause 4.1: Hiểu bối cảnh tổ chức

Trước khi xác định phạm vi, bạn cần hiểu **bối cảnh** (context) mà tổ chức hoạt động. ISO 27001 yêu cầu phân tích cả **bối cảnh nội bộ** và **bối cảnh bên ngoài**.

### Bối cảnh nội bộ (Internal Context)

Những yếu tố bên trong tổ chức ảnh hưởng đến ISMS:

- **Văn hóa tổ chức:** Nhân viên có ý thức bảo mật cao không? Leadership có cam kết với ATTT không?
- **Cấu trúc tổ chức:** Phân cấp như thế nào? Ai chịu trách nhiệm về ATTT?
- **Năng lực nội bộ:** Có chuyên gia bảo mật không? IT team có kỹ năng gì?
- **Hệ thống IT hiện tại:** Dùng cloud hay on-premise? Công nghệ nào (AWS, Google Workspace, self-hosted)?
- **Quy trình hiện có:** Đã có quy trình phát triển phần mềm, quản lý thay đổi, backup chưa?

### Bối cảnh bên ngoài (External Context)

Những yếu tố bên ngoài tác động đến ISMS:

- **Thị trường:** Khách hàng chủ yếu ở đâu (Việt Nam, EU, US)? Họ yêu cầu gì về bảo mật?
- **Quy định pháp luật:** Nghị định 13/2023 (PDPA VN), GDPR (nếu có khách EU), HIPAA (nếu làm healthcare)
- **Ngành công nghiệp:** Fintech có yêu cầu cao hơn e-commerce
- **Mối đe dọa:** Ransomware, DDoS, social engineering phổ biến ở Việt Nam
- **Đối thủ cạnh tranh:** Họ có ISO 27001 chưa? Đó có phải lợi thế cạnh tranh không?

### Công cụ phân tích: SWOT cho An toàn Thông tin

Dưới đây là template SWOT (Strengths, Weaknesses, Opportunities, Threats) áp dụng cho bối cảnh bảo mật:

| **Strengths (Điểm mạnh)** | **Weaknesses (Điểm yếu)** |
|---------------------------|---------------------------|
| ✅ IT team có kinh nghiệm DevOps | ❌ Không có chuyên gia bảo mật chuyên trách |
| ✅ Đã sử dụng AWS với IAM tốt | ❌ Chưa có quy trình incident response |
| ✅ Code review bắt buộc trong Git | ❌ Nhân viên chưa được đào tạo về ATTT |
| ✅ Backup tự động hàng ngày | ❌ Không có giám sát log hệ thống |
| ✅ Leadership cam kết với chất lượng | ❌ Ngân sách ATTT hạn chế |

| **Opportunities (Cơ hội)** | **Threats (Mối đe dọa)** |
|----------------------------|--------------------------|
| 🔵 Khách hàng quốc tế yêu cầu ISO 27001 | 🔴 Ransomware tấn công các SME VN |
| 🔵 Nghị định 13 tạo nhu cầu compliance | 🔴 Nhân viên nghỉ việc mang theo dữ liệu |
| 🔵 Tăng giá dịch vụ sau khi có chứng chỉ | 🔴 DDoS từ đối thủ cạnh tranh |
| 🔵 Mở rộng thị trường EU, Singapore | 🔴 Phishing targeting founder/CEO |
| 🔵 Giảm phí bảo hiểm cyber | 🔴 Lỗ hổng trong thư viện mã nguồn mở |

### Mermaid Diagram: Internal vs External Context

{{< mermaid >}}
mindmap
  root((Bối cảnh<br/>ISO 27001))
    Nội bộ
      Văn hóa
        Ý thức ATTT nhân viên
        Cam kết leadership
        Văn hóa trách nhiệm
      Cấu trúc
        Phân cấp rõ ràng
        Vai trò ATTT
        Báo cáo sự cố
      Năng lực
        IT team skills
        Security expertise
        Đào tạo liên tục
      Công nghệ
        Cloud AWS/Azure/GCP
        On-premise servers
        SaaS tools
      Quy trình
        SDLC process
        Change management
        Backup & recovery
    Bên ngoài
      Thị trường
        Khách hàng B2B/B2C
        Địa lý VN/EU/US
        Yêu cầu khách hàng
      Pháp luật
        Nghị định 13/2023
        GDPR EU
        Industry regulations
      Ngành
        Fintech
        Healthcare
        E-commerce
      Mối đe dọa
        Ransomware
        Phishing
        Insider threats
        DDoS attacks
      Cạnh tranh
        Đối thủ có ISO 27001
        Price competition
        Differentiation
{{< /mermaid >}}

### Bài tập thực hành

**Hãy điền SWOT template trên cho tổ chức của bạn.** Dành 30-45 phút để:
1. Thu thập ý kiến từ IT team, leadership, và một vài nhân viên
2. Liệt kê ít nhất 3-5 mục cho mỗi ô
3. Ưu tiên các mục có tác động lớn đến ISMS

Tài liệu này sẽ trở thành **"Context of the Organization"** - một trong những tài liệu bắt buộc khi audit.

---

## Clause 4.2: Các bên liên quan (Interested Parties)

ISO 27001 yêu cầu bạn xác định **ai** quan tâm đến ISMS của bạn và **họ yêu cầu gì**.

### Các bên liên quan phổ biến cho SME Việt Nam

{{< callout type="info" >}}
**Thông tin hữu ích:** Các bên liên quan thường gặp cho doanh nghiệp công nghệ SME tại Việt Nam bao gồm:
- Khách hàng (B2B, B2G, B2C)
- Nhân viên và ứng viên
- Nhà đầu tư và cổ đông
- Cơ quan quản lý (Bộ Công an, Bộ TT&TT)
- Đối tác công nghệ và nhà cung cấp
- Tổ chức chứng nhận (BSI, SQC, URS...)
{{< /callout >}}

### Template: Stakeholder Register

| Bên liên quan | Yêu cầu bảo mật | Tác động đến ISMS |
|---------------|-----------------|-------------------|
| **Khách hàng doanh nghiệp (B2B)** | ISO 27001 certification, SOC 2 Type II, data residency tại VN | Quyết định scope (phải bao gồm dịch vụ cung cấp cho họ), chọn kiểm soát Annex A liên quan đến cloud, encryption |
| **Nhân viên** | Bảo vệ thông tin cá nhân (CCCD, lương), môi trường làm việc an toàn | A.6 (People controls): screening, training, clear desk policy |
| **Bộ Công an (Nghị định 13/2023)** | Bảo vệ dữ liệu cá nhân của công dân VN, báo cáo vi phạm trong 72h | A.5.34 (Privacy), A.5.24 (Incident management), encryption, logging |
| **Đối tác AWS/Azure** | Tuân thủ Shared Responsibility Model, sử dụng đúng IAM | A.5.23 (Cloud services), A.8.3 (Access control) |
| **Nhà đầu tư/Cổ đông** | Giảm rủi ro cyber, bảo vệ IP và trade secrets | Risk assessment, business continuity plan (A.5.30) |
| **Nhà cung cấp SaaS** (Google Workspace, Slack, GitHub) | Chấp nhận Terms of Service, bảo vệ credentials | A.5.19 (Supplier relationships), A.5.20 (Supplier agreements) |
| **Tổ chức chứng nhận** (BSI Vietnam) | Tuân thủ đầy đủ ISO 27001:2022, tài liệu đầy đủ | Tất cả Clauses 4-10, Statement of Applicability |
| **Cơ quan thuế** | Bảo vệ dữ liệu tài chính, lưu trữ hóa đơn điện tử | Backup, retention policy, access control |

### Ví dụ thực tế: Yêu cầu từ khách hàng

**Case:** Công ty phần mềm XYZ (30 nhân viên) vừa ký hợp đồng với một ngân hàng lớn tại Singapore. Ngân hàng yêu cầu:
- ✅ ISO 27001 certification trong vòng 6 tháng
- ✅ Penetration testing hàng năm
- ✅ Dữ liệu khách hàng phải được mã hóa (at rest và in transit)
- ✅ Access log phải lưu trữ ít nhất 1 năm
- ✅ Incident response plan với SLA phản hồi 4 giờ

➡️ **Tác động:** Scope ISMS phải bao gồm "Dịch vụ phát triển mobile banking cho khách hàng Singapore". Annex A phải chọn: A.8.24 (Cryptography), A.8.15 (Logging), A.5.24 (Incident management), A.8.8 (Vulnerability management).

---

## Clause 4.3: Xác định phạm vi ISMS

Đây là **bước quan trọng nhất** trong giai đoạn lập kế hoạch. Scope Statement (Tuyên bố phạm vi) xác định:
- **Ranh giới vật lý:** Văn phòng nào? Địa điểm nào?
- **Ranh giới tổ chức:** Phòng ban nào? Bộ phận nào?
- **Ranh giới công nghệ:** Hệ thống nào? Ứng dụng nào? Cloud accounts nào?
- **Ranh giới quy trình:** Quy trình nào (SDLC, HR, sales)?

### Nguyên tắc xác định scope

{{< callout type="tip" >}}
**Mẹo vàng:** Bắt đầu với một phòng ban hoặc một dịch vụ cốt lõi, rồi mở rộng.

**Lợi ích:**
- Giảm 30-50% chi phí chứng nhận ban đầu
- Nhanh hơn 2-3 tháng
- Ít phức tạp hơn, dễ quản lý
- Sau khi có chứng chỉ, mở rộng scope dễ dàng hơn
{{< /callout >}}

### Template: Scope Statement

```
INFORMATION SECURITY MANAGEMENT SYSTEM SCOPE STATEMENT

Organization: [Tên công ty]
Issue Date: [DD/MM/YYYY]
Approved by: [CEO/General Director]

1. SCOPE BOUNDARY

The ISMS applies to:

a) Physical Locations:
   - [Địa chỉ văn phòng chính, tầng nào, phòng nào]
   - [Data center location nếu có]
   - [Loại trừ: chi nhánh X, kho hàng Y nếu không liên quan]

b) Organizational Units:
   - [Development Team (15 nhân viên)]
   - [DevOps Team (3 nhân viên)]
   - [Product Management (2 nhân viên)]
   - [Loại trừ: Sales, Marketing, HR nếu không trong scope]

c) Information Systems and Assets:
   - [AWS Production Account (eu-west-1)]
   - [GitHub Enterprise repositories]
   - [Jira Cloud instance]
   - [Customer database PostgreSQL]
   - [Loại trừ: Internal HR system, Marketing website]

d) Processes:
   - [Software Development Lifecycle (SDLC)]
   - [CI/CD pipeline]
   - [Incident Response]
   - [Backup & Recovery]

2. SERVICES IN SCOPE

The ISMS covers the provision of:
   - [Tên dịch vụ chính: "SaaS Project Management Platform for Enterprise Customers"]
   - [Dịch vụ phụ nếu có: "API integration services"]

3. EXCLUSIONS AND JUSTIFICATION

The following are explicitly excluded from the ISMS:
   - [Marketing website (công khai, không xử lý dữ liệu nhạy cảm)]
   - [Internal HR recruitment system (do vendor quản lý hoàn toàn)]

4. APPLICABILITY STATEMENT

This scope is determined based on:
   - Customer requirements for ISO 27001 certification
   - Risk assessment findings
   - Legal and regulatory requirements (Decree 13/2023)
   - Business objectives for international expansion
```

### Ví dụ thực tế: 3 mẫu Scope Statement

#### Ví dụ 1: Công ty phát triển phần mềm (20 nhân viên)

**Công ty:** DevStudio Vietnam Co., Ltd.
**Phạm vi:**
- **Locations:** Văn phòng tầng 5, tòa nhà A, đường B, Quận 1, TP.HCM
- **Units:** Development team (12), QA team (3), DevOps (2), Product Owner (1)
- **Systems:** AWS Production (ap-southeast-1), GitLab self-managed, Jenkins CI/CD, PostgreSQL databases
- **Services:** "Custom software development services for financial sector clients in Vietnam and Singapore"
- **Exclusions:** Sales và Admin departments (4 nhân viên)

**Lý do:** Khách hàng ngân hàng yêu cầu ISO 27001 cho team phát triển sản phẩm của họ.

#### Ví dụ 2: Công ty thương mại điện tử (30 nhân viên)

**Công ty:** ShopFast E-commerce JSC
**Phạm vi:**
- **Locations:** Văn phòng HQ Hà Nội + DC tại Viettel IDC
- **Units:** IT Operations (5), Dev team (8), Customer Service (4), Logistics Tech (3)
- **Systems:** E-commerce platform (web + mobile app), Payment gateway integration, Customer database (MySQL), Order management system
- **Services:** "Online retail platform processing customer personal data and payment information"
- **Exclusions:** Physical warehouse operations, Marketing campaigns

**Lý do:** Tuân thủ Nghị định 13/2023, bảo vệ dữ liệu 500,000+ khách hàng.

#### Ví dụ 3: Công ty dịch vụ IT/Consulting (15 nhân viên)

**Công ty:** CloudOps Consulting Ltd.
**Phạm vi:**
- **Locations:** Văn phòng Quận 7, TP.HCM (100% remote work allowed)
- **Units:** Cloud Engineering team (8), Security Consulting team (4), Project Management (2)
- **Systems:** AWS multi-account setup quản lý cho khách hàng, Terraform IaC, Monitoring stack (Datadog)
- **Services:** "Managed cloud infrastructure services and security consulting for enterprise clients"
- **Exclusions:** Internal finance system (outsourced to kế toán)

**Lý do:** Khách hàng enterprise yêu cầu vendor phải có ISO 27001 để ký hợp đồng >$100K.

### Mermaid Diagram: Scope Boundary Visualization

{{< mermaid >}}
graph TB
    subgraph IN_SCOPE[TRONG PHẠM VI ISMS]
        subgraph LOCATION[Địa điểm vật lý]
            HQ[Văn phòng HQ Tầng 5<br/>123 Nguyễn Huệ, Q1, HCM]
            SERVER[Server room<br/>tại văn phòng]
        end

        subgraph PEOPLE[Nhân sự]
            DEV[Development Team<br/>12 người]
            DEVOPS[DevOps Team<br/>3 người]
            QA[QA Team<br/>2 người]
            PM[Product Manager<br/>1 người]
        end

        subgraph SYSTEMS[Hệ thống công nghệ]
            AWS[AWS Production<br/>ap-southeast-1]
            GIT[GitHub Enterprise<br/>Source code repos]
            DB[PostgreSQL Database<br/>Customer data]
            CICD[Jenkins CI/CD<br/>Pipeline]
        end

        subgraph PROCESS[Quy trình]
            SDLC[Software Development<br/>Lifecycle]
            INCIDENT[Incident Response<br/>Process]
            BACKUP[Backup & Recovery<br/>Daily backups]
        end
    end

    subgraph OUT_SCOPE[NGOÀI PHẠM VI ISMS]
        SALES[Sales Team<br/>4 người - Chỉ dùng CRM]
        MARKETING[Marketing Website<br/>Không xử lý data nhạy cảm]
        HR_SYS[HR System<br/>Do vendor quản lý]
        BRANCH[Chi nhánh Hà Nội<br/>Chỉ sales office]
    end

    HQ -.Bảo vệ bởi.-> PHYSICAL[A.7 Physical Controls]
    PEOPLE -.Tuân thủ.-> PEOPLE_CTL[A.6 People Controls]
    AWS -.Áp dụng.-> TECH_CTL[A.8 Tech Controls]
    SDLC -.Quản lý bởi.-> ORG_CTL[A.5 Org Controls]

    style IN_SCOPE fill:#c8e6c9
    style OUT_SCOPE fill:#ffccbc
    style HQ fill:#e3f2fd
    style AWS fill:#fff9c4
{{< /mermaid >}}

---

## Clause 4.4: Hệ thống quản lý An toàn Thông tin

Clause 4.4 yêu cầu tổ chức thiết lập, triển khai, duy trì và cải tiến liên tục ISMS. Điều này có nghĩa là ISMS không phải là dự án một lần, mà là **quy trình liên tục** theo chu trình PDCA.

### PDCA Cycle cho ISMS

ISO 27001 dựa trên mô hình **Plan-Do-Check-Act** (Lập kế hoạch - Thực hiện - Kiểm tra - Hành động):

{{< mermaid >}}
graph LR
    subgraph PLAN[PLAN - Lập kế hoạch<br/>Clauses 4, 5, 6]
        P1[4.1-4.3: Context & Scope]
        P2[5: Leadership & Policy]
        P3[6.1: Risk Assessment]
        P4[6.2: Risk Treatment]
        P5[6.3: ISMS Objectives]
        P1 --> P2 --> P3 --> P4 --> P5
    end

    subgraph DO[DO - Thực hiện<br/>Clauses 7, 8]
        D1[7.1: Resources]
        D2[7.2-7.3: Competence & Awareness]
        D3[7.4-7.5: Documentation]
        D4[8.1: Operational Planning]
        D5[8.2-8.3: Risk Treatment & Controls]
        D1 --> D2 --> D3 --> D4 --> D5
    end

    subgraph CHECK[CHECK - Kiểm tra<br/>Clause 9]
        C1[9.1: Monitoring & Measurement]
        C2[9.2: Internal Audit]
        C3[9.3: Management Review]
        C1 --> C2 --> C3
    end

    subgraph ACT[ACT - Hành động<br/>Clause 10]
        A1[10.1: Nonconformity]
        A2[10.2: Corrective Action]
        A3[10.3: Continual Improvement]
        A1 --> A2 --> A3
    end

    P5 --> D1
    D5 --> C1
    C3 --> A1
    A3 -.Feedback loop.-> P3

    style PLAN fill:#e3f2fd
    style DO fill:#fff9c4
    style CHECK fill:#ffccbc
    style ACT fill:#c8e6c9
{{< /mermaid >}}

### Tích hợp ISMS với quy trình kinh doanh

ISMS không nên là một hệ thống tách biệt. Nó cần tích hợp vào các quy trình hiện có:

- **SDLC:** Thêm security requirements, threat modeling, code review vào sprint
- **Change Management:** Đánh giá rủi ro ATTT trước khi deploy
- **HR Onboarding:** Đào tạo ATTT, ký NDA, cấp quyền truy cập theo principle of least privilege
- **Procurement:** Đánh giá vendor security trước khi ký hợp đồng
- **Incident Management:** Quy trình báo cáo và xử lý sự cố ATTT

**Mục tiêu:** Nhân viên không cảm thấy ISMS là "thêm công việc", mà là **một phần tự nhiên** của cách họ làm việc hàng ngày.

---

## Bài tập thực hành: Gap Analysis

**Gap Analysis** (Phân tích khoảng cách) giúp bạn hiểu **hiện tại tổ chức đang ở đâu** so với yêu cầu ISO 27001.

### Gap Analysis Checklist

Dưới đây là checklist đơn giản cho SME (tập trung vào 20 kiểm soát quan trọng nhất):

| Annex A Control | Mô tả | Hiện trạng (Có/Một phần/Không) | Khoảng cách | Ưu tiên | Hành động cần thực hiện |
|-----------------|-------|-------------------------------|-------------|---------|------------------------|
| **A.5.1** | Information security policy | ⚠️ Một phần | Chưa có chính sách chính thức | High | Viết ISMS Policy, phê duyệt bởi CEO |
| **A.5.9** | Inventory of information assets | ❌ Không | Chưa có danh sách tài sản | High | Tạo Asset Register trong Excel/Jira |
| **A.5.10** | Acceptable use of information | ✅ Có | Có trong employee handbook | Low | Review và cập nhật |
| **A.5.15** | Access control policy | ⚠️ Một phần | Có IAM trên AWS, chưa có policy văn bản | Medium | Viết Access Control Policy |
| **A.5.23** | Cloud services security | ⚠️ Một phần | Dùng AWS, chưa đánh giá shared responsibility | High | Review AWS security, tạo cloud security guideline |
| **A.6.1** | Screening employees | ❌ Không | Chưa background check | Medium | Thêm vào quy trình tuyển dụng |
| **A.6.2** | Terms of employment | ✅ Có | Có hợp đồng lao động, NDA | Low | Thêm điều khoản ATTT vào hợp đồng |
| **A.6.3** | Awareness training | ❌ Không | Chưa có training ATTT | High | Lập kế hoạch training 2h/quý |
| **A.7.2** | Physical entry controls | ⚠️ Một phần | Có khóa cửa, chưa có access card | Medium | Cân nhắc access control system |
| **A.7.7** | Clear desk and screen | ❌ Không | Chưa có policy | Low | Tạo clean desk policy |
| **A.8.2** | Privileged access rights | ⚠️ Một phần | AWS root account chưa MFA | High | Enable MFA cho tất cả admin accounts |
| **A.8.3** | Information access restriction | ⚠️ Một phần | RBAC trên AWS, chưa review định kỳ | Medium | Quarterly access review |
| **A.8.5** | Secure authentication | ⚠️ Một phần | MFA cho AWS, chưa có cho internal tools | High | Enforce MFA cho tất cả critical systems |
| **A.8.8** | Vulnerability management | ❌ Không | Chưa có vulnerability scanning | High | Triển khai Dependabot, OWASP ZAP |
| **A.8.9** | Configuration management | ⚠️ Một phần | Có Terraform, chưa có change control | Medium | Tạo change approval workflow |
| **A.8.13** | Backup | ✅ Có | Daily backup to S3, tested 1 lần/tháng | Low | Document backup procedure |
| **A.8.15** | Logging | ⚠️ Một phần | CloudWatch logs, chưa có retention policy | Medium | Define 1-year retention, enable CloudTrail |
| **A.8.24** | Cryptography | ⚠️ Một phần | HTTPS, RDS encryption, chưa có key management policy | Medium | Tạo crypto policy, document key management |
| **A.8.28** | Secure coding | ⚠️ Một phần | Code review trên GitHub, chưa có secure coding guideline | High | Tạo OWASP-based secure coding checklist |
| **A.5.24** | Incident response | ❌ Không | Chưa có quy trình incident response | High | Viết Incident Response Plan |

### Cách sử dụng Gap Analysis

{{< callout type="tip" >}}
**Mẹo thực chiến:** Sử dụng bảng Gap Analysis này để xác định những gì bạn đã có và những gì cần bổ sung.

**Quick wins (làm ngay trong 2 tuần đầu):**
- Enable MFA cho tất cả admin accounts (A.8.5)
- Tạo Asset Register trong Google Sheets (A.5.9)
- Document backup procedure hiện tại (A.8.13)
- Viết draft Information Security Policy (A.5.1)

➡️ Điều này cho bạn **4 kiểm soát** đã sẵn sàng cho audit, tạo động lực tiếp tục!
{{< /callout >}}

---

## Tài liệu cần tạo

Sau khi hoàn thành Clause 4, bạn cần có các tài liệu sau (bắt buộc cho audit):

### 1. ISMS Scope Statement

- **Template:** Xem phần 4.3 ở trên
- **Định dạng:** Word/PDF, 2-3 trang
- **Phê duyệt:** CEO hoặc General Director
- **Lưu trữ:** Document Management System (có thể dùng Google Drive/SharePoint với version control)

### 2. Context of the Organization Document

- **Nội dung:** SWOT analysis, internal/external factors
- **Template:**
  ```
  1. Internal Context
     - Organization structure
     - Culture and values related to information security
     - IT capabilities
     - Existing processes

  2. External Context
     - Market and customers
     - Legal and regulatory requirements
     - Industry sector risks
     - Competitive landscape

  3. SWOT Analysis
     [Bảng SWOT như phần 4.1]
  ```

### 3. Interested Parties Register

- **Template:** Stakeholder table (xem phần 4.2)
- **Định dạng:** Excel hoặc Jira (nếu dùng Jira cho risk management)
- **Cập nhật:** Quarterly hoặc khi có thay đổi lớn

### 4. Gap Analysis Report

- **Template:** Bảng checklist ở phần trên
- **Mục đích:** Làm cơ sở cho Risk Treatment Plan (Phần 3)
- **Cập nhật:** Sau internal audit, trước certification audit

{{< callout type="info" >}}
**Tài nguyên miễn phí:** Bạn có thể tải các template miễn phí từ:
- [ISO 27001 Toolkit GitHub](https://github.com/search?q=iso27001+toolkit) - nhiều template Excel/Word
- [UpGuard ISO 27001 Templates](https://www.upguard.com/) - Gap analysis spreadsheet
- [Advisera ISO 27001 Documentation Toolkit](https://advisera.com/) - 100+ templates (có phí, nhưng có free trial)
{{< /callout >}}

---

## Sai lầm thường gặp

### 1. Scope quá rộng ngay từ đầu

**Sai lầm:** "Chúng ta sẽ chứng nhận toàn bộ công ty 50 người ngay lần đầu."

**Hậu quả:**
- Chi phí audit tăng gấp đôi
- Cần document quá nhiều quy trình
- Thời gian kéo dài từ 6 tháng thành 12 tháng
- Khó maintain

**Giải pháp:** Bắt đầu với 1 business unit hoặc 1 dịch vụ cốt lõi, mở rộng sau.

### 2. Bỏ qua bối cảnh bên ngoài (quy định pháp luật)

**Sai lầm:** Chỉ tập trung vào yêu cầu của khách hàng, không nghiên cứu Nghị định 13/2023.

{{< callout type="danger" >}}
**Nguy hiểm:** Không bao giờ bỏ qua Nghị định 13/2023/NĐ-CP khi xác định phạm vi!

Nếu tổ chức bạn xử lý dữ liệu cá nhân của công dân Việt Nam (email, số điện thoại, CCCD...), bạn **bắt buộc** phải tuân thủ Nghị định 13. Auditor ISO 27001 sẽ kiểm tra xem bạn có đánh giá compliance với local regulations không.

**Hành động:** Thêm "Decree 13/2023 compliance" vào Interested Parties register, chọn các kiểm soát Annex A liên quan (A.5.34 Privacy, A.8.24 Cryptography, A.8.10 Information deletion).
{{< /callout >}}

### 3. Không có sự tham gia của lãnh đạo

**Sai lầm:** Chỉ có IT Manager làm ISMS, CEO/Founder không biết gì.

**Hậu quả:**
- Clause 5 (Leadership) sẽ fail ngay
- Không có ngân sách và nguồn lực
- Nhân viên không coi trọng ISMS

**Giải pháp:**
- CEO phải phê duyệt Scope Statement, ISMS Policy
- Leadership phải tham dự Management Review meetings (Clause 9.3)
- Giao KPI về ATTT cho các trưởng phòng

### 4. Gap Analysis quá hời hợt

**Sai lầm:** "Chúng ta check 93 kiểm soát trong 2 giờ, xong rồi!"

**Thực tế:** Gap analysis cần 2-3 tuần, phỏng vấn nhiều người, kiểm tra thực tế hệ thống.

**Giải pháp:** Dành 1-2 ngày cho mỗi nhóm kiểm soát (A.5, A.6, A.7, A.8), thu thập bằng chứng, chụp screenshot, lưu log.

---

## Kết luận & Bước tiếp theo

Chúc mừng! Bạn vừa hoàn thành **Clause 4** - nền tảng của ISMS. Bây giờ bạn đã có:

### Checklist của giai đoạn này

- ✅ SWOT analysis (Context of Organization)
- ✅ Stakeholder register (Interested Parties)
- ✅ ISMS Scope Statement (rõ ràng, cụ thể)
- ✅ Gap Analysis report (biết mình đang ở đâu)
- ✅ Danh sách ưu tiên những gì cần làm tiếp

### Bước tiếp theo

Trong **Phần 3: Đánh giá rủi ro và Kế hoạch xử lý rủi ro**, chúng ta sẽ đi sâu vào **Clause 6.1** - trái tim của ISO 27001:

- **Risk Assessment Methodology:** Cách đánh giá rủi ro bằng phương pháp định tính (qualitative)
- **Asset Register:** Liệt kê tài sản thông tin cần bảo vệ
- **Risk Matrix 5x5:** Xếp hạng rủi ro theo mức độ nghiêm trọng
- **Risk Treatment Plan:** Quyết định cách xử lý từng rủi ro (tránh, giảm, chia sẻ, chấp nhận)
- **Mapping rủi ro với Annex A:** Liên kết rủi ro với kiểm soát phù hợp

👉 **[Đọc tiếp Phần 3: Đánh giá rủi ro và Kế hoạch xử lý rủi ro →](/posts/iso27001-sme/03-danh-gia-rui-ro/)**

---

**Câu hỏi thường gặp:**

**Q: Tôi có thể thay đổi scope sau khi đã chứng nhận không?**
A: Có! Bạn có thể mở rộng hoặc thu hẹp scope. Nếu thay đổi lớn (>30%), cần báo Certification Body và có thể cần re-certification audit. Nếu thay đổi nhỏ, báo cáo trong Surveillance Audit là đủ.

**Q: Scope có thể chỉ bao gồm 1 văn phòng trong số 3 văn phòng của công ty không?**
A: Có, miễn là bạn có lý do hợp lý (ví dụ: chỉ văn phòng Sài Gòn phục vụ khách hàng yêu cầu ISO 27001, còn Hà Nội và Đà Nẵng chỉ làm sales). Auditor sẽ kiểm tra ranh giới có rõ ràng không.

**Q: Tôi dùng hoàn toàn SaaS (Google Workspace, GitHub, AWS), có cần bao gồm các hệ thống đó trong scope không?**
A: Có. Mặc dù vendor quản lý infrastructure, bạn vẫn chịu trách nhiệm về cách bạn **sử dụng** các dịch vụ đó (IAM, encryption, access control). Đây là Shared Responsibility Model - xem A.5.23.
