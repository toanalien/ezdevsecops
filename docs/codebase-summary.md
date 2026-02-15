# Codebase Summary

## Project Structure

```
ezdevsecops/
├── hugo.toml                    # Hugo configuration
├── .gitmodules                  # Git submodule config (PaperMod theme)
├── .gitignore                   # Git ignore rules (Hugo entries)
│
├── content/
│   ├── posts/
│   │   ├── _index.md           # Posts landing page
│   │   ├── doks-mastery/
│   │   │   ├── _index.md       # DOKS Mastery series index
│   │   │   ├── 01-doks-preparation/index.md
│   │   │   ├── 02-sysadmin-guide/index.md
│   │   │   ├── 03-devops-guide/index.md
│   │   │   ├── 04-developer-guide/index.md
│   │   │   ├── 05-rbac-security/index.md
│   │   │   ├── 06-troubleshooting-performance/index.md
│   │   │   └── 07-cicd-integration/index.md
│   │   ├── iso27001-sme/
│   │   │   ├── _index.md       # ISO 27001 SME series index
│   │   │   ├── 01-gioi-thieu-iso27001/index.md
│   │   │   ├── 02-pham-vi-isms-boi-canh/index.md
│   │   │   ├── 03-danh-gia-rui-ro/index.md
│   │   │   ├── 04-tuyen-bo-ap-dung/index.md
│   │   │   ├── 05-chinh-sach-tai-lieu/index.md
│   │   │   ├── 06-trien-khai-kiem-soat/index.md
│   │   │   ├── 07-dao-tao-nhan-su/index.md
│   │   │   ├── 08-danh-gia-noi-bo/index.md
│   │   │   ├── 09-chuan-bi-chung-nhan/index.md
│   │   │   └── 10-tuan-thu-phap-luat-vn/index.md
│   │   └── openclaw-personal-assistant/
│   │       ├── _index.md       # OpenClaw Personal Assistant series index
│   │       ├── 01-infrastructure-preparation/index.md
│   │       ├── 02-installation-configuration/index.md
│   │       ├── 03-messaging-channel-integration/index.md
│   │       ├── 04-security-hardening/index.md
│   │       ├── 05-skills-customization/index.md
│   │       └── 06-operations-maintenance/index.md
│
├── layouts/
│   ├── partials/
│   │   └── extend_head.html     # Custom CSS + Mermaid loader
│   └── shortcodes/
│       ├── callout.html         # Callout box shortcode
│       ├── mermaid.html         # Mermaid diagram shortcode
│       └── download-epub.html    # EPUB download button shortcode
│
├── assets/
│   ├── css/
│   │   └── custom-styles.css    # Custom styles (callouts, code blocks)
│   └── epub/                     # EPUB generation assets
│       ├── metadata/
│       │   ├── doks-mastery.yaml     # EPUB metadata for DOKS series
│       │   └── iso27001-sme.yaml     # EPUB metadata for ISO 27001 series
│       ├── epub-styles.css       # Embedded CSS for EPUB files
│       └── fonts/                # Custom fonts for EPUB embedding
│
├── themes/
│   └── hugo-PaperMod/           # PaperMod theme (submodule)
│
├── data/                        # Hugo data files
├── i18n/                        # Internationalization
├── archetypes/                  # Post templates
│
├── .github/
│   └── workflows/
│       └── deploy-hugo-to-github-pages.yml  # CI/CD deployment
│
├── scripts/
│   └── generate-epub.sh         # EPUB generation script (Pandoc + Mermaid CLI)
│
├── CLAUDE.md                    # Claude Code instructions
├── AGENTS.md                    # Agent documentation
└── plans/                       # Implementation plans
```

## Key Files

### Configuration
- **hugo.toml** (81 lines)
  - Base URL: `https://toanalien.github.io/ezdevsecops/`
  - Theme: hugo-PaperMod
  - Language: Vietnamese (`vi`)
  - Taxonomies: categories, tags, series
  - Mermaid support, search (Fuse.js)
  - Main menu with 5 navigation items

### Content
- **7 Tutorial Posts** (doks-mastery series)
  - Each post: Markdown file in timestamped directory
  - Frontmatter: title, date, categories, tags, series, weight, mermaid flag
  - Vietnamese titles and descriptions
  - Learning objectives, prerequisites, step-by-step guides
- **10 ISO 27001 SME Tutorial Posts** (iso27001-sme series)
  - Information Security Management System (ISMS) comprehensive guide
  - Vietnamese language content targeting enterprise security professionals
  - Series covers introduction through certification and Vietnam compliance
- **6 OpenClaw Personal Assistant Tutorial Posts** (openclaw-personal-assistant series)
  - Self-hosted AI assistant deployment guide using OpenClaw framework
  - Vietnamese language content targeting AI practitioners and automation engineers
  - Series covers infrastructure, installation, integration, security, customization, and operations

### Layout Components
- **extend_head.html** (15 lines)
  - Loads custom CSS via Hugo resources
  - Conditional Mermaid v11 ESM loader (checks `mermaid: true` in frontmatter)
  - Theme-aware dark mode support

- **callout.html** (8 lines)
  - Shortcode: `{{< callout type="info" >}}...{{< /callout >}}`
  - Types: info, warning, danger, tip (Vietnamese titles)
  - Markdown content support via `markdownify`

- **mermaid.html** (4 lines)
  - Shortcode: `{{< mermaid >}}...{{< /mermaid >}}`
  - Wraps content in div with mermaid class for rendering

- **download-epub.html** (22 lines)
  - Shortcode: `{{< download-epub file="/downloads/series-name.epub" chapters="7" label="Download" >}}`
  - Renders styled download button with icon and chapter count
  - Parameters: `file` (EPUB path), `chapters` (number), `label` (button text, Vietnamese default)

### Styling
- **custom-styles.css** (50+ lines)
  - Callout boxes: 4 color schemes (blue, green, orange, red)
  - Callout title styling (bold, margin)
  - Code blocks: max-height 600px with overflow
  - Print styles: hide navigation, footer, etc.

### Deployment & EPUB Generation
- **deploy-hugo-to-github-pages.yml** (68 lines)
  - Trigger: Push to `main` branch or manual `workflow_dispatch`
  - Hugo v0.146.0 extended binary
  - **EPUB Generation:** Pandoc + Mermaid CLI installed, `scripts/generate-epub.sh` runs before Hugo build
  - Build: `hugo --minify`
  - Deploy: Upload artifact to GitHub Pages
  - Output includes EPUB files in `/public/downloads/`

## Technology Stack

| Component | Version | Purpose |
|-----------|---------|---------|
| Hugo | 0.146.0 (extended) | Static site generator |
| PaperMod | Latest (submodule) | Responsive theme |
| Mermaid | v11 (CDN ESM) | Diagram rendering |
| Mermaid CLI | Latest (Node.js) | Diagram → SVG conversion for EPUB |
| Pandoc | Latest | Markdown → EPUB conversion |
| Fuse.js | Built-in (PaperMod) | Full-text search |
| GitHub Actions | Latest | CI/CD automation |

## Content Characteristics

### Blog Posts
- **Format:** Markdown with YAML frontmatter
- **Language:** Vietnamese content, English technical terms
- **Typical Structure:**
  - Title (Vietnamese)
  - Description (for meta tags)
  - Learning objectives
  - Prerequisites
  - Body sections with headings
  - Code blocks with syntax highlighting
  - Callout boxes for key points
  - Mermaid diagrams where helpful

### Series Organization
- **DOKS Mastery:** 7-part series on DigitalOcean Kubernetes
  - Weight: Posts numbered 1-7 for ordering
  - Metadata: Category (Kubernetes), multiple tags
- **ISO 27001 SME:** 10-part series on Information Security Management Systems
  - Weight: Posts numbered 1-10 for ordering
  - Metadata: Category (Security), tags: iso27001, isms, compliance, security

## Build & Deployment

### Build Process
1. Checkout code + submodules
2. Install Hugo v0.146.0 extended
3. Run: `hugo --minify`
4. Output: `/public/` directory
5. Upload artifact to GitHub Pages

### Output
- **Site URL:** `https://toanalien.github.io/ezdevsecops/`
- **Build Time:** ~5 seconds
- **Assets Generated:**
  - HTML pages
  - CSS (minified custom + PaperMod)
  - JSON search index
  - RSS feed
  - Sitemap

## Customization Points

### Easy to Modify
- **hugo.toml:** Add menu items, change descriptions, adjust base URL
- **custom-styles.css:** Adjust colors, spacing, responsive breakpoints
- **layouts/shortcodes/:** Add new shortcodes or enhance existing ones
- **content/posts/:** Add new blog posts in `doks-mastery/` directory

### Requires Careful Handling
- **PaperMod submodule:** Don't edit directly, update via submodule commands
- **extend_head.html:** Ensure Mermaid logic doesn't break theme functionality
- **.github/workflows/:** Update Hugo version carefully (test locally first)

## File Statistics

- **Markdown Files:** 26 (1 index, 7 DOKS posts, 10 ISO 27001 posts, 6 OpenClaw posts, 1 landing page, 1 DOKS index, 1 OpenClaw index)
- **HTML Templates:** 3 (extend_head, callout, mermaid)
- **CSS:** 1 custom stylesheet
- **Config:** 1 TOML file
- **Workflow:** 1 GitHub Actions file
- **Total Code Lines:** ~200 (excluding content)
