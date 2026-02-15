#!/usr/bin/env bash
# generate-epub.sh — Generate EPUB files from Hugo blog series
# Usage: ./scripts/generate-epub.sh [series-slug]
#   No argument: generates all series
#   With argument: generates only the specified series
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$ROOT_DIR/static/downloads"
EPUB_ASSETS="$ROOT_DIR/assets/epub"
PUPPETEER_CONFIG="$EPUB_ASSETS/puppeteer-config.json"
TMP_DIR=""

# Ensure Chrome shared libs are discoverable for mmdc (e.g. libnss3.so)
# CI (ubuntu-latest) has these system-wide; local dev may need bundled browser libs
if command -v mmdc &>/dev/null && ! ldconfig -p 2>/dev/null | grep -q libnss3; then
  _nss_lib=$(find "${HOME}/.cache" /config/.cache 2>/dev/null -name "libnss3.so" -print -quit 2>/dev/null || true)
  if [[ -n "${_nss_lib:-}" ]]; then
    export LD_LIBRARY_PATH="$(dirname "$_nss_lib"):${LD_LIBRARY_PATH:-}"
  fi
  unset _nss_lib
fi

# Series slug → content directory mapping (hardcoded, KISS)
declare -A SERIES_MAP=(
  ["doks-mastery"]="content/posts/doks-mastery"
  ["iso27001-sme"]="content/posts/iso27001-sme"
)

# Vietnamese callout type titles
declare -A CALLOUT_TITLES=(
  ["info"]="Thông tin"
  ["warning"]="Cảnh báo"
  ["danger"]="Nguy hiểm"
  ["tip"]="Mẹo"
)

# Cleanup temp files on exit
cleanup() { [[ -n "${TMP_DIR:-}" && -d "${TMP_DIR:-}" ]] && rm -rf "$TMP_DIR" || true; }
trap cleanup EXIT

# Strip YAML frontmatter (between first two --- lines)
strip_frontmatter() {
  awk 'BEGIN{n=0} /^---[[:space:]]*$/{n++; next} n>=2{print}' "$1"
}

# Extract title from YAML frontmatter
extract_title() {
  sed -n '/^---$/,/^---$/{ /^title:/{s/^title: *"\{0,1\}//; s/"\{0,1\}[[:space:]]*$//; p; q} }' "$1"
}

# Convert callout shortcodes to HTML blockquotes
# Handles: {{< callout type="X" >}} ... {{< /callout >}}
convert_callouts() {
  awk -v info="${CALLOUT_TITLES[info]}" \
      -v warning="${CALLOUT_TITLES[warning]}" \
      -v danger="${CALLOUT_TITLES[danger]}" \
      -v tip="${CALLOUT_TITLES[tip]}" '
    BEGIN { in_callout=0 }
    /\{\{<[[:space:]]*callout/ {
      # Extract type using mawk-compatible match + substr
      ctype = "info"
      if (match($0, /type="[^"]*"/)) {
        ctype = substr($0, RSTART+6, RLENGTH-7)
      }
      # Map type to Vietnamese title
      if (ctype == "info") ctitle = info
      else if (ctype == "warning") ctitle = warning
      else if (ctype == "danger") ctitle = danger
      else if (ctype == "tip") ctitle = tip
      else ctitle = ctype
      printf "<blockquote class=\"callout callout-%s\">\n<strong>%s</strong><br/>\n", ctype, ctitle
      in_callout=1
      next
    }
    /\{\{<[[:space:]]*\/callout[[:space:]]*>\}\}/ {
      print "</blockquote>"
      in_callout=0
      next
    }
    { print }
  '
}

# Convert mermaid shortcodes to SVG images (if mmdc available) or placeholder text
# Uses a counter file in tmp_dir to maintain global numbering across posts
convert_mermaid() {
  local tmp_dir="$1"
  local counter_file="$tmp_dir/mermaid-counter"
  # Initialize counter file if not exists
  [[ -f "$counter_file" ]] || echo "0" > "$counter_file"
  local start_count
  start_count=$(cat "$counter_file")

  awk -v tmp_dir="$tmp_dir" -v start="$start_count" '
    BEGIN { in_mermaid=0; counter=start }
    /\{\{<[[:space:]]*mermaid[[:space:]]*>\}\}/ {
      in_mermaid=1
      counter++
      mmd_file = tmp_dir "/mermaid-" counter ".mmd"
      marker_file = tmp_dir "/mermaid-" counter ".marker"
      # Write marker for post-processing
      print "%%MERMAID_PLACEHOLDER_" counter "%%" > marker_file
      close(marker_file)
      next
    }
    /\{\{<[[:space:]]*\/mermaid[[:space:]]*>\}\}/ {
      close(mmd_file)
      in_mermaid=0
      # Output placeholder that will be replaced later
      print "%%MERMAID_PLACEHOLDER_" counter "%%"
      next
    }
    in_mermaid {
      print >> mmd_file
      next
    }
    { print }
    END { print counter > (tmp_dir "/mermaid-counter") }
  '
}

# Render mermaid .mmd files to SVG and replace placeholders in combined markdown
render_mermaid_svgs() {
  local combined_file="$1"
  local tmp_dir="$2"
  local svg_dir="$tmp_dir/svgs"
  mkdir -p "$svg_dir"

  local has_mmdc=false
  if command -v mmdc &>/dev/null; then
    has_mmdc=true
  fi

  for mmd_file in "$tmp_dir"/mermaid-*.mmd; do
    [[ -f "$mmd_file" ]] || continue
    local num
    num=$(basename "$mmd_file" | sed 's/mermaid-\([0-9]*\)\.mmd/\1/')
    local svg_file="$svg_dir/diagram-${num}.svg"
    local placeholder="%%MERMAID_PLACEHOLDER_${num}%%"

    if $has_mmdc; then
      # Build mmdc args with puppeteer config if available
      local mmdc_args=(-i "$mmd_file" -o "$svg_file" -t neutral -b transparent)
      [[ -f "$PUPPETEER_CONFIG" ]] && mmdc_args+=(-p "$PUPPETEER_CONFIG")

      # Render SVG via mermaid-cli
      if mmdc "${mmdc_args[@]}" 2>/dev/null; then
        echo "    Rendered diagram-${num}.svg"
        # Inline the SVG content directly into the markdown for reliable EPUB embedding
        local svg_content
        svg_content=$(cat "$svg_file")
        # Use a temp file for replacement since SVG content is multiline
        awk -v placeholder="$placeholder" -v svgfile="$svg_file" '
          $0 == placeholder {
            while ((getline line < svgfile) > 0) print line
            close(svgfile)
            next
          }
          { print }
        ' "$combined_file" > "${combined_file}.tmp"
        mv "${combined_file}.tmp" "$combined_file"
      else
        echo "  Warning: mmdc failed for diagram-${num}, using placeholder" >&2
        sed -i "s|${placeholder}|> *[Biểu đồ ${num} - xem trên website]*|" "$combined_file"
      fi
    else
      # Fallback: placeholder text when mmdc not available
      sed -i "s|${placeholder}|> *[Biểu đồ ${num} - xem trên website]*|" "$combined_file"
    fi
  done

  # Return SVG dir path for pandoc --resource-path
  echo "$svg_dir"
}

# Generate EPUB for a single series
generate_epub() {
  local series_slug="$1"
  local content_dir="$ROOT_DIR/${SERIES_MAP[$series_slug]}"
  local metadata_file="$EPUB_ASSETS/metadata/${series_slug}.yaml"
  local css_file="$EPUB_ASSETS/epub-styles.css"
  local output_file="$OUTPUT_DIR/${series_slug}.epub"

  # Validate inputs
  [[ -d "$content_dir" ]] || { echo "Error: content dir not found: $content_dir" >&2; return 1; }
  [[ -f "$metadata_file" ]] || { echo "Error: metadata not found: $metadata_file" >&2; return 1; }

  TMP_DIR=$(mktemp -d)
  local combined="$TMP_DIR/combined.md"
  touch "$combined"

  echo "Generating EPUB for: $series_slug"

  # Collect and process posts in directory order (01-*, 02-*, etc.)
  for post_dir in "$content_dir"/*/; do
    local md_file="$post_dir/index.md"
    [[ -f "$md_file" ]] || continue

    local title
    title=$(extract_title "$md_file")
    [[ -n "$title" ]] || { echo "  Warning: no title in $md_file, skipping" >&2; continue; }

    echo "  Processing: $(basename "$post_dir") — $title"

    # Chapter heading
    printf '\n# %s\n\n' "$title" >> "$combined"

    # Strip frontmatter, convert shortcodes, append
    strip_frontmatter "$md_file" \
      | convert_callouts \
      | convert_mermaid "$TMP_DIR" \
      >> "$combined"

    printf '\n\n' >> "$combined"
  done

  # Render mermaid SVGs and get resource path
  local svg_dir
  svg_dir=$(render_mermaid_svgs "$combined" "$TMP_DIR")

  # Build pandoc command
  mkdir -p "$OUTPUT_DIR"
  local pandoc_args=(
    "$combined"
    -f gfm+raw_html
    --metadata-file="$metadata_file"
    --toc --toc-depth=2
    --top-level-division=chapter
    -o "$output_file"
  )

  # Add CSS if it exists
  [[ -f "$css_file" ]] && pandoc_args+=(--css="$css_file")

  # Add fonts if they exist
  for font in "$EPUB_ASSETS"/fonts/*.ttf; do
    [[ -f "$font" ]] && pandoc_args+=(--epub-embed-font="$font")
  done

  # Add SVG resource path if SVGs were rendered
  local has_svgs=false
  if [[ -d "$svg_dir" ]]; then
    for _svg in "$svg_dir"/*.svg; do
      [[ -f "$_svg" ]] && has_svgs=true && break
    done
  fi
  if $has_svgs; then
    pandoc_args+=(--resource-path="$svg_dir")
  fi

  pandoc "${pandoc_args[@]}"

  local filesize
  filesize=$(du -h "$output_file" | cut -f1)
  echo "Generated: $output_file ($filesize)"

  # Cleanup per-series temp
  rm -rf "$TMP_DIR"
  TMP_DIR=""
}

# Main
main() {
  if [[ $# -gt 0 ]]; then
    # Generate specific series
    local slug="$1"
    if [[ -z "${SERIES_MAP[$slug]+x}" ]]; then
      echo "Error: unknown series '$slug'. Available: ${!SERIES_MAP[*]}" >&2
      exit 1
    fi
    generate_epub "$slug"
  else
    # Generate all series
    for slug in $(echo "${!SERIES_MAP[@]}" | tr ' ' '\n' | sort); do
      generate_epub "$slug"
    done
  fi

  echo "Done."
}

main "$@"
