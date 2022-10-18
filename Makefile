.PHONY: clean lint
.PHONY: build-base build-subnets
.PHONY: publish-base publish-subnets

DIST_DIR = $(shell pwd)/dist
ANSIBLE_GALAXY_CMD ?= ansible-galaxy
ANSIBLE_LINT_CMD ?= ansible-lint --profile production --offline

lint: ## Lint all ansible files
	@${ANSIBLE_LINT_CMD} entropygraph

clean: ## Delete all built artifacts
	rm -rf ${DIST_DIR}

build: build-base build-subnets ## Build all collections

build-base: dist ## Build 'base' collection
	@${ANSIBLE_GALAXY_CMD} collection build entropygraph/base --output-path ${DIST_DIR}

build-subnets: dist ## Build 'subnets' collection
	@${ANSIBLE_GALAXY_CMD} collection build entropygraph/subnets --output-path ${DIST_DIR}

publish: publish-base publish-subnets ## Publish all collections

publish-base: ## Publish 'base' collection
	@${ANSIBLE_GALAXY_CMD} collection publish --token $(shell cat ~/.ansible/galaxy_token) dist/entropygraph-base-*.tar.gz || true

publish-subnets: ## Publish 'subnets' collection
	@${ANSIBLE_GALAXY_CMD} collection publish --token $(shell cat ~/.ansible/galaxy_token) dist/entropygraph-subnets-*.tar.gz || true

dist:
	mkdir ${DIST_DIR}

##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
