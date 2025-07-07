# hugo-smartlink

A Hugo module that provides smart link functionality for Hugo sites. This module automatically converts `[[link]]` syntax into proper HTML links based on configurable patterns and rules.

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

```markdown
# My Documentation

Here are some examples of smart links:

- [[Getting Started#installation]] - Links to a section in "Getting Started" page
- [[TIL-1309]] - Links to a JIRA ticket
- [[TIL-1309#215234]] - Links to a specific JIRA comment
- [[-/About]] - Links to the About page (with namespace stripping)
- [[/Portal]] - Links to the Portal page
```

## Configuration Options

### Link Rule Properties

Each link rule in `smartWikiLinks` can have the following properties:

- **`name`**: A descriptive name for the rule
- **`pattern`**: Regex pattern to match links (optional for wiki links)
- **`url`**: URL template with placeholders like `{0}`, `{1}`, etc.
- **`label`**: Label template for the link text
- **`class`**: CSS classes to apply to the link (only used when `output: html`)
- **`wikiLink`**: Set to `true` for internal wiki-style links
- **`stripNamespace`**: Set to `true` to strip namespace prefixes (like `-`)

### Pattern Matching

- `{0}`: The entire matched string
- `{1}`, `{2}`, etc.: Captured groups from the regex pattern
- Use `{0}` for the full match or numbered groups for specific parts

## Examples

| Source | Rule | Output |
|:-------|:----:|:------:|
| `[[TIL-1309]]` | JIRA | `[TIL-1309](https://example.com/browse/TIL-1309)` |
| `[[TIL-1309#215234]]` | JIRA Comment | `[TIL-1309#215234](https://example.com/browse/TIL-1309?focusedId=215234#comment-215234)` |
| `[[TIL-1309#215234 \| myJira]]` | JIRA Comment | `[myJira](https://example.com/browse/TIL-1309?focusedId=215234#comment-215234)` |
| `[[Getting Started#installation]]` | WikiLink | `[Getting Started#installation](getting-started#installation)` |
| `[[-/About]]` | WikiLink | `[About](/about)` |

### HTML Output Examples

When using `output: html`, the same links generate HTML `<a>` tags with classes:

```html
<!-- [[TIL-1309]] with class: external jira-link -->
<a href="https://example.com/browse/TIL-1309" class="external jira-link">TIL-1309</a>

<!-- [[-/About]] with class: wikilink -->
<a href="/about" class="wikilink">About</a>
```

## Advanced Usage

### Custom Link Labels

You can specify custom labels using the pipe syntax:

```markdown
[[TIL-1309|Custom JIRA Link]]
```

This will use "Custom JIRA Link" as the link text instead of the default.

### Namespace Handling

For wiki links with namespaces:

```markdown
[[-/About]]  # Links to /about with label "About"
[[/About]]   # Links to /about with label "/About"
```

### Fallback Links

Configure a default rule to handle unmatched links:

```yaml
- name: "default"
  pattern: "^.*$"
  url: "/broken-link/"
  class: "broken-link"
```

## How It Works

1. **Content Processing**: The module processes your content and looks for `[[link]]` patterns
2. **Pattern Matching**: Each link is matched against configured patterns in order
3. **Link Generation**: Based on the matched rule, it generates the appropriate HTML link
4. **Caching**: Links are cached for performance

## File Structure

```text
hugo-smartlink/
├── go.mod                    # Go module definition
├── layouts/
│   ├── _partials/
│   │   ├── content.html      # Main content template
│   │   ├── content-smartlink.html  # Smart link processing
│   │   └── smartlink.html    # Link generation logic
│   └── _shortcodes/
│       └── smartlink.html    # Shortcode for manual link generation
├── LICENSE                   # License file
└── README.md                # This file
```

## Requirements

- Hugo 0.80.0 or later
- Go 1.16 or later

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please open an issue on the GitHub repository.
