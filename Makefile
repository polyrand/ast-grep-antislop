SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

UTC_ISO_DATE = $(shell date -u +"%Y-%m-%d%Z")
UTC_ISO_TIME = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

OP_ACCOUNT ?= my.1password.com ## 1Password account.
OP_ACCOUNT := $(strip $(OP_ACCOUNT))

.DEFAULT_GOAL := help
.PHONY: help
help: ## Display available targets and variables.
	@echo "Usage: make [TARGET] [VARIABLE=VALUE]"
	@echo ""
	@echo "Available targets:"
	@# Extract targets defined with 'target: ## Description'
	@grep -E \
		'^[a-zA-Z\.\_$$/%\-]+.*:.*?##\s.*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-38s\033[0m %s\n", $$1, $$2}' | \
		sort
	@echo ""
	@echo "Documented variables:"
	@# Extract variables defined with 'VAR [operator] VALUE ## Description'
	@grep -E \
		'^[a-zA-Z\._]+[ \t]*[:?]?=.*##\s.*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = "[ \t]*[:?]?=.*## "}; {printf "\033[36m%-38s\033[0m %s\n", $$1, $$2}' | \
		sort


define run_rule_tests
	@count=0; \
	for rule_file in rules/$(1)/*.yml; do \
		rule_name="$${rule_file##*/}"; \
		rule_name="$${rule_name%.yml}"; \
		sample_file="test_samples/$${rule_name}.$(2)"; \
		result="$$(ast-grep scan --rule "$${rule_file}" --json=compact "$${sample_file}")"; \
		if [[ "$${result}" == "[]" ]]; then \
			echo "FAIL $(1): $${rule_name} did not match $${sample_file}"; \
			exit 1; \
		fi; \
		count=$$((count + 1)); \
	done; \
	echo "PASS $(1): $${count} rules matched their samples"
endef

.PHONY: test test-javascript test-typescript test-python
test: test-javascript test-typescript test-python ## Verify every rule against its same-named language sample.

test-javascript: ## Verify all JavaScript rules.
	$(call run_rule_tests,javascript,js)

test-typescript: ## Verify all TypeScript rules.
	$(call run_rule_tests,typescript,ts)

test-python: ## Verify all Python rules.
	$(call run_rule_tests,python,py)


.PHONY: gl
gl: ## Push to local repo
	@if ! git remote get-url local >/dev/null 2>&1; then echo "Skipping gl: no 'local' remote found."; exit 1; fi
	git add .
	-git commit -m "Update"
	git push local main
