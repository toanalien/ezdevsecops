# Code Standards & Guidelines

## Hugo & Go Template Standards

### TOML Configuration (hugo.toml)

**Format & Structure**
```toml
# Use TOML format (Hugo standard)
baseURL = "https://toanalien.github.io/ezdevsecops/"
languageCode = "vi"
title = "EZ DevSecOps"

# Organize parameters in sections
[params]
  ShowReadingTime = true

  [params.nested]
    key = "value"

[[array]]
  # Array of tables (menu items, social icons)
  name = "item"
```

**Rules:**
- Use lowercase keys with camelCase for compound names
- Keep baseURL consistent with deployment environment
- Document non-obvious parameters in comments
- Use meaningful section names ([taxonomies], [markup], [outputs])

### Go Templates (Layouts)

**File Organization**
```
layouts/
├── partials/
│   └── extend_head.html      # Injected into <head>
└── shortcodes/
    ├── callout.html          # {{< callout >}}
    └── mermaid.html          # {{< mermaid >}}
```

**Template Syntax Rules**

**Partial (extend_head.html)**
```go-html
{{- /* Trim whitespace */ -}}
{{ $css := resources.Get "css/custom-styles.css" | minify }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}">

{{ if .Params.mermaid }}
  <script type="module">
    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
  </script>
{{ end }}
```

**Guidelines:**
- Use `{{- ... -}}` for whitespace control in critical areas
- Chain filters with pipes: `{{ value | filter1 | filter2 }}`
- Conditionals: `{{ if condition }} ... {{ end }}`
- Variable assignment: `{{ $var := value }}`
- Safe HTML output: Use `| safeHTML` only for trusted content
- Markdown processing: Use `| markdownify` for user content

**Shortcode Example**
```go-html
{{ $type := .Get "type" | default "info" }}
{{ $titles := dict "info" "Thông tin" "warning" "Cảnh báo" }}
{{ $title := index $titles $type | default ($type | title) }}
<div class="callout callout-{{ $type }}">
  <div class="callout-title">{{ $title }}</div>
  <div class="callout-content">{{ .Inner | markdownify }}</div>
</div>
```

**Rules:**
- Use named parameters: `{{ .Get "paramName" }}`
- Provide sensible defaults with `| default`
- Use `dict` for lookup tables (maps)
- Index maps with: `{{ index mapVar "key" }}`
- Always process inner content safely

## Markdown Content Standards

### Frontmatter (YAML)

**Required Fields**
```yaml
---
title: "Post Title in Vietnamese"
date: 2026-02-14
draft: false
description: "Meta description (for SEO, ~160 chars)"
categories: ["Kubernetes"]
tags: ["kubernetes", "digitalocean", "doks"]
series: ["DOKS Mastery"]
weight: 1
mermaid: true  # Only if post uses mermaid diagrams
---
```

**Rules:**
- Titles in Vietnamese, descriptive (50-70 characters ideal)
- Date format: YYYY-MM-DD
- Draft: false for published posts
- Categories: Single category (using "Kubernetes" for DOKS posts)
- Tags: lowercase, kebab-case, 3-5 tags max
- Series: Must match existing series names exactly
- Weight: Integer for ordering within series
- Mermaid flag: Include only if diagrams present

### Content Markdown

**Heading Hierarchy**
```markdown
## Main Section (h2 - only use below title)
### Subsection (h3)
#### Detail (h4)
```

**Rules:**
- Never use h1 (#) - title already used
- Start with h2 (##) for main sections
- Use logical nesting (no h2 → h4 jumps)
- Maximum 4 heading levels

**Code Blocks**

**Syntax Highlighting**
```bash
# Always specify language for highlighting
# Languages: bash, python, go, yaml, toml, html, css, javascript, etc.

# Code content here
```

**Rules:**
- Always include language tag (triple backticks with language)
- Languages: bash, python, go, yaml, toml, json, html, css, js
- Max line length in code: 80 characters (consider horizontal scroll)
- For long output: Use 5-10 representative lines with "..." for brevity

**Lists**

```markdown
- Use hyphens for unordered lists
  - Nested items indented (2 spaces)

1. Use numbers for ordered steps
2. Each step on new line
```

**Rules:**
- Unordered: use `-` (not `*` or `+`)
- Ordered: use `1. 2. 3. ...` (Hugo handles numbering)
- Indentation: 2 spaces for nested lists
- Lists in callouts: Markdown automatically processed

### Callout Boxes

**Usage**

```markdown
{{< callout type="info" >}}
**Bold title or first line**
This is informational content.
{{< /callout >}}
```

**Available Types & Vietnamese Titles**
| Type | Vietnamese | Use Case |
|------|-----------|----------|
| info | Thông tin | General information, tips |
| tip | Mẹo | Best practices, shortcuts |
| warning | Cảnh báo | Important warnings |
| danger | Nguy hiểm | Critical, dangerous operations |

**Rules:**
- Type parameter required (defaults to "info")
- Content supports Markdown (emphasis, bold, lists, code)
- Use for important information that needs visual distinction
- Avoid nesting callouts

### Mermaid Diagrams

**Usage**

```markdown
{{< mermaid >}}
graph LR
  A[Start] --> B{Decision}
  B -->|Yes| C[Action]
  B -->|No| D[Stop]
{{< /mermaid >}}
```

**Requirements**
- Must include `mermaid: true` in frontmatter
- Valid Mermaid v11 syntax
- Flowchart, sequence, state, class diagrams supported
- Dark mode compatible (Mermaid handles theme detection)

**Rules:**
- One diagram per shortcode block
- Keep diagrams simple and readable
- Use meaningful labels and colors
- Test diagram rendering in both light and dark modes
- Max complexity: 10-15 nodes (diagram readability)

## CSS Standards (custom-styles.css)

**Organization**

```css
/* Group by feature/component */

/* Callout boxes */
.callout { ... }
.callout-info { ... }

/* Code blocks */
.post-content .highlight pre { ... }

/* Print media */
@media print { ... }
```

**Naming Conventions**
- Use kebab-case: `.callout-title`, `.callout-info`
- Component-based: `.callout`, `.callout-{type}`
- Scope to context: `.post-content .highlight pre`

**Color Standards for Callouts**
```css
/* Info (blue) */
.callout-info {
  border-color: #3b82f6;
  background: rgba(59, 130, 246, 0.08);
}

/* Tip (green) */
.callout-tip {
  border-color: #22c55e;
  background: rgba(34, 197, 94, 0.08);
}

/* Warning (orange) */
.callout-warning {
  border-color: #f59e0b;
  background: rgba(245, 158, 11, 0.08);
}

/* Danger (red) */
.callout-danger {
  border-color: #ef4444;
  background: rgba(239, 68, 68, 0.08);
}
```

**Rules:**
- Use consistent color palette
- Border: 4px solid on left side
- Background: 8% opacity of border color
- Padding: 1rem 1.2rem (consistent spacing)
- Border-radius: 4px (subtle corners)

## GitHub Actions Workflow Standards

**File Location & Naming**
```
.github/workflows/deploy-hugo-to-github-pages.yml
```

**Structure**

```yaml
name: Deploy Hugo to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true
          fetch-depth: 0
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: "0.146.0"
          extended: true
      - name: Build
        run: hugo --minify
      # Continue with artifact upload...
```

**Rules:**
- Trigger on: push to main + manual dispatch
- Always checkout with submodules (theme)
- Pin Hugo version (use extended binary)
- Run: `hugo --minify` for production
- Keep step names descriptive

## Naming Conventions Summary

| Type | Pattern | Example |
|------|---------|---------|
| TOML keys | camelCase | `ShowReadingTime` |
| CSS classes | kebab-case | `.callout-warning` |
| Template files | snake_case + .html | `extend_head.html` |
| Post directories | kebab-case + number | `01-doks-preparation` |
| Tags | lowercase kebab-case | `kubernetes`, `digitalocean` |
| Variables (YAML) | snake_case | `mermaid`, `series` |
| Go template vars | camelCase | `$pageTitle` |

## Documentation Standards

### Post Metadata
- Title: 50-70 characters, Vietnamese
- Description: 150-160 characters (SEO snippet)
- Tags: 3-5 tags, lowercase, kebab-case
- Series: Exact match to series name
- Weight: Integer (1, 2, 3... for ordering)

### Content Structure
1. Learning objectives (what you'll learn)
2. Prerequisites (what you need before starting)
3. Main sections with step-by-step instructions
4. Code examples with syntax highlighting
5. Summary or next steps

### Cross-References
- Link to other posts: Use relative links `/posts/...`
- Link to series: Use category `/series/doks-mastery/`
- Link to tags: Use `/tags/tagname/`

## Quality Checklist

- [ ] YAML frontmatter complete and valid
- [ ] Markdown syntax valid (no unclosed code blocks)
- [ ] Code blocks have language specified
- [ ] Headings follow h2→h3→h4 hierarchy
- [ ] Links use relative paths within site
- [ ] Callout types correct (info|warning|danger|tip)
- [ ] Mermaid diagrams render correctly
- [ ] No broken links or references
- [ ] Reading time reasonable (<10 min typical)
- [ ] Vietnamese content spells correctly
- [ ] English technical terms lowercase (kubernetes, not Kubernetes in prose)
