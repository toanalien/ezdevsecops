---
title: "ISO 27001 cho SME Phần 7: Đào tạo Nhận thức Bảo mật và Quản lý Nhân sự"
date: 2026-02-14
draft: false
description: "Hướng dẫn xây dựng chương trình đào tạo nhận thức bảo mật thông tin cho SME - nội dung đào tạo, công cụ miễn phí, và cách đo lường hiệu quả"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "security-awareness", "training", "clause-7", "nhan-su", "dao-tao"]
series: ["ISO 27001 cho SME"]
weight: 7
mermaid: true
---

## Giới thiệu

Sau khi triển khai các kiểm soát kỹ thuật trong [Phần 6](/posts/iso27001-sme/06-trien-khai-kiem-soat/), yếu tố quan trọng nhất còn lại là **con người**. Dù có hệ thống bảo mật tốt đến đâu, một nhân viên click vào link phishing hoặc sử dụng mật khẩu yếu cũng có thể phá hủy toàn bộ phòng thủ.

ISO 27001 yêu cầu tổ chức phải đảm bảo nhân viên có **năng lực (competence)** và **nhận thức (awareness)** về bảo mật thông tin. Đây không chỉ là yêu cầu compliance mà còn là đầu tư thiết yếu cho an toàn tổ chức.

{{< callout type="info" >}}
**Thông tin**: Theo thống kê, 82% vụ vi phạm dữ liệu liên quan đến yếu tố con người - phishing, social engineering, lỗi cấu hình, mật khẩu yếu. Đầu tư vào training là ROI cao nhất trong bảo mật.
{{< /callout >}}

### Sau bài viết này, bạn sẽ có thể:

- ✅ Hiểu yêu cầu ISO 27001 về competence và awareness
- ✅ Xây dựng chương trình đào tạo bảo mật cho SME
- ✅ Tạo nội dung đào tạo cho 6 module cơ bản
- ✅ Sử dụng công cụ miễn phí để training và đo lường
- ✅ Quản lý vòng đời nhân sự trong ISMS (onboarding/offboarding)
- ✅ Thu thập evidence cho audit

---

## Yêu cầu của ISO 27001 về Nhân sự

### Clause 7.2: Competence (Năng lực)

ISO 27001:2022 Clause 7.2 yêu cầu tổ chức phải:

1. **Xác định năng lực cần thiết** cho người thực hiện công việc ảnh hưởng đến ISMS
2. **Đảm bảo người đó có năng lực** dựa trên education, training, experience
3. **Hành động để có được năng lực** (training, mentoring, reassignment)
4. **Giữ lại evidence** của competence (training records, certificates)

**Ví dụ vai trò cần competence:**
- CISO/Information Security Manager: ISO 27001 Lead Implementer certification
- IT Manager: Technical security skills (firewall, SIEM, cloud security)
- Internal Auditor: ISO 27001 Lead Auditor certification
- Developers: Secure coding training (OWASP)

---

### Clause 7.3: Awareness (Nhận thức)

Clause 7.3 yêu cầu nhân viên **nhận biết (aware of)**:

1. **Information security policy**: Nội dung và tầm quan trọng
2. **Contribution to ISMS effectiveness**: Vai trò của họ trong bảo mật
3. **Implications of not conforming**: Hậu quả khi vi phạm chính sách bảo mật

**Áp dụng cho:** TẤT CẢ nhân viên (không chỉ IT), bao gồm contractors, temps.

---

### Annex A.6: People Controls

**A.6 People controls** chi tiết hơn về quản lý nhân sự:

| Control | Tên | Nội dung |
|---------|-----|----------|
| **A.6.1** | Screening | Background check trước khi tuyển dụng (đã cover Phần 6) |
| **A.6.2** | Terms and conditions of employment | Điều khoản bảo mật trong hợp đồng lao động |
| **A.6.3** | Information security awareness, education and training | **Training bắt buộc** |
| **A.6.4** | Disciplinary process | Quy trình kỷ luật khi vi phạm bảo mật |
| **A.6.5** | Responsibilities after termination | Offboarding (đã cover Phần 6) |
| **A.6.6** | Confidentiality or non-disclosure agreements | NDA cho nhân viên, contractors |
| **A.6.7** | Remote working | Bảo mật WFH (đã cover Phần 6) |
| **A.6.8** | Information security event reporting | Báo cáo sự cố bảo mật |

---

### Vòng đời Nhân sự trong ISMS

{{< mermaid >}}
graph TB
    subgraph Recruitment["1. Tuyển dụng"]
        JOB_POST[Đăng tin tuyển dụng<br/>với security responsibilities]
        SCREEN[Screening & Background Check<br/>A.6.1]
        INTERVIEW[Phỏng vấn<br/>Đánh giá security awareness]
    end

    subgraph Hiring["2. Nhận việc"]
        CONTRACT[Hợp đồng lao động<br/>Security clauses A.6.2]
        NDA[Ký NDA<br/>A.6.6]
        AUP_SIGN[Ký Acceptable Use Policy<br/>A.5.10]
    end

    subgraph Onboarding["3. Onboarding"]
        IT_SETUP[Cấp tài khoản & thiết bị<br/>A.5.18]
        SECURITY_TRAIN[Security Awareness Training<br/>A.6.3 - Mandatory]
        ROLE_TRAIN[Role-specific Training<br/>Clause 7.2]
        POLICY_REVIEW[Đọc & xác nhận Policy<br/>A.5.1]
    end

    subgraph Employment["4. Làm việc"]
        ANNUAL_TRAIN[Annual Refresher Training<br/>A.6.3]
        PHISHING_SIM[Phishing Simulations<br/>Quarterly]
        ROLE_CHANGE[Role Change<br/>Access review A.5.18]
        INCIDENT_TRAIN[Training sau sự cố<br/>A.5.27]
    end

    subgraph Discipline["5. Kỷ luật (nếu vi phạm)"]
        INVESTIGATE[Điều tra vi phạm]
        DISCIPLINARY[Kỷ luật Process<br/>A.6.4]
        RETRAIN[Remedial Training]
    end

    subgraph Offboarding["6. Nghỉ việc"]
        NOTICE[Thông báo nghỉ việc]
        ACCESS_REVOKE[Thu hồi tất cả truy cập<br/>A.6.5 - Day 1]
        EQUIP_RETURN[Thu thiết bị]
        EXIT_INTERVIEW[Exit Interview<br/>Nhắc nhở NDA]
        MONITOR[Giám sát 30 ngày<br/>Phát hiện truy cập bất thường]
    end

    JOB_POST --> SCREEN
    SCREEN --> INTERVIEW
    INTERVIEW --> CONTRACT

    CONTRACT --> NDA
    NDA --> AUP_SIGN
    AUP_SIGN --> IT_SETUP

    IT_SETUP --> SECURITY_TRAIN
    SECURITY_TRAIN --> ROLE_TRAIN
    ROLE_TRAIN --> POLICY_REVIEW

    POLICY_REVIEW --> ANNUAL_TRAIN
    ANNUAL_TRAIN --> PHISHING_SIM
    PHISHING_SIM --> ROLE_CHANGE
    ROLE_CHANGE --> INCIDENT_TRAIN
    INCIDENT_TRAIN --> ANNUAL_TRAIN

    Employment --> INVESTIGATE
    INVESTIGATE --> DISCIPLINARY
    DISCIPLINARY --> RETRAIN
    RETRAIN --> Employment

    Employment --> NOTICE
    NOTICE --> ACCESS_REVOKE
    ACCESS_REVOKE --> EQUIP_RETURN
    EQUIP_RETURN --> EXIT_INTERVIEW
    EXIT_INTERVIEW --> MONITOR

    style SECURITY_TRAIN fill:#ff6b6b
    style ANNUAL_TRAIN fill:#ff6b6b
    style ACCESS_REVOKE fill:#ff6b6b
    style NDA fill:#4ecdc4
    style PHISHING_SIM fill:#ffe66d
{{< /mermaid >}}

---

## Xây dựng Chương trình Đào tạo

### Training Needs Analysis theo Vai trò

Không phải ai cũng cần training giống nhau. Phân loại theo vai trò:

| Vai trò | Training Required | Frequency | Duration | Evidence |
|---------|-------------------|-----------|----------|----------|
| **All Staff** | Basic Security Awareness (6 modules) | Onboarding + Annual | 2 hours | Attendance + Quiz |
| **IT Team** | Technical Security Training<br/>(SIEM, incident response, hardening) | Onboarding + Bi-annual | 8 hours | Certificates |
| **Developers** | Secure Coding (OWASP Top 10) | Onboarding + Annual | 4 hours | Quiz + Code review |
| **Management** | ISMS Overview, Risk Management | Onboarding + Annual | 2 hours | Attendance |
| **ISMS Team** | ISO 27001 Implementation | Initial + As needed | 16-40 hours | Certification |
| **HR** | Data Privacy, Screening, Offboarding | Onboarding + Annual | 2 hours | Quiz |
| **Finance** | Data Protection, Fraud Prevention | Onboarding + Annual | 2 hours | Quiz |

---

### Training Schedule

**Onboarding Training** (Tuần đầu tiên):
- Day 1: Basic security awareness (1 hour)
- Day 2-3: Role-specific training
- Week 1 End: Quiz + policy acknowledgment

**Annual Refresher Training**:
- Month: Tháng 1 hoặc tháng sinh nhật nhân viên (để spread load)
- Duration: 1-2 giờ
- Content: Updates policies, new threats, lessons learned từ incidents

**Incident-Triggered Training**:
- Sau phishing incident: Phishing awareness cho affected users
- Sau data leak: Data classification training
- Sau malware infection: Endpoint security training

**Phishing Simulations**:
- Frequency: Quarterly (4 lần/năm)
- Method: Gửi fake phishing email, track click rate
- Follow-up: Immediate training cho người click

---

### Template: Training Plan

| Training ID | Topic | Target Audience | Frequency | Method | Duration | Owner | Evidence |
|-------------|-------|-----------------|-----------|--------|----------|-------|----------|
| TR-001 | Security Awareness Basics | All staff | Onboarding + Annual | Google Slides + Quiz | 2h | IT Manager | Attendance + Quiz results |
| TR-002 | Phishing & Social Engineering | All staff | Onboarding + Quarterly sim | Video + Simulation | 30min | IT Manager | Simulation click rate |
| TR-003 | Secure Coding (OWASP) | Developers | Onboarding + Annual | Workshop + Labs | 4h | Dev Lead | Quiz + Code review |
| TR-004 | Incident Response | IT Team | Onboarding + Bi-annual | Tabletop exercise | 3h | CISO | Exercise report |
| TR-005 | ISO 27001 Fundamentals | ISMS Team | Initial | Online course | 16h | CISO | Certificate |
| TR-006 | Data Privacy (PDPA/GDPR) | HR, Marketing | Onboarding + Annual | Presentation | 1.5h | Legal | Attendance |

{{< callout type="tip" >}}
**Mẹo**: Chia đào tạo thành các buổi 15-30 phút - nhân viên tiếp thu tốt hơn. Thay vì training 2 giờ liên tục, chia thành 4 sessions 30 phút trong 2 tuần.
{{< /callout >}}

---

## Nội dung Đào tạo Nhận thức Cơ bản

**6 modules bắt buộc cho tất cả nhân viên:**

### Module 1: Chính sách Bảo mật Thông tin (30 phút)

**Mục tiêu học tập:**
- Hiểu Information Security Policy của công ty
- Biết trách nhiệm bảo mật của mình
- Biết hậu quả khi vi phạm

**Nội dung:**
1. **Tại sao bảo mật quan trọng?**
   - Ví dụ data breach nổi tiếng (Equifax, SolarWinds, Colonial Pipeline)
   - Ảnh hưởng đến công ty: mất khách hàng, phạt pháp lý, reputation damage
   - Chi phí trung bình 1 data breach: $4.45M (IBM 2023)

2. **3 trụ cột bảo mật: CIA Triad**
   - **Confidentiality (Bí mật)**: Chỉ người có quyền mới truy cập
   - **Integrity (Toàn vẹn)**: Dữ liệu chính xác, không bị sửa đổi trái phép
   - **Availability (Khả dụng)**: Dữ liệu sẵn sàng khi cần

3. **Information Security Policy highlights**
   - Security objectives
   - Your role and responsibilities
   - Where to find policies (SharePoint/intranet)

4. **Hậu quả vi phạm**
   - Verbal warning → Written warning → Suspension → Termination
   - Pháp lý: có thể bị truy tố nếu cố ý (Cybersecurity Law Vietnam)

**Bài tập thực hành:**
- Scenario: "Bạn nhận được email từ CEO yêu cầu chuyển tiền gấp. Bạn làm gì?"
  - Đúng: Gọi điện/nhắn tin CEO xác nhận trước khi chuyển
  - Sai: Chuyển ngay vì sếp yêu cầu

**Quiz (5 câu):**
1. CIA Triad là viết tắt của gì?
2. Bạn có thể chia sẻ mật khẩu với đồng nghiệp không?
3. Phát hiện laptop bị mất, bước đầu tiên là gì?
4. Ai chịu trách nhiệm bảo mật thông tin? (Đáp án: Tất cả mọi người)
5. Tìm policy ở đâu?

---

### Module 2: Mật khẩu & Xác thực (30 phút)

**Mục tiêu:**
- Tạo mật khẩu mạnh
- Sử dụng password manager
- Kích hoạt MFA

**Nội dung:**
1. **Password Hygiene**
   - **Độ dài > 12 ký tự** (14+ preferred)
   - **Passphrase tốt hơn password**: "ILove2EatPhoInHanoi!" > "P@ssw0rd"
   - **Unique password** cho mỗi tài khoản - KHÔNG dùng lại
   - **Không chia sẻ** mật khẩu với ai
   - **Đổi ngay** nếu nghi ngờ bị lộ

2. **Password Manager**
   - Lợi ích: Nhớ 1 master password thay vì 50 passwords
   - Recommend: Bitwarden (free), 1Password (company-paid)
   - Demo: Cách cài đặt và sử dụng Bitwarden

3. **Multi-Factor Authentication (MFA)**
   - **Something you know** (password) + **Something you have** (phone)
   - Bắt buộc cho: Email, VPN, AWS, GitHub
   - Setup: Google Authenticator, Authy
   - Demo: Enable MFA trên Google Workspace

4. **Phishing password scams**
   - Fake login pages
   - "Your password has expired, click here to reset"
   - Luôn kiểm tra URL trước khi nhập mật khẩu

**Bài tập thực hành:**
- Tạo passphrase mạnh (dựa trên câu yêu thích)
- Cài đặt Bitwarden extension
- Enable MFA trên Google Workspace account

**Quiz (5 câu):**
1. Mật khẩu tốt nhất trong các phương án sau?
   - a) Password123
   - b) P@ssw0rd!
   - c) ILoveMyDog2024InHanoi!
   - d) 12345678
2. Có thể chia sẻ mật khẩu với IT support không?
3. MFA bảo vệ khỏi loại tấn công nào?
4. Password manager an toàn không?
5. Phải làm gì khi nghi ngờ mật khẩu bị lộ?

---

### Module 3: Phishing & Social Engineering (45 phút)

**Mục tiêu:**
- Nhận diện email phishing
- Tránh social engineering attacks
- Biết cách báo cáo

**Nội dung:**

1. **Phishing là gì?**
   - Email giả mạo để lừa click link, tải malware, hoặc lộ thông tin
   - 90% cyberattacks bắt đầu từ phishing email
   - Chi phí trung bình 1 phishing attack thành công: $4.91M

2. **Dấu hiệu nhận biết Phishing**
   ✓ **Sender email lạ**: ceo@company-inc.com (giả) vs ceo@company.com (thật)
   ✓ **Urgent/Threatening tone**: "Account will be closed in 24h!"
   ✓ **Generic greeting**: "Dear Customer" thay vì tên bạn
   ✓ **Suspicious links**: Hover chuột, kiểm tra URL trước khi click
   ✓ **Unexpected attachments**: Đặc biệt .exe, .zip, .scr
   ✓ **Grammar mistakes**: Lỗi chính tả, ngữ pháp sai
   ✓ **Requests for credentials/payment**: Công ty không bao giờ hỏi password qua email

3. **Các loại Phishing**
   - **Spear Phishing**: Target specific person với thông tin cá nhân hóa
   - **Whaling**: Target executives (CEO, CFO)
   - **Vishing**: Voice phishing qua điện thoại
   - **Smishing**: SMS phishing
   - **Business Email Compromise (BEC)**: Giả mạo CEO/vendor để lừa chuyển tiền

4. **Social Engineering Tactics**
   - **Pretexting**: Giả danh IT support - "I need to verify your password"
   - **Baiting**: USB drive bỏ quên ở parking lot (có malware)
   - **Tailgating**: Theo vào văn phòng khi ai đó mở cửa
   - **Quid pro quo**: "Free gift if you complete this survey" (lấy thông tin)

5. **Cách phòng thủ**
   - ✅ **THINK before you CLICK**: Pause, verify, then act
   - ✅ **Verify independently**: Gọi điện/nhắn tin qua kênh khác để xác nhận
   - ✅ **Hover links**: Kiểm tra URL trước khi click
   - ✅ **Don't trust urgency**: Scammers create pressure
   - ✅ **Report suspicious emails**: Forward to security@company.com

**Ví dụ Phishing Email (phân tích):**

```
From: ceo@company-support.com
To: finance@company.com
Subject: URGENT: Wire Transfer Needed

Dear Finance Team,

I am currently in a meeting with investors and need you to wire $50,000
to our new vendor immediately. Please use the account details below.

Bank: XX Bank
Account: 1234567890
Routing: 987654321

This is time-sensitive. Please complete within 1 hour.

Best,
John CEO
```

**Red flags:**
1. ❌ Email domain: company-support.com (not company.com)
2. ❌ Urgency: "within 1 hour"
3. ❌ Unusual request: CEO không yêu cầu wire transfer qua email
4. ❌ Generic signature: "John CEO" (không có chữ ký thật)
5. ❌ No context: New vendor chưa được approve?

**Bài tập thực hành:**
- Phân tích 5 email samples: Phishing hay Legitimate?
- Role-play: IT support giả mạo gọi xin password

**Quiz (5 câu):**
1. Dấu hiệu email phishing?
2. Nhận email từ CEO yêu cầu chuyển tiền gấp, bạn làm gì?
3. Hover link trước khi click để xem gì?
4. USB drive bỏ rơi ở parking lot, nên làm gì?
5. Report phishing email đến đâu?

{{< callout type="warning" >}}
**Cảnh báo**: Đào tạo phải bao gồm bài kiểm tra - auditor cần bằng chứng nhân viên hiểu nội dung. Quiz pass rate < 80% = cần đào tạo lại.
{{< /callout >}}

---

### Module 4: Bảo mật Dữ liệu (30 phút)

**Mục tiêu:**
- Phân loại dữ liệu
- Xử lý dữ liệu đúng cách
- Xóa dữ liệu an toàn

**Nội dung:**

1. **Data Classification**

| Level | Mô tả | Ví dụ | Handling |
|-------|-------|-------|----------|
| **Public** | Có thể công khai | Marketing materials, job postings | No restrictions |
| **Internal** | Chỉ trong công ty | Internal memos, policies | Email within company OK |
| **Confidential** | Nhạy cảm, hạn chế | Customer data, contracts, financials | Encryption required, need-to-know |
| **Restricted** | Cực kỳ nhạy cảm | Trade secrets, M&A plans, PII | Encrypt + MFA, minimal access |

2. **Data Handling Best Practices**
   - **Email**: Không gửi Confidential/Restricted qua email thường, dùng encrypted email/secure file sharing
   - **Sharing**: Chỉ share với người có "need-to-know"
   - **Printing**: Đứng chờ printer, không để tài liệu ở máy in
   - **USB/External drives**: Encrypt trước khi copy dữ liệu
   - **Cloud storage**: Chỉ dùng approved services (Google Drive, OneDrive), KHÔNG Dropbox cá nhân
   - **Screenshots**: Cẩn thận không lộ thông tin nhạy cảm khi screenshot/screen share

3. **Personal Data Protection (PII/PDPA)**
   - PII = Personally Identifiable Information: tên, CMND, địa chỉ, số điện thoại, email
   - Vietnam Decree 13/2023: Bảo vệ dữ liệu cá nhân
   - Xử lý PII: Collect minimum, encrypt, delete khi hết mục đích

4. **Data Deletion**
   - **Don't just delete**: Empty Recycle Bin không đủ
   - **Secure delete**: Dùng file shredder (Eraser, BleachBit)
   - **Hardware disposal**: IT team wipe HDD/SSD trước khi discard
   - **Paper documents**: Shred (không vứt nguyên vào trash)

**Bài tập thực hành:**
- Phân loại 10 loại dữ liệu (customer contract, org chart, quarterly financials, v.v.)
- Scenario: Cần share customer list với marketing agency, làm sao cho an toàn?

**Quiz (5 câu):**
1. Dữ liệu nào là Restricted?
2. Có thể gửi customer data qua Gmail cá nhân không?
3. Xóa file trên laptop, có đủ an toàn không?
4. Screenshot có thể chứa dữ liệu nhạy cảm không?
5. PII là gì?

---

### Module 5: Bảo mật Thiết bị (30 phút)

**Mục tiêu:**
- Bảo vệ laptop, điện thoại công ty
- An toàn khi remote work
- Xử lý thiết bị mất/bị đánh cắp

**Nội dung:**

1. **Laptop/Desktop Security**
   - ✅ **Screen lock**: Windows+L khi rời bàn, auto-lock sau 5 phút
   - ✅ **Full disk encryption**: BitLocker/FileVault enabled
   - ✅ **Antivirus updated**: Real-time protection ON
   - ✅ **OS updates**: Install security patches monthly
   - ✅ **Strong password/PIN**: Không dùng "1234"
   - ✅ **Physical security**: Không để laptop không giám sát ở công cộng
   - ✅ **Backup**: Backup quan trọng data định kỳ

2. **Mobile Device Security**
   - ✅ **Screen lock**: PIN/Fingerprint/Face ID
   - ✅ **Auto-lock**: 1-2 phút
   - ✅ **Encryption**: Enabled by default trên iOS/Android mới
   - ✅ **App permissions**: Chỉ cho phép permissions cần thiết
   - ✅ **No jailbreak/root**: Vi phạm policy, nguy hiểm
   - ✅ **Work profile**: Tách biệt work và personal data (BYOD)
   - ✅ **Remote wipe**: Enable Find My Device / MDM

3. **Remote Work Security**
   - ✅ **VPN mandatory**: Khi truy cập hệ thống công ty từ xa
   - ✅ **Secure WiFi**: WPA3, không dùng public WiFi cho work (hoặc phải VPN)
   - ✅ **Home office**: Lock room khi không ở
   - ✅ **Video calls**: Blur/virtual background nếu có thông tin nhạy cảm phía sau
   - ✅ **Clear desk**: Không để tài liệu công ty trên bàn
   - ✅ **No shoulder surfing**: Cẩn thận khi làm việc ở nơi công cộng

4. **Lost/Stolen Device Protocol**
   1. **Report immediately**: Gọi IT Manager ngay (hotline: xxx)
   2. **Remote wipe**: IT sẽ xóa dữ liệu từ xa
   3. **Change passwords**: Tất cả accounts đã login trên thiết bị đó
   4. **Police report**: Nếu bị đánh cắp (cần cho insurance claim)

**Bài tập thực hành:**
- Kiểm tra laptop: BitLocker enabled? Screen lock setting?
- Setup Find My Device trên điện thoại

**Quiz (5 câu):**
1. Rời bàn 5 phút, có cần lock màn hình không?
2. Public WiFi an toàn cho work không?
3. Laptop bị mất, bước đầu tiên làm gì?
4. Jailbreak iPhone có được phép không?
5. VPN bắt buộc khi nào?

---

### Module 6: Báo cáo Sự cố Bảo mật (15 phút)

**Mục tiêu:**
- Nhận diện security incident
- Biết cách báo cáo
- Hiểu quy trình xử lý

**Nội dung:**

1. **Security Incident là gì?**
   - Bất kỳ sự kiện nào vi phạm hoặc đe dọa bảo mật thông tin
   - Ví dụ:
     - Click vào phishing link
     - Laptop bị mất/đánh cắp
     - Malware infection
     - Unauthorized access attempt
     - Data leak (vô tình gửi file cho sai người)
     - Suspicious email/phone call
     - Password compromise

2. **Tại sao phải báo cáo?**
   - **Fast response = less damage**: Phát hiện sớm → ngăn chặn kịp thời
   - **Protect others**: Phishing campaign có thể target nhiều người
   - **Compliance**: Legal requirement (PDPA, ISO 27001)
   - **No blame culture**: Báo cáo thật thà được khuyến khích, không bị phạt

3. **Cách báo cáo**
   - **Email**: security@company.com
   - **Slack**: #security-incidents channel
   - **Hotline**: [Phone number] (critical incidents only)
   - **In-person**: IT Manager office

4. **Thông tin cần cung cấp**
   - **Gì**: Sự cố gì xảy ra?
   - **Khi nào**: Thời gian chính xác
   - **Ai**: Ai bị ảnh hưởng?
   - **Đâu**: Location, system nào?
   - **Evidence**: Screenshot, email headers, logs (nếu có)

5. **Quy trình xử lý (tóm tắt)**
   1. **Report** → 2. **Triage** (IT assess severity) → 3. **Contain** → 4. **Investigate** → 5. **Remediate** → 6. **Lessons Learned**

**Bài tập:**
- Scenario: "Bạn vừa click vào link trong email nghi ngờ. Làm gì tiếp theo?"
  1. ✅ Report ngay đến security@company.com
  2. ✅ Disconnect WiFi/Ethernet (nếu nghi ngờ malware)
  3. ✅ Đổi passwords (nếu đã nhập credentials)
  4. ✅ Chờ hướng dẫn từ IT

**Quiz (3 câu):**
1. Click nhầm vào phishing link, có cần báo cáo không?
2. Báo cáo security incident đến đâu?
3. Báo cáo incident có bị phạt không?

---

## Công cụ Đào tạo Miễn phí / Chi phí Thấp

### 1. Tạo nội dung Training

| Tool | Cost | Use Case |
|------|------|----------|
| **Google Slides** | Free | Presentation slides |
| **Canva** | Free tier + Pro $13/month | Professional graphics, templates |
| **Loom** | Free tier | Record video tutorials |
| **OBS Studio** | Free | Screen recording, video editing |
| **Notion/Confluence** | Free tiers | Training documentation wiki |

---

### 2. Quiz & Assessment

| Tool | Cost | Features |
|------|------|----------|
| **Google Forms** | Free | Quiz, automatic grading, response tracking |
| **Typeform** | Free tier: 10 questions | Beautiful UI, logic jumps |
| **Kahoot** | Free tier | Gamified quiz, live competitions |
| **Quizizz** | Free | Self-paced quiz, leaderboards |

**Google Forms Example:**
```
Training Quiz: Security Awareness Basics

1. What does CIA Triad stand for?
   - Confidentiality, Integrity, Availability *
   - Central Intelligence Agency
   - Cloud, Internet, Access
   - Correct, Improve, Achieve

2. You receive an email from "CEO" asking to wire money urgently. What should you do?
   - Wire immediately, CEO is waiting
   - Verify by calling CEO directly *
   - Reply to email asking confirmation
   - Ignore the email

[* = Correct answer]
```

{{< callout type="tip" >}}
**Mẹo**: Google Forms + Google Slides = giải pháp đào tạo hoàn chỉnh, miễn phí. Kết hợp với Google Classroom nếu cần track progress cho nhiều cohorts.
{{< /callout >}}

---

### 3. Phishing Simulation

| Tool | Cost | Features |
|------|------|----------|
| **KnowBe4 Free Phishing Test** | Free (limited) | Send simulated phishing to 100 users, report results |
| **Gophish** | Free (open-source) | Self-hosted phishing simulation platform |
| **PhishMe (Cofense)** | Paid (~$5/user/year) | Enterprise phishing simulation + training |
| **Lucy Security** | Free trial + Paid | Advanced phishing/malware simulation |

**Gophish Quickstart:**
```bash
# Self-hosted phishing simulation
wget https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip
unzip gophish-v0.12.1-linux-64bit.zip
./gophish

# Access web UI at https://localhost:3333
# Create campaign, import user list, send simulated phishing
```

**Recommended workflow:**
1. **Quarter 1**: Use KnowBe4 free test (baseline measurement)
2. **Quarter 2-4**: Self-host Gophish for ongoing simulations
3. **Track**: Click rate, report rate over time (target: <5% click rate)

---

### 4. Video Training Resources (Free)

| Source | Content |
|--------|---------|
| **NIST Cybersecurity Awareness** | [nist.gov/itl/applied-cybersecurity/nice/resources](https://www.nist.gov/itl/applied-cybersecurity/nice/resources) |
| **SANS Security Awareness** | [sans.org/security-awareness-training/resources](https://www.sans.org/security-awareness-training/resources) |
| **CISA Cybersecurity Tips** | [cisa.gov/cybersecurity-tips](https://www.cisa.gov/cybersecurity-tips) |
| **YouTube Channels** | Simplilearn, Professor Messer, NetworkChuck (security topics) |

**Curated Playlist cho SME:**
1. Introduction to Cybersecurity (15 min)
2. Password Security & MFA (10 min)
3. Phishing Awareness (12 min)
4. Social Engineering (10 min)
5. Mobile Device Security (8 min)
6. Incident Reporting (5 min)

**Total**: ~60 phút video + 30 phút quiz = 1.5 giờ onboarding training.

---

## Đo lường Hiệu quả Đào tạo

### Metrics to Track

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| **Training completion rate** | 100% within 30 days of onboarding | LMS/spreadsheet tracking |
| **Quiz pass rate** | ≥ 80% first attempt | Google Forms auto-grade |
| **Phishing simulation click rate** | < 5% | Gophish/KnowBe4 dashboard |
| **Phishing simulation report rate** | > 70% | Gophish/KnowBe4 dashboard |
| **Security incidents (user error)** | Decrease 20% YoY | Incident tracking system |
| **Time to complete training** | < 2 hours (basic awareness) | LMS tracking |
| **Post-training survey score** | ≥ 4/5 satisfaction | Google Forms survey |

---

### Training Effectiveness Cycle

{{< mermaid >}}
graph TB
    subgraph Plan["1. Lập kế hoạch"]
        IDENTIFY[Xác định Training Needs<br/>Role-based analysis]
        DESIGN[Thiết kế Nội dung<br/>6 modules]
        SCHEDULE[Lên lịch<br/>Onboarding + Annual]
    end

    subgraph Deliver["2. Triển khai"]
        ANNOUNCE[Thông báo Training<br/>Email + Calendar invite]
        CONDUCT[Thực hiện Đào tạo<br/>Slides + Video + Quiz]
        ASSESS[Đánh giá<br/>Quiz + Attendance]
    end

    subgraph Measure["3. Đo lường"]
        QUIZ_RATE[Quiz Pass Rate<br/>Target: ≥80%]
        PHISH_SIM[Phishing Simulation<br/>Target: <5% click]
        INCIDENT_RATE[Incident Rate<br/>Trend down]
        SURVEY[Feedback Survey<br/>Satisfaction score]
    end

    subgraph Improve["4. Cải tiến"]
        ANALYZE[Phân tích Kết quả<br/>Identify gaps]
        UPDATE[Cập nhật Nội dung<br/>New threats, lessons learned]
        RETRAIN[Đào tạo lại<br/>Targeted remediation]
    end

    subgraph Report["5. Báo cáo"]
        MGMT_REVIEW[Management Review<br/>Quarterly report]
        EVIDENCE[Thu thập Evidence<br/>For audit]
    end

    IDENTIFY --> DESIGN
    DESIGN --> SCHEDULE
    SCHEDULE --> ANNOUNCE

    ANNOUNCE --> CONDUCT
    CONDUCT --> ASSESS

    ASSESS --> QUIZ_RATE
    ASSESS --> PHISH_SIM
    ASSESS --> INCIDENT_RATE
    ASSESS --> SURVEY

    QUIZ_RATE --> ANALYZE
    PHISH_SIM --> ANALYZE
    INCIDENT_RATE --> ANALYZE
    SURVEY --> ANALYZE

    ANALYZE --> UPDATE
    UPDATE --> RETRAIN
    RETRAIN --> CONDUCT

    ANALYZE --> MGMT_REVIEW
    MGMT_REVIEW --> EVIDENCE
    EVIDENCE --> Plan

    style CONDUCT fill:#ff6b6b
    style ASSESS fill:#4ecdc4
    style ANALYZE fill:#ffe66d
    style UPDATE fill:#95e1d3
{{< /mermaid >}}

---

### Before/After Comparison

**Example: Phishing Simulation Results**

| Quarter | Click Rate | Report Rate | Improvement |
|---------|------------|-------------|-------------|
| **Q1 2026 (Baseline)** | 25% | 10% | - |
| **Q2 2026 (After Training)** | 15% | 40% | ↓40% clicks, ↑300% reports |
| **Q3 2026** | 8% | 60% | ↓68% clicks, ↑500% reports |
| **Q4 2026** | 4% | 75% | ↓84% clicks, ↑650% reports |

**Target achieved**: Click rate < 5% ✅

---

### Template: Training Effectiveness Tracker

```markdown
# Training Effectiveness Report - Q1 2026

## Completion Metrics
- Total employees: 25
- Completed onboarding training: 25 (100%)
- Completed annual refresher: 23 (92%) - 2 on leave
- Average time to complete: 1.8 hours

## Assessment Results
- Quiz pass rate (first attempt): 88%
- Quiz pass rate (after retake): 100%
- Average quiz score: 87/100

## Phishing Simulation
- Emails sent: 25
- Clicked link: 2 (8%)
- Reported as phishing: 18 (72%)
- No action: 5 (20%)

## Incidents (User Error)
- Q1 2026: 3 incidents
- Q1 2025: 7 incidents
- Improvement: ↓57%

## Feedback
- Survey response rate: 80% (20/25)
- Average satisfaction: 4.2/5
- Comments: "Phishing examples very helpful", "Quiz too easy", "Want more technical content"

## Action Items
- [ ] Add advanced phishing examples (spear phishing, BEC)
- [ ] Create technical track for IT/Dev teams
- [ ] Retrain 2 employees with low quiz scores
- [ ] Follow up with 5 non-reporters (phishing blind spot)

## Next Review: 2026-06-15
```

---

## Quản lý Nhân sự trong ISMS

### A.6.2: Terms and Conditions of Employment

**Security clauses trong hợp đồng lao động:**

```markdown
ĐIỀU KHOẢN BẢO MẬT THÔNG TIN (EMPLOYMENT CONTRACT)

Nhân viên cam kết:

1. TUÂN THỦ CHÍNH SÁCH: Tuân thủ Information Security Policy và các chính sách liên quan.

2. BẢO MẬT THÔNG TIN: Bảo vệ thông tin công ty, không tiết lộ cho bên thứ ba.

3. SỬ DỤNG TÀI SẢN: Sử dụng tài sản CNTT công ty chỉ cho mục đích công việc, theo Acceptable Use Policy.

4. BÁO CÁO SỰ CỐ: Báo cáo ngay mọi sự cố bảo mật hoặc vi phạm chính sách.

5. ĐÀO TẠO: Tham gia đầy đủ các khóa đào tạo bảo mật bắt buộc.

6. TRUY CẬP: Quyền truy cập sẽ được cấp theo nguyên tắc "need-to-know" và thu hồi khi kết thúc hợp đồng.

7. NGHĨA VỤ SAU KHI NGHỈ VIỆC: Nghĩa vụ bảo mật tiếp tục sau khi kết thúc hợp đồng lao động.

8. VI PHẠM: Vi phạm chính sách bảo mật có thể dẫn đến kỷ luật, chấm dứt hợp đồng, và truy tố pháp lý.

Ký tên: _________________ Ngày: _________
```

---

### A.6.4: Disciplinary Process

**Quy trình kỷ luật khi vi phạm bảo mật:**

| Mức độ | Vi phạm | Kỷ luật | Ví dụ |
|--------|---------|---------|-------|
| **Minor** | Vô tình, lần đầu | Verbal warning + Remedial training | Để laptop không khóa màn hình |
| **Moderate** | Lặp lại hoặc nghiêm trọng hơn | Written warning + Training | Click phishing link 2 lần |
| **Serious** | Cố ý hoặc gây thiệt hại | Suspension + Investigation | Chia sẻ credentials |
| **Severe** | Rất nghiêm trọng, cố ý | Termination + Legal action | Data exfiltration, sabotage |

**Quy trình:**
1. **Investigation**: Thu thập evidence, phỏng vấn
2. **Determination**: Đánh giá mức độ vi phạm
3. **Disciplinary action**: Áp dụng kỷ luật phù hợp
4. **Documentation**: Ghi nhận vào HR file
5. **Follow-up**: Training, monitoring

---

### Onboarding Security Checklist (Chi tiết)

```markdown
ONBOARDING SECURITY CHECKLIST

Employee: _______________  Start Date: ___________  Role: __________

HR TASKS:
- [ ] Employment contract với security clauses ký kết
- [ ] NDA ký kết
- [ ] Background check completed (nếu required)
- [ ] Emergency contact collected

IT ACCESS SETUP:
- [ ] Email account created (firstname.lastname@company.com)
- [ ] MFA enabled trên email
- [ ] VPN account created
- [ ] Cloud accounts (AWS/Azure) created với least privilege
- [ ] GitHub/GitLab account added to org
- [ ] Slack account created
- [ ] Laptop issued: Serial #___________, Encrypted: Yes/No
- [ ] Mobile device (if needed): Serial #___________, MDM enrolled: Yes/No
- [ ] Badge/access card issued: Card #___________

POLICIES & TRAINING:
- [ ] Information Security Policy provided & acknowledged
- [ ] Acceptable Use Policy signed
- [ ] Data Classification Guide provided
- [ ] Password Policy explained
- [ ] Incident Reporting procedure explained
- [ ] Security Awareness Training scheduled (within 7 days)

WEEK 1 TRAINING:
- [ ] Day 1: Security Awareness Basic (2 hours) - Completed: ___/___/___
- [ ] Day 3: Role-specific training - Completed: ___/___/___
- [ ] Week 1 End: Quiz passed (≥80%): Yes/No - Score: ____/100

CONFIRMATION:
- [ ] All access granted reviewed by Manager
- [ ] All training completed
- [ ] Quiz passed
- [ ] Employee confirms understanding of security responsibilities

Employee Signature: _________________  Date: _________
IT Manager Signature: _______________  Date: _________
HR Signature: ______________________  Date: _________
```

---

### Offboarding Security Checklist (Chi tiết)

**Đã cover trong Phần 6, nhắc lại:**

{{< callout type="danger" >}}
**Nguy hiểm**: Không vô hiệu hóa tài khoản nhân viên nghỉ việc là rủi ro bảo mật nghiêm trọng. 20% data breaches liên quan đến former employees vẫn có access. Disable ALL access **trong ngày cuối cùng**, không chờ đến ngày hôm sau.
{{< /callout >}}

---

## Lưu trữ Bằng chứng Đào tạo

### Evidence cần thu thập

| Evidence Type | Description | Retention | Storage |
|---------------|-------------|-----------|---------|
| **Training attendance** | Danh sách tham gia (Google Forms, sign-in sheet) | 3 years minimum | /evidence/A.6.3-Training/ |
| **Quiz results** | Individual scores, pass/fail | 3 years | Google Forms responses export |
| **Certificates** | Completion certificates (for technical training) | Permanent (in HR file) | HR system + /evidence/ |
| **Policy acknowledgments** | Signed AUP, InfoSec Policy | Duration of employment + 3 years | HR system |
| **Phishing simulation reports** | Click rate, report rate, trends | 3 years | Gophish exports |
| **Training materials** | Slides, videos, handouts | Current version + 1 previous | SharePoint/Drive |
| **Training plan** | Annual training schedule | 3 years | /evidence/ |
| **Effectiveness reports** | Quarterly analysis | 3 years | /evidence/ |

---

### Evidence Organization

```
Evidence/A.6-People/
├── A.6.1-Screening/
│   ├── Screening-Process.pdf
│   └── Background-Check-Reports/ (redacted)
├── A.6.2-Employment-Terms/
│   ├── Contract-Template-Security-Clauses.docx
│   └── Signed-Contracts/ (HR system, not in shared drive)
├── A.6.3-Training/
│   ├── Training-Plan-2026.xlsx
│   ├── Training-Materials/
│   │   ├── Module-1-InfoSec-Policy.pptx
│   │   ├── Module-2-Password-MFA.pptx
│   │   ├── Module-3-Phishing.pptx
│   │   ├── Module-4-Data-Security.pptx
│   │   ├── Module-5-Device-Security.pptx
│   │   └── Module-6-Incident-Reporting.pptx
│   ├── Attendance/
│   │   ├── 2026-Q1-Attendance.xlsx
│   │   ├── 2026-Q2-Attendance.xlsx
│   │   └── ...
│   ├── Quiz-Results/
│   │   ├── 2026-Q1-Quiz-Results.csv (exported from Google Forms)
│   │   └── ...
│   ├── Certificates/
│   │   ├── ISO27001-Lead-Implementer-CISO.pdf
│   │   ├── Secure-Coding-OWASP-DevLead.pdf
│   │   └── ...
│   ├── Phishing-Simulations/
│   │   ├── 2026-Q1-Phishing-Report.pdf
│   │   ├── 2026-Q2-Phishing-Report.pdf
│   │   └── Gophish-Campaign-Exports/
│   └── Effectiveness-Reports/
│       ├── 2026-Q1-Training-Effectiveness.pdf
│       └── ...
├── A.6.5-Offboarding/
│   ├── Offboarding-Checklist-Template.xlsx
│   └── Completed-Checklists/ (by employee, redacted)
└── A.6.6-NDA/
    └── NDA-Template.docx
```

{{< callout type="info" >}}
**Thông tin**: Lưu tất cả bằng chứng đào tạo trong thư mục `/evidence/A.6.3-Training/` với cấu trúc rõ ràng theo quarter/year - cần cho mọi đợt audit (internal, certification, surveillance).
{{< /callout >}}

---

## Kết luận & Bước tiếp theo

Con người là **cả điểm yếu và điểm mạnh** nhất của bảo mật. Đầu tư đúng vào training, awareness, và HR processes sẽ biến nhân viên thành lớp phòng thủ đầu tiên.

### Checklist Chương trình Training

- ✅ Training needs analysis hoàn thành (role-based)
- ✅ 6 training modules cơ bản tạo xong
- ✅ Training schedule thiết lập (onboarding + annual + incident-triggered)
- ✅ Quiz/assessment cho mỗi module
- ✅ Phishing simulation setup (Gophish/KnowBe4)
- ✅ Onboarding/offboarding checklists sẵn sàng
- ✅ Evidence collection system organized
- ✅ Effectiveness metrics tracking
- ✅ 100% nhân viên completed training trong 30 ngày

### Điểm nhấn quan trọng

- **Clause 7.2 + 7.3**: Competence + Awareness bắt buộc cho tất cả nhân viên
- **A.6.3**: Security awareness training là kiểm soát mandatory
- **6 modules cơ bản**: Policy, Password, Phishing, Data, Device, Incident Reporting
- **Free tools đủ dùng**: Google Forms + Slides + Gophish = training stack hoàn chỉnh
- **Đo lường effectiveness**: Quiz pass rate, phishing click rate, incident trend
- **Evidence critical**: Attendance, quiz results, certificates - cần cho audit
- **People lifecycle**: Onboarding → Annual training → Offboarding - security ở mọi giai đoạn

### Next Steps: Internal Audit & Certification

Sau khi hoàn thành training (Phần 7), ISMS của bạn đã sẵn sàng cho **Internal Audit** và **Certification Audit**:

1. **Internal Audit** (Month 4 trong implementation plan):
   - Audit toàn bộ ISMS theo Clause 4-10 + Annex A SoA
   - Identify non-conformities
   - Corrective actions trong 30-90 ngày

2. **Management Review**:
   - Present ISMS status, audit results, metrics
   - Top management approval để proceed certification

3. **Certification Audit**:
   - Stage 1: Document review, readiness check
   - Stage 2: On-site/remote audit, evidence verification
   - Certification issued (valid 3 years)

**Trong series tiếp theo**, chúng tôi sẽ cover:
- **Phần 8**: Internal Audit & Continuous Improvement
- **Phần 9**: Certification Audit Preparation
- **Phần 10**: Post-Certification - Surveillance Audits & ISMS Maintenance

### Tài liệu tham khảo

- ISO/IEC 27001:2022 - Clause 7.2, 7.3 (Support)
- ISO/IEC 27002:2022 - A.6.3 Implementation Guidance
- [NIST Nice Cybersecurity Workforce Framework](https://www.nist.gov/itl/applied-cybersecurity/nice)
- [SANS Security Awareness Resources](https://www.sans.org/security-awareness-training/resources)
- [KnowBe4 Free Phishing Tools](https://www.knowbe4.com/free-phishing-security-test)
- [Gophish Documentation](https://docs.getgophish.com/)
- Verizon 2023 Data Breach Investigations Report (DBIR)
