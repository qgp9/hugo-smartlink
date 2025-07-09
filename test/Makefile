# SmartLink Test Suite Makefile

.PHONY: help test clean cleanall fresh prepare

# Default test directory
export TEST_DIR ?= tmp-test-site/generated
export TMP_SITE_DIR = tmp-test-site
export TMP_SITE_DIR_ABS = $(abspath ./$(TMP_SITE_DIR))

PERF_RESULT_DIR = tmp-test-site/perf-result
PERF_RESULT_DIR_ABS = $(abspath $(PERF_RESULT_DIR))

# SmartLink directory (absolute path)
SMARTLINK_DIR = $(realpath ..)

export VERBOSE = $(V)
# TEST_DIR_ABS will be empty if it's out of the current directory
export TEST_DIR_ABS = $(filter $(TMP_SITE_DIR_ABS)/%,$(abspath $(TEST_DIR)))

# Hugo module replacement (global)
export HUGO_MODULE_REPLACEMENTS = github.com/qgp9/hugo-smartlink -> $(SMARTLINK_DIR)

# Exit with error if TEST_DIR_ABS is empty
ifeq ($(TEST_DIR_ABS),)
$(error TEST_DIR_ABS is empty. TEST_DIR must be a subdirectory of the $(TMP_SITE_DIR_ABS). TEST_DIR=$(TEST_DIR))
endif

# Default target
help:
	@echo "SmartLink Test Suite"
	@echo "==================="
	@echo ""
	@echo "Available targets:"
	@echo "  test      - Run tests [TEST_DIR=$(TEST_DIR)]"
	@echo "  prepare-perf - Prepare performance test files [N_COPIES=10]"
	@echo "  build     - Build Hugo site only (for manual hyperfine testing)"
	@echo "  test-perf - Run performance test with hyperfine"
	@echo "  clean     - Remove $(TEST_DIR) directory"
	@echo "  cleanall  - Remove tmp-test-site directory"
	@echo "  fresh     - Clean and run tests"
	@echo "  prepare   - Prepare test site structure only"
	@echo "  help      - Show this help message (default)"
	@echo ""
	@echo "Environment variables:"
	@echo "  TEST_DIR  - Test directory path (default: $(TEST_DIR))"
	@echo "              Must be a subdirectory of ./$(TMP_SITE_DIR)/"
	@echo "              Examples: ./$(TMP_SITE_DIR)/generated, ./$(TMP_SITE_DIR)/my-test"
	@echo "  V         - Verbose mode (V=1 for verbose output, default: 0)"
	@echo "  N_COPIES  - Number of test file copies for performance test (default: 10)"
	@echo ""

# Default target
test: prepare
	./scripts/run-tests.sh "$$TEST_DIR" "$$VERBOSE"

# Performance test: prepare only
prepare-perf: prepare
	@echo "Preparing performance test files..."
	bash ./scripts/prepare-performance-test.sh "$(TEST_DIR_ABS)/content/performance" "$(N_COPIES)"

# Build only (for manual testing with hyperfine)
build: prepare
	@echo "Building Hugo site..."
	cd $(TEST_DIR_ABS) && \
	HUGO_MODULE_REPLACEMENTS="$(HUGO_MODULE_REPLACEMENTS)" \
	hugo --config config-html.toml $(if $(VERBOSE),, --quiet)

# Performance test with hyperfine
test-perf: cleanall
	@$(MAKE) prepare-perf
	@$(MAKE) prepare
	@echo "Running performance test with hyperfine..."
	@echo "Testing SmartLink: fully-disabled vs shortcode-disabled vs no-cache vs with-cache..."
	@mkdir -p $(PERF_RESULT_DIR)
	@mkdir -p $(TEST_DIR_ABS)/layouts/_shortcodes
	@mkdir -p $(TEST_DIR_ABS)/layouts/_partials
	hyperfine \
		--warmup 1 \
		--runs 5 \
		--prepare 'rm -rf $(TEST_DIR_ABS)/public' \
		--export-json $(PERF_RESULT_DIR_ABS)/hyperfine-results.json \
		--export-markdown $(PERF_RESULT_DIR_ABS)/hyperfine-results.md \
		--command-name "Fully Disabled" \
		--command-name "Shortcode Disabled" \
		--command-name "No Cache" \
		--command-name "With Cache" \
		'cp test-files/test-layouts/_shortcodes/smartlink-disabled.html $(TEST_DIR_ABS)/layouts/_shortcodes/smartlink.html && cp test-files/test-layouts/_partials/content-disabled.html $(TEST_DIR_ABS)/layouts/_partials/content.html && cd $(TEST_DIR_ABS) && HUGO_MODULE_REPLACEMENTS="$(HUGO_MODULE_REPLACEMENTS)" hugo --config config-html.toml --quiet' \
		'cp test-files/test-layouts/_shortcodes/smartlink-disabled.html $(TEST_DIR_ABS)/layouts/_shortcodes/smartlink.html && cp test-files/test-layouts/_partials/content-shortcode-disabled.html $(TEST_DIR_ABS)/layouts/_partials/content.html && cd $(TEST_DIR_ABS) && HUGO_MODULE_REPLACEMENTS="$(HUGO_MODULE_REPLACEMENTS)" hugo --config config-html.toml --quiet' \
		'cp test-files/test-layouts/_shortcodes/smartlink-no-cache.html $(TEST_DIR_ABS)/layouts/_shortcodes/smartlink.html && cp $(SMARTLINK_DIR)/layouts/_partials/content-smartlink.html $(TEST_DIR_ABS)/layouts/_partials/content.html && cd $(TEST_DIR_ABS) && HUGO_MODULE_REPLACEMENTS="$(HUGO_MODULE_REPLACEMENTS)" hugo --config config-html.toml --quiet' \
		'cp $(SMARTLINK_DIR)/layouts/_shortcodes/smartlink.html $(TEST_DIR_ABS)/layouts/_shortcodes/smartlink.html && cp $(SMARTLINK_DIR)/layouts/_partials/content-smartlink.html $(TEST_DIR_ABS)/layouts/_partials/content.html && cd $(TEST_DIR_ABS) && HUGO_MODULE_REPLACEMENTS="$(HUGO_MODULE_REPLACEMENTS)" hugo --config config-html.toml --quiet'
	@echo "Results saved to $(PERF_RESULT_DIR)/hyperfine-results.json and .md"



# Clean test directory
clean:
	rm -rf $(TEST_DIR_ABS)

# Clean all tmp-test-site
cleanall:
	rm -rf $(TMP_SITE_DIR_ABS)
	@echo "Removed tmp-test-site directory."

# Fresh run (clean + test)
fresh:
	$(MAKE) clean
	$(MAKE) test

# Prepare test site structure only
prepare:
	@./scripts/prepare-test-site.sh "$$TEST_DIR"
	@./scripts/prepare-test.sh "$$TEST_DIR"

# Show help
.DEFAULT_GOAL := help