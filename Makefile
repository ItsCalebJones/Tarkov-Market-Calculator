VERSION := $(shell jq -r '.version' package.json)

.PHONY: install
install: ## Install the npm environment
	@echo "🚀 Install the npm environment"
	@npm run install
	@npm run husky

.PHONY: dev
dev:  ## Build production dist
	@echo "🚀 Running application locally"
	@npm run dev

.PHONY: build
build: clean-build ## Build production dist
	@echo "🚀 Building production distributable"
	@npm run build

.PHONY: docker-build
docker-build: clean-build ## Build production dist
	@echo "🚀 Building Docker Image distributable for tarkov-market-calculator:$(VERSION) 🚀"
	@docker build . -t tarkov-calculator-react:$(VERSION)

.PHONY: docker-run
docker-run: docker-build ## Build production dist
	@echo "🚀 Building Docker Image distributable for tarkov-market-calculator:$(VERSION) 🚀"
	@docker run -it -p 8080:80 --rm --name tarkov-market-calculator-$(VERSION) tarkov-calculator-react:$(VERSION)

.PHONY: clean-build
clean-build: ## clean build artifacts
	@rm -rf dist/

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
