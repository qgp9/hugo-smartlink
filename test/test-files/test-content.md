---
title: SmartLink Test Content
---

## Basic SmartLink Examples

* `\[[my-page]]` ||| [[my-page]] ||| {{< expected_a href="/my-page" label="my-page" output="markdown" >}}
* `\[[my-page]]` ||| [[my-page]] ||| {{< expected_a href="/my-page" label="my-page" class="wikilink" output="html" >}}

* `\[[about-us]]` ||| [[about-us]] ||| {{< expected_a href="/about-us" label="about-us" output="markdown" >}}
* `\[[about-us]]` ||| [[about-us]] ||| {{< expected_a href="/about-us" label="about-us" class="wikilink" output="html" >}}

* `\[[getting-started]]` ||| [[getting-started]] ||| {{< expected_a href="/getting-started" label="getting-started" output="markdown" >}}
* `\[[getting-started]]` ||| [[getting-started]] ||| {{< expected_a href="/getting-started" label="getting-started" class="wikilink" output="html" >}}

* `\[[api-reference]]` ||| [[api-reference]] ||| {{< expected_a href="/api-reference" label="api-reference" output="markdown" >}}
* `\[[api-reference]]` ||| [[api-reference]] ||| {{< expected_a href="/api-reference" label="api-reference" class="wikilink" output="html" >}}

* `\[[contact-us]]` ||| [[contact-us]] ||| {{< expected_a href="/contact-us" label="contact-us" output="markdown" >}}
* `\[[contact-us]]` ||| [[contact-us]] ||| {{< expected_a href="/contact-us" label="contact-us" class="wikilink" output="html" >}}

## StripNamespace Examples

* `\[[docs/guide]]` ||| [[docs/guide]] ||| {{< expected_a href="/docs/guide" label="guide" output="markdown" >}}
* `\[[docs/guide]]` ||| [[docs/guide]] ||| {{< expected_a href="/docs/guide" label="guide" class="wikilink" output="html" >}}

* `\[[ -docs/guide ]]` ||| [[ -docs/guide ]] ||| {{< expected_a href="/docs/guide" label="guide" output="markdown" >}}
* `\[[ -docs/guide ]]` ||| [[ -docs/guide ]] ||| {{< expected_a href="/docs/guide" label="guide" class="wikilink" output="html" >}}

## Edge Cases

* `\[[simple]]` ||| [[simple]] ||| {{< expected_a href="/simple" label="simple" output="markdown" >}}
* `\[[simple]]` ||| [[simple]] ||| {{< expected_a href="/simple" label="simple" class="wikilink" output="html" >}}

* `\[[abc]]` ||| [[abc]] ||| {{< expected_a href="/abc" label="abc" output="markdown" >}}
* `\[[abc]]` ||| [[abc]] ||| {{< expected_a href="/abc" label="abc" class="wikilink" output="html" >}}

* `\[[def]]` ||| [[def]] ||| {{< expected_a href="/def" label="def" output="markdown" >}}
* `\[[def]]` ||| [[def]] ||| {{< expected_a href="/def" label="def" class="wikilink" output="html" >}}

* `\[[page]]` ||| [[page]] ||| {{< expected_a href="/page" label="page" output="markdown" >}}
* `\[[page]]` ||| [[page]] ||| {{< expected_a href="/page" label="page" class="wikilink" output="html" >}}

## Special Characters

* `\[[test-page]]` ||| [[test-page]] ||| {{< expected_a href="/test-page" label="test-page" output="markdown" >}}
* `\[[test-page]]` ||| [[test-page]] ||| {{< expected_a href="/test-page" label="test-page" class="wikilink" output="html" >}}

* `\[[test_page]]` ||| [[test_page]] ||| {{< expected_a href="/test_page" label="test_page" output="markdown" >}}
* `\[[test_page]]` ||| [[test_page]] ||| {{< expected_a href="/test_page" label="test_page" class="wikilink" output="html" >}}

* `\[[test.page]]` ||| [[test.page]] ||| {{< expected_a href="/test.page" label="test.page" output="markdown" >}}
* `\[[test.page]]` ||| [[test.page]] ||| {{< expected_a href="/test.page" label="test.page" class="wikilink" output="html" >}}

* `\[[test@domain]]` ||| [[test@domain]] ||| {{< expected_a href="/test@domain" label="test@domain" output="markdown" >}}
* `\[[test@domain]]` ||| [[test@domain]] ||| {{< expected_a href="/test@domain" label="test@domain" class="wikilink" output="html" >}} 