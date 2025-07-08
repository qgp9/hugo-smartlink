---
title: SmartLink Test Content
---

## Basic WikiLink Examples (README.md)

* `\[[my-page]]` ||| [[my-page]] ||| {{< expected_a href="/my-page/" label="my-page" output="markdown" >}}
* `\[[my-page]]` ||| [[my-page]] ||| {{< expected_a href="/my-page/" label="my-page" class="wikilink" output="html" >}}

* `\[[about-us]]` ||| [[about-us]] ||| {{< expected_a href="/about-us/" label="about-us" output="markdown" >}}
* `\[[about-us]]` ||| [[about-us]] ||| {{< expected_a href="/about-us/" label="about-us" class="wikilink" output="html" >}}

* `\[[getting-started]]` ||| [[getting-started]] ||| {{< expected_a href="/getting-started/" label="getting-started" output="markdown" >}}
* `\[[getting-started]]` ||| [[getting-started]] ||| {{< expected_a href="/getting-started/" label="getting-started" class="wikilink" output="html" >}}

* `\[[api-reference]]` ||| [[api-reference]] ||| {{< expected_a href="/api-reference/" label="api-reference" output="markdown" >}}
* `\[[api-reference]]` ||| [[api-reference]] ||| {{< expected_a href="/api-reference/" label="api-reference" class="wikilink" output="html" >}}

* `\[[contact-us]]` ||| [[contact-us]] ||| {{< expected_a href="/contact-us/" label="contact-us" output="markdown" >}}
* `\[[contact-us]]` ||| [[contact-us]] ||| {{< expected_a href="/contact-us/" label="contact-us" class="wikilink" output="html" >}}

## StripNamespace Examples (README.md)

* `\[[docs/guide]]` ||| [[docs/guide]] ||| {{< expected_a href="/docs/guide/" label="guide" output="markdown" >}}
* `\[[docs/guide]]` ||| [[docs/guide]] ||| {{< expected_a href="/docs/guide/" label="guide" class="wikilink" output="html" >}}

* `\[[ -docs/guide ]]` ||| [[ -docs/guide ]] ||| {{< expected_a href="/docs/guide/" label="guide" output="markdown" >}}
* `\[[ -docs/guide ]]` ||| [[ -docs/guide ]] ||| {{< expected_a href="/docs/guide/" label="guide" class="wikilink" output="html" >}}

## Path Variations and Edge Cases

### Basic Paths
* `\[[simple]]` ||| [[simple]] ||| {{< expected_a href="/simple/" label="simple" output="markdown" >}}
* `\[[simple]]` ||| [[simple]] ||| {{< expected_a href="/simple/" label="simple" class="wikilink" output="html" >}}

* `\[[abc]]` ||| [[abc]] ||| {{< expected_a href="/abc/" label="abc" output="markdown" >}}
* `\[[abc]]` ||| [[abc]] ||| {{< expected_a href="/abc/" label="abc" class="wikilink" output="html" >}}

* `\[[def]]` ||| [[def]] ||| {{< expected_a href="/def/" label="def" output="markdown" >}}
* `\[[def]]` ||| [[def]] ||| {{< expected_a href="/def/" label="def" class="wikilink" output="html" >}}

* `\[[page]]` ||| [[page]] ||| {{< expected_a href="/page/" label="page" output="markdown" >}}
* `\[[page]]` ||| [[page]] ||| {{< expected_a href="/page/" label="page" class="wikilink" output="html" >}}

### Subdirectory Paths
* `\[[docs/api/v1]]` ||| [[/docs/api/v1]] ||| {{< expected_a href="/docs/api/v1/" label="v1" output="markdown" >}}
* `\[[docs/api/v1]]` ||| [[/docs/api/v1]] ||| {{< expected_a href="/docs/api/v1/" label="v1" class="wikilink" output="html" >}}

* `\[[docs/guide]]` ||| [[docs/guide]] ||| {{< expected_a href="/docs/guide/" label="guide" output="markdown" >}}
* `\[[docs/guide]]` ||| [[docs/guide]] ||| {{< expected_a href="/docs/guide/" label="guide" class="wikilink" output="html" >}}

### Special Characters in Paths
* `\[[test-page]]` ||| [[test-page]] ||| {{< expected_a href="/test-page/" label="test-page" output="markdown" >}}
* `\[[test-page]]` ||| [[test-page]] ||| {{< expected_a href="/test-page/" label="test-page" class="wikilink" output="html" >}}

* `\[[test_page]]` ||| [[test_page]] ||| {{< expected_a href="/test_page/" label="test_page" output="markdown" >}}
* `\[[test_page]]` ||| [[test_page]] ||| {{< expected_a href="/test_page/" label="test_page" class="wikilink" output="html" >}}

* `\[[test.page]]` ||| [[test.page]] ||| {{< expected_a href="/test.page/" label="test.page" output="markdown" >}}
* `\[[test.page]]` ||| [[test.page]] ||| {{< expected_a href="/test.page/" label="test.page" class="wikilink" output="html" >}}

* `\[[test@domain]]` ||| [[test@domain]] ||| {{< expected_a href="/test@domain/" label="test@domain" output="markdown" >}}
* `\[[test@domain]]` ||| [[test@domain]] ||| {{< expected_a href="/test@domain/" label="test@domain" class="wikilink" output="html" >}}

### Three-Level Paths
* `\[[docs/api/v1]]` ||| [[docs/api/v1]] ||| {{< expected_a href="/docs/api/v1/" label="v1" output="markdown" >}}
* `\[[docs/api/v1]]` ||| [[docs/api/v1]] ||| {{< expected_a href="/docs/api/v1/" label="v1" class="wikilink" output="html" >}}

* `\[[getting-started/guide]]` ||| [[getting-started/guide]] ||| {{< expected_a href="/getting-started/guide/" label="guide" output="markdown" >}}
* `\[[getting-started/guide]]` ||| [[getting-started/guide]] ||| {{< expected_a href="/getting-started/guide/" label="guide" class="wikilink" output="html" >}}

## Custom Pattern Examples (README.md)

### JIRA Pattern
* `\[[PROJ-123]]` ||| [[PROJ-123]] ||| {{< expected_a href="https://example.com/browse/PROJ-123" label="PROJ-123" class="jira-link" output="markdown" >}}
* `\[[PROJ-123]]` ||| [[PROJ-123]] ||| {{< expected_a href="https://example.com/browse/PROJ-123" label="PROJ-123" class="jira-link" output="html" >}}

* `\[[BUG-456]]` ||| [[BUG-456]] ||| {{< expected_a href="https://example.com/browse/BUG-456" label="BUG-456" class="jira-link" output="markdown" >}}
* `\[[BUG-456]]` ||| [[BUG-456]] ||| {{< expected_a href="https://example.com/browse/BUG-456" label="BUG-456" class="jira-link" output="html" >}}

### GitHub Issue Pattern
* `\[[#42]]` ||| [[#42]] ||| {{< expected_a href="https://github.com/owner/repo/issues/42" label="#42" class="github-issue" output="markdown" >}}
* `\[[#42]]` ||| [[#42]] ||| {{< expected_a href="https://github.com/owner/repo/issues/42" label="#42" class="github-issue" output="html" >}}

* `\[[#123]]` ||| [[#123]] ||| {{< expected_a href="https://github.com/owner/repo/issues/123" label="#123" class="github-issue" output="markdown" >}}
* `\[[#123]]` ||| [[#123]] ||| {{< expected_a href="https://github.com/owner/repo/issues/123" label="#123" class="github-issue" output="html" >}}

### GitHub Issue with Label Pattern
* `\[[https://github.com/company/repo/issues/123]]` ||| [[https://github.com/company/repo/issues/123]] ||| {{< expected_a href="https://github.com/company/repo/issues/123" label="company/repo#123" class="github-issue" output="markdown" >}}
* `\[[https://github.com/company/repo/issues/123]]` ||| [[https://github.com/company/repo/issues/123]] ||| {{< expected_a href="https://github.com/company/repo/issues/123" label="company/repo#123" class="github-issue" output="html" >}}

* `\[[https://github.com/owner/project/issues/456]]` ||| [[https://github.com/owner/project/issues/456]] ||| {{< expected_a href="https://github.com/owner/project/issues/456" label="owner/project#456" class="github-issue" output="markdown" >}}
* `\[[https://github.com/owner/project/issues/456]]` ||| [[https://github.com/owner/project/issues/456]] ||| {{< expected_a href="https://github.com/owner/project/issues/456" label="owner/project#456" class="github-issue" output="html" >}}

### Slack Channel Pattern
* `\[[slack:#general]]` ||| [[slack:#general]] ||| {{< expected_a href="https://company.slack.com/app_redirect?channel=general" label="slack:#general" class="slack-channel" output="markdown" >}}
* `\[[slack:#general]]` ||| [[slack:#general]] ||| {{< expected_a href="https://company.slack.com/app_redirect?channel=general" label="slack:#general" class="slack-channel" output="html" >}}

* `\[[slack:#random]]` ||| [[slack:#random]] ||| {{< expected_a href="https://company.slack.com/app_redirect?channel=random" label="slack:#random" class="slack-channel" output="markdown" >}}
* `\[[slack:#random]]` ||| [[slack:#random]] ||| {{< expected_a href="https://company.slack.com/app_redirect?channel=random" label="slack:#random" class="slack-channel" output="html" >}}

## Prefix Alias Examples (README.md)

### Tilde Prefix
* `\[[~/About]]` ||| [[~/About]] ||| {{< expected_a href="/doc/about/" label="About" output="markdown" >}}
* `\[[~/About]]` ||| [[~/About]] ||| {{< expected_a href="/doc/about/" label="About" class="wikilink" output="html" >}}

* `\[[~/installation]]` ||| [[~/installation]] ||| {{< expected_a href="/doc/installation/" label="installation" output="markdown" >}}
* `\[[~/installation]]` ||| [[~/installation]] ||| {{< expected_a href="/doc/installation/" label="installation" class="wikilink" output="html" >}}

### Docs Prefix
* `\[[docs:Guide]]` ||| [[docs:Guide]] ||| {{< expected_a href="/documentation/guide/" label="Guide" output="markdown" >}}
* `\[[docs:Guide]]` ||| [[docs:Guide]] ||| {{< expected_a href="/documentation/guide/" label="Guide" class="wikilink" output="html" >}}

* `\[[docs:troubleshooting]]` ||| [[docs:troubleshooting]] ||| {{< expected_a href="/documentation/troubleshooting/" label="troubleshooting" output="markdown" >}}
* `\[[docs:troubleshooting]]` ||| [[docs:troubleshooting]] ||| {{< expected_a href="/documentation/troubleshooting/" label="troubleshooting" class="wikilink" output="html" >}}

## Edge Cases and Error Handling

### Non-existent Pages (Should use broken link fallback)
* `\[[non-existent-page]]` ||| [[non-existent-page]] ||| {{< expected_a href="/broken-link/" label="non-existent-page" class="broken-link" output="markdown" >}}
* `\[[non-existent-page]]` ||| [[non-existent-page]] ||| {{< expected_a href="/broken-link/" label="non-existent-page" class="broken-link" output="html" >}}

* `\[[missing-docs/guide]]` ||| [[missing-docs/guide]] ||| {{< expected_a href="/broken-link/" label="guide" class="broken-link" output="markdown" >}}
* `\[[missing-docs/guide]]` ||| [[missing-docs/guide]] ||| {{< expected_a href="/broken-link/" label="guide" class="broken-link" output="html" >}}

### Empty or Invalid Links
* `\[[[]]` ||| [[]] ||| {{< expected_a href="/broken-link/" label="" class="broken-link" output="markdown" >}}
* `\[[[]]` ||| [[]] ||| {{< expected_a href="/broken-link/" label="" class="broken-link" output="html" >}}

* `\[[ ]]` ||| [[ ]] ||| {{< expected_a href="/broken-link/" label=" " class="broken-link" output="markdown" >}}
* `\[[ ]]` ||| [[ ]] ||| {{< expected_a href="/broken-link/" label=" " class="broken-link" output="html" >}}

### Special Characters and Unicode
* `\[[test-한글]]` ||| [[test-한글]] ||| {{< expected_a href="/test-한글/" label="test-한글" output="markdown" >}}
* `\[[test-한글]]` ||| [[test-한글]] ||| {{< expected_a href="/test-한글/" label="test-한글" class="wikilink" output="html" >}}

* `\[[test-émojis]]` ||| [[test-émojis]] ||| {{< expected_a href="/test-émojis/" label="test-émojis" output="markdown" >}}
* `\[[test-émojis]]` ||| [[test-émojis]] ||| {{< expected_a href="/test-émojis/" label="test-émojis" class="wikilink" output="html" >}}

### Numbers and Mixed Content
* `\[[page-123]]` ||| [[page-123]] ||| {{< expected_a href="/page-123/" label="page-123" output="markdown" >}}
* `\[[page-123]]` ||| [[page-123]] ||| {{< expected_a href="/page-123/" label="page-123" class="wikilink" output="html" >}}

* `\[[123-page]]` ||| [[123-page]] ||| {{< expected_a href="/123-page/" label="123-page" output="markdown" >}}
* `\[[123-page]]` ||| [[123-page]] ||| {{< expected_a href="/123-page/" label="123-page" class="wikilink" output="html" >}}

## Real-world Usage Examples

### Documentation Links
* `\[[docs/api/v1]]` ||| [[docs/api/v1]] ||| {{< expected_a href="/docs/api/v1/" label="v1" output="markdown" >}}
* `\[[docs/api/v1]]` ||| [[docs/api/v1]] ||| {{< expected_a href="/docs/api/v1/" label="v1" class="wikilink" output="html" >}}

### Project Management Links
* `\[[PROJ-789]]` ||| [[PROJ-789]] ||| {{< expected_a href="https://example.com/browse/PROJ-789" label="PROJ-789" class="jira-link" output="markdown" >}}
* `\[[PROJ-789]]` ||| [[PROJ-789]] ||| {{< expected_a href="https://example.com/browse/PROJ-789" label="PROJ-789" class="jira-link" output="html" >}}

### Communication Links
* `\[[slack:#help]]` ||| [[slack:#help]] ||| {{< expected_a href="https://company.slack.com/app_redirect?channel=help" label="slack:#help" class="slack-channel" output="markdown" >}}
* `\[[slack:#help]]` ||| [[slack:#help]] ||| {{< expected_a href="https://company.slack.com/app_redirect?channel=help" label="slack:#help" class="slack-channel" output="html" >}}
