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


.PHONY: gl
gl: ## Push to local repo
	@if ! git remote get-url local >/dev/null 2>&1; then echo "Skipping gl: no 'local' remote found."; exit 1; fi
	git add .
	-git commit -m "Update"
	git push local main

