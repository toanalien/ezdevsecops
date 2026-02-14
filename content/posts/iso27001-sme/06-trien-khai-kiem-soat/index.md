---
title: "ISO 27001 cho SME Phần 6: Triển khai các Kiểm soát Annex A trong Thực tế"
date: 2026-02-14
draft: false
description: "Hướng dẫn triển khai các kiểm soát Annex A ISO 27001:2022 cho SME - công cụ miễn phí, cấu hình thực tế, checklist triển khai cho từng nhóm kiểm soát"
categories: ["Bảo mật thông tin"]
tags: ["iso27001", "annex-a", "controls", "implementation", "open-source", "security-tools"]
series: ["ISO 27001 cho SME"]
weight: 6
mermaid: true
---

## Giới thiệu

Sau khi hoàn thành SoA ([Phần 4](/posts/iso27001-sme/04-tuyen-bo-ap-dung/)) và xây dựng tài liệu ISMS ([Phần 5](/posts/iso27001-sme/05-chinh-sach-tai-lieu/)), đã đến lúc **triển khai thực tế** các kiểm soát Annex A. Đây là bước quan trọng nhất - chuyển từ giấy tờ sang hành động cụ thể.

Thách thức lớn nhất với SME: **Ngân sách hạn chế, nguồn lực ít, nhưng vẫn phải đáp ứng yêu cầu bảo mật**. Tin tốt là hầu hết kiểm soát có thể triển khai bằng công cụ miễn phí hoặc open-source.

{{< callout type="info" >}}
**Thông tin**: Không cần triển khai tất cả 93 kiểm soát cùng lúc - bắt đầu với các kiểm soát có rủi ro cao nhất từ risk assessment (Phần 3). Phased approach giúp team không bị overwhelm.
{{< /callout >}}

### Sau bài viết này, bạn sẽ có thể:

- ✅ Triển khai kiểm soát cho 4 nhóm: Organizational, People, Physical, Technological
- ✅ Sử dụng công cụ miễn phí/open-source cho từng kiểm soát
- ✅ Lập kế hoạch triển khai theo giai đoạn (4 tháng)
- ✅ Thu thập evidence cho certification audit
- ✅ Xây dựng technology security stack cho SME

---

## A.5: Kiểm soát Tổ chức (Organizational Controls)

Nhóm kiểm soát này tập trung vào **policies, processes, roles, và quản lý rủi ro** - nền tảng của ISMS.

### Kiểm soát ưu tiên cho SME

#### A.5.1: Policies for Information Security

**Đã hoàn thành trong Phần 5** - Information Security Policy cấp cao.

**Checklist:**
- ✅ Policy có chữ ký CEO
- ✅ Communicate cho toàn bộ nhân viên
- ✅ Publish trên intranet/SharePoint
- ✅ Đặt lịch review hàng năm

**Evidence:** Policy document v1.0, email announcement, SharePoint link

---

#### A.5.2: Information Security Roles and Responsibilities

**Mục đích:** Phân công rõ ràng ai làm gì trong ISMS.

**Implementation:**

1. **Tạo RACI Matrix** (Responsible, Accountable, Consulted, Informed)

| Vai trò ISMS | Trách nhiệm | Người đảm nhận (ví dụ) |
|--------------|-------------|------------------------|
| **Information Security Manager (CISO)** | Quản lý ISMS tổng thể, xem xét rủi ro, báo cáo Top Mgmt | CTO hoặc IT Manager |
| **Risk Owner** | Chịu trách nhiệm xử lý rủi ro cụ thể | Department Heads |
| **Control Owner** | Triển khai và duy trì kiểm soát | IT Manager, DevOps Lead, HR |
| **Internal Auditor** | Thực hiện internal audit | External contractor hoặc trained staff |
| **Incident Response Manager** | Điều phối xử lý sự cố | IT Manager |
| **DPO (Data Protection Officer)** | Bảo vệ dữ liệu cá nhân (nếu có) | Legal/Compliance |

2. **Document trong Organizational Chart**

3. **Update Job Descriptions** với security responsibilities

**Tools:** Microsoft Visio, Lucidchart (free tier), hoặc Google Sheets

**Evidence:** RACI matrix, org chart, updated job descriptions

---

#### A.5.7: Threat Intelligence

**Mục đích:** Giám sát mối đe dọa mới nổi để cập nhật phòng thủ.

**Implementation:**

1. **Đăng ký Threat Feeds miễn phí:**
   - **[AlienVault OTX](https://otx.alienvault.com)** - Open Threat Exchange, miễn phí
   - **[MITRE ATT&CK](https://attack.mitre.org)** - Framework TTP (Tactics, Techniques, Procedures)
   - **[VirusTotal Intelligence](https://www.virustotal.com)** - Malware intelligence (free tier)
   - **[US-CERT Alerts](https://www.cisa.gov/uscert/ncas/alerts)** - Government alerts

2. **Theo dõi Security News:**
   - [The Hacker News](https://thehackernews.com)
   - [Krebs on Security](https://krebsonsecurity.com)
   - [Bleeping Computer](https://www.bleepingcomputer.com)

3. **Quy trình:**
   - IT Manager review threat feeds **hàng tuần**
   - Đánh giá impact to organization
   - Update defenses nếu cần (patch, block IoC, update rules)
   - Document trong threat intelligence log

**Tools:** RSS reader (Feedly), email subscriptions

{{< callout type="tip" >}}
**Mẹo**: A.5.7 Threat Intelligence - đăng ký miễn phí OTX AlienVault để nhận cảnh báo mối đe dọa mới. Setup email alert cho severity: high/critical, review 15 phút mỗi tuần là đủ.
{{< /callout >}}

**Evidence:** Threat intelligence log, email subscriptions, review meeting minutes

---

#### A.5.10: Acceptable Use of Information and Assets

**Đã hoàn thành trong Phần 5** - Acceptable Use Policy (AUP).

**Implementation:**
- Nhân viên ký acknowledgment khi onboarding
- Publish AUP trên intranet
- Annual reminder email

**Tools:** Google Forms (employee acknowledgment), DocuSign (digital signature)

**Evidence:** Signed AUP acknowledgments, intranet link

---

#### A.5.15: Access Control Policy

**Đã hoàn thành trong Phần 5** - Access Control Policy.

**Implementation thực tế sẽ ở A.8.x** (Technological Controls - xem bên dưới).

---

#### A.5.19: Information Security in Supplier Relationships

**Mục đích:** Quản lý rủi ro từ vendors/third-parties.

**Implementation:**

1. **Tạo Vendor Risk Assessment Template:**

| Tiêu chí | Câu hỏi | Điểm rủi ro |
|----------|---------|-------------|
| Data access | Vendor có truy cập dữ liệu nhạy cảm? | 1-5 |
| ISO 27001 | Vendor có chứng nhận ISO 27001? | +2 nếu có |
| SOC 2 | Vendor có SOC 2 Type II? | +1 nếu có |
| Data location | Dữ liệu lưu trữ ở đâu? | EU/US: 1, Other: 3 |
| Incident history | Vendor có data breach trong 3 năm qua? | +5 nếu có |

2. **Security Requirements trong Hợp đồng:**
   - Right to audit
   - Data protection obligations
   - Incident notification (within 24h)
   - Data deletion upon termination
   - SLA requirements (uptime, response time)

3. **Vendor Inventory:**

| Vendor | Service | Risk Level | ISO 27001? | Review Date |
|--------|---------|------------|------------|-------------|
| AWS | Cloud hosting | High | Yes | Q1 2026 |
| Google Workspace | Email, Drive | High | Yes | Q1 2026 |
| GitHub | Source code | High | Yes | Q2 2026 |
| Slack | Communication | Medium | Yes | Q3 2026 |

**Tools:** Excel/Google Sheets cho vendor inventory

**Evidence:** Vendor contracts với security clauses, vendor risk assessments, review meeting minutes

---

#### A.5.23: Information Security for Cloud Services

**Mục đích:** Bảo mật khi sử dụng cloud (AWS, Azure, GCP).

**Implementation cho AWS (ví dụ):**

1. **Enable AWS Security Best Practices:**
   - ✅ **Root account MFA** enabled
   - ✅ **IAM password policy**: min 14 chars, complexity, rotation 90 days
   - ✅ **CloudTrail** logging enabled (all regions)
   - ✅ **Config** enabled để track configuration changes
   - ✅ **GuardDuty** enabled (threat detection, $0.50/day)
   - ✅ **Security Hub** enabled (compliance checks)
   - ✅ **VPC Flow Logs** enabled
   - ✅ **S3 bucket encryption** default enabled
   - ✅ **S3 Block Public Access** enabled by default

2. **AWS Security Checklist:**
   - No overly permissive security groups (0.0.0.0/0 cho SSH/RDP)
   - Least privilege IAM policies
   - Regular access key rotation
   - No hardcoded credentials trong code

3. **Regular AWS Security Review:**
   - Run **AWS Trusted Advisor** security checks (free tier)
   - Review **Security Hub** findings monthly
   - Check **GuardDuty** alerts weekly

**Tools (free/included):**
- AWS CloudTrail
- AWS Config
- AWS Security Hub
- AWS GuardDuty (pay-as-you-go, ~$50/month cho SME)
- AWS Trusted Advisor (Basic checks miễn phí)

**Evidence:** Screenshots của enabled services, Security Hub compliance reports, review logs

---

#### A.5.24: Information Security Incident Management Planning

**Đã hoàn thành trong Phần 5** - Incident Response Plan.

**Implementation:**

1. **Setup Incident Reporting Channel:**
   - Email: security@company.com
   - Slack channel: #security-incidents
   - Hotline: cho critical incidents

2. **Incident Response Team:**
   - Incident Manager: IT Manager
   - Technical Lead: DevOps Lead
   - Communications: CEO/PR
   - Legal: Legal Counsel (if needed)

3. **Incident Classification & SLA:**

| Severity | Ví dụ | Response Time | Resolution Target |
|----------|-------|---------------|-------------------|
| Critical | Ransomware, data breach, system compromise | 15 phút | 4 giờ (contain) |
| High | Malware infection, DDoS | 1 giờ | 24 giờ |
| Medium | Phishing attempt, policy violation | 4 giờ | 3 ngày |
| Low | Lost device (non-sensitive), minor config issue | 1 ngày | 1 tuần |

4. **Incident Response Playbooks:**
   - Ransomware playbook
   - Data breach playbook
   - DDoS playbook
   - Phishing playbook

**Tools:** Incident tracking trong Jira/ServiceNow, hoặc Google Sheets

**Evidence:** Incident response plan, playbooks, incident tickets, post-incident reports

---

#### A.5.30: ICT Readiness for Business Continuity

**Mục đích:** Đảm bảo hệ thống CNTT sẵn sàng cho disaster recovery.

**Implementation:**

1. **Xác định RTO/RPO cho từng hệ thống:**

| Hệ thống | Criticality | RTO | RPO | Backup Strategy |
|----------|-------------|-----|-----|-----------------|
| Production database | Critical | 2h | 1h | Hourly snapshot + continuous replication |
| Application servers | Critical | 4h | 4h | Daily AMI backup |
| Email (Google Workspace) | High | 1h | 1h | Google manages |
| Internal wiki | Medium | 24h | 24h | Daily backup |
| Development environments | Low | 3 days | 1 day | Weekly backup |

2. **Disaster Recovery Plan:**
   - Multi-AZ deployment trong AWS
   - Automated failover
   - Backup to different region (disaster scenario)
   - Documented recovery procedures

3. **DR Testing:**
   - **Tabletop exercise**: Quarterly (discuss scenario)
   - **Partial DR test**: Bi-annually (restore 1 system)
   - **Full DR test**: Annually (failover entire production)

**Evidence:** RTO/RPO table, DR plan document, DR test reports

---

## A.6: Kiểm soát Con người (People Controls)

Nhóm kiểm soát về **tuyển dụng, đào tạo, kỷ luật, offboarding**.

### Kiểm soát ưu tiên cho SME

#### A.6.1: Screening

**Mục đích:** Background check nhân viên trước khi tuyển dụng.

**Implementation:**

1. **Screening Process:**
   - **Reference checks**: Gọi 2 người tham chiếu từ CV
   - **Education verification**: Xác minh bằng cấp (đặc biệt cho vị trí sensitive)
   - **Criminal background check**: Sử dụng dịch vụ background check (VN: Vietnam Background Check Service)
   - **Social media screening**: Review public LinkedIn, Facebook (không vi phạm privacy)

2. **Screening theo vị trí:**

| Vị trí | Level | Screening Required |
|--------|-------|-------------------|
| Developer, DevOps | Medium | Reference + Education |
| IT Manager, CISO | High | Reference + Education + Background check |
| Finance, HR | High | Reference + Education + Background check |
| Intern | Low | Reference only |

3. **Document trong HR file:**
   - Screening checklist
   - Reference check notes
   - Background check report

**Tools:** LinkedIn, background check services (~$20-50/check)

**Evidence:** Screening checklists trong HR files, background check reports

---

#### A.6.3: Information Security Awareness, Education and Training

**Chi tiết sẽ có trong Phần 7** - Training & People Management.

**Quick implementation:**
- Annual security awareness training cho tất cả nhân viên
- Onboarding security training cho new hires
- Specialized training cho IT/DevOps team
- Phishing simulation quarterly

**Tools (free):**
- Google Slides + Google Forms (quiz)
- KnowBe4 Free Phishing Security Test
- NIST Cybersecurity Awareness resources

**Evidence:** Training attendance records, quiz results, certificates

---

#### A.6.5: Responsibilities After Termination or Change of Employment

**Mục đích:** Đảm bảo không còn truy cập khi nghỉ việc hoặc chuyển vai trò.

**Implementation:**

**Offboarding Security Checklist:**

```markdown
OFFBOARDING CHECKLIST - Employee: [Name] - Last Day: [Date]

IT ACCESS:
- [ ] Disable Active Directory / Google Workspace account (immediately on last day)
- [ ] Disable VPN access
- [ ] Remove from AWS IAM, GitHub, Slack, all SaaS tools
- [ ] Disable physical access card
- [ ] Revoke API keys, tokens, certificates issued to employee
- [ ] Change shared passwords employee had access to

EQUIPMENT:
- [ ] Collect laptop, phone, security token
- [ ] Wipe devices (DoD 5220.22-M standard)
- [ ] Collect access cards, keys

DATA:
- [ ] Transfer work data to manager
- [ ] Delete personal data from company systems
- [ ] Backup employee's files (retain 30 days)

LEGAL:
- [ ] Remind of NDA obligations
- [ ] Collect signed offboarding acknowledgment
- [ ] Final paycheck processed

MONITORING:
- [ ] Monitor for unusual activity 30 days post-termination
- [ ] Review access logs for anomalies
```

**Role Change Checklist:**

```markdown
ROLE CHANGE - Employee: [Name] - New Role: [Title]

- [ ] Review current access rights
- [ ] Remove access no longer needed (old role)
- [ ] Grant new access (new role)
- [ ] Update in IAM systems
- [ ] Update in HR system
- [ ] Security training for new role (if needed)
- [ ] Manager approval for access changes
```

**Tools:** HR system (BambooHR, Workday), checklist trong Google Sheets

{{< callout type="danger" >}}
**Nguy hiểm**: Không vô hiệu hóa tài khoản nhân viên nghỉ việc là rủi ro bảo mật nghiêm trọng. Nhiều data breach xảy ra do former employee vẫn có access. Disable account **ngay trong ngày cuối cùng**.
{{< /callout >}}

**Evidence:** Offboarding checklists, HR records, access revocation logs

---

#### A.6.7: Remote Working

**Mục đích:** Bảo mật khi làm việc từ xa (WFH).

**Implementation:**

1. **Remote Work Security Requirements:**
   - ✅ **VPN mandatory** khi truy cập hệ thống nội bộ (WireGuard, OpenVPN)
   - ✅ **Endpoint protection** installed (antivirus, EDR)
   - ✅ **Full disk encryption** (BitLocker, FileVault)
   - ✅ **Screen lock** after 5 minutes idle
   - ✅ **Secure WiFi**: WPA3, không dùng public WiFi cho work
   - ✅ **Physical security**: Clear desk khi rời khỏi workspace
   - ✅ **No screen sharing** trong video calls khi có thông tin nhạy cảm

2. **Remote Work Policy checklist:**
   - Approved work locations (home, coworking space - not coffee shop)
   - Equipment standards (company-issued preferred)
   - Video call backgrounds (blur/virtual background for confidentiality)
   - Data download restrictions

**Tools:**
- **VPN**: WireGuard (free, modern), OpenVPN Access Server (free 2 connections)
- **MDM**: Microsoft Intune (included in M365 Business Premium)
- **Encryption**: BitLocker (Windows), FileVault (macOS) - built-in

**Evidence:** Remote work policy, VPN connection logs, endpoint compliance reports

---

## A.7: Kiểm soát Vật lý (Physical Controls)

Nhóm kiểm soát về **bảo vệ cơ sở vật chất và thiết bị**.

### Kiểm soát ưu tiên cho SME

{{< callout type="tip" >}}
**Mẹo**: Văn phòng nhỏ (< 50 người) không cần hệ thống kiểm soát truy cập đắt tiền - khóa cửa thông minh + camera IP giám sát là đủ. Nhiều kiểm soát A.7 có thể "không áp dụng" nếu thuê văn phòng chung.
{{< /callout >}}

#### A.7.1 & A.7.2: Physical Security Perimeters & Physical Entry

**Implementation cho SME thuê văn phòng:**

1. **Nếu thuê văn phòng chung/coworking:**
   - **Mark as N/A trong SoA** - landlord quản lý physical security
   - **Evidence**: Contract với landlord, confirmation email về CCTV/security guard
   - **Compensating control**: Lock cho server room (nếu có)

2. **Nếu thuê văn phòng riêng:**
   - **Smart locks**: Schlage, Yale (biometric/PIN, ~$200/door)
   - **Access control**: Simple card reader (~$500 system)
   - **Visitor log**: Google Forms/paper log

**Evidence:** Lease agreement, photos của physical security, visitor logs

---

#### A.7.7: Clear Desk and Clear Screen

**Mục đích:** Ngăn chặn shoulder surfing và truy cập trái phép khi rời khỏi bàn làm việc.

**Implementation:**

1. **Clear Desk Policy:**
   - Không để tài liệu nhạy cảm trên bàn khi rời đi
   - Lock tài liệu vào ngăn kéo hoặc cabinet
   - Shred tài liệu không cần thiết

2. **Clear Screen Policy:**
   - Screen lock tự động sau **5 phút** idle (Windows/macOS setting)
   - Privacy screen filters cho laptop (optional, ~$30)
   - Lock màn hình khi rời bàn (Windows+L, Cmd+Ctrl+Q)

3. **Enforcement:**
   - Quarterly "clean desk audit" bởi security team
   - Gamification: "Security Champion of the Month" cho team tuân thủ tốt nhất

**Tools (built-in):**
- Windows: Settings → Personalization → Lock screen → Screen timeout
- macOS: System Preferences → Security & Privacy → Require password after sleep

**Evidence:** Clear desk policy, compliance audit reports, photos (anonymized)

---

#### A.7.10: Storage Media

**Mục đích:** Quản lý USB, external HDD, backup tapes.

**Implementation:**

1. **Storage Media Inventory:**

| Media Type | Serial Number | Owner | Location | Encryption? | Purpose |
|------------|---------------|-------|----------|-------------|---------|
| USB 32GB | SN12345 | IT Manager | Locked cabinet | Yes (BitLocker) | Offsite backup |
| External HDD 2TB | WD98765 | DevOps Lead | Server room | Yes (VeraCrypt) | Archive |

2. **Storage Media Policy:**
   - ✅ **Encryption mandatory** cho tất cả removable media
   - ✅ **Approval required** để sử dụng USB (default: disabled via GPO)
   - ✅ **Secure disposal**: Wipe (DBAN, Eraser) trước khi discard
   - ✅ **Physical destruction** cho media cực kỳ nhạy cảm (shredder, degausser)

3. **USB Restrictions:**
   - Disable USB mass storage via Group Policy (Windows)
   - Whitelist approved USB devices only

**Tools:**
- **Encryption**: BitLocker (Windows), VeraCrypt (cross-platform, free)
- **USB management**: Group Policy (Windows), MDM (Intune)
- **Secure erase**: DBAN (free), Eraser (free)

**Evidence:** Storage media inventory, disposal certificates, GPO screenshots

---

## A.8: Kiểm soát Công nghệ (Technological Controls)

Nhóm lớn nhất và **quan trọng nhất cho tech SME**. 34 kiểm soát cover toàn bộ technology stack.

### Technology Security Stack cho SME

{{< mermaid >}}
graph TB
    subgraph User_Layer["Lớp Người dùng"]
        ENDPOINT[Endpoint Security<br/>A.8.1, A.8.7]
        AUTH[Authentication & MFA<br/>A.8.5]
        USER_TRAIN[User Awareness<br/>A.6.3]
    end

    subgraph Network_Layer["Lớp Mạng"]
        FIREWALL[Firewall / Security Groups<br/>A.8.20]
        VPN[VPN Access<br/>A.6.7]
        SEGMENTATION[Network Segmentation<br/>A.8.22]
        WEB_FILTER[Web Filtering<br/>A.8.23]
    end

    subgraph Application_Layer["Lớp Ứng dụng"]
        APP_SEC[Application Security<br/>A.8.26, A.8.28]
        CODE_REVIEW[Secure Coding & Review<br/>A.8.28]
        WAF[Web Application Firewall<br/>A.8.20]
        API_SEC[API Security<br/>A.8.21]
    end

    subgraph Data_Layer["Lớp Dữ liệu"]
        ENCRYPTION[Encryption at Rest/Transit<br/>A.8.24]
        BACKUP[Backup & Recovery<br/>A.8.13]
        DLP[Data Loss Prevention<br/>A.8.12]
        ACCESS_CONTROL[Access Control<br/>A.8.2, A.8.3]
    end

    subgraph Infrastructure_Layer["Lớp Hạ tầng"]
        CLOUD_SEC[Cloud Security<br/>A.5.23]
        CONFIG_MGMT[Configuration Mgmt<br/>A.8.9]
        PATCH_MGMT[Vulnerability Mgmt<br/>A.8.8]
        CHANGE_MGMT[Change Management<br/>A.8.32]
    end

    subgraph Monitoring_Layer["Lớp Giám sát"]
        LOGGING[Centralized Logging<br/>A.8.15]
        MONITORING[Security Monitoring<br/>A.8.16]
        SIEM[SIEM / Alerting<br/>A.8.16]
        INCIDENT_RESP[Incident Response<br/>A.5.24-A.5.28]
    end

    User_Layer --> Network_Layer
    Network_Layer --> Application_Layer
    Application_Layer --> Data_Layer
    Data_Layer --> Infrastructure_Layer
    Infrastructure_Layer --> Monitoring_Layer

    Monitoring_Layer -.feedback.-> User_Layer
    Monitoring_Layer -.feedback.-> Network_Layer
    Monitoring_Layer -.feedback.-> Application_Layer

    style ENDPOINT fill:#ffcccb
    style AUTH fill:#ffcccb
    style FIREWALL fill:#add8e6
    style ENCRYPTION fill:#90ee90
    style BACKUP fill:#90ee90
    style LOGGING fill:#ffffe0
    style MONITORING fill:#ffffe0
{{< /mermaid >}}

### Kiểm soát ưu tiên cho SME (chi tiết)

#### A.8.1: User Endpoint Devices

**Mục đích:** Bảo mật laptop, desktop, mobile devices.

**Implementation:**

1. **Endpoint Security Requirements:**
   - ✅ OS up-to-date (Windows 11, macOS 14+)
   - ✅ Full disk encryption (BitLocker, FileVault)
   - ✅ Antivirus/EDR installed
   - ✅ Firewall enabled
   - ✅ Screen lock (max 5 min idle)
   - ✅ Auto-update enabled

2. **Mobile Device Management (MDM):**

**Free/Low-cost MDM Options:**

| Tool | Cost | Features | Best For |
|------|------|----------|----------|
| **Microsoft Intune** | Included in M365 Business Premium ($22/user/month) | Full MDM, compliance policies, conditional access | Windows + iOS/Android |
| **Google Workspace MDM** | Included in Business Plus ($18/user/month) | Basic MDM for Android/iOS | Google-centric orgs |
| **SimpleMDM** | $4/device/month | macOS/iOS focus, simple UI | Mac/iPhone only |
| **Miradore** | Free tier: 25 devices | Basic MDM for Windows/Mac/iOS/Android | Very small teams |

3. **Compliance Policies (Intune example):**
   - Require encryption
   - Require antivirus (definition < 7 days old)
   - Require PIN/biometric
   - Block jailbroken/rooted devices
   - Remote wipe capability

**Evidence:** MDM enrollment reports, compliance dashboards, screenshots

---

#### A.8.2: Privileged Access Rights

**Mục đích:** Least privilege - chỉ admin thật sự mới có admin rights.

**Implementation:**

1. **Principle of Least Privilege:**
   - Standard users: **NO admin rights** trên laptop
   - Admin rights: Chỉ cho IT team, và chỉ khi cần (Just-In-Time Admin)
   - Privileged accounts: Riêng biệt (admin-john@, không dùng john@ cho admin tasks)

2. **Privileged Access Management (PAM):**

**Free/Low-cost PAM Tools:**

| Tool | Cost | Use Case |
|------|------|----------|
| **sudo** (Linux) | Built-in | Server admin access with logging |
| **Windows LAPS** | Free (Microsoft) | Local admin password rotation |
| **JumpCloud** | Free tier: 10 users | Centralized user/device management |
| **Teleport Community** | Open-source | SSH/Kubernetes access with audit |
| **Boundary (HashiCorp)** | Open-source | Secure access to hosts/services |

3. **Sudo Audit (Linux servers):**
   ```bash
   # Enable sudo logging
   echo "Defaults logfile=/var/log/sudo.log" >> /etc/sudoers

   # Review sudo log weekly
   cat /var/log/sudo.log | grep COMMAND
   ```

4. **Privileged Account Review:**
   - Quarterly review: Ai có admin access?
   - Remove unused privileged accounts
   - Rotate shared admin passwords quarterly

**Evidence:** Privileged account list, sudo logs, review reports

---

#### A.8.5: Secure Authentication

**Mục đích:** MFA bắt buộc, password hygiene, chống account takeover.

**Implementation:**

1. **Multi-Factor Authentication (MFA):**

**Bắt buộc MFA cho:**
- ✅ Email (Google Workspace, M365)
- ✅ VPN access
- ✅ Cloud platforms (AWS, Azure, GCP)
- ✅ Source code repos (GitHub, GitLab)
- ✅ Production systems
- ✅ Admin accounts

**Free MFA Tools:**

| Tool | Type | Cost | Best For |
|------|------|------|----------|
| **Google Authenticator** | TOTP | Free | Personal devices |
| **Authy** | TOTP + Backup | Free | Multi-device sync |
| **Microsoft Authenticator** | TOTP + Push | Free | M365 integration |
| **YubiKey** (hardware) | FIDO2/U2F | $25-50/key | High security |
| **Duo Security** | Push + TOTP | Free tier: 10 users | SMB |

2. **Password Policy:**
   - **Minimum length**: 12 characters (14+ for privileged)
   - **Complexity**: Upper + lower + number + special
   - **Rotation**: 90 days (or longer if MFA enabled)
   - **No reuse**: Last 10 passwords
   - **No common passwords**: Block "Password123", "Company2024"

3. **Password Manager (highly recommended):**

| Tool | Cost | Features |
|------|------|----------|
| **Bitwarden** | Free (premium $10/year) | Open-source, self-host option, team sharing |
| **1Password Business** | $7.99/user/month | Team vaults, SSO, compliance reports |
| **LastPass** | Free (premium $3/month) | Widely used, easy adoption |

**Evidence:** MFA enrollment reports, password policy screenshots, authenticator app screenshots

---

#### A.8.7: Protection Against Malware

**Mục đích:** Chống virus, ransomware, malware.

**Implementation:**

1. **Endpoint Protection (Antivirus/EDR):**

**Free/Low-cost Options:**

| Tool | Cost | Platform | Features |
|------|------|----------|----------|
| **Windows Defender** | Included in Windows 10/11 | Windows | Antivirus, Firewall, Exploit Protection - sufficient for SME |
| **ClamAV** | Free (open-source) | Linux, macOS | Signature-based AV |
| **Sophos Home** | Free for personal, $60/year for 10 devices | Windows, macOS | Real-time protection, web filtering |
| **Malwarebytes Business** | $50/device/year | Windows, macOS | Anti-malware, anti-ransomware |
| **CrowdStrike Falcon (small business)** | ~$8/device/month | All platforms | EDR, AI detection - best-in-class |

**Recommendation cho SME:**
- **Windows Defender** là đủ nếu kết hợp với MFA, patching, user training
- **CrowdStrike/SentinelOne** nếu budget cho phép (EDR > traditional AV)

2. **Malware Protection Checklist:**
   - ✅ AV/EDR installed trên tất cả endpoints
   - ✅ Real-time scanning enabled
   - ✅ Definition updates daily (auto)
   - ✅ Full scan weekly
   - ✅ Email gateway scanning (Gmail/M365 built-in)
   - ✅ Web filtering (block malicious sites)

**Evidence:** AV/EDR deployment reports, scan logs, detection alerts

---

#### A.8.8: Management of Technical Vulnerabilities

**Mục đích:** Quét lỗ hổng, patch management.

**Implementation:**

1. **Vulnerability Scanning:**

**Free/Low-cost Vulnerability Scanners:**

| Tool | Cost | Use Case |
|------|------|----------|
| **OpenVAS** | Free (open-source) | Network vulnerability scanning |
| **Nessus Essentials** | Free for 16 IPs | Network/web app scanning |
| **Trivy** | Free (open-source) | Container image scanning |
| **OWASP ZAP** | Free (open-source) | Web application security testing |
| **Snyk** | Free tier | Dependency scanning in code repos |
| **GitHub Dependabot** | Included in GitHub | Dependency vulnerability alerts |

2. **Patch Management:**

**Patching SLA:**

| Severity | Patch Timeline | Example |
|----------|----------------|---------|
| **Critical** | 7 days | Remote code execution (RCE) |
| **High** | 30 days | Privilege escalation |
| **Medium** | 60 days | Information disclosure |
| **Low** | 90 days | Minor bugs |

3. **Patching Process:**
   - **Automated patching**: Windows Update, unattended-upgrades (Ubuntu)
   - **Manual review**: For production servers (test in staging first)
   - **Patching schedule**: Non-critical systems monthly, critical systems weekly review

4. **Container/Dependency Scanning:**
   ```yaml
   # GitHub Actions - Trivy scan
   - name: Run Trivy vulnerability scanner
     uses: aquasecurity/trivy-action@master
     with:
       image-ref: 'myapp:latest'
       severity: 'HIGH,CRITICAL'
   ```

**Evidence:** Vulnerability scan reports, patch compliance reports, remediation tickets

---

#### A.8.9: Configuration Management

**Mục đích:** Standardize và harden system configurations.

**Implementation:**

1. **Configuration Management Tools:**

| Tool | Cost | Use Case |
|------|------|----------|
| **Ansible** | Free (open-source) | Agentless, YAML playbooks, easy to learn |
| **Puppet/Chef** | Free (open-source) | More complex, enterprise-grade |
| **SaltStack** | Free (open-source) | Event-driven automation |
| **AWS Systems Manager** | Free (with AWS) | Patch/config management for EC2 |

2. **Hardening Standards:**
   - **CIS Benchmarks**: [cisecurity.org/cis-benchmarks](https://www.cisecurity.org/cis-benchmarks/)
     - CIS Ubuntu Linux Benchmark
     - CIS Amazon Web Services Foundations Benchmark
     - CIS Docker Benchmark
   - **NIST Checklists**: [ncp.nist.gov/repository](https://ncp.nist.gov/repository)

3. **Baseline Configurations (Ansible example):**
   ```yaml
   # Ansible playbook: hardening-ubuntu.yml
   - name: Harden Ubuntu servers
     hosts: all
     tasks:
       - name: Ensure SSH root login disabled
         lineinfile:
           path: /etc/ssh/sshd_config
           regexp: '^PermitRootLogin'
           line: 'PermitRootLogin no'

       - name: Ensure firewall enabled
         ufw:
           state: enabled

       - name: Install fail2ban
         apt:
           name: fail2ban
           state: present
   ```

**Evidence:** Ansible playbooks, CIS compliance scan reports, configuration baselines

---

#### A.8.13: Information Backup

**Mục đích:** Bảo vệ khỏi data loss, ransomware.

**Implementation:**

1. **3-2-1 Backup Rule:**
   - **3** copies của dữ liệu
   - **2** different media types
   - **1** offsite/offline copy

2. **Backup Strategy:**

| Data Type | Frequency | Retention | Tool | RPO |
|-----------|-----------|-----------|------|-----|
| **Production DB** | Hourly snapshot + continuous replication | 30 days | AWS RDS automated backups | 1 hour |
| **Application servers** | Daily AMI | 7 days | AWS Data Lifecycle Manager | 24h |
| **File storage** | Hourly (S3 versioning) | 90 days | S3 versioning + lifecycle | 1 hour |
| **Code repos** | Continuous (Git) | Forever | GitHub/GitLab mirroring | Real-time |
| **Emails** | Continuous | Unlimited | Google Workspace Vault | Real-time |

3. **Backup Tools:**

**Free/Low-cost Options:**

| Tool | Cost | Use Case |
|------|------|----------|
| **Restic** | Free (open-source) | Encrypted backups to S3/B2/local |
| **Borg Backup** | Free (open-source) | Deduplication, encryption |
| **Duplicati** | Free (open-source) | GUI, Windows-friendly |
| **AWS Backup** | Pay-as-you-go | Centralized backup for AWS resources |
| **Backblaze B2** | $6/TB/month | S3-compatible, cheap offsite |

4. **Backup Testing:**
   - **Monthly restore test**: Restore 1 random file
   - **Quarterly DR drill**: Full system restore to staging
   - **Annual DR exercise**: Complete disaster recovery simulation

5. **Ransomware Protection:**
   - **Immutable backups**: S3 Object Lock, Glacier Vault Lock
   - **Offline backups**: Disconnect external HDD monthly
   - **Air-gapped backups**: Tape archive offsite

**Evidence:** Backup logs, restore test reports, backup configuration screenshots

---

#### A.8.15 & A.8.16: Logging & Monitoring Activities

**Mục đích:** Audit trail, threat detection, incident response.

**Implementation:**

1. **Centralized Logging:**

**Free/Low-cost Logging Stacks:**

| Stack | Cost | Components | Best For |
|-------|------|------------|----------|
| **ELK (Elasticsearch + Logstash + Kibana)** | Free (self-hosted) | Full-featured, scalable | Large log volume |
| **Grafana Loki + Promtail** | Free (self-hosted) | Lightweight, optimized for Kubernetes | Modern infra |
| **Graylog** | Free (open-source) | Easier than ELK, good UI | SME sweet spot |
| **AWS CloudWatch Logs** | Pay-as-you-go | Managed, AWS-native | AWS-only |
| **Datadog** | $15/host/month | SaaS, easy setup, powerful | Budget available |

**Recommendation cho SME:** **Grafana Loki** (lightweight, free) hoặc **Graylog** (full-featured, easier than ELK).

2. **Logs to Collect:**

| Log Source | Purpose | Retention |
|------------|---------|-----------|
| **Authentication logs** | Login attempts, failures, MFA | 1 year |
| **Access logs** | File/DB access, privilege escalation | 1 year |
| **System logs** | OS events, errors, crashes | 90 days |
| **Application logs** | App errors, transactions | 90 days |
| **Network logs** | Firewall, VPN, IDS/IPS | 90 days |
| **Cloud logs** | CloudTrail (AWS), Activity Log (Azure) | 1 year |
| **Web server logs** | HTTP requests, errors | 90 days |

3. **Security Monitoring (SIEM):**

**Free/Low-cost SIEM Options:**

| Tool | Cost | Features |
|------|------|----------|
| **Wazuh** | Free (open-source) | SIEM + EDR + compliance, ruleset included |
| **Security Onion** | Free (open-source) | Full NSM suite (Suricata + Zeek + ELK) |
| **AlienVault OSSIM** | Free (open-source) | SIEM with correlation engine |
| **Splunk Free** | Free up to 500MB/day | Industry standard, limited in free tier |

**Recommendation:** **Wazuh** (best free SIEM for SME, active community).

4. **Alerting Rules (examples):**
   - Failed login > 5 times in 5 minutes (brute force)
   - Login from impossible travel (VPN Hanoi → US in 1 hour)
   - Privilege escalation (user added to Admins group)
   - Critical vulnerability detected
   - AWS root account usage
   - Large data exfiltration (> 1GB outbound in 10 min)

**Evidence:** Logging configuration, SIEM screenshots, alert examples, incident tickets

---

#### A.8.20: Networks Security

**Mục đích:** Firewall, network segmentation, secure architecture.

**Implementation:**

1. **Firewall:**
   - **Cloud**: AWS Security Groups, Azure NSG (free, integrated)
   - **On-prem**: pfSense (free, powerful), OPNsense (free)
   - **Default deny**: Block all, allow only necessary ports

2. **Network Segmentation:**

```
Production VPC (10.0.0.0/16)
├── Public Subnet (10.0.1.0/24) - Load balancers, NAT gateway
├── Private Subnet (10.0.10.0/24) - Application servers
├── Data Subnet (10.0.20.0/24) - Databases
└── Management Subnet (10.0.100.0/24) - Bastion, monitoring

Dev VPC (10.1.0.0/16) - Completely isolated from Production
```

3. **Security Best Practices:**
   - ✅ No direct internet access for databases
   - ✅ Bastion host for SSH access (no direct SSH to instances)
   - ✅ VPN required for internal resources
   - ✅ Regular security group review (remove 0.0.0.0/0 rules)

**Evidence:** Network diagrams, firewall rules export, security group configs

---

#### A.8.23: Web Filtering

**Mục đích:** Block malicious/inappropriate websites.

**Implementation:**

**Free/Low-cost Web Filtering:**

| Tool | Cost | Deployment | Use Case |
|------|------|------------|----------|
| **Pi-hole** | Free (open-source) | DNS-level blocking | Office network |
| **pfSense + pfBlockerNG** | Free | Firewall appliance | Advanced filtering |
| **Cloudflare Gateway** | Free tier: 50 users | Cloud-based DNS filtering | Remote workers |
| **Cisco Umbrella** | $3/user/month | Enterprise DNS security | Best features/support |

**Recommendation:** **Cloudflare Gateway Free** (easiest) hoặc **Pi-hole** (self-hosted).

**Categories to Block:**
- Malware, phishing, ransomware (high priority)
- Adult content (optional)
- Gambling, illegal drugs (optional)
- File sharing, torrents (optional)

**Evidence:** Web filtering config, blocked requests logs

---

#### A.8.24: Use of Cryptography

**Mục đích:** Encrypt data in transit và at rest.

**Implementation:**

1. **Encryption in Transit:**
   - ✅ **HTTPS everywhere**: Let's Encrypt (free, auto-renew)
   - ✅ **TLS 1.2+ only**: Disable TLS 1.0/1.1
   - ✅ **Strong ciphers**: AEAD ciphers (AES-GCM, ChaCha20-Poly1305)
   - ✅ **HSTS enabled**: Force HTTPS
   - ✅ **VPN encryption**: WireGuard (ChaCha20), OpenVPN (AES-256)

2. **Encryption at Rest:**
   - ✅ **Full disk encryption**: BitLocker (Windows), FileVault (macOS), LUKS (Linux)
   - ✅ **Database encryption**: AWS RDS encryption, Transparent Data Encryption
   - ✅ **S3 encryption**: Default encryption enabled (AES-256)
   - ✅ **Backup encryption**: Restic (AES-256-CTR), Borg (AES-256-CTR)

3. **Key Management:**
   - **AWS KMS**: Managed key storage, audit logging
   - **HashiCorp Vault**: Free (open-source), self-hosted
   - **No hardcoded keys**: Use environment variables, secrets manager

**Tools:**
- **Let's Encrypt + Certbot**: Free SSL/TLS certificates
- **AWS Certificate Manager**: Free certs for AWS resources
- **GPG**: File encryption (free)

**Evidence:** SSL/TLS config, encryption at rest screenshots, key management policies

---

#### A.8.28: Secure Coding

**Mục đích:** Avoid security bugs in application code.

**Implementation:**

1. **Secure Coding Standards:**
   - **OWASP Top 10**: [owasp.org/www-project-top-ten](https://owasp.org/www-project-top-ten/)
   - **CWE Top 25**: [cwe.mitre.org/top25](https://cwe.mitre.org/top25/)
   - **Language-specific guides**: Python, JavaScript, Java, Go

2. **Static Application Security Testing (SAST):**

**Free SAST Tools:**

| Tool | Languages | Integration |
|------|-----------|-------------|
| **SonarQube Community** | 25+ languages | CI/CD, IDE |
| **Semgrep** | 20+ languages | GitHub Actions, GitLab CI |
| **Bandit** | Python | CLI, pre-commit hooks |
| **ESLint + security plugins** | JavaScript | npm, webpack |
| **SpotBugs + FindSecBugs** | Java | Maven, Gradle |
| **CodeQL** | Many languages | GitHub Advanced Security |

3. **Dependency Scanning:**
   - **Snyk**: Free for open-source projects
   - **Dependabot**: Included in GitHub
   - **npm audit**, **pip-audit**: Built-in package managers

4. **Code Review:**
   - Mandatory peer review for all PRs
   - Security checklist during review
   - Automated checks (SAST, linting) block merge if fail

**Evidence:** SonarQube reports, Dependabot alerts, code review logs

---

## Kế hoạch Triển khai theo Giai đoạn

Không triển khai 93 kiểm soát cùng lúc. Phased approach 4 tháng:

{{< mermaid >}}
gantt
    title Kế hoạch Triển khai Kiểm soát ISO 27001 (4 tháng)
    dateFormat YYYY-MM-DD
    axisFormat %b

    section Tháng 1 - Critical Controls
    Access Control Policy & Implementation :done, m1-1, 2026-02-15, 7d
    MFA cho tất cả hệ thống :done, m1-2, 2026-02-22, 7d
    Backup & Recovery (3-2-1 rule) :done, m1-3, 2026-03-01, 7d
    Malware Protection (AV/EDR) :done, m1-4, 2026-03-08, 7d

    section Tháng 2 - Monitoring & Detection
    Centralized Logging (Loki/Graylog) :active, m2-1, 2026-03-15, 10d
    Security Monitoring (Wazuh SIEM) :active, m2-2, 2026-03-25, 10d
    Vulnerability Scanning (OpenVAS) :m2-3, 2026-04-04, 7d
    Patch Management Process :m2-4, 2026-04-11, 7d

    section Tháng 3 - Processes & People
    Incident Response Plan & Testing :m3-1, 2026-04-18, 10d
    Business Continuity Plan & DR :m3-2, 2026-04-28, 10d
    Vendor Management & Contracts :m3-3, 2026-05-08, 7d
    Security Awareness Training :m3-4, 2026-05-15, 7d

    section Tháng 4 - Advanced Controls
    Configuration Management (Ansible) :m4-1, 2026-05-22, 7d
    Secure Coding & SAST (SonarQube) :m4-2, 2026-05-29, 10d
    Remaining SoA Controls :m4-3, 2026-06-08, 7d
    Internal Audit & Readiness :crit, m4-4, 2026-06-15, 7d
{{< /mermaid >}}

### Tháng 1: Critical Controls (Must-Have)

**Mục tiêu:** Triển khai 12 kiểm soát quan trọng nhất.

- ✅ A.5.15, A.8.2, A.8.3: Access Control (Least Privilege, MFA)
- ✅ A.8.5: Secure Authentication (MFA cho email, VPN, cloud, GitHub)
- ✅ A.8.7: Malware Protection (Windows Defender/CrowdStrike)
- ✅ A.8.13: Backup (3-2-1 rule, test restore)
- ✅ A.5.1: Information Security Policy
- ✅ A.6.3: Basic security awareness training

**Deliverables:**
- MFA enabled cho tất cả critical systems
- Backup running với test restore successful
- AV/EDR deployed trên 100% endpoints
- Access control policy published

---

### Tháng 2: Monitoring & Vulnerability Management

**Mục tiêu:** Visibility và threat detection.

- ✅ A.8.15: Centralized Logging (Grafana Loki hoặc Graylog)
- ✅ A.8.16: Security Monitoring (Wazuh SIEM)
- ✅ A.8.8: Vulnerability Scanning (OpenVAS/Nessus Essentials)
- ✅ A.8.9: Patch Management (process + automation)
- ✅ A.5.7: Threat Intelligence (OTX, MITRE ATT&CK)

**Deliverables:**
- SIEM operational với basic alerting rules
- Vulnerability scan baseline established
- Patching SLA defined và enforced

---

### Tháng 3: Processes & People

**Mục tiêu:** Incident response, BCP, training.

- ✅ A.5.24-A.5.28: Incident Response Plan + playbooks
- ✅ A.5.30: Business Continuity Plan (RTO/RPO, DR testing)
- ✅ A.5.19-A.5.21: Vendor Management (contracts, risk assessment)
- ✅ A.6.1: Screening process
- ✅ A.6.3: Comprehensive security awareness training
- ✅ A.6.5: Offboarding/Role change checklists

**Deliverables:**
- Incident response tested (tabletop exercise)
- DR drill successful
- 100% nhân viên hoàn thành security training

---

### Tháng 4: Advanced Controls & Audit Readiness

**Mục tiêu:** Hoàn thiện SoA, chuẩn bị audit.

- ✅ A.8.9: Configuration Management (Ansible playbooks)
- ✅ A.8.28: Secure Coding (SonarQube, code review)
- ✅ A.8.20-A.8.24: Network security, encryption, web filtering
- ✅ Remaining controls từ SoA
- ✅ Internal Audit (toàn bộ ISMS)
- ✅ Corrective actions cho findings

**Deliverables:**
- 100% SoA controls implemented hoặc có plan
- Internal audit report với 0 major NC
- Evidence repository organized
- Ready cho certification audit

{{< callout type="warning" >}}
**Cảnh báo**: Ghi chép bằng chứng triển khai cho mọi kiểm soát - auditor cần xem evidence. Không có evidence = kiểm soát chưa triển khai = non-conformity.
{{< /callout >}}

---

## Thu thập Bằng chứng (Evidence Collection)

### Loại Evidence theo Kiểm soát

| Kiểm soát | Loại Evidence | Ví dụ |
|-----------|---------------|-------|
| **A.5.1** | Policy document | InfoSec Policy v1.0 PDF with CEO signature |
| **A.5.7** | Logs, subscriptions | OTX subscription confirmation, threat review meeting minutes |
| **A.6.3** | Training records | Training attendance sheet, quiz results, certificates |
| **A.8.2** | Access lists, logs | Privileged account inventory, sudo log review |
| **A.8.5** | Config screenshots | MFA enrollment report, Google Workspace 2FA settings |
| **A.8.7** | Deployment reports | Windows Defender status on all endpoints |
| **A.8.8** | Scan reports | OpenVAS scan report, remediation tickets |
| **A.8.13** | Backup logs, test reports | S3 backup logs, restore test report |
| **A.8.15** | Log samples | Graylog screenshot, log retention config |
| **A.8.16** | SIEM config, alerts | Wazuh alerting rules, incident tickets |

### Cấu trúc Evidence Repository

```
Evidence Repository/
├── A.5-Organizational/
│   ├── A.5.1-Policy/
│   │   ├── InfoSec-Policy-v1.0-signed.pdf
│   │   ├── Email-Announcement-2026-02-14.pdf
│   │   └── SharePoint-Publication-Screenshot.png
│   ├── A.5.7-ThreatIntel/
│   │   ├── OTX-Subscription-Confirmation.pdf
│   │   ├── Threat-Review-Meeting-Minutes-2026-02.pdf
│   │   └── MITRE-ATT&CK-Feed-Config.png
│   └── ...
├── A.6-People/
│   ├── A.6.1-Screening/
│   │   ├── Screening-Process-Doc.pdf
│   │   ├── Background-Check-Reports/ (redacted)
│   │   └── Reference-Check-Templates.docx
│   ├── A.6.3-Training/
│   │   ├── Training-Attendance-2026-Q1.xlsx
│   │   ├── Quiz-Results-Summary.pdf
│   │   └── Training-Certificates/
│   └── ...
├── A.7-Physical/
│   ├── A.7.7-ClearDesk/
│   │   ├── Clear-Desk-Policy-v1.0.pdf
│   │   ├── Compliance-Audit-2026-Q1.xlsx
│   │   └── Photos-Anonymized/
│   └── ...
├── A.8-Technological/
│   ├── A.8.2-PrivilegedAccess/
│   │   ├── Privileged-Accounts-Inventory.xlsx
│   │   ├── Sudo-Log-Review-2026-02.pdf
│   │   └── Access-Review-Report-2026-Q1.pdf
│   ├── A.8.5-Authentication/
│   │   ├── MFA-Enrollment-Report-100percent.pdf
│   │   ├── Google-Workspace-2FA-Settings.png
│   │   ├── AWS-MFA-Config.png
│   │   └── GitHub-2FA-Org-Settings.png
│   ├── A.8.8-Vulnerabilities/
│   │   ├── OpenVAS-Scan-2026-02-15.pdf
│   │   ├── Remediation-Tracking.xlsx
│   │   └── Patch-Compliance-Report-2026-Q1.pdf
│   ├── A.8.13-Backup/
│   │   ├── Backup-Configuration.pdf
│   │   ├── S3-Backup-Logs-2026-02.csv
│   │   └── Restore-Test-Report-2026-02-20.pdf
│   └── ...
└── Internal-Audits/
    ├── 2026-Q1-Internal-Audit-Report.pdf
    ├── 2026-Q1-Corrective-Actions.xlsx
    └── Management-Review-2026-02.pdf
```

{{< callout type="tip" >}}
**Mẹo**: Tạo thư mục theo mã kiểm soát: `/evidence/A.8.5-MFA/`, `/evidence/A.8.13-backup/`. Dễ tìm kiếm khi auditor yêu cầu evidence cho kiểm soát cụ thể.
{{< /callout >}}

### Evidence Checklist

Trước certification audit, kiểm tra:

- ✅ Evidence cho **tất cả** kiểm soát "Applicable" trong SoA
- ✅ Evidence **dated** (trong 12 tháng gần nhất, hoặc theo review frequency)
- ✅ Evidence **signed/approved** (nếu là policy/plan)
- ✅ Screenshots **clear, readable**, có timestamp
- ✅ Logs/reports **not empty** - cho thấy hệ thống hoạt động
- ✅ Sensitive data **redacted** trong evidence (passwords, PII)
- ✅ Evidence **organized** theo control ID
- ✅ **Index/inventory** của evidence repository

---

## Kết luận & Bước tiếp theo

Triển khai kiểm soát Annex A là công việc lớn nhưng hoàn toàn khả thi với SME nếu:
1. **Ưu tiên đúng**: Critical controls trước
2. **Dùng công cụ free/open-source**: Tiết kiệm 80% chi phí
3. **Phased approach**: 4 tháng thay vì cố làm hết trong 1 tháng
4. **Document evidence**: Không evidence = không có triển khai

### Checklist Triển khai

- ✅ 12 critical controls (Month 1) đã implemented
- ✅ Logging & monitoring (Month 2) operational
- ✅ Incident response & BCP (Month 3) tested
- ✅ Advanced controls (Month 4) completed
- ✅ Evidence repository organized
- ✅ All tools deployed và operational
- ✅ Staff trained trên các công cụ mới

### Tool Summary cho SME Stack

| Layer | Free/Low-cost Tools |
|-------|---------------------|
| **Endpoint** | Windows Defender, BitLocker, FileVault |
| **Authentication** | Google Authenticator, Authy, Bitwarden |
| **Network** | pfSense, AWS Security Groups, WireGuard VPN |
| **Monitoring** | Grafana Loki, Wazuh SIEM |
| **Vulnerability** | OpenVAS, Nessus Essentials, Trivy |
| **Backup** | Restic, AWS Backup, Backblaze B2 |
| **Configuration** | Ansible, CIS Benchmarks |
| **Secure Coding** | SonarQube, Semgrep, Dependabot |
| **Cloud Security** | AWS Security Hub, CloudTrail, GuardDuty |

**Total estimated cost:** $500-2000/month cho 25-person tech SME (chủ yếu là cloud costs, SaaS subscriptions).

Trong **[Phần 7](/posts/iso27001-sme/07-dao-tao-nhan-su/)**, chúng ta sẽ xây dựng chương trình đào tạo nhận thức bảo mật toàn diện - từ nội dung đào tạo, công cụ miễn phí, đến cách đo lường hiệu quả.

### Tài liệu tham khảo

- ISO/IEC 27002:2022 - Control Implementation Guidance
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Awesome Security](https://github.com/sbilly/awesome-security) - Curated list of security tools
