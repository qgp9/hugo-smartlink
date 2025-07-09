# Hugo SmartLink Test Suite

## Overview

This test suite validates Hugo SmartLink functionality and measures performance across different configurations. It includes functional tests for SmartLink behavior and performance benchmarks comparing various caching strategies.

## Test Structure

### Functional Tests
- **Basic WikiLink Examples**: Tests standard `[[page]]` syntax
- **StripNamespace Examples**: Tests `[[docs/guide]]` → `guide` label extraction
- **Custom Pattern Examples**: Tests JIRA, GitHub issues, Slack channels
- **Prefix Alias Examples**: Tests `[[~/About]]`, `[[docs:Guide]]` patterns
- **Edge Cases**: Tests special characters, Unicode, empty links, broken links

### Performance Tests
Tests 4 different SmartLink configurations:

1. **Fully Disabled**: `{{- .Content -}}` - Hugo default rendering
2. **Shortcode Disabled**: SmartLink processing with original `[[...]]` output
3. **No Cache**: SmartLink processing without caching
4. **With Cache**: SmartLink processing with `partialCached` enabled

## Usage

### Run All Tests

```bash
cd test
make test
```

### Run Performance Tests Only

```bash
# Default test (N=10 copies)
make test-perf

# Custom number of copies
make test-perf N=50

# Large scale test
make test-perf N=100
```

### Prepare Test Site Only

```bash
make prepare
```

### Clean Up

```bash
# Clean test directory
make clean

# Clean all temporary files
make cleanall
```

## Test Files

### Test Content
- `test-files/test-content.md`: Comprehensive test cases with 166 SmartLinks
- `test-files/expected_a.html`: Expected output shortcode for validation

### Test Layouts
- `test-files/test-layouts/_partials/content-disabled.html`: Fully disabled SmartLink
- `test-files/test-layouts/_partials/content-shortcode-disabled.html`: Shortcode disabled
- `test-files/test-layouts/_shortcodes/smartlink-disabled.html`: Disabled shortcode
- `test-files/test-layouts/_shortcodes/smartlink-no-cache.html`: No-cache shortcode

### Scripts
- `scripts/prepare-test-site.sh`: Creates test site structure
- `scripts/prepare-test.sh`: Copies test content to site
- `scripts/prepare-performance-test.sh`: Creates N copies of test content
- `scripts/run-tests.sh`: Executes functional tests

## Performance Results

### N=10 Test Results

| Configuration | Build Time | Performance |
|---------------|------------|-------------|
| Shortcode Disabled | 42.9ms | Fastest |
| Fully Disabled | 45.0ms | -5% |
| No Cache | 49.1ms | -14% |
| With Cache | 51.5ms | -20% |

### N=100 Test Results

| Configuration | Build Time | Performance |
|---------------|------------|-------------|
| Shortcode Disabled | 1.23s | Fastest |
| Fully Disabled | 1.45s | -18% |
| No Cache | 1.78s | -45% |
| With Cache | 1.25s | -2% |

## Test Configuration

### Environment Variables
- `TEST_DIR`: Test directory path (default: `tmp-test-site/generated`)
- `V`: Verbose mode (V=1 for verbose output)
- `N_COPIES`: Number of test file copies for performance tests (default: 10)

### Hugo Configuration
- Uses `config-html.toml` for HTML output testing
- Module replacement: `github.com/qgp9/hugo-smartlink -> /path/to/project`
- Quiet mode for consistent timing measurements

## File Structure

```txt
test/
├── Makefile                           # Test orchestration
├── README.md                          # This file
├── scripts/
│   ├── prepare-test-site.sh          # Site structure setup
│   ├── prepare-test.sh               # Content preparation
│   ├── prepare-performance-test.sh   # Performance test setup
│   └── run-tests.sh                  # Test execution
├── test-files/
│   ├── test-content.md               # Main test content (166 SmartLinks)
│   ├── expected_a.html               # Expected output shortcode
│   └── test-layouts/                 # Test-specific layouts
│       ├── _partials/
│       │   ├── content-disabled.html
│       │   └── content-shortcode-disabled.html
│       └── _shortcodes/
│           ├── smartlink-disabled.html
│           └── smartlink-no-cache.html
└── tmp-test-site/                    # Generated test site
    ├── generated/                     # Test site content
    └── perf-result/                  # Performance test results
```

## Performance Testing Details

### Test Methodology
1. **Preparation**: Creates N copies of test content with 166 SmartLinks each
2. **Benchmarking**: Uses hyperfine for reliable timing measurements
3. **Comparison**: Tests 4 different SmartLink configurations
4. **Results**: Exports JSON and Markdown reports

### Key Findings
- **Shortcode disabled** is fastest (regexp only, no rendering)
- **With cache** shows significant improvement over no-cache for large N
- **Fully disabled** is close to shortcode disabled performance
- **No cache** is slowest due to repeated shortcode processing

### Recommendations
- Use `partialCached` for production sites with many SmartLinks
- Results include warmup runs and multiple iterations
- Test with realistic content sizes (N=50-100) for accurate performance assessment

## Notes

- Performance tests use hyperfine for statistical reliability
- Results include warmup runs and multiple iterations
- Test site is cleaned between runs for consistent results
- All test files are isolated in `test-files/` directory
