
.ONESHELL:
.SHELL := /usr/bin/bash
.DEFAULT_GOAL := help

ROOT_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
# DEMO_FOLDERS_VERTICALS := example_simple example_output_file example_multi_environment_with_workspace
DEMO_FOLDERS_VERTICALS := example_simple example_output_file
DEMO_FOLDERS_TARGET := example_simple

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: clean-tfstate
clean-tfstate: validate-tfstate ## Remove terraform assoicated files. ie. *.tfstate, *.tfplan, etc
	@echo "+ $@"
	@find ${PWD} -type f -name '*.tfstate*' -exec rm -f {} +
	@find ${PWD} -type f -name '*.tfplan*' -exec rm -f {} +
	@find ${PWD} -type f -name '*.terraform.lock.hcl*' -exec rm -f {} +

.PHONY: clean-all
clean-all: clean-tfstate ## Remove .terraform local cache directory. Really start fresh!
	@echo "+ $@"
	@find ${PWD} -type d -name '.terraform' -exec rm -rf {} +

.PHONY: validate
validate: format ## Validate HCL script files
	@echo "+ $@"
	@echo "Looping through verticals: "
	for veriticals in ${DEMO_FOLDERS_VERTICALS}; do \
		pushd $$veriticals; \
		echo "###"; \
		echo "#Validating: ${PWD}"; \
		echo "###"; \
		terraform init && terraform validate || exit 1; \
		popd; \
	done

.PHONY: format
format: ## Format HCL script files.
	@echo "+ $@"
	@terraform fmt -recursive

.PHONY: apply
apply: clean-tfstate ## Apply single vertical. default: DEMO_FOLDERS_TARGET=example_simple. !WARNING: Creates a tfstate file!
	@echo "+ $@"
	pushd ${DEMO_FOLDERS_TARGET} || exit 1; \
	terraform -version; \
	terraform init; \
	terraform plan -var-file=${PWD}/${DEMO_FOLDERS_TARGET}/config/okta.tfvars -out=${DEMO_FOLDERS_TARGET}.tfplan || exit 1; \
	terraform apply -auto-approve "${DEMO_FOLDERS_TARGET}.tfplan" || exit 1; \
	terraform destroy -var-file=${PWD}/${DEMO_FOLDERS_TARGET}/config/okta.tfvars -auto-approve || exit 1; \
	popd; \

.PHONY: test
test: clean-tfstate validate ## Run complete terraform init & plan subcommand on all the veriticals.
	@echo "+ $@"
	@echo "Start running through all veriticals: "
	for veriticals in ${DEMO_FOLDERS_VERTICALS}; do \
		pushd $$veriticals; \
		terraform -version; \
		TF_IN_AUTOMATION=1 terraform init; \
		TF_IN_AUTOMATION=1 terraform plan -var-file=${PWD}/$$veriticals/config/okta.tfvars -out=$$veriticals.tfplan || exit 1; \
		popd; \
	done

.PHONY: validate-tfstate
validate-tfstate: ## Validate the default terraform.tfstate file exist. !WARNING: Fagile check.
	@echo "+ $@"
	for veriticals in ${DEMO_FOLDERS_VERTICALS}; do \
		pushd $$veriticals; \
		if [ -f "${PWD}/$$veriticals/terraform.tfstate" ]; then \
			cat ${PWD}/$$veriticals/terraform.tfstate | jq -e '.resources | length == 0' || exit 1; \
		fi; \
		popd; \
	done
