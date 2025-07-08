#!/usr/bin/env bash

# SmartLink Test Content Copier
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TEST_SITE_DIR="${1:-tmp-test-site/generated}"
SOURCE_FILE="./test-files/test-content.md"

main() {
    echo "📋 Copying test content to test site..."
    
    # Create directory if it doesn't exist
    mkdir -p "$TEST_SITE_DIR/content/docs/test"
    
    # Copy the test content file to single test directory
    cp "$SOURCE_FILE" "$TEST_SITE_DIR/content/docs/test/index.md"
    
    echo -e "${GREEN}✅ Test content copied successfully${NC}"
    echo -e "${YELLOW}Files created:${NC}"
    echo "  - $TEST_SITE_DIR/content/docs/test/index.md"
}

main "$@" 