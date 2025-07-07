<!-- omit from toc -->
# Hugo SmartLink

[![Hugo version](https://img.shields.io/badge/hugo-0.127.0-blue.svg)](https://gohugo.io/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/qgp9/hugo-smartlink/blob/main/LICENSE)

A Hugo module that provides smart link functionality for Hugo sites. This module automatically converts `[[link]]` syntax into proper HTML links based on configurable patterns and rules.

<!-- omit from toc -->
## Features

- 🔗 **Wiki Link Detection**: Automatically detects and converts `[[link]]` syntax
- ⚙️ **Configurable Patterns**: Supports regex patterns to match different types of links
- 🎨 **Customizable Output**: Choose between Markdown or HTML output formats
- 🏷️ **Smart Labels**: Define custom labels and URL patterns
- 📁 **Prefix Aliases**: Map namespace prefixes to different paths
- 🎯 **Theme Compatible**: Works seamlessly with existing Hugo themes

<!-- omit from toc -->
## Table of Contents

- [Installation](#installation)
  - [Step 1: Install the Module](#step-1-install-the-module)
  - [Step 2: Add to Site Configuration](#step-2-add-to-site-configuration)
- [Quick Start](#quick-start)
  - [Zero Configuration](#zero-configuration)
  - [Basic Usage](#basic-usage)
  - [Default Configuration (Reference)](#default-configuration-reference)
- [Configuration](#configuration)
  - [Basic Configuration](#basic-configuration)
  - [Advanced Configuration](#advanced-configuration)
    - [Output Format](#output-format)
    - [Prefix Aliases](#prefix-aliases)
- [Usage Examples](#usage-examples)
  - [Wiki-Style Links](#wiki-style-links)
  - [External System Links](#external-system-links)
  - [With Prefix Aliases](#with-prefix-aliases)
  - [Complex Patterns](#complex-patterns)
- [For Theme Developers](#for-theme-developers)
  - [Step 1: Create Content Partial](#step-1-create-content-partial)
  - [Step 2: Update Templates](#step-2-update-templates)
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

The module works out of the box with default settings. No configuration required!

### Basic Usage

You can immediately use `[[link]]` syntax in your content:

```markdown
# My Documentation

This is a link to [[my-page]] and another to [[about-us]].
```

**Output:**

```html
<p>This is a link to <a href="/my-page">my-page</a> and another to <a href="/about-us">about-us</a>.</p>
```

### Default Configuration (Reference)

If you want to see what the default configuration looks like:

```toml
[params]
# Smart Link Options
[params.smartLinkOptions]
output = "markdown"

# Internal Wiki Link
[[params.smartWikiLinks]]
name = "WikiLink"
wikiLink = true
stripNamespace = true 
class = "wikilink" # Only used when output: html

# Broken Links 
[[params.smartWikiLinks]]
name = "Broken Link"
pattern = "^.*$"
url = "/broken-link/"
class = "broken-link" # Only used when output: html
```

## Configuration

### Basic Configuration

Customize SmartLink behavior with `smartLinkOptions` and `smartWikiLinks` array:

```toml
[params]
  [params.smartLinkOptions]
    output = "markdown"  # "markdown" or "html" - use "html" for CSS classes

  # Define wiki-style links
  [[params.smartWikiLinks]]
    name = "WikiLink"
    wikiLink = true
    stripNamespace = true  # Remove namespace prefix from display text
    class = "wikilink"  # Only used when output: html

  # Define custom patterns
  [[params.smartWikiLinks]]
    name = "JIRA"
    pattern = "^([A-Z][A-Z0-9]+-\\d+)$"
    url = "https://example.com/browse/{0}"
    class = "jira-link"

  [[params.smartWikiLinks]]
    name = "GitHub Issue"
    pattern = "^#(\\d+)$"
    url = "https://github.com/owner/repo/issues/{1}"
    class = "github-issue"

  [[params.smartWikiLinks]]
    name = "GitHub Issue with Label"
    pattern = "^https://github\\.com/([^/]+/[^/]+)/issues/(\\d+)$"
    label = "{1}#{2}"
    class = "github-issue"
```

**Examples:**

**WikiLink Rule:**

- Input: `[[my-page]]`
  - Markdown: `[my-page](/my-page)`
  - HTML: `<a href="/my-page" class="wikilink">my-page</a>`

- Input: `[[docs/guide]]`
  - Markdown: `[guide](/docs/guide)`
  - HTML: `<a href="/docs/guide" class="wikilink">guide</a>`
  - Note: stripNamespace removes path prefix

**JIRA Rule:**

- Input: `[[PROJ-123]]`
  - Markdown: `[PROJ-123](https://example.com/browse/PROJ-123)`
  - HTML: `<a href="https://example.com/browse/PROJ-123" class="jira-link">PROJ-123</a>`

**GitHub Issue Rule:**

- Input: `[[#42]]`
  - Markdown: `[#42](https://github.com/owner/repo/issues/42)`
  - HTML: `<a href="https://github.com/owner/repo/issues/42" class="github-issue">#42</a>`

**GitHub Issue with Label Rule:**

- Input: `[[https://github.com/company/repo/issues/123]]`
  - Markdown: `[company/repo#123](https://github.com/company/repo/issues/123)`
  - HTML: `<a href="https://github.com/company/repo/issues/123" class="github-issue">company/repo#123</a>`

### Advanced Configuration

#### Output Format

Control how links are generated:

```toml
[params]
  [params.smartLinkOptions]
    output = "html"  # or "markdown" (default)
```

| Format | Pros | Cons |
|--------|------|------|
| **`markdown`** (default) | ✅ Hugo's link render hooks applied<br>✅ Standard Markdown output | ❌ CSS classes cannot be applied directly |
| **`html`** | ✅ CSS classes can be applied directly<br>✅ More control over styling | ❌ Hugo's link render hooks not applied |

#### Prefix Aliases

Map namespace prefixes to different paths:

```toml
[params]
  [params.smartLinkOptions]
    [params.smartLinkOptions.prefixAlias]
      "~" = "/doc/"
      "docs:" = "/documentation/"
```

**Examples:**

- `[[~/About]]` → `[About](/doc/about)`
- `[[docs:Guide]]` → `[Guide](/documentation/guide)`

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
# Configuration for multiple systems
[[params.smartWikiLinks]]
  name = "JIRA"
  pattern = "^([A-Z][A-Z0-9]+-\\d+)$"
  url = "https://company.atlassian.net/browse/{0}"
  class = "jira-link"

[[params.smartWikiLinks]]
  name = "GitHub Issue"
  pattern = "^#(\\d+)$"
  url = "https://github.com/company/repo/issues/{1}"
  class = "github-issue"

[[params.smartWikiLinks]]
  name = "GitHub Issue with Label"
  pattern = "^https://github\\.com/([^/]+/[^/]+)/issues/(\\d+)$"
  label = "{1}#{2}"
  class = "github-issue"

[[params.smartWikiLinks]]
  name = "Slack Channel"
  pattern = "^slack:#([a-z0-9-]+)$"
  url = "https://company.slack.com/app_redirect?channel={1}"
  class = "slack-channel"
```

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

## Contributing

We welcome contributions! Please feel free to open an issue or submit a pull request.

<!-- omit from toc -->
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
