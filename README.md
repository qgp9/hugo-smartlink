<!-- omit from toc -->
# hugo-smartlink

A Hugo module that provides smart link functionality for Hugo sites. This module automatically converts `[[link]]` syntax into proper HTML links based on configurable patterns and rules.

<!-- omit from toc -->
## Table of Contents

- [Features](#features)
- [Install](#install)
- [Configuration](#configuration)
  - [Output Type Configuration](#output-type-configuration)
  - [Prefix Alias Configuration](#prefix-alias-configuration)
- [Usage](#usage)
  - [1. Configure Smart Links](#1-configure-smart-links)
  - [2. Use Smart Links in Content](#2-use-smart-links-in-content)

## Features

- **Wiki Link Detection**: Automatically detects and converts `[[link]]` syntax in content
- **Configurable Patterns**: Support for regex patterns to match different types of links
- **Wiki-style Links**: Built-in support for wiki-style internal links
- **External Link Support**: Configurable external link patterns (JIRA, etc.)
- **Custom Classes**: Add custom CSS classes to generated links
- **Label Customization**: Customize link labels with patterns and replacements

## Install

```bash
hugo mod get github.com/qgp9/hugo-smartlink@latest
```

Add to your `config.yaml` or `config.toml`:

```yaml
module:
  imports:
    - path: github.com/qgp9/hugo-smartlink
```

## Configuration

If your theme does **not** support `_partials/content.html`, you need to import the override and your theme as follows:

```yaml
module:
  imports:
    - path: github.com/qgp9/hugo-smartlink
    - path: github.com/qgp9/hugo-smartlink-theme-override/hextra
    - path: github.com/imfing/hextra
```

> If your theme does not support `_partials/content.html`, you must import the override and your theme as shown above.

### Output Type Configuration

You can configure how smart links are rendered by setting the `output` option:

```yaml
params:
  smartLinkOptions:
    output: markdown   # or html
```

**Output Types:**

- **`markdown`** (default): Generates standard markdown links `[label](url)`
  - ✅ Hugo's link render hooks are applied (external links, security, accessibility)
  - ❌ CSS classes cannot be applied directly
  - Use URL pattern-based CSS selectors for styling

- **`html`**: Generates HTML `<a>` tags `<a href="..." class="...">label</a>`
  - ✅ CSS classes can be applied directly via configuration
  - ❌ Hugo's link render hooks are not applied
  - You need to handle external links, security attributes manually

### Prefix Alias Configuration

You can map namespace prefixes to different paths using `prefixAlias`:

```yaml
params:
  smartLinkOptions:
    output: markdown
    prefixAlias:
      "~": "/doc/"
      "docs:": "/documentation/"
      "api:": "/api-docs/"
```

**Examples:**

- `[[~/About]]` → `[About](/doc/about)`
- `[[docs:Guide]]` → `[Guide](/documentation/guide)`
- `[[api:User]]` → `[User](/api-docs/user)`
- `[[/About]]` → `[About](/about)` (no prefix alias)

## Usage

### 1. Configure Smart Links

Add the `smartWikiLinks` parameter to your Hugo configuration:

```yaml
params:
  smartWikiLinks:
    - name: WikiLink
      wikiLink: true
      stripNamespace: true
      class: wikilink  # Only used when output: html
    - name: JIRA Comment
      pattern: '^([A-Z][A-Z0-9]+-\d+)#(\d+)$'
      url: "https://example.com/browse/{1}?focusedId={2}#comment-{2}"
      class: external jira-link  # Only used when output: html
      label: "Jira:{1}/{2}"
    - name: JIRA
      pattern: '^[A-Z][A-Z0-9]+-\d+$'
      url: "https://example.com/browse/{0}"
      class: external jira-link  # Only used when output: html
    - name: JIRA Link
      pattern: '^https://example.com/browse/(.+?)\?.*?#comment-(\d+)'
      label: "{1}#{2}"
    - name: "default"
      pattern: "^.*$"
      url: "/broken-link/"
      class: "broken-link"  # Only used when output: html
```

### 2. Use Smart Links in Content

Write your content using the `[[link]]` syntax:

```