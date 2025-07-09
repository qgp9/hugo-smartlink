#!/bin/bash

# SmartLink Test Suite
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test directory
TEST_DIR="${1:-tmp-test-site/generated}"
HUGO_MODULE_REPLACEMENTS="github.com/qgp9/hugo-smartlink -> $(readlink -f ..)"

echo "🧪 SmartLink Test Suite"
echo "==========================="

# Test counters
TOTAL_PASSED=0
TOTAL_FAILED=0
MARKDOWN_PASSED=0
MARKDOWN_FAILED=0
HTML_PASSED=0
HTML_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_dir="$2"
    local config_file="$3"
    local verbose="$4"
    local test_dir_abs=$(readlink -f "$test_dir")
    local config_file_abs=$(readlink -f "$config_file")
    local owd=$(pwd)
    
    echo -e "${YELLOW}Testing: $test_name${NC}"
    
    # Set module replacement before cd
    QUIET="--quiet"
    if [ "$verbose" = "1" ]; then
        QUIET=""
        set -x
    fi
    cd "$test_dir_abs"
    HUGO_MODULE_REPLACEMENTS="$HUGO_MODULE_REPLACEMENTS" hugo build --config "$config_file_abs" $QUIET
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Hugo build failed for $test_name${NC}"
        if [[ "$test_name" == *"Markdown"* ]]; then
            ((MARKDOWN_FAILED++))
        else
            ((HTML_FAILED++))
        fi
        ((TOTAL_FAILED++))
        cd ..
        return 1
    fi
    set +x
    
    # Find the test file
    TEST_FILE="public/docs/test/index.html"
    
    if [ ! -f "$TEST_FILE" ]; then
        echo -e "${RED}❌ Test file not found for $test_name: $TEST_FILE${NC}"
        echo "Available files:"
        find public -name "*.html" | head -5
        if [[ "$test_name" == *"Markdown"* ]]; then
            ((MARKDOWN_FAILED++))
        else
            ((HTML_FAILED++))
        fi
        ((TOTAL_FAILED++))
        cd ..
        return 1
    fi
    
    # Verify SmartLink conversion
    local test_passed=true
    local test_count=0
    local passed_count=0
    local failed_count=0
    local first_two_results=()
    local first_two_statuses=()
    local result_count=0
    
    # Extract lines with ||| pattern and verify each one
    while IFS= read -r line; do
        if [[ "$line" == *"|||"* ]]; then
            # Use sed to split by ||| and extract the parts
            local parts=$(echo "$line" | sed 's/|||/\n/g')
            local part1=$(echo "$parts" | head -1)
            local part2=$(echo "$parts" | head -2 | tail -1)
            local part3=$(echo "$parts" | head -3 | tail -1)
            local part4=$(echo "$parts" | head -4 | tail -1)
            
            if [ -n "$part1" ] && [ -n "$part2" ] && [ -n "$part3" ] && [ -n "$part4" ]; then
                local src_literal="$part1"
                local converted="$part2"
                local should_result="$part3"
                local expected_result="$part4"
                
                # Clean up the parts (remove leading/trailing whitespace)
                converted=$(echo "$converted" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                should_result=$(echo "$should_result" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                expected_result=$(echo "$expected_result" | sed 's/^.*<a/<a/;s/a>.*$/a>/' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                
                # Clean up src_literal: remove <p><code>...</code></p> or <code>...</code> and decode HTML entities
                src_literal_clean=$(echo "$src_literal" | sed -E 's#^.*<code>(.*)</code>.*$#\1#')
                src_literal_clean=$(echo "$src_literal_clean" | sed 's/&lt;/</g; s/&gt;/>/g; s/&quot;/\"/g; s/&amp;/\&/g')
                
                # Remove <code> tags from converted and expected_result
                converted=$(echo "$converted" | sed 's/^<code>//;s/<\/code>$//')
                expected_result=$(echo "$expected_result" | sed 's/^<code>//;s/<\/code>$//')
                
                # Decode HTML entities
                converted=$(echo "$converted" | sed 's/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&amp;/&/g')
                expected_result=$(echo "$expected_result" | sed 's/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&amp;/&/g')
                
                # Remove trailing HTML tags (like </code></p>) from both
                converted=$(echo "$converted" | sed 's#</code></p>##g' | sed 's#</p>##g')
                expected_result=$(echo "$expected_result" | sed 's#</code></p>##g' | sed 's#</p>##g')
                
                # Store first two results for display
                if [ $result_count -lt 2 ]; then
                    first_two_results+=("Test: $src_literal_clean")
                    first_two_results+=("Converted: $converted")
                    first_two_results+=("Expected: $expected_result")
                    first_two_statuses+=("$should_result")
                    first_two_results+=("---")
                fi
                ((result_count++))
                
                # Check if this test should pass based on the should_result
                local should_pass=false
                if [[ "$should_result" == "SHOULD_SUCCESS" ]]; then
                    should_pass=true
                fi
                
                # Compare values directly (href normalization is handled in shortcode)
                if [ "$converted" != "$expected_result" ]; then
                    if [ "$should_pass" = true ]; then
                        echo -e "${RED}❌ Mismatch found (should pass):${NC}"
                        echo "  Test:      $src_literal_clean"
                        echo "  Converted: $converted"
                        echo "  Expected:  $expected_result"
                        test_passed=false
                        ((failed_count++))
                    else
                        # This test is expected to fail, so it's actually a pass
                        ((passed_count++))
                    fi
                else
                    if [ "$should_pass" = true ]; then
                        ((passed_count++))
                    else
                        echo -e "${RED}❌ Test passed when it should fail:${NC}"
                        echo "  Test:      $src_literal_clean"
                        echo "  Converted: $converted"
                        echo "  Expected:  $expected_result"
                        test_passed=false
                        ((failed_count++))
                    fi
                fi
                ((test_count++))
            fi
        fi
    done < "$TEST_FILE"
    
    # Update counters based on test group
    if [[ "$test_name" == *"Markdown"* ]]; then
        ((MARKDOWN_PASSED += passed_count))
        ((MARKDOWN_FAILED += failed_count))
    else
        ((HTML_PASSED += passed_count))
        ((HTML_FAILED += failed_count))
    fi
    
    ((TOTAL_PASSED += passed_count))
    ((TOTAL_FAILED += failed_count))
    
    if [ "$test_passed" = true ]; then
        echo -e "${GREEN}✅ $test_name passed! ($passed_count/$test_count tests)${NC}"
        # Show first two results even when test passes
        if [ ${#first_two_results[@]} -gt 0 ]; then
            echo -e "${BLUE}📋 First 2 test results:${NC}"
            local status_index=0
            for result in "${first_two_results[@]}"; do
                if [[ "$result" == "---" ]]; then
                    echo ""
                    ((status_index++))
                else
                    echo "  $result"
                    # Add status with color after the third line (Expected: ...)
                    if [[ "$result" == "Expected:"* ]] && [ $status_index -lt ${#first_two_statuses[@]} ]; then
                        local status="${first_two_statuses[$status_index]}"
                        if [[ "$status" == "SHOULD_SUCCESS" ]]; then
                            echo -e "  Status: ${GREEN}✅ SHOULD_SUCCESS${NC}"
                        else
                            echo -e "  Status: ${YELLOW}⚠️ SHOULD_FAIL${NC}"
                        fi
                    fi
                fi
            done
        fi
    else
        echo -e "${RED}❌ $test_name failed! ($passed_count/$test_count tests passed)${NC}"
    fi
    
    cd "$owd"
}

# Main execution
main() {
    local verbose="${2:-0}"
    
    echo -e "${BLUE}🚀 Starting SmartLink test suite...${NC}"
    if [ "$verbose" = "1" ]; then
        echo -e "${YELLOW}Verbose mode enabled${NC}"
    fi
    
    echo -e "${BLUE}🔨 Building test sites...${NC}"
    
    # Run tests on $TEST_DIR
    echo -e "${BLUE}📊 Running tests on $TEST_DIR...${NC}"
    run_test "Markdown Output Test" "$TEST_DIR" "$TEST_DIR/config-markdown.toml" "$verbose"
    run_test "HTML Output Test" "$TEST_DIR" "$TEST_DIR/config-html.toml" "$verbose"
    
    echo ""
    echo "📊 Test Results:"
    echo "=================="
    
    # Group results
    local markdown_total=$((MARKDOWN_PASSED + MARKDOWN_FAILED))
    local html_total=$((HTML_PASSED + HTML_FAILED))
    
    if [ $markdown_total -gt 0 ]; then
        if [ $MARKDOWN_FAILED -eq 0 ]; then
            echo -e "${GREEN}✅ Markdown Tests: $MARKDOWN_PASSED/$markdown_total passed${NC}"
        else
            echo -e "${RED}❌ Markdown Tests: $MARKDOWN_PASSED/$markdown_total passed, $MARKDOWN_FAILED failed${NC}"
        fi
    fi
    
    if [ $html_total -gt 0 ]; then
        if [ $HTML_FAILED -eq 0 ]; then
            echo -e "${GREEN}✅ HTML Tests: $HTML_PASSED/$html_total passed${NC}"
        else
            echo -e "${RED}❌ HTML Tests: $HTML_PASSED/$html_total passed, $HTML_FAILED failed${NC}"
        fi
    fi
    
    echo ""
    local total_tests=$((TOTAL_PASSED + TOTAL_FAILED))
    echo -e "${BLUE}📈 Total: $TOTAL_PASSED/$total_tests tests passed${NC}"
    
    if [ $TOTAL_FAILED -eq 0 ]; then
        echo -e "${GREEN}🎉 All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}💥 Some tests failed!${NC}"
        exit 1
    fi
}

# Run main function
main "$@" 