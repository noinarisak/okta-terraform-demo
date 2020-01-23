.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ##  Remove tfstate and tfplan files. WARNING: Make sure 'terraform destroy' has been executed. Manual Okta resources is required.
	@echo "+ $@"
	@find . -type f -name '*.tfstate*' -exec rm -f {} +
	@find . -type f -name '*.tfplan' -exec rm -f {} +