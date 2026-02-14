# EZ DevSecOps Documentation

Welcome to the EZ DevSecOps documentation hub. This folder contains comprehensive guides for understanding, maintaining, and contributing to the Hugo blog project.

## Quick Navigation

### For Project Managers & Stakeholders
**→ [Project Overview & PDR](./project-overview-pdr.md)** (163 lines)
- Project summary and vision
- Core features and success metrics
- Architecture overview
- Roadmap and acceptance criteria

### For Developers & Contributors
**→ [Deployment Guide](./deployment-guide.md)** (532 lines)
- How to publish new blog posts
- Local development setup
- Step-by-step procedures for common tasks
- Comprehensive troubleshooting guide
- **Start here if you're publishing content**

**→ [Code Standards](./code-standards.md)** (365 lines)
- Hugo and Go template standards
- Markdown content guidelines
- CSS naming conventions
- Pre-publishing quality checklist
- **Reference this before publishing posts**

### For Architects & Technical Leads
**→ [System Architecture](./system-architecture.md)** (348 lines)
- Deployment architecture diagrams
- Component architecture (4 layers)
- Data flow patterns
- Configuration architecture
- Dependency graph
- Security and performance considerations

### For Maintainers
**→ [Codebase Summary](./codebase-summary.md)** (167 lines)
- Complete project directory structure
- Key files analysis
- Technology stack
- File statistics and characteristics
- Customization points

---

## Project Structure

```
EZ DevSecOps Blog
├── Hugo v0.146.0 (extended binary)
├── PaperMod Theme (git submodule)
├── 7 DOKS Mastery Tutorial Posts (Vietnamese)
├── Custom Shortcodes (callout, mermaid v11)
├── GitHub Pages Deployment (GitHub Actions)
└── Fuse.js Full-Text Search
```

## Key Facts at a Glance

| Aspect | Details |
|--------|---------|
| **Purpose** | Educational blog: DevSecOps and Kubernetes tutorials in Vietnamese |
| **Technology** | Hugo v0.146.0 extended + PaperMod theme |
| **Content** | 7-part DOKS Mastery series on DigitalOcean Kubernetes |
| **Hosting** | GitHub Pages (automated via GitHub Actions) |
| **Build Time** | ~5 seconds |
| **Live URL** | https://toanalien.github.io/ezdevsecops/ |
| **CI/CD** | Automatic deployment on push to `main` |
| **Interactive Features** | Mermaid diagrams, Fuse.js search, dark mode, callout boxes |

## Common Tasks

### Publishing a New Post
1. Read: [Deployment Guide → Publishing a New Post](./deployment-guide.md#publishing-a-new-post)
2. Reference: [Code Standards → Frontmatter Template](./code-standards.md#frontmatter-yaml)
3. Before publishing: [Code Standards → Quality Checklist](./code-standards.md#quality-checklist)

### Setting Up Local Development
1. Read: [Deployment Guide → Local Testing](./deployment-guide.md#local-testing)
2. Follow: Platform-specific setup instructions (macOS, Linux, Windows)
3. Test with: `hugo server` (live reload at http://localhost:1313/ezdevsecops/)

### Understanding the Architecture
1. Start: [System Architecture → High-Level Overview](./system-architecture.md#high-level-overview)
2. Deep dive: Component architecture, data flow, configuration
3. Reference: Dependency graph and security considerations

### Troubleshooting Issues
1. Locate your symptom: [Deployment Guide → Troubleshooting](./deployment-guide.md#troubleshooting)
2. Follow the solution steps
3. Check related sections for context

### Customizing Configuration
1. Reference: [Code Standards → TOML Configuration](./code-standards.md#toml-configuration-hugotoml)
2. Details: [Deployment Guide → Configuration Updates](./deployment-guide.md#configuration-updates)
3. Test locally before committing

## File Organization

```
/config/workspace/ezdevsecops/
├── docs/                          # ← You are here
│   ├── README.md                  # Navigation and quick reference
│   ├── project-overview-pdr.md    # Project vision and requirements
│   ├── codebase-summary.md        # Directory structure and files
│   ├── system-architecture.md     # Architecture diagrams and design
│   ├── code-standards.md          # Coding and content standards
│   └── deployment-guide.md        # Operational procedures
│
├── content/posts/
│   └── doks-mastery/              # Tutorial series
│       ├── 01-doks-preparation/
│       ├── 02-sysadmin-guide/
│       ├── 03-devops-guide/
│       ├── 04-developer-guide/
│       ├── 05-rbac-security/
│       ├── 06-troubleshooting-performance/
│       └── 07-cicd-integration/
│
├── layouts/
│   ├── partials/
│   │   └── extend_head.html       # Custom CSS + Mermaid loader
│   └── shortcodes/
│       ├── callout.html           # Vietnamese callout boxes
│       └── mermaid.html           # Mermaid diagram wrapper
│
├── assets/css/
│   └── custom-styles.css          # Callout and code block styling
│
├── themes/
│   └── hugo-PaperMod/             # Theme submodule
│
├── .github/workflows/
│   └── deploy-hugo-to-github-pages.yml
│
└── hugo.toml                      # Hugo configuration
```

## Technology Stack

- **Static Site Generator:** Hugo v0.146.0 (extended binary)
- **Theme:** PaperMod (responsive, minimal design)
- **Deployment:** GitHub Pages + GitHub Actions
- **Search:** Fuse.js (client-side full-text search)
- **Diagrams:** Mermaid v11 (CDN-based, dark mode compatible)
- **Language:** Vietnamese content, English technical terms

## Content Series

### DOKS Mastery (7 Parts)
A comprehensive guide to DigitalOcean Kubernetes (DOKS) for developers, sysadmins, and DevOps engineers.

1. **DOKS Preparation** - Cluster setup and prerequisites
2. **Sysadmin Guide** - Node management and monitoring
3. **DevOps Guide** - Deployment strategies
4. **Developer Guide** - Application deployment
5. **RBAC & Security** - Access control and policies
6. **Troubleshooting & Performance** - Diagnostics and optimization
7. **CI/CD Integration** - GitHub Actions automation

All posts include:
- Learning objectives
- Prerequisites
- Step-by-step instructions
- Code examples with syntax highlighting
- Important notes in callout boxes
- Architecture diagrams (where applicable)

## Standards & Best Practices

### Content Standards
- Vietnamese titles and descriptions
- YAML frontmatter with all required fields
- Markdown heading hierarchy (h2-h4 only)
- Code blocks with language tags
- Relative links within the site
- Callout boxes for important notes (4 types: info, tip, warning, danger)

### Code Standards
- TOML configuration with camelCase keys
- Go templates with whitespace control
- CSS organized by component
- Consistent naming conventions (kebab-case)
- Quality checklist before publishing

### Deployment Standards
- Push to `main` branch triggers automatic deployment
- All changes tested locally before pushing
- Commits follow conventional format
- No sensitive data committed
- Submodule updates verified

## Development Workflow

```
Create/Edit Post
    ↓
Write Content (Markdown + YAML)
    ↓
Test Locally (hugo server)
    ↓
Commit to Git
    ↓
Push to main branch
    ↓
GitHub Actions Builds & Deploys
    ↓
Live at https://toanalien.github.io/ezdevsecops/
```

**Time to live:** ~30 seconds from push to deployment

## Getting Help

### Check Documentation First
- Specific task → [Deployment Guide](./deployment-guide.md)
- Code or template question → [Code Standards](./code-standards.md)
- Architecture question → [System Architecture](./system-architecture.md)
- File/structure question → [Codebase Summary](./codebase-summary.md)

### Common Issues & Solutions
See: [Deployment Guide → Troubleshooting](./deployment-guide.md#troubleshooting)

## Statistics

| Document | Lines | Purpose |
|----------|-------|---------|
| README.md (this file) | ~250 | Navigation and quick reference |
| project-overview-pdr.md | 163 | Project vision and PDR |
| codebase-summary.md | 167 | Directory structure and stats |
| system-architecture.md | 348 | Architecture and design |
| code-standards.md | 365 | Standards and conventions |
| deployment-guide.md | 532 | Procedures and troubleshooting |
| **Total** | **1,825** | **Complete documentation suite** |

## Documentation Maintenance

This documentation is kept up-to-date with the codebase. When making significant changes:

1. Update relevant documentation files
2. Ensure examples remain accurate
3. Update links if files are reorganized
4. Keep naming conventions consistent
5. Include updates in commit message

## Last Updated

February 14, 2026 - Hugo blog implementation complete

---

**Need to contribute?** Start with [Deployment Guide](./deployment-guide.md) for publishing content or [Code Standards](./code-standards.md) for technical guidelines.

**Questions about architecture?** See [System Architecture](./system-architecture.md) for technical deep-dives.

**Looking for file locations?** Check [Codebase Summary](./codebase-summary.md) for the complete directory structure.
