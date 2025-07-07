# hugo-smartlink

## Install

```bash
hugo mod get github.com/qgp9/hugo-smartlink@latest
```

```yaml
module:
  imports:
    - path: github.com/qgp9/hugo-smartlink
```

## Configuration

```yaml
module:
  imports:
    - path: github.com/qgp9/hugo-smartlink
    - path: github.com/qgp9/hugo-smartlink-theme-override/hextra
    - path: github.com/imfing/hextra
```

## Usage

```yaml



## Example

```yaml
params:
  smartWikiLinks:
    - name: WikiLink
      wikiLink: true
      stripNamespace: true
      class: wikilink
    - name: WikiLink
      wikiLink: true
      stripNamespace: true
      class: wikilink
    - name: JIRA Comment
      pattern: '^([A-Z][A-Z0-9]+-\d+)#(\d+)$'
      url: "https://example.com/browse/{1}?focusedId={2}#comment-{2}"
      class: external jira-link
      label: "Jira:{1}/{2}"
    - name: JIRA
      pattern: '^[A-Z][A-Z0-9]+-\d+$'
      url: "https://example.com/browse/{0}"
      class: external jira-link
    - name: JIRA Link
      pattern: '^https://example.com/browse/(.+?)\?.*?#comment-(\d+)'
      label: "{1}#{2}"
    - name: "default"
      pattern: "^.*$"
      url: "/broken-link/"
      class: "broken-link"
```

| src | name | dst |
|:----|:----:|:----|
| [[TIL-1309]] | JIRA | \[TIL-1309](https://example.com/browser/TIL-1390) |
| [[TIL-1309#215234]] | JIRA Comment | \[TIL-1309#215234](https://example.com/browser/TIL-1390?focusedId=215234#comment-215234) |
| [[TIL-1309#215234 \| myJira]] | JIRA Comment | \[TIL-1309#215234](https://example.com/browser/TIL-1390?focusedId=215234#comment-215234) |
| [[https://example.com/browse/TIL-1390?focusedId=215234#comment-215234]] | JIRA Link | \[TIL-1309#215234](https://example.com/browser/TIL-1390?focusedId=215234#comment-215234) |
| [[Getting Started#installation]] | WikiLink | \[Getting Started#installation](getting-started#installation) |
| [[~/About]] | WikiLink | \[~/About](/about) |
| [[~/Portal]] | WikiLink | \[~/Portal](/portal) |
| [[/About\|/About]] | WikiLink | \[/About](/about) |
| [[/About\|/About]] | WikiLink | \[/About](/about) |
