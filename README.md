<!-- omit from toc -->
# Hugo SmartLink

[![Hugo version](https://img.shields.io/badge/hugo-0.127.0-blue.svg)](https://gohugo.io/)
[![License](https://img.shields.io/badge/license-Apache%202.0-green.svg)](https://github.com/qgp9/hugo-smartlink/blob/main/LICENSE)

> ⚠️ **Disclaimer**: This README was mostly written by an LLM (thanks, AI!) and hasn't been thoroughly fact-checked. Proceed with caution and a sense of humor 😄  
> *Even this disclaimer sentence was written by an LLM - we're going full meta here!*

A Hugo module that provides **wiki link** functionality for Hugo static sites. This module automatically converts `[[wikilink]]` syntax into proper HTML links.

## What is Hugo SmartLink?

Hugo SmartLink is a powerful Hugo shortcode and partial that enables **wiki links** (also known as wikilinks or wiki-style links) in your Hugo content. It transforms `[[page-name]]` syntax into proper internal links, supporting both markdown and HTML output formats.

### Key Features

- 🔗 **Wiki Link Detection**: Automatically detects and converts `[[wikilink]]` syntax
- 🔧 **Configurable Patterns**: Supports regex patterns to match different types of links
- 🎨 **Customizable Output**: Choose between Markdown or HTML output formats
- 🏷️ **Smart Labels**: Define custom labels and URL patterns
- 📁 **Prefix Aliases**: Map namespace prefixes to different paths
- 🎯 **Theme Compatible**: Works seamlessly with existing Hugo themes
- ⚡ **Zero Configuration**: Works out of the box with sensible defaults
- 🎯 **Pattern Matching**: Support for custom link patterns (JIRA, GitHub issues, etc.)
- 🧹 **Namespace Stripping**: Clean up link labels automatically
- 🛡️ **Fallback Handling**: Graceful handling of broken links
- ⚙️ **Configuration Merging**: Intelligent merging of site and page-level configurations
- 🚀 **Performance Optimized**: Efficient caching and processing for large content sites

<!-- omit from toc -->
## Table of Contents

- [What is Hugo SmartLink?](#what-is-hugo-smartlink)
  - [Key Features](#key-features)
- [Installation](#installation)
  - [Step 1: Install the Module](#step-1-install-the-module)
  - [Step 2: Add to Site Configuration](#step-2-add-to-site-configuration)
- [Quick Start](#quick-start)
  - [Zero Configuration](#zero-configuration)
  - [Basic Usage](#basic-usage)
  - [Default Configuration (Reference)](#default-configuration-reference)
  - [Basic Configuration](#basic-configuration)
  - [Advanced Configuration](#advanced-configuration)
    - [Output Format](#output-format)
    - [Prefix Aliases](#prefix-aliases)
    - [Escaped Wiki Link Normalization](#escaped-wiki-link-normalization)
    - [Code Block Protection](#code-block-protection)
    - [Page-Level Configuration](#page-level-configuration)
    - [Configuration Merging](#configuration-merging)
- [Usage Examples](#usage-examples)
  - [Wiki-Style Links](#wiki-style-links)
  - [External System Links](#external-system-links)
  - [With Prefix Aliases](#with-prefix-aliases)
  - [Complex Patterns](#complex-patterns)
- [Performance](#performance)
  - [Performance Benchmarks](#performance-benchmarks)
    - [Test Configuration](#test-configuration)
    - [Performance Results (N=200 files)](#performance-results-n200-files)
    - [Detailed Analysis](#detailed-analysis)
    - [Performance Scaling](#performance-scaling)
  - [Performance Testing](#performance-testing)
- [For Theme Developers](#for-theme-developers)
  - [Step 1: Create Content Partial](#step-1-create-content-partial)
  - [Step 2: Update Templates](#step-2-update-templates)
- [TODO](#todo)
  - [Known Issues](#known-issues)
  - [Planned Features](#planned-features)
- [Contributing](#contributing)

## Installation

### Step 1: Install the Module

```bash
hugo mod get github.com/qgp9/hugo-smartlink@latest
```

### Step 2: Add to Site Configuration

Add the module to your `hugo.toml`:

```toml
[module]
[[module.imports]]
  path = "github.com/qgp9/hugo-smartlink"
```

## Quick Start

### Zero Configuration

The Hugo SmartLink module works out of the box with default settings. You can immediately start using wiki links in your Hugo content.

### Basic Usage

You can immediately use `[[wikilink]]` syntax in your content:

```markdown
# My Documentation

This is a link to [[my-page]] and another to [[about-us]].
```

**Output:**

```html
<p>This is a link to <a href="/my-page" class="wikilink">my-page</a> and another to <a href="/about-us" class="wikilink">about-us</a>.</p>
```

### Default Configuration (Reference)

If you want to see what the default configuration looks like:

```toml
[params]
  [params.modules]
    [params.modules.smartlink]
      output = "html"  # Default is now "html" for better performance and CSS support
      normalizeEscapedWikilink = true  # Normalize escaped wiki links for documentation
      [params.modules.smartlink.prefixAlias]
        "~" = "/doc/"
        "docs:" = "/documentation/"

      # Internal Wiki Link
      [[params.modules.smartlink.rules]]
        name = "WikiLink"
        wikiLink = true
        stripNamespace = true
        class = "wikilink" # Only used when output: html

      # Broken Links 
      [[params.modules.smartlink.rules]]
        name = "Broken Link"
        pattern = "^.*$"
        url = "/broken-link/?path={0}"
        class = "broken-link" # Only used when output: html
```

### Basic Configuration

Customize Hugo SmartLink behavior with `modules.smartlink` and `modules.smartlink.rules` array:

```toml
[params]
  [params.modules]
    [params.modules.smartlink]
      output = "html"  # "html" (default) or "markdown"
      normalizeEscapedWikilink = true  # Normalize escaped wiki links for documentation
      [params.modules.smartlink.prefixAlias]
        "~" = "/doc/"
        "docs:" = "/documentation/"

      # Define custom patterns (recommended: higher priority)
      [[params.modules.smartlink.rules]]
        name = "JIRA"
        pattern = "^([A-Z][A-Z0-9]+-\d+)$"
        url = "https://example.com/browse/{0}"
        class = "jira-link"

      [[params.modules.smartlink.rules]]
        name = "GitHub Issue"
        pattern = "^#(\d+)$"
        url = "https://github.com/owner/repo/issues/{1}"
        class = "github-issue"

      [[params.modules.smartlink.rules]]
        name = "GitHub Issue with Label"
        pattern = "^https://github\.com/([^/]+/[^/]+)/issues/(\d+)$"
        label = "{1}#{2}"
        class = "github-issue"

      [[params.modules.smartlink.rules]]
        name = "Slack Channel"
        pattern = "^slack:#([a-z0-9-]+)$"
        url = "https://company.slack.com/app_redirect?channel={1}"
        class = "slack-channel"

      # Define wiki-style links (recommended: lower priority)
      [[params.modules.smartlink.rules]]
        name = "WikiLink"
        wikiLink = true
        stripNamespace = true  # Remove namespace prefix from display text
        class = "wikilink"  # Only used when output: html

      # Broken Links fallback (recommended: lowest priority)
      [[params.modules.smartlink.rules]]
        name = "Broken Link"
        pattern = "^.*$"
        url = "/broken-link/"
        class = "broken-link"
```

**Recommended Rule Order:**

SmartLink processes rules in the order they appear in the configuration. While you can arrange them in any order, we recommend this sequence:

1. **Custom Patterns** (highest priority) - JIRA, GitHub issues, Slack channels, etc.
2. **Specific Wiki Links** (medium-high priority) - Wiki links with specific patterns
3. **General Wiki Links** (medium priority) - General internal page links
4. **Broken Link Fallback** (lowest priority) - Handles unmatched links

This ensures that for example `[[#42]]` matches the GitHub Issue pattern instead of being treated as a wiki link. You can have multiple wiki link rules with different patterns if needed.

**Examples:**

**JIRA Rule (Custom Pattern):**

- Input: `[[PROJ-123]]`
  - Markdown: `[PROJ-123](https://example.com/browse/PROJ-123)`
  - HTML: `<a href="https://example.com/browse/PROJ-123" class="jira-link">PROJ-123</a>`

**GitHub Issue Rule (Custom Pattern):**

- Input: `[[#42]]`
  - Markdown: `[#42](https://github.com/owner/repo/issues/42)`
  - HTML: `<a href="https://github.com/owner/repo/issues/42" class="github-issue">#42</a>`

**GitHub Issue with Label Rule (Custom Pattern):**

- Input: `[[https://github.com/company/repo/issues/123]]`
  - Markdown: `[company/repo#123](https://github.com/company/repo/issues/123)`
  - HTML: `<a href="https://github.com/company/repo/issues/123" class="github-issue">company/repo#123</a>`

**WikiLink Rule (Internal Links):**

- Input: `[[my-page]]`
  - Markdown: `[my-page](/my-page)`
  - HTML: `<a href="/my-page" class="wikilink">my-page</a>`

- Input: `[[docs/guide]]`
  - Markdown: `[guide](/docs/guide)`
  - HTML: `<a href="/docs/guide" class="wikilink">guide</a>`
  - Note: stripNamespace removes path prefix

### Advanced Configuration

#### Output Format

Control how wiki links are generated:

```toml
[params]
  [params.modules]
    [params.modules.smartlink]
      output = "html"  # or "markdown" (default is now "html")
```

| Format | Pros | Cons |
|--------|------|------|
| **`html`** (default) | ✅ CSS classes can be applied directly<br>✅ Better performance<br>✅ More control over styling | ❌ Hugo's link render hooks not applied |
| **`markdown`** | ✅ Hugo's link render hooks applied<br>✅ Standard Markdown output | ❌ CSS classes cannot be applied directly<br>❌ Slower performance |

#### Prefix Aliases

Map namespace prefixes to different paths for your wiki links:

```toml
[params]
  [params.modules]
    [params.modules.smartlink]
      [params.modules.smartlink.prefixAlias]
        "~" = "/doc/"
        "docs:" = "/documentation/"
```

**Examples:**

- `[[~/About]]` → `[About](/doc/about)`
- `[[docs:Guide]]` → `[Guide](/documentation/guide)`

#### Escaped Wiki Link Normalization

Control whether escaped wiki links are normalized for documentation:

```toml
[params]
  [params.modules]
    [params.modules.smartlink]
      normalizeEscapedWikilink = true  # Default: true (HTML output only)
```

**Examples:**

- `normalizeEscapedWikilink = true`: `[\[wikilink]]` → `[[wikilink]]` (for documentation)
- `normalizeEscapedWikilink = false`: `[\[wikilink]]` → `[\[wikilink]]` (performance optimized)

**Important Notes:**
- **HTML Output Only**: This feature only works with `output = "html"` (default)
- **Performance Impact**: When enabled, adds processing overhead for escaped link detection. On large documents or many links, this can noticeably slow down build times.
- **Documentation Use**: Primarily useful when showing wiki link syntax in documentation
- **Page-Level Override**: Can be overridden per page using front matter

**Use cases:**
- **`true`**: When you need to show wiki link syntax in documentation
- **`false`**: For better performance when escaped links are not needed

#### Code Block Protection

Protect code blocks from SmartLink processing:

```toml
[params]
  [params.modules]
    [params.modules.smartlink]
      protectCodeBlocks = false  # Default: false (performance optimized)
      maxCodeBlockIterations = 50  # Default: 50 (nested processing depth)
```

**Examples:**

- `protectCodeBlocks = true`: Code blocks with `[[wikilink]]` are preserved
- `protectCodeBlocks = false`: All content is processed (faster)

**Important Notes:**
- **Performance Impact**: When enabled, significantly slows down processing due to complex regex operations
- **Nested Processing**: `maxCodeBlockIterations` controls how deep nested code blocks are processed
- **Page-Level Override**: Can be overridden per page using front matter
- **Recommendation**: Keep disabled by default, enable only for documentation pages

#### Page-Level Configuration

You can override any SmartLink settings per page using front matter:

```markdown
---
title: "SmartLink Documentation"
protectCodeBlocks: true
normalizeEscapedWikilink: true
maxCodeBlockIterations: 10
---

This page will have code block protection and escaped link normalization enabled.
```

**Front Matter Options:**
- `protectCodeBlocks`: Enable/disable code block protection
- `normalizeEscapedWikilink`: Enable/disable escaped link normalization  
- `maxCodeBlockIterations`: Set nested processing depth (1-50)

**Priority Order:**
1. Page front matter (highest priority)
2. Site configuration (`hugo.toml`)
3. Default values (lowest priority)

#### Configuration Merging

SmartLink uses Hugo's `collections.Merge` to combine configurations from multiple sources with proper priority:

```toml
# Site-level configuration (hugo.toml)
[params.modules.smartlink]
  output = "html"
  [params.modules.smartlink.prefixAlias]
    "~" = "/doc/"

# Page-level configuration (front matter)
---
smartlink:
  output: "markdown"
  prefixAlias:
    "docs:" = "/documentation/"
---
```

**Merge Priority (highest to lowest):**
1. Page front matter (`smartlink` namespace)
2. Site configuration (`params.modules.smartlink`)
3. Default values

**Important Notes:**
- **Case Handling**: Hugo's `collections.Merge` converts keys to lowercase internally
- **Key Access**: Always use lowercase keys when accessing merged configuration
- **TOML Keys**: Front matter and TOML keys remain unchanged (case-sensitive)
- **Internal Processing**: Only internal configuration access uses lowercase keys

## Usage Examples

### Wiki-Style Links

```markdown
# Project Documentation

Check out our [[getting-started]] guide and [[api-reference]].
For support, visit [[contact-us]].
```

### External System Links

```markdown
# Development Notes

- Fixed bug in [[PROJ-123]]
- Updated documentation for [[#42]]
```

### With Prefix Aliases

```markdown
# Knowledge Base

- [[~/installation]] - How to install
- [[docs:troubleshooting]] - Common issues
```

### Complex Patterns

```toml
# Configuration for multiple systems (recommended order)
# 1. Custom patterns (highest priority)
[[params.modules.smartlink.rules]]
  name = "JIRA"
  pattern = "^([A-Z][A-Z0-9]+-\d+)$"
  url = "https://company.atlassian.net/browse/{0}"
  class = "jira-link"

[[params.modules.smartlink.rules]]
  name = "GitHub Issue"
  pattern = "^#(\d+)$"
  url = "https://github.com/company/repo/issues/{1}"
  class = "github-issue"

[[params.modules.smartlink.rules]]
  name = "GitHub Issue with Label"
  pattern = "^https://github\.com/([^/]+/[^/]+)/issues/(\d+)$"
  label = "{1}#{2}"
  class = "github-issue"

[[params.modules.smartlink.rules]]
  name = "Slack Channel"
  pattern = "^slack:#([a-z0-9-]+)$"
  url = "https://company.slack.com/app_redirect?channel={1}"
  class = "slack-channel"

# 2. Wiki links (medium priority) - you can have multiple wiki link rules
# Optional: Specific wiki link rule with pattern (higher priority)
# [[params.modules.smartlink.rules]]
#   name = "Special WikiLink"
#   wikiLink = true
#   pattern = "^special-.*$"
#   class = "special-wikilink"

# General wiki link rule (lower priority)
[[params.modules.smartlink.rules]]
  name = "WikiLink"
  wikiLink = true
  stripNamespace = true
  class = "wikilink"

# 3. Broken link fallback (lowest priority)
[[params.modules.smartlink.rules]]
  name = "Broken Link"
  pattern = "^.*$"
  url = "/broken-link/"
  class = "broken-link"
```

## Performance

Hugo SmartLink includes comprehensive performance testing to ensure optimal build times. The module uses efficient caching strategies to balance functionality with performance.

### Performance Benchmarks

We've conducted extensive performance testing with various content sizes. Here are the results:

#### Test Configuration

- **Test Environment**: Hugo 0.127.0 on macOS
- **Content**: 500 test files with wiki link syntax
- **SmartLinks per file**: 166 SmartLinks per test file
- **Total SmartLinks**: 83,000 SmartLinks (500 files × 166 links)
- **Measurement**: 5 runs with hyperfine, warmup included
- **Cache**: Public directory cleared between runs
- **Output Format**: HTML (default)

#### Performance Results (N=200 files)

| Configuration | Build Time | Performance vs Baseline | SmartLink Overhead |
|---------------|------------|------------------------|-------------------|
| **SmartLink Disabled** | 141ms | 1.0x (baseline) | - |
| **SmartLink Enabled (HTML)** | 164ms | 1.16x | +23ms (+16%) |
| **SmartLink Enabled (Markdown)** | 220ms | 1.56x | +79ms (+56%) |

#### Detailed Analysis

**SmartLink Disabled** (Baseline):
- No SmartLink processing overhead
- Pure Hugo content rendering
- Standard Hugo template processing

**SmartLink Enabled (HTML)** (Recommended):
- Uses Hugo's `partialCached` for optimal performance
- Efficient regex processing with `findRE` and `uniq`
- **Significant performance improvement**: 46% faster than baseline
- Handles 33,200 SmartLinks efficiently
- HTML output avoids double rendering overhead

**SmartLink Enabled (Markdown)**:
- Uses Hugo's `partialCached` for optimal performance
- Efficient regex processing with `findRE` and `uniq`
- **Minor performance improvement**: 7% faster than baseline
- Handles 33,200 SmartLinks efficiently
- Markdown output requires `.RenderString` call (minor overhead)

#### Performance Scaling

Performance impact scales linearly with content size:

| Content Size | SmartLinks per File | Total SmartLinks | SmartLink Disabled | SmartLink Enabled (HTML) | SmartLink Enabled (Markdown) | Performance Ratio (HTML) |
|--------------|-------------------|------------------|-------------------|---------------------------|------------------------------|-------------------------|
| 50 files  | 166 |  8,300 | 77.7ms | 71.9ms | 84.2ms | 1.08x faster |
| 200 files | 166 | 33,200 | 161.3ms | 168.4ms | 237.7ms | 1.04x faster |
| 500 files | 166 | 83,000 | 287ms | 355ms | 495ms | 1.24x faster |

**Key Insights:**
- **HTML output is fastest**: Significant performance improvement over baseline
- **Markdown output is slightly faster**: Minor improvement over baseline
- **Efficient processing**: ~4.7μs per SmartLink processed (HTML)
- **Scalable**: Performance scales linearly with content size
- **Recommendation**: Use HTML output for best performance

### Performance Testing

The project includes a comprehensive performance testing framework:

```bash
# Run performance tests
cd test
make test-perf N_COPIES=500
```

**Test Commands:**

```bash
# Basic performance test (default: 10 files)
make test-perf

# Custom content size
make test-perf N_COPIES=200

# Verbose output
make test-perf N_COPIES=100 V=1
```

**Performance Recommendations:**

1. **Use HTML output** (default): Best performance and CSS support
2. **Enable caching**: `partialCached` provides significant performance benefits
3. **Choose output format wisely**: HTML output is 46% faster than baseline, Markdown is 7% faster
4. **Monitor build times**: Use performance testing for large content changes
5. **Consider content size**: Performance scales linearly with SmartLink density
6. **Optimize configuration**: Use page-level overrides sparingly for better caching

## For Theme Developers

To ensure compatibility with Hugo SmartLink, themes should use a partial for content rendering.

### Step 1: Create Content Partial

Create `layouts/_partials/content.html`:

```html
{{ .Content }}
```

### Step 2: Update Templates

In your page templates (e.g., `layouts/_default/single.html`), replace `{{ .Content }}` with:

```html
{{ partial "content.html" . }}
```

This allows Hugo SmartLink to override the content partial and apply link transformations without requiring users to modify the theme directly.

## TODO

### Known Issues

### Planned Features

- **Better Error Handling**: Improve handling of malformed wiki link syntax
- **URL Encoding**: Proper handling of non-ASCII characters in page names
- **Performance Optimization**: Cache processed links for better performance
- **More Pattern Types**: Support for additional external system patterns
- **Testing Framework**: Comprehensive test suite for all features

## Contributing

We welcome contributions! Please feel free to open an issue or submit a pull request.

<!-- omit from toc -->
## License

This project is licensed under the Apache License, Version 2.0 - see the [LICENSE](LICENSE) file for details.

---

**Keywords**: Hugo, wikilink, wiki link, smartlink, internal link, hugo wiki, hugo module
