# Deployment Guide

## Overview

EZ DevSecOps is deployed to GitHub Pages using GitHub Actions. The deployment is fully automated—pushing to the `main` branch triggers a build and deploy workflow that makes the site live in seconds.

**Live URL:** https://toanalien.github.io/ezdevsecops/

## Prerequisites

- Git installed locally
- GitHub account with push access to `ezdevsecops/ezdevsecops` repository
- Hugo v0.146.0 (extended binary) for local testing only

## Deployment Architecture

### Automatic Workflow

```
Local Commit
    ↓ git push origin main
GitHub Repository
    ↓ Detects push to main
GitHub Actions Workflow Triggered
    ├─ Checkout code + submodules
    ├─ Install Hugo v0.146.0 extended
    ├─ Build: hugo --minify
    └─ Create artifact from /public/
    ↓
GitHub Pages Deployment
    ├─ Receives artifact
    ├─ Updates gh-pages branch
    └─ Serves via HTTPS CDN
    ↓
Live Site Updated
    └─ https://toanalien.github.io/ezdevsecops/
```

## Publishing a New Post

### Step 1: Create Post Directory

```bash
# Create numbered directory in DOKS Mastery series
mkdir -p content/posts/doks-mastery/XX-post-name

# Create index file
touch content/posts/doks-mastery/XX-post-name/index.md
```

**Directory Naming:**
- Pattern: `{number}-{kebab-case-name}`
- Example: `07-cicd-integration/`
- Number: Sequential within series

### Step 2: Write Frontmatter

```yaml
---
title: "DOKS Mastery Phần N: Tiêu đề bài viết"
date: 2026-02-14
draft: false
description: "Mô tả ngắn gọn ~160 ký tự cho SEO snippet."
categories: ["Kubernetes"]
tags: ["kubernetes", "digitalocean", "tag3", "tag4", "tag5"]
series: ["DOKS Mastery"]
weight: N
mermaid: true  # Only if using diagrams
---
```

**Rules:**
- `title`: Vietnamese, 50-70 characters
- `date`: Today's date (YYYY-MM-DD)
- `draft`: false (to publish immediately)
- `description`: SEO-friendly summary
- `series`: Must be exactly "DOKS Mastery"
- `weight`: Order within series (1-7)
- `mermaid`: Include only if post has diagrams

### Step 3: Write Content

**Recommended Structure**

```markdown
## Giới thiệu

Brief introduction about this part...

### Sau bài viết này, bạn sẽ có thể:

- ✅ Learning objective 1
- ✅ Learning objective 2
- ✅ Learning objective 3

### Prerequisites

Requirements before starting...

## Main Section 1

Content with examples...

## Main Section 2

{{< callout type="warning" >}}
Important warning here
{{< /callout >}}

## Kết luận

Summary...
```

**Guidelines:**
- Start with learning objectives
- Use h2 for major sections, h3 for subsections
- Include code examples with language tags
- Use callout boxes for important notes
- Add Mermaid diagrams if helpful
- Keep paragraphs concise (2-3 sentences max)

### Step 4: Commit and Push

```bash
# Stage the new post
git add content/posts/doks-mastery/XX-post-name/

# Commit with descriptive message
git commit -m "Add DOKS Mastery part N: Post title"

# Push to main branch
git push origin main
```

**Commit Message Format:**
- Pattern: `Add DOKS Mastery part N: {Title}`
- Keep clear and descriptive
- Reference what's new/changed

### Step 5: Verify Deployment

1. Push commit to `main`
2. Visit GitHub Actions tab: https://github.com/ezdevsecops/ezdevsecops/actions
3. Watch workflow progress (~30 seconds total)
4. Check live site after workflow completes: https://toanalien.github.io/ezdevsecops/posts/doks-mastery/xx-post-name/

## Local Testing

### Setup Local Environment

```bash
# Clone repository with submodules
git clone --recurse-submodules https://github.com/ezdevsecops/ezdevsecops.git
cd ezdevsecops

# If already cloned without submodules:
git submodule update --init --recursive
```

**macOS:**
```bash
# Install Hugo extended via Homebrew
brew install hugo

# Verify version
hugo version  # Should be v0.146.0 or later
```

**Linux:**
```bash
# Download Hugo extended binary
wget https://github.com/gohugoio/hugo/releases/download/v0.146.0/hugo_extended_0.146.0_linux-amd64.tar.gz
tar -xzf hugo_extended_0.146.0_linux-amd64.tar.gz
sudo mv hugo /usr/local/bin/
```

**Windows:**
```bash
# Using Scoop
scoop install hugo-extended

# Or download from releases and add to PATH
```

### Build and Serve Locally

```bash
# Build site with minification (production)
hugo --minify

# Or serve with live reload (development)
hugo server

# Visit http://localhost:1313/ezdevsecops/
```

**Hugo Server Options:**
```bash
hugo server                    # Default: localhost:1313
hugo server --port 8000       # Custom port
hugo server --buildDrafts     # Include draft posts
hugo server --disableLiveJS   # Disable live reload (if needed)
```

### Test Locally Before Publishing

1. Create post in `content/posts/doks-mastery/`
2. Run `hugo server`
3. Navigate to your post
4. Verify:
   - Frontmatter rendered correctly
   - Markdown formatted as expected
   - Code blocks highlighted properly
   - Callout boxes styled correctly
   - Mermaid diagrams render (if applicable)
   - Links work
   - Navigation breadcrumbs display

### Preview Build Output

```bash
# Generate production build
hugo --minify

# Check output directory
ls -lh public/

# Open home page
open public/index.html  # macOS
xdg-open public/index.html  # Linux
```

## Editing Existing Posts

### Update Post Content

```bash
# Edit the post
nano content/posts/doks-mastery/XX-name/index.md

# Test locally
hugo server

# Commit and push
git add content/posts/doks-mastery/XX-name/index.md
git commit -m "Update DOKS Mastery part N: {description of change}"
git push origin main
```

### Update Frontmatter Only

**Allow Changes:**
- `date`: Update to publish date if reordering
- `draft`: Toggle publish/unpublish
- `tags`: Add or remove tags
- `weight`: Reorder within series
- `description`: SEO snippet updates

**Avoid Changes:**
- `title`: Don't change after publishing (URL changes)
- `series`: Keep consistent within series

### Delete a Post

```bash
# Remove post directory
rm -rf content/posts/doks-mastery/XX-name/

# Commit and push
git commit -m "Remove DOKS Mastery part N: {reason if applicable}"
git push origin main
```

## Configuration Updates

### Update Base URL

**File:** `hugo.toml`

```toml
baseURL = "https://custom-domain.com/"  # If custom domain added
```

**Requirements:**
- Always include trailing slash
- Must be HTTPS
- Test locally after change

### Update Menu Items

**File:** `hugo.toml`

```toml
[[menu.main]]
  name = "Trang chủ"
  url = "/"
  weight = 1

[[menu.main]]
  name = "New Menu Item"
  url = "/new-section/"
  weight = 6
```

**Rules:**
- Name: Display text
- URL: Relative path
- Weight: Order (lower = higher priority)

### Customize Theme Parameters

**File:** `hugo.toml` (`[params]` section)

```toml
[params]
  defaultTheme = "auto"          # auto, light, dark
  ShowReadingTime = true         # Display reading time
  ShowPostNavLinks = true        # Navigation between posts
  ShowBreadCrumbs = true         # Breadcrumb navigation
  ShowCodeCopyButtons = true     # Copy code button
  ShowToc = true                 # Table of contents
  TocOpen = true                 # TOC expanded by default
```

## Theme & Asset Updates

### Update PaperMod Theme

```bash
# Update theme submodule to latest
git submodule update --remote themes/hugo-PaperMod

# Test locally
hugo server

# Commit and push
git add themes/hugo-PaperMod
git commit -m "Update PaperMod theme to latest version"
git push origin main
```

### Update Hugo Version in Workflow

**File:** `.github/workflows/deploy-hugo-to-github-pages.yml`

```yaml
- name: Setup Hugo
  uses: peaceiris/actions-hugo@v3
  with:
    hugo-version: "0.147.0"  # Update version here
    extended: true
```

**Steps:**
1. Update version number in workflow file
2. Test locally with new Hugo version: `hugo version`
3. Commit workflow file
4. Push and verify workflow completes successfully

### Customize CSS

**File:** `assets/css/custom-styles.css`

```css
/* Add or modify styles here */
.callout {
  /* Existing styles */
}

/* Your custom styles */
.my-custom-class {
  color: #333;
}
```

**Changes automatically:**
- Minified by Hugo
- Injected via `extend_head.html`
- No Hugo restart needed for development (hot reload)

## Troubleshooting

### Build Fails in GitHub Actions

1. **Check workflow logs:**
   - https://github.com/ezdevsecops/ezdevsecops/actions
   - Click on failed workflow
   - Review error messages

2. **Common issues:**
   - Markdown syntax error: Check for unclosed code blocks
   - Invalid YAML frontmatter: Verify indentation
   - Missing submodule: Ensure theme submodule initialized
   - Hugo version mismatch: Test locally first

3. **Fix and retry:**
   ```bash
   hugo --minify  # Test locally
   git push origin main  # Workflow retries automatically
   ```

### Site Not Updating After Push

1. Check workflow status at GitHub Actions
2. Clear browser cache (Ctrl+Shift+Delete or Cmd+Shift+Delete)
3. Wait 30 seconds and refresh (CDN delay)
4. Check live URL: https://toanalien.github.io/ezdevsecops/

### Local Build Issues

**Hugo not found:**
```bash
which hugo
hugo version
# If missing, reinstall Hugo v0.146.0
```

**Submodule missing:**
```bash
git submodule update --init --recursive
```

**CSS not loading:**
```bash
# Clean build
rm -rf resources/
hugo --minify
```

**Mermaid diagrams not rendering:**
- Verify `mermaid: true` in frontmatter
- Check browser console for CDN errors
- Test with simple diagram first

### Port Already in Use

```bash
# Use different port
hugo server --port 8000

# Or kill process on default port
lsof -i :1313  # Find process
kill -9 <PID>  # Kill it
```

## Rollback & Recovery

### Revert Last Commit

```bash
# View recent commits
git log --oneline -5

# Revert last commit (keeps files modified)
git reset --soft HEAD~1

# Or reset completely (lose changes)
git reset --hard HEAD~1

# Push to main
git push origin main --force  # Use carefully!
```

### Restore from GitHub Pages History

GitHub Pages keeps previous builds. If needed:

1. Check GitHub repository settings → Pages section
2. Previous deployments available in Actions tab
3. Re-run previous successful workflow if needed

## Performance & Optimization

### Site Performance
- **Build time:** ~5 seconds
- **Page size:** ~50KB average
- **Load time:** <1 second (GitHub CDN)

### Optimization Tips

**Reduce image sizes:**
```bash
# Before adding images to posts
imagemagick convert large.png -quality 80 optimized.png
```

**Minimize code blocks:**
- Keep examples concise (5-15 lines)
- Use "..." for long output

**Lazy load diagrams:**
- Only include `mermaid: true` if post has diagrams
- Reduces JS load for posts without diagrams

## Monitoring Deployment

### View Workflow Status

- **GitHub Actions Dashboard:** https://github.com/ezdevsecops/ezdevsecops/actions
- **Pages Settings:** https://github.com/ezdevsecops/ezdevsecops/settings/pages

### Check Deployment Logs

```bash
# View all recent deployments
git log --oneline -10

# Check Actions tab for workflow status
# Each push shows:
# ✅ Workflow completed in ~30 seconds
# ✅ Site deployed to GitHub Pages
```

## Security & Best Practices

- **Never commit secrets:** No API keys, credentials in content
- **Use relative links:** `/posts/...` not full URLs
- **Validate YAML:** Use YAML linter before committing
- **Test locally:** Always verify before pushing
- **Review changes:** Check diff before committing
- **Keep submodule updated:** Regular theme updates

## Next Steps After First Deployment

1. ✅ Verify live site is working
2. ✅ Test search functionality
3. ✅ Check mobile responsiveness
4. ✅ Test dark mode toggle
5. ✅ Verify Mermaid diagrams render
6. ✅ Check RSS feed: `/feed.xml`
7. ✅ Verify sitemap: `/sitemap.xml`
