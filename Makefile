.DEFAULT_GOAL := help

.PHONY: help dev build build-debug lint lint-fix format format-check \
        test rust-lint rust-format rust-test ci setup clean ports \
        full-check full-write changelog \
        template-check bring-up-to-date bring-up-to-date-all sync-cousins

## Development ---------------------------------------------------------------

help: ## Show this help message
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Development:"
	@echo "  dev            Run tauri dev server"
	@echo "  build          Build for production"
	@echo "  build-debug    Build with debug symbols"
	@echo "  ports          Show auto-assigned port allocations"
	@echo ""
	@echo "Linting & Formatting:"
	@echo "  lint           Run all linters (frontend + Rust)"
	@echo "  lint-fix       Auto-fix lint issues"
	@echo "  format         Format all code"
	@echo "  format-check   Check formatting without changes"
	@echo "  full-check     Run all code checks (lint + format-check)"
	@echo "  full-write     Auto-fix all formatting (frontend + Rust)"
	@echo ""
	@echo "Testing:"
	@echo "  test           Run all tests (frontend + Rust)"
	@echo ""
	@echo "Rust:"
	@echo "  rust-lint      Run cargo clippy"
	@echo "  rust-format    Run cargo fmt"
	@echo "  rust-test      Run cargo test"
	@echo ""
	@echo "CI & Setup:"
	@echo "  ci             Run full CI pipeline (lint, format-check, test, build)"
	@echo "  setup          Install dependencies and git hooks"
	@echo "  clean          Remove build artifacts"
	@echo "  changelog      Generate changelog from conventional commits"
	@echo ""
	@echo "Template:"
	@echo "  template-check       Check template drift against upstream"
	@echo "  bring-up-to-date     Sync with upstream template (dry-run default)"
	@echo "  bring-up-to-date-all Sync all downstream projects (dry-run default)"
	@echo "  sync-cousins         Sync shared layer to cousin templates (dry-run default)"
	@echo ""

dev: ## Run tauri dev server
	pnpm tauri dev

ports: ## Show auto-assigned port allocations
	@scripts/dev-port.sh --all

build: ## Build for production
	pnpm tauri build

build-debug: ## Build with debug symbols
	pnpm tauri build --debug

## Linting & Formatting ------------------------------------------------------

lint: ## Run all linters (frontend + Rust)
	pnpm run frontend:lint
	cd src-tauri && cargo clippy -- -D warnings

lint-fix: ## Auto-fix lint issues
	cd src-web && pnpm eslint . --fix
	cd src-tauri && cargo clippy --fix --allow-dirty

format: ## Format all code
	pnpm run format

format-check: ## Check formatting without changes
	pnpm run format:check
	cd src-tauri && cargo fmt -- --check

full-check: lint format-check ## Run all code checks

full-write: ## Auto-fix all formatting (frontend + Rust)
	pnpm run format
	cd src-tauri && cargo fmt --all

## Testing -------------------------------------------------------------------

test: ## Run all tests (frontend + Rust)
	pnpm run frontend:test
	cd src-tauri && cargo test

## Rust ----------------------------------------------------------------------

rust-lint: ## Run cargo clippy
	cd src-tauri && cargo clippy -- -D warnings

rust-format: ## Run cargo fmt
	cd src-tauri && cargo fmt

rust-test: ## Run cargo test
	cd src-tauri && cargo test

## CI & Setup ----------------------------------------------------------------

ci: lint format-check test build ## Run full CI pipeline

setup: ## Install dependencies and git hooks
	pnpm run project:init
	pnpm lefthook install

changelog: ## Generate changelog from conventional commits
	git-cliff --output CHANGELOG.md

template-check: ## Check template drift against upstream
	scripts/sync-template-check

bring-up-to-date: ## Sync with upstream template (dry-run default; pass ARGS="--execute" to run)
	bash scripts/bring_up_to_date.sh $(ARGS)

bring-up-to-date-all: ## Sync all downstream projects (dry-run default; pass ARGS="--execute" to run)
	bash scripts/bring_up_to_date_all.sh $(ARGS)

sync-cousins: ## Sync shared layer to cousin templates (dry-run default; pass ARGS="--execute" to run)
	bash scripts/sync_cousins.sh $(ARGS)

clean: ## Remove build artifacts
	pnpm run clean
