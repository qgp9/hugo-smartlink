#!/usr/bin/env bash

# SmartLink Test Site Generator - Prepare Basic Structure
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base directory
TEST_SITE_DIR="${1:-tmp-test-site/generated}"

main() {
    echo "🔨 Generating SmartLink Test Site Structure..."
    echo -e "${YELLOW}Creating test site directory: $TEST_SITE_DIR${NC}"
    # Create directory structure
    mkdir -p "$TEST_SITE_DIR"/{content,layouts/_default,layouts/_shortcodes,static}
    
    create_config "$TEST_SITE_DIR/config-markdown.toml" "markdown"
    create_config "$TEST_SITE_DIR/config-html.toml"     "html"
    create_go_mod "$TEST_SITE_DIR/go.mod"
    create_single_html "$TEST_SITE_DIR/layouts/_default/single.html"
    
    # Create basic dummy content files
    create_basic_dummy_pages

    copy_test_files

    echo -e "${GREEN}✅ Basic test site structure created in $TEST_SITE_DIR${NC}"
    echo -e "${YELLOW}Next: Add test content and expected files${NC}" 
}

create_config() {
    local config_file="$1"
    local smartLinkOptions_output="$2"
    # Create base config.toml
    cat > "$config_file" << EOF
baseURL = "http://example.com/"
languageCode = "en-us"
title = "SmartLink Test Site"

[module]
  [[module.imports]]
    path = "github.com/qgp9/hugo-smartlink"
    disable = false

[params]
  [params.smartLinkOptions]
    output = "$smartLinkOptions_output"
    [params.smartLinkOptions.prefixAlias]
      "~" = "/doc/"
      "docs:" = "/documentation/"

  # Define custom patterns (higher priority)
  [[params.smartWikiLinks]]
    name = "JIRA"
    pattern = "^([A-Z][A-Z0-9]+-[0-9]+)$"
    url = "https://example.com/browse/{0}"
    class = "jira-link"

  [[params.smartWikiLinks]]
    name = "GitHub Issue"
    pattern = "^#([0-9]+)$"
    url = "https://github.com/owner/repo/issues/{1}"
    class = "github-issue"

  [[params.smartWikiLinks]]
    name = "GitHub Issue with Label"
    pattern = "^https://github.com/([^/]+/[^/]+)/issues/([0-9]+)$"
    label = "{1}#{2}"
    class = "github-issue"

  [[params.smartWikiLinks]]
    name = "Slack Channel"
    pattern = "^slack:#([a-z0-9-]+)$"
    url = "https://company.slack.com/app_redirect?channel={1}"
    class = "slack-channel"

  # Define wiki-style links (lower priority)
  [[params.smartWikiLinks]]
    name = "WikiLink"
    wikiLink = true
    stripNamespace = true
    class = "wikilink"

  # Broken Links fallback
  [[params.smartWikiLinks]]
    name = "Broken Link"
    pattern = "^.*$"
    url = "/broken-link/"
    class = "broken-link"
EOF
}

create_go_mod() {
    local go_mod_file="$1"
    cat > "$go_mod_file" << 'EOF'
module test-site

go 1.21

require github.com/qgp9/hugo-smartlink v0.0.0-20240101000000-000000000000
EOF
}

create_single_html() {
    local single_html_file="$1"
    mkdir -p "$(dirname "$single_html_file")"
    echo '{{ partial "content.html" . }}' > $single_html_file
}

# Function to create a page with minimal frontmatter
make_page() {
    local file_path="$1"
    local title="$2"
    local content="$3"
    
    # Create directory if needed
    mkdir -p "$(dirname "$file_path")"
    
    # Create page with frontmatter
    cat > "$file_path" << EOF
---
title: "$title"
date: 2024-01-01
---

$content
EOF
}

create_basic_dummy_pages() {
    # Create basic dummy pages that are referenced in tests
    make_page "$TEST_SITE_DIR/content/my-page/index.md" "My Page" "This is my page content."
    make_page "$TEST_SITE_DIR/content/about-us/index.md" "About Us" "About us page content."
    make_page "$TEST_SITE_DIR/content/getting-started/index.md" "Getting Started" "Getting started guide."
    make_page "$TEST_SITE_DIR/content/api-reference/index.md" "API Reference" "API documentation."
    make_page "$TEST_SITE_DIR/content/contact-us/index.md" "Contact Us" "Contact information."
    make_page "$TEST_SITE_DIR/content/simple/index.md" "Simple Page" "A simple test page."
    make_page "$TEST_SITE_DIR/content/abc/index.md" "ABC Page" "ABC page content."
    make_page "$TEST_SITE_DIR/content/def/index.md" "DEF Page" "DEF page content."
    make_page "$TEST_SITE_DIR/content/page/index.md" "Page" "Generic page content."
    make_page "$TEST_SITE_DIR/content/test-page/index.md" "Test Page" "Test page with hyphens."
    make_page "$TEST_SITE_DIR/content/test_page/index.md" "Test Page" "Test page with underscores."
    make_page "$TEST_SITE_DIR/content/test.page/index.md" "Test Page" "Test page with dots."
    make_page "$TEST_SITE_DIR/content/test@domain/index.md" "Test Page" "Test page with @ symbol."
    
    # Create nested pages with proper Hugo structure
    # Branch directories need _index.md, leaf pages use index.md
    make_page "$TEST_SITE_DIR/content/docs/_index.md" "Documentation" "Documentation section."
    make_page "$TEST_SITE_DIR/content/docs/guide/index.md" "Guide" "Documentation guide."
    make_page "$TEST_SITE_DIR/content/docs/api/_index.md" "API" "API documentation section."
    make_page "$TEST_SITE_DIR/content/docs/api/v1/index.md" "API v1" "API version 1 documentation."
    
    # Create pages for three-level path tests
    # Note: 4+ level paths are not supported due to Hugo's URL structure limitations
    # Hugo requires _index.md files for deep nested paths, which complicates SmartLink detection
    make_page "$TEST_SITE_DIR/content/getting-started/_index.md" "Getting Started" "Getting started section."
    make_page "$TEST_SITE_DIR/content/getting-started/guide/index.md" "Guide" "Getting started guide."
    
    # Create pages for prefix alias tests (these should exist for the alias to work)
    make_page "$TEST_SITE_DIR/content/doc/about/index.md" "About" "About page for tilde prefix."
    make_page "$TEST_SITE_DIR/content/doc/installation/index.md" "Installation" "Installation page for tilde prefix."
    make_page "$TEST_SITE_DIR/content/documentation/guide/index.md" "Guide" "Guide page for docs prefix."
    make_page "$TEST_SITE_DIR/content/documentation/troubleshooting/index.md" "Troubleshooting" "Troubleshooting page for docs prefix."
    
    # Create pages for special character tests
    make_page "$TEST_SITE_DIR/content/test-한글/index.md" "한글 Test" "Korean character test page."
    make_page "$TEST_SITE_DIR/content/test-émojis/index.md" "Émojis Test" "Emoji character test page."
    make_page "$TEST_SITE_DIR/content/page-123/index.md" "Page 123" "Page with numbers."
    make_page "$TEST_SITE_DIR/content/123-page/index.md" "123 Page" "Page starting with numbers."
}

copy_test_files() {
    echo -e "${YELLOW}📝 Copying test files...${NC}"
    
    # Ensure layouts/_shortcodes directory exists
    mkdir -p "$TEST_SITE_DIR/layouts/_shortcodes"
    # Copy expected_a shortcode
    if [ -f "./test-files/expected_a.html" ]; then
        cp "./test-files/expected_a.html" "$TEST_SITE_DIR/layouts/_shortcodes/"
        echo -e "${GREEN}✅ Copied expected_a.html shortcode${NC}"
    else
        echo -e "${YELLOW}⚠️  expected_a.html not found in test-files/, skipping${NC}"
    fi
    
    # Copy test content to single test directory
    if [ -f "./test-files/test-content.md" ]; then
        mkdir -p "$TEST_SITE_DIR/content/docs/test"
        cp "./test-files/test-content.md" "$TEST_SITE_DIR/content/docs/test/index.md"
        echo -e "${GREEN}✅ Copied test-content.md to test directory${NC}"
    else
        echo -e "${YELLOW}⚠️  test-content.md not found in test-files/, skipping${NC}"
    fi
}

main "$@"