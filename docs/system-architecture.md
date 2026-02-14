# System Architecture

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Content Authors                          │
│                    (Write Markdown Posts)                       │
└────────────────────┬────────────────────────────────────────────┘
                     │ git push to main
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                   GitHub Repository                             │
│  (ezdevsecops/ezdevsecops)                                       │
│  ├─ content/posts/doks-mastery/ (7 tutorial posts)              │
│  ├─ layouts/ (custom templates & shortcodes)                    │
│  ├─ assets/ (custom CSS)                                        │
│  ├─ themes/hugo-PaperMod/ (submodule)                           │
│  └─ hugo.toml (configuration)                                   │
└────────────────────┬────────────────────────────────────────────┘
                     │ Push to main branch
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│              GitHub Actions Workflow                            │
│  (deploy-hugo-to-github-pages.yml)                              │
│                                                                 │
│  Step 1: Checkout (with submodules)                             │
│  Step 2: Install Hugo v0.146.0 extended                         │
│  Step 3: Build: hugo --minify                                   │
│  Step 4: Upload artifact to GitHub Pages                        │
└────────────────────┬────────────────────────────────────────────┘
                     │ Build output
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│              Hugo Build Engine                                  │
│                                                                 │
│  Processes:                                                     │
│  ├─ Markdown → HTML (via goldmark renderer)                     │
│  ├─ Shortcodes (callout, mermaid)                               │
│  ├─ CSS pipeline (custom-styles.css minified)                   │
│  ├─ Taxonomies (tags, categories, series)                       │
│  ├─ Search index (JSON feed for Fuse.js)                        │
│  └─ Outputs (HTML, CSS, RSS, sitemap)                           │
│                                                                 │
│  Output: /public/ directory                                    │
└────────────────────┬────────────────────────────────────────────┘
                     │ /public artifact
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│              GitHub Pages Storage                               │
│  (gh-pages branch auto-managed)                                 │
│                                                                 │
│  Serves static content to CDN                                   │
└────────────────────┬────────────────────────────────────────────┘
                     │ HTTPS delivery
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│           Live Website (GitHub Pages)                           │
│                                                                 │
│  URL: https://ezdevsecops.github.io/ezdevsecops/                │
│  ├─ Posts with syntax highlighting                              │
│  ├─ Mermaid diagrams (v11, browser-rendered)                    │
│  ├─ Full-text search (Fuse.js)                                  │
│  ├─ Dark mode support                                           │
│  └─ Mobile responsive (PaperMod)                                │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### 1. Content Layer

**Markdown-Based Posts**
- Location: `content/posts/doks-mastery/`
- Format: Markdown with YAML frontmatter
- Structure: Each post in numbered directory with `index.md`
- Metadata: title, date, draft, description, categories, tags, series, weight, mermaid flag

**Content Pipeline:**
```
Post File (index.md)
    ↓
Parse Frontmatter (YAML)
    ↓
Process Markdown
    ├─ Convert to HTML
    ├─ Process shortcodes [callout], [mermaid]
    └─ Highlight code blocks (Monokai style)
    ↓
Combine with PaperMod Layout
    ↓
Render HTML Page
```

### 2. Template Layer

**Hugo Templates**
- **Base:** PaperMod theme (handles base layout, navigation, styling)
- **Overrides:** `layouts/partials/extend_head.html` - injects custom CSS and Mermaid loader
- **Shortcodes:** Custom template implementations for interactive elements

**Template Processing:**
```
extend_head.html (partial)
├─ {{ $css := resources.Get "css/custom-styles.css" | minify }}
├─ Load custom CSS from assets/
└─ Conditionally load Mermaid v11 (if page has mermaid: true)

shortcodes/callout.html
├─ Extract type parameter (info|warning|danger|tip)
├─ Map to Vietnamese title
└─ Render div with color-coded styling

shortcodes/mermaid.html
├─ Wrap inner content in <div class="mermaid">
└─ Allow browser-side rendering via CDN script
```

### 3. Static Asset Layer

**CSS Processing**
- Custom styles: `assets/css/custom-styles.css`
- Hugo resources pipeline minifies CSS
- Styles include:
  - Callout box colors and typography
  - Code block overflow handling
  - Print media rules
  - Dark mode compatibility

**JavaScript (External)**
- **Mermaid v11:** CDN ESM module (https://cdn.jsdelivr.net/npm/mermaid@11/)
  - Only loaded when `mermaid: true` in post frontmatter
  - Detects dark mode via `document.body.classList.contains('dark')`
- **Fuse.js:** Included in PaperMod theme
  - Reads generated JSON index
  - Provides client-side full-text search

### 4. Build & Deployment Layer

**Hugo Build Process**
```
Input:
├─ content/ (Markdown)
├─ layouts/ (Templates)
├─ assets/ (CSS)
├─ themes/hugo-PaperMod/ (Theme)
└─ hugo.toml (Config)
         ↓
    Hugo Engine
    ├─ Parse config (TOML)
    ├─ Process content (Markdown → HTML)
    ├─ Render templates
    ├─ Minify assets
    ├─ Generate taxonomies (tags, series)
    └─ Create search index (JSON)
         ↓
Output: /public/
├─ /index.html (home)
├─ /posts/ (post pages)
├─ /posts/doks-mastery/ (series pages)
├─ /tags/ (tag index)
├─ /series/ (series index)
├─ /search/ (search page)
├─ /index.json (search data)
├─ /feed.xml (RSS)
├─ /sitemap.xml
└─ /css/ (compiled + minified)
```

**CI/CD Pipeline**
```
Git Push to main
    ↓
GitHub Actions Workflow Triggered
    ├─ Checkout code + submodules
    ├─ Install Hugo v0.146.0 extended
    ├─ Run: hugo --minify
    ├─ Create artifact from /public/
    └─ Deploy to GitHub Pages
    ↓
GitHub Pages Updates
    ├─ Receives artifact
    ├─ Updates gh-pages branch
    └─ Serves via HTTPS CDN
    ↓
Live Website Updated
```

## Data Flow

### Content Update Flow
```
Author creates/edits post
    ↓ (Markdown + YAML frontmatter)
Git commit + push to main
    ↓
GitHub detects push
    ↓
Workflow: deploy-hugo-to-github-pages triggered
    ↓
Hugo processes all content
    ├─ Reads post frontmatter (series, tags, weight)
    ├─ Renders post with PaperMod layout
    ├─ Injects custom CSS + Mermaid loader
    ├─ Generates series index pages
    └─ Minifies CSS and HTML
    ↓
GitHub Pages deployment artifact created
    ↓
GitHub Pages receives artifact
    ↓
Website live at https://ezdevsecops.github.io/ezdevsecops/
```

### User Interaction Flow
```
User visits site
    ↓
Browser loads HTML (from GitHub Pages CDN)
    ├─ PaperMod theme CSS loaded
    ├─ custom-styles.css loaded
    └─ Extended head partial rendered
    ↓
User interacts:
├─ Reading post
│   ├─ Syntax highlighted code visible
│   ├─ Callout boxes styled with colors
│   └─ If mermaid: true, Mermaid v11 renders diagrams
│
├─ Searching
│   ├─ Fuse.js searches JSON index
│   └─ Results filtered client-side
│
└─ Theme toggle (dark/light)
    ├─ PaperMod updates body class
    └─ Mermaid re-renders with appropriate theme
```

## Configuration Architecture

### hugo.toml Structure
```toml
baseURL = "https://ezdevsecops.github.io/ezdevsecops/"
languageCode = "vi"
title = "EZ DevSecOps"
theme = "hugo-PaperMod"

[taxonomies]
  category = "categories"
  tag = "tags"
  series = "series"

[params]
  # Theme parameters
  defaultTheme = "auto"
  ShowReadingTime = true
  ShowPostNavLinks = true
  ShowBreadCrumbs = true
  ShowCodeCopyButtons = true
  ShowToc = true
  TocOpen = true

  [params.fuseOpts]
    # Search configuration
    threshold = 0.4
    keys = ["title", "permalink", "summary", "content"]

[markup.highlight]
  # Code highlighting
  codeFences = true
  style = "monokai"
  lineNos = true

[outputs]
  home = ["HTML", "RSS", "JSON"]

[[menu.main]]
  # Navigation menu (5 items)
```

## Shortcode System

### Callout Shortcode
```
Usage: {{< callout type="warning" >}}Content here{{< /callout >}}

Processing:
├─ type parameter → lookup Vietnamese title
├─ Determine color scheme
├─ Wrap in <div class="callout callout-{type}">
├─ Markdownify inner content
└─ Render with styled title
```

### Mermaid Shortcode
```
Usage: {{< mermaid >}}graph LR...{{< /mermaid >}}

Processing:
├─ Wrap inner text in <div class="mermaid">
├─ Mark page as mermaid: true
├─ extend_head.html loads Mermaid v11
└─ Browser renders diagram client-side
```

## Dependency Graph

```
Hugo (v0.146.0)
├─ goldmark (Markdown renderer)
├─ Taxonomy engine (tags, series, categories)
├─ Asset pipeline (CSS minification)
└─ Template engine (Go templates)

Theme: PaperMod (submodule)
├─ Base layouts and partials
├─ CSS framework
├─ Fuse.js (search)
└─ Dark mode support

External (CDN/Browser):
├─ Mermaid v11 (diagram rendering)
├─ Fuse.js (full-text search)
└─ GitHub Pages CDN (hosting + delivery)

Custom Code:
├─ extend_head.html (CSS + Mermaid injection)
├─ shortcodes/callout.html (styled boxes)
├─ shortcodes/mermaid.html (diagram wrapper)
└─ custom-styles.css (styling)
```

## Security Considerations

- **Content Safety:** Markdown input processed by Hugo (no arbitrary code execution)
- **HTML Escaping:** goldmark handles HTML escaping; `unsafe = true` only in specific contexts
- **Submodule Trust:** PaperMod is official theme from trusted source
- **CDN Resources:** Mermaid from jsdelivr (CDN pinned to v11)
- **No User Input:** Static site - no forms or dynamic data processing
- **GitHub Pages HTTPS:** All traffic encrypted

## Performance Architecture

- **Build Time:** ~5 seconds (Hugo is fast for 7 posts)
- **Output Size:** Minified CSS + HTML, ~50KB average per page
- **Caching:** GitHub Pages CDN caches everything
- **Search:** Client-side (no backend query needed)
- **Media:** SVG diagrams (Mermaid) - no image encoding overhead
