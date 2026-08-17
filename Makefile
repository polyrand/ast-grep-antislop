SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

UTC_ISO_DATE = $(shell date -u +"%Y-%m-%d%Z")
UTC_ISO_TIME = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
RULES_ARCHIVE = ast-grep-antislop.tar.gz
ARCHIVE_FILES = \
	sgconfig.yml \
	rules/no_boolean_behaviour_parameter.yml \
	rules/no_chained_type_assertions.yml \
	rules/no_complex_boolean_condition.yml \
	rules/no_conditional_empty_object_spread.yml \
	rules/no_discarded_validator_result.yml \
	rules/no_known_value_widening.yml \
	rules/no_module_mocking.yml \
	rules/no_nested_callback.yml \
	rules/no_object_parameters.yml \
	rules/no_raw_deserializer_return.yml \
	rules/no_reflect_apply.yml \
	rules/no_reflect_get.yml \
	rules/no_runtime_typeof.yml \
	rules/no_shape_in_symbol_names.yml \
	rules/no_single_use_functions_same_file.yml \
	rules/no_unknown_parameters.yml \
	rules/no_unknown_returns.yml \
	rules/no_unknown_type_aliases.yml \
	rules/no_unsafe_dictionary_type.yml \
	rules/no_widen_then_assert.yml \
	rules/require_safety_comment_for_type_assertion.yml

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
	for rule_file in rules/*.yml; do \
		rule_name="$${rule_file##*/}"; \
		rule_name="$${rule_name%.yml}"; \
		sample_file="test_samples/$${rule_name}.$(2)"; \
		if [[ ! -f "$${sample_file}" ]]; then \
			continue; \
		fi; \
		result="$$(ast-grep scan --rule "$${rule_file}" --json=compact "$${sample_file}")"; \
		if [[ "$${result}" == "[]" ]]; then \
			echo "FAIL $(1): $${rule_name} did not match $${sample_file}"; \
			exit 1; \
		fi; \
		count=$$((count + 1)); \
	done; \
	echo "PASS $(1): $${count} rules matched their samples"
endef

.PHONY: rules-archive
rules-archive: $(RULES_ARCHIVE) ## Create the downloadable ast-grep rules archive.

$(RULES_ARCHIVE): $(ARCHIVE_FILES)
	COPYFILE_DISABLE=1 tar -czf "$@" $(ARCHIVE_FILES)

.PHONY: test test-javascript test-typescript test-python test-single-use-functions-same-file test-no-boolean-behaviour-parameter test-no-discarded-validator-result test-no-complex-boolean-condition test-no-raw-deserializer-return test-no-nested-callback
test: test-javascript test-typescript test-python test-single-use-functions-same-file test-no-boolean-behaviour-parameter test-no-discarded-validator-result test-no-complex-boolean-condition test-no-raw-deserializer-return test-no-nested-callback ## Verify every rule against its same-named language sample.

test-javascript: ## Verify all JavaScript rules.
	$(call run_rule_tests,javascript,js)

test-typescript: ## Verify all TypeScript rules.
	$(call run_rule_tests,typescript,ts)

test-python: ## Verify all Python rules.
	$(call run_rule_tests,python,py)

test-single-use-functions-same-file: ## Verify exact same-file direct-call counting.
	@for extension in js ts py; do \
		positive_sample="test_samples/no_single_use_functions_same_file.$${extension}"; \
		valid_sample="test_samples/valid/no_single_use_functions_same_file.$${extension}"; \
		positive_count="$$(ast-grep scan \
			--rule rules/no_single_use_functions_same_file.yml \
			--json=stream "$${positive_sample}" | awk 'END { print NR }')"; \
		if [[ "$${positive_count}" -ne 1 ]]; then \
			echo "FAIL single-use-functions-same-file: expected 1 warning for $${positive_sample}, got $${positive_count}"; \
			exit 1; \
		fi; \
		valid_result="$$(ast-grep scan \
			--rule rules/no_single_use_functions_same_file.yml \
			--json=compact "$${valid_sample}")"; \
		if [[ "$${valid_result}" != "[]" ]]; then \
			echo "FAIL single-use-functions-same-file: unexpected warning for $${valid_sample}"; \
			exit 1; \
		fi; \
	done; \
	echo "PASS single-use-functions-same-file: exactly one direct call matched per language; zero-call, reused, and recursive functions were ignored"

test-no-boolean-behaviour-parameter: ## Verify boolean behaviour parameter warnings and valid cases.
	@for extension in js ts py; do \
		positive_sample="test_samples/no_boolean_behaviour_parameter.$${extension}"; \
		valid_sample="test_samples/valid/no_boolean_behaviour_parameter.$${extension}"; \
		positive_count="$$(ast-grep scan \
			--rule rules/no_boolean_behaviour_parameter.yml \
			--json=stream "$${positive_sample}" | awk 'END { print NR }')"; \
		if [[ "$${positive_count}" -ne 1 ]]; then \
			echo "FAIL no-boolean-behaviour-parameter: expected 1 warning for $${positive_sample}, got $${positive_count}"; \
			exit 1; \
		fi; \
		valid_result="$$(ast-grep scan \
			--rule rules/no_boolean_behaviour_parameter.yml \
			--json=compact "$${valid_sample}")"; \
		if [[ "$${valid_result}" != "[]" ]]; then \
			echo "FAIL no-boolean-behaviour-parameter: unexpected warning for $${valid_sample}"; \
			exit 1; \
		fi; \
		done; \
	echo "PASS no-boolean-behaviour-parameter: one warning per language; data boolean parameters ignored"

test-no-discarded-validator-result: ## Verify discarded validator result warnings and valid cases.
	@for extension in js ts py; do \
		positive_sample="test_samples/no_discarded_validator_result.$${extension}"; \
		valid_sample="test_samples/valid/no_discarded_validator_result.$${extension}"; \
		positive_count="$$(ast-grep scan \
			--rule rules/no_discarded_validator_result.yml \
			--json=stream "$${positive_sample}" | awk 'END { print NR }')"; \
		if [[ "$${positive_count}" -ne 1 ]]; then \
			echo "FAIL no-discarded-validator-result: expected 1 warning for $${positive_sample}, got $${positive_count}"; \
			exit 1; \
		fi; \
		valid_result="$$(ast-grep scan \
			--rule rules/no_discarded_validator_result.yml \
			--json=compact "$${valid_sample}")"; \
		if [[ "$${valid_result}" != "[]" ]]; then \
			echo "FAIL no-discarded-validator-result: unexpected warning for $${valid_sample}"; \
			exit 1; \
		fi; \
	done; \
	echo "PASS no-discarded-validator-result: one warning per language; consumed results ignored"

test-no-complex-boolean-condition: ## Verify complex boolean condition warnings and valid cases.
	@for extension in js ts py; do \
		positive_sample="test_samples/no_complex_boolean_condition.$${extension}"; \
		valid_sample="test_samples/valid/no_complex_boolean_condition.$${extension}"; \
		positive_count="$$(ast-grep scan \
			--rule rules/no_complex_boolean_condition.yml \
			--json=stream "$${positive_sample}" | awk 'END { print NR }')"; \
		if [[ "$${positive_count}" -ne 1 ]]; then \
			echo "FAIL no-complex-boolean-condition: expected 1 warning for $${positive_sample}, got $${positive_count}"; \
			exit 1; \
		fi; \
		valid_result="$$(ast-grep scan \
			--rule rules/no_complex_boolean_condition.yml \
			--json=compact "$${valid_sample}")"; \
		if [[ "$${valid_result}" != "[]" ]]; then \
			echo "FAIL no-complex-boolean-condition: unexpected warning for $${valid_sample}"; \
			exit 1; \
		fi; \
	done; \
	echo "PASS no-complex-boolean-condition: one warning per language; named parts and split branches ignored"

test-no-raw-deserializer-return: ## Verify raw deserializer return warnings and valid cases.
	@for extension in js ts py; do \
		positive_sample="test_samples/no_raw_deserializer_return.$${extension}"; \
		valid_sample="test_samples/valid/no_raw_deserializer_return.$${extension}"; \
		positive_count="$$(ast-grep scan \
			--rule rules/no_raw_deserializer_return.yml \
			--json=stream "$${positive_sample}" | awk 'END { print NR }')"; \
		if [[ "$${positive_count}" -ne 1 ]]; then \
			echo "FAIL no-raw-deserializer-return: expected 1 warning for $${positive_sample}, got $${positive_count}"; \
			exit 1; \
		fi; \
		valid_result="$$(ast-grep scan \
			--rule rules/no_raw_deserializer_return.yml \
			--json=compact "$${valid_sample}")"; \
		if [[ "$${valid_result}" != "[]" ]]; then \
			echo "FAIL no-raw-deserializer-return: unexpected warning for $${valid_sample}"; \
			exit 1; \
		fi; \
	done; \
	echo "PASS no-raw-deserializer-return: one warning per language; domain parsing before return ignored"

test-no-nested-callback: ## Verify nested Python function warnings.
	@positive_sample="test_samples/no_nested_callback.py"; \
	positive_count="$$(ast-grep scan \
		--rule rules/no_nested_callback.yml \
		--json=stream "$${positive_sample}" | awk 'END { print NR }')"; \
	if [[ "$${positive_count}" -ne 3 ]]; then \
		echo "FAIL no-nested-callback: expected 3 warnings for $${positive_sample}, got $${positive_count}"; \
		exit 1; \
	fi; \
	echo "PASS no-nested-callback: nested defs and lambdas reviewed, including local helpers"


.PHONY: gl
gl: ## Push to local repo
	@if ! git remote get-url local >/dev/null 2>&1; then echo "Skipping gl: no 'local' remote found."; exit 1; fi
	git add .
	-git commit -m "Update"
	git push local main
