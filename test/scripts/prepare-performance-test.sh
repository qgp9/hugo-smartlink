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
    echo "Created test-content-$i.md"
done

echo "Performance test files prepared in $PERFORMANCE_CONTENT_DIR"
echo "Total files created: $N_COPIES" 