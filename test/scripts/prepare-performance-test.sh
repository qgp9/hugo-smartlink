#!/bin/bash

# Performance test preparation script
# Creates multiple copies of test-content.md for performance testing

set -e
set -u

PERFORMANCE_CONTENT_DIR=$1
N_COPIES=$2

# Source test-content.md (고정 경로)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_MD="$SCRIPT_DIR/../test-files/test-content.md"

# Create target directory
mkdir -p "$PERFORMANCE_CONTENT_DIR"

# Copy test-content.md N times
for i in $(seq 1 $N_COPIES); do
    cp "$SRC_MD" "$PERFORMANCE_CONTENT_DIR/test-content-$i.md"
    #echo "Created test-content-$i.md"
done

# TEST_DIR is the Hugo test site root (e.g., tmp-test-site/generated)
TEST_DIR="$(dirname "$(dirname "$PERFORMANCE_CONTENT_DIR")")"

# Create layout directories for different test cases
mkdir -p "$TEST_DIR/layouts-disabled/_partials"
mkdir -p "$TEST_DIR/layouts-disabled/_shortcodes"

# Copy basic content.html for disabled test
cp "$SCRIPT_DIR/../test-files/test-layouts/_partials/content-disabled.html" "$TEST_DIR/layouts-disabled/_partials/content.html"

# Copy single.html template to layouts-disabled
mkdir -p "$TEST_DIR/layouts-disabled/_default" && cp "$TEST_DIR/layouts/_default/single.html" "$TEST_DIR/layouts-disabled/_default/single.html"

# Copy shortcodes for layouts-disabled
cp "$SCRIPT_DIR/../test-files/expected_a.html" "$TEST_DIR/layouts-disabled/_shortcodes/"

# Create config-disabled.toml (SmartLink disabled)
cat > "$TEST_DIR/config-disabled.toml" << 'EOF'
baseURL = "http://example.com/"
languageCode = "en-us"
title = "SmartLink Test Site"

# No module imports - SmartLink disabled
EOF

echo "Performance test files prepared in $PERFORMANCE_CONTENT_DIR"
echo "Total files created: $N_COPIES"
echo "Using existing config files: config-disabled.toml, config-html.toml, config-markdown.toml" 
