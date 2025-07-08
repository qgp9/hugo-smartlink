# SmartLink Test Suite Makefile

.PHONY: help test clean cleanall fresh prepare

# Default test directory
TEST_DIR ?= tmp-test-site/generated
TMP_SITE_DIR = tmp-test-site
TMP_SITE_DIR_ABS = $(abspath ./$(TMP_SITE_DIR))

# TEST_DIR_ABS will be empty if it's out of the current directory
TEST_DIR_ABS = $(filter $(TMP_SITE_DIR_ABS)/%,$(abspath $(TEST_DIR)))

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
	@echo ""

# Default target
test: prepare
	@./run-tests.sh "$$TEST_DIR"

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
	@./prepare-test-site.sh "$$TEST_DIR"
	@./prepare-test.sh "$$TEST_DIR"

# Show help
.DEFAULT_GOAL := help