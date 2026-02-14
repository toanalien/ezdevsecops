# EZ DevSecOps - Project Overview & PDR

## Project Summary

**EZ DevSecOps** is a educational blog platform built with Hugo that delivers comprehensive DevSecOps and Kubernetes tutorials in Vietnamese. The project focuses on making enterprise-grade Kubernetes (DigitalOcean Kubernetes - DOKS) accessible through practical, step-by-step guides.

**Purpose:** Provide comprehensive tutorials on DevSecOps practices and information security management systems for enterprise professionals, covering Kubernetes deployment, CI/CD automation, and ISO 27001 ISMS implementation.

**Launch Date:** February 2026
**Status:** Active Development (Phase 2: Enterprise Security Expansion)
**Audience:** Vietnamese-speaking DevOps engineers, system administrators, security professionals, and ISMS implementers

## Core Features

### Content System
- **7-part DOKS Mastery Series** covering:
  1. DOKS Preparation (cluster setup, prerequisites)
  2. Sysadmin Guide (node management, monitoring)
  3. DevOps Guide (deployment strategies)
  4. Developer Guide (application deployment)
  5. RBAC & Security (access control, policies)
  6. Troubleshooting & Performance (diagnostics, optimization)
  7. CI/CD Integration (GitHub Actions, automation)

- **10-part ISO 27001 SME Series** covering:
  1. Introduction to ISO 27001 standards
  2. ISMS scope and organizational context
  3. Risk assessment methodologies
  4. Statement of Applicability (SoA)
  5. Information security policies and documentation
  6. Control implementation and deployment
  7. Personnel training and awareness programs
  8. Internal audit procedures
  9. Certification preparation
  10. Vietnam-specific compliance requirements

- **Series Organization:** Posts grouped thematically with automatic navigation
- **Multi-language Support:** Vietnamese content with English technical terms

### Technical Foundation
- **Static Site Generator:** Hugo v0.146.0 (extended binary)
- **Theme:** PaperMod (git submodule) - minimal, responsive design
- **Hosting:** GitHub Pages (automatic deployment)
- **CI/CD:** GitHub Actions workflow for automated builds

### Interactive Features
- **Mermaid Diagrams:** Conditional loading (v11 ESM via CDN)
- **Custom Callout Shortcodes:** Vietnamese titles (info, warning, danger, tip)
- **Search Capability:** Fuse.js full-text search with JSON index
- **Dark Mode:** Automatic theme switching with Mermaid integration
- **Code Highlighting:** Monokai style with line numbers and copy buttons

## Technical Requirements

### Functional Requirements
- [x] Generate static HTML from Markdown content
- [x] Support Vietnamese language configuration
- [x] Render Mermaid diagrams with dark mode compatibility
- [x] Provide full-text search across all content
- [x] Enable automatic GitHub Pages deployment on commits
- [x] Display post series with automatic navigation links
- [x] Provide categorization by tags and series

### Non-Functional Requirements
- **Build Performance:** Hugo builds in <5 seconds
- **Site Performance:** Minified assets, ~50KB page size average
- **Mobile Responsiveness:** Full mobile support via PaperMod theme
- **Accessibility:** Semantic HTML, proper heading hierarchy
- **SEO:** Automatic sitemap, RSS feed, breadcrumbs

## Architecture Overview

```
ezdevsecops/
├── hugo.toml              # Main configuration (baseURL, theme, params)
├── content/
│   └── posts/
│       ├── doks-mastery/  # 7-part tutorial series
│       │   ├── 01-doks-preparation/
│       │   ├── 02-sysadmin-guide/
│       │   ├── 03-devops-guide/
│       │   ├── 04-developer-guide/
│       │   ├── 05-rbac-security/
│       │   ├── 06-troubleshooting-performance/
│       │   └── 07-cicd-integration/
│       └── _index.md
├── layouts/
│   ├── partials/
│   │   └── extend_head.html     # Custom CSS + Mermaid loader
│   └── shortcodes/
│       ├── callout.html         # Vietnamese callout boxes
│       └── mermaid.html         # Mermaid diagram wrapper
├── assets/
│   └── css/
│       └── custom-styles.css    # Callouts, code blocks, print styles
├── themes/
│   └── hugo-PaperMod/           # Submodule: PaperMod theme
└── .github/
    └── workflows/
        └── deploy-hugo-to-github-pages.yml  # CI/CD pipeline
```

## Deployment Architecture

**GitHub Pages Flow:**
1. Developer pushes to `main` branch
2. GitHub Actions workflow triggered
3. Hugo (v0.146.0) builds with PaperMod theme → `/public`
4. Build artifact uploaded to GitHub Pages storage
5. Live site updated at `https://toanalien.github.io/ezdevsecops/`

## Success Metrics

| Metric | Target | Status |
|--------|--------|--------|
| DOKS Series Complete | 7 posts | ✓ 7/7 |
| ISO 27001 Series Complete | 10 posts | ✓ 10/10 |
| Total Content Posts | 17+ | ✓ 17/17 |
| Build Time | <10 seconds | ✓ ~5s |
| Mobile Responsive | 100% coverage | ✓ PaperMod |
| Search Functional | All posts searchable | ✓ Fuse.js |
| Diagram Rendering | Mermaid v11 works | ✓ CDN ESM |
| CI/CD Automated | Push-to-live | ✓ Actions |

## Key Dependencies

- **Hugo v0.146.0** (extended binary required for SCSS)
- **PaperMod Theme** (git submodule)
- **Mermaid v11** (CDN: jsdelivr)
- **Fuse.js** (search library, included in PaperMod)
- **GitHub Actions** (deployment automation)

## Content Strategy

### Blog Organization
- **Base URL:** `https://toanalien.github.io/ezdevsecops/`
- **Posts URL:** `/posts/doks-mastery/XX-name/`
- **Series Pages:** Automatic series index generation
- **Tags:** kubernetes, digitalocean, doks, kubectl, etc.

### Post Structure
Each post includes:
- YAML frontmatter (title, date, categories, tags, series, weight)
- Vietnamese title and description
- Learning objectives
- Prerequisites
- Step-by-step content
- Code examples with syntax highlighting
- Callout boxes for important notes
- Mermaid diagrams where applicable

## Maintenance & Roadmap

### Current Phase
- [x] Hugo project setup
- [x] PaperMod theme integration
- [x] 7 tutorial posts authored
- [x] Custom shortcodes (callout, mermaid)
- [x] GitHub Actions deployment
- [x] Documentation created

### Future Enhancements
- [ ] Vietnamese-only search filtering
- [ ] Community comments (Disqus or Giscus)
- [ ] Newsletter subscription
- [ ] Advanced filtering (date range, difficulty level)
- [ ] Video integration in posts

## Acceptance Criteria

- ✓ All 7 DOKS tutorial posts published
- ✓ All 10 ISO 27001 SME tutorial posts published
- ✓ Site builds successfully with Hugo v0.146.0
- ✓ Automatic deployment via GitHub Pages working
- ✓ Mermaid diagrams render correctly
- ✓ Search functionality operational across both series
- ✓ Mobile and dark mode responsive
- ✓ Documentation complete and up-to-date
- ✓ Project changelog established
- ✓ Development roadmap created
