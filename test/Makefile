# SmartLink Test Suite Makefile

.PHONY: help test clean cleanall fresh prepare

# Default test directory
TEST_DIR ?= tmp-test-site/generated

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
	@echo "  help      - Show this help message(default)"
	@echo ""

# Default target
test: prepare
	@./run-tests.sh "$$TEST_DIR"

# Clean test directory
clean:
	@rm -rf $(TEST_DIR)

# Clean all tmp-test-site
cleanall:
	rm -rf tmp-test-site
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