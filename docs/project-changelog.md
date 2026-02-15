# Project Changelog

All notable changes to the EZ DevSecOps project are documented here.

## [2026-02-14] - EPUB Series Download Feature Launch

### Added
- **EPUB Generation System** for blog series (Pandoc + mermaid-cli integration)
  - `scripts/generate-epub.sh` - Build script for batch EPUB generation
  - `assets/epub/metadata/{series}.yaml` - EPUB metadata files (doks-mastery, iso27001-sme)
  - `assets/epub/epub-styles.css` - Embedded styling for EPUB files
  - `assets/epub/fonts/` - Custom font embedding support
  - `layouts/shortcodes/download-epub.html` - UI shortcode for download buttons

- **CI/CD EPUB Integration** (.github/workflows/deploy-hugo-to-github-pages.yml)
  - Pre-build EPUB generation (runs before Hugo build)
  - Pandoc + mermaid-cli installation in GitHub Actions
  - SVG diagram rendering for offline reading
  - Callout shortcode → HTML blockquote conversion

- **Features**
  - Readers can download full series as EPUB files
  - Mermaid diagrams converted to SVG for offline viewing
  - Customizable callout styling in EPUB output
  - Vietnamese language metadata and labels
  - Download buttons on series index pages

### Changed
- Updated `docs/codebase-summary.md` with EPUB asset structure and scripts
- Updated `docs/system-architecture.md` with EPUB generation pipeline details
- Enhanced CI/CD workflow to support offline reading formats

### Impact
- Series now available in portable EPUB format (7 DOKS posts + 10 ISO 27001 posts)
- Readers can download and read offline on e-readers and mobile devices
- Mermaid diagrams embedded as SVG images in EPUB files
- Reduced dependency on web browser for full content access

---

## [2026-02-14] - ISO 27001 SME Series Launch

### Added
- **ISO 27001 SME Tutorial Series** (10 comprehensive blog posts)
  - 01: Giới thiệu ISO 27001 - Introduction to Information Security Management Systems
  - 02: Phạm vi ISMS & bối cảnh - ISMS Scope and Context
  - 03: Đánh giá rủi ro - Risk Assessment
  - 04: Tuyên bố áp dụng - Statement of Applicability (SoA)
  - 05: Chính sách & tài liệu - Policies and Documentation
  - 06: Triển khai & kiểm soát - Implementation and Controls
  - 07: Đào tạo nhân sự - Personnel Training and Awareness
  - 08: Đánh giá nội bộ - Internal Audits
  - 09: Chuẩn bị chứng nhận - Certification Preparation
  - 10: Tuân thủ pháp luật VN - Vietnam Compliance Requirements

### Changed
- Updated `docs/codebase-summary.md` to reflect new ISO 27001 SME content directory structure
- Expanded content portfolio to include enterprise security alongside Kubernetes topics

### Impact
- Content portfolio expanded from 1 series (7 posts) to 2 series (17 posts total)
- New audience segment: Information Security professionals and ISMS implementers
- Broadens platform scope beyond DevOps to enterprise security practices

---

## [2026-02-13] - Documentation System Established

### Added
- Created core documentation structure in `./docs/`
  - `project-overview-pdr.md` - Project overview and Product Development Requirements
  - `code-standards.md` - Comprehensive Hugo and Markdown standards
  - `codebase-summary.md` - Codebase structure and file organization
  - `deployment-guide.md` - Deployment instructions
  - `system-architecture.md` - System architecture documentation
  - `project-changelog.md` - Changelog (this file)

### Documentation Features
- Hugo configuration standards (TOML format)
- Go template coding guidelines
- Markdown content and frontmatter specifications
- CSS naming conventions for callouts
- GitHub Actions workflow standards
- Code quality checklist and validation procedures

---

## [2026-02-07] - DOKS Mastery Series Complete

### Added
- **7-Part DOKS Mastery Tutorial Series** published
  - 01: DOKS Preparation
  - 02: Sysadmin Guide
  - 03: DevOps Guide
  - 04: Developer Guide
  - 05: RBAC & Security
  - 06: Troubleshooting & Performance
  - 07: CI/CD Integration

### Features
- Vietnamese language content
- Comprehensive learning objectives and prerequisites
- Step-by-step implementation guides
- Code examples with syntax highlighting
- Custom callout boxes and Mermaid diagrams
- Series navigation and tagging

---

## [2026-02-01] - Site Launch

### Added
- Hugo v0.146.0 setup with PaperMod theme
- GitHub Actions deployment pipeline
- Custom shortcodes (callout, mermaid)
- Dark mode support with theme detection
- Fuse.js full-text search integration
- RSS feed and sitemap generation

### Infrastructure
- Site URL: `https://toanalien.github.io/ezdevsecops/`
- Automatic deployment on push to main branch
- Minified assets and optimized build process
- Mobile-responsive design via PaperMod

---

## Version History

| Version | Date | Status | Major Features |
|---------|------|--------|----------------|
| 2.1 | 2026-02-14 | Active | EPUB download feature (offline reading) |
| 2.0 | 2026-02-14 | Active | ISO 27001 SME series (10 posts) |
| 1.0 | 2026-02-01 | Active | DOKS Mastery series (7 posts) + infrastructure |
