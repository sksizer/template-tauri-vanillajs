.DEFAULT_GOAL := help

.PHONY: help initialize rename \
        dev build build-debug ports \
        lint lint-fix format format-check full-check full-write \
        frontend-dev frontend-build frontend-preview \
        frontend-lint frontend-test \
        frontend-format frontend-format-check \
        test test-unit \
        rust-lint rust-format rust-test \
        backend-lint backend-format-check backend-test \
        ci setup clean \
        install-deps-debian release changelog \
        template-check bring-up-to-date bring-up-to-date-all \
        deps-update deps-update-all deps-upgrade deps-upgrade-all \
        sync-cousins

help: ## Show this help message
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Initialization:"
	@echo "  initialize     Run project initialization script"
	@echo "  rename         Run project rename script"
	@echo ""
	@echo "Development:"
	@echo "  dev            Run tauri dev server (auto-assigned port)"
	@echo "  build          Build for production"
	@echo "  build-debug    Build with debug symbols"
	@echo "  ports          Show auto-assigned port block for this worktree"
	@echo ""
	@echo "Frontend:"
	@echo "  frontend-dev          Run Vite dev server"
	@echo "  frontend-build        Build frontend for production"
	@echo "  frontend-preview      Preview frontend production build"
	@echo "  frontend-lint         Run frontend linter"
	@echo "  frontend-test         Run frontend tests"
	@echo "  frontend-format       Format frontend code"
	@echo "  frontend-format-check Check frontend formatting"
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
	@echo "  test-unit      Run frontend unit tests only"
	@echo ""
	@echo "Rust / Backend:"
	@echo "  rust-lint      Run cargo clippy"
	@echo "  rust-format    Run cargo fmt"
	@echo "  rust-test      Run cargo test"
	@echo "  backend-lint         Alias for rust-lint"
	@echo "  backend-format-check Check backend formatting"
	@echo "  backend-test         Alias for rust-test"
	@echo ""
	@echo "CI & Setup:"
	@echo "  ci             Run full CI pipeline (lint, format-check, test, build)"
	@echo "  setup          Install dependencies and git hooks"
	@echo "  clean          Remove build artifacts"
	@echo "  changelog      Generate changelog from conventional commits"
	@echo "  install-deps-debian  Install system dependencies (Debian/Ubuntu)"
	@echo "  release        Create a new release"
	@echo ""
	@echo "Template:"
	@echo "  template-check        Check template drift against upstream"
	@echo "  bring-up-to-date      Sync with upstream template (dry-run default)"
	@echo "  bring-up-to-date-all  Sync all downstream projects (dry-run default)"
	@echo "  deps-update           Update deps within semver ranges (dry-run default)"
	@echo "  deps-update-all       Update deps across all downstream projects (dry-run default)"
	@echo "  deps-upgrade          Upgrade deps to latest (dry-run default)"
	@echo "  deps-upgrade-all      Upgrade deps across all downstream projects (dry-run default)"
	@echo "  sync-cousins          Sync shared layer to cousin templates (dry-run default)"
	@echo ""

## Initialization ------------------------------------------------------------

initialize: ## Run project initialization script
	scripts/initialize.sh

rename: ## Run project rename script
	scripts/rename.sh

## Development targets -------------------------------------------------------

dev: ## Run tauri dev server
	pnpm tauri dev

build: ## Build for production
	pnpm tauri build

build-debug: ## Build with debug symbols
	pnpm tauri build --debug

ports: ## Show auto-assigned port block for this worktree
	@scripts/dev-port.sh --all

## Frontend ------------------------------------------------------------------

frontend-dev: ## Run Vite dev server
	cd src-web && pnpm run dev

frontend-build: ## Build frontend for production
	cd src-web && pnpm run build

frontend-preview: ## Preview frontend production build
	cd src-web && pnpm run preview

frontend-lint: ## Run frontend linter
	pnpm run frontend:lint

frontend-test: ## Run frontend tests
	pnpm run frontend:test

frontend-format: ## Format frontend code
	cd src-web && pnpm run format

frontend-format-check: ## Check frontend formatting
	cd src-web && pnpm run format:check

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

test-unit: ## Run frontend unit tests only
	pnpm run frontend:test

## Rust / Backend ------------------------------------------------------------

rust-lint: ## Run cargo clippy
	cd src-tauri && cargo clippy -- -D warnings

rust-format: ## Run cargo fmt
	cd src-tauri && cargo fmt

rust-test: ## Run cargo test
	cd src-tauri && cargo test

backend-lint: rust-lint ## Alias for rust-lint

backend-format-check: ## Check backend formatting
	pnpm run backend:format:check

backend-test: rust-test ## Alias for rust-test

## CI & Setup ----------------------------------------------------------------

ci: lint format-check test build ## Run full CI pipeline

setup: ## Install dependencies and git hooks
	pnpm run project:init
	pnpm lefthook install

clean: ## Remove build artifacts
	pnpm run clean

changelog: ## Generate changelog from conventional commits
	git-cliff --output CHANGELOG.md

install-deps-debian: ## Install system dependencies (Debian/Ubuntu)
	sudo apt install build-essential pkg-config libgtk-3-dev libglib2.0-dev libwebkit2gtk-4.1-dev libayatana-appindicator3-dev librsvg2-dev libssl-dev

release: ## Create a new release
	pnpm run release

## Template ------------------------------------------------------------------

template-check: ## Check template drift against upstream
	pnpm run template:check

bring-up-to-date: ## Sync with upstream template (dry-run default; pass ARGS="--execute" to run)
	bash scripts/bring_up_to_date.sh $(ARGS)

bring-up-to-date-all: ## Sync all downstream projects (dry-run default; pass ARGS="--execute" to run)
	bash scripts/bring_up_to_date_all.sh $(ARGS)

deps-update: ## Update deps within semver ranges (dry-run default; pass ARGS="--execute" to run)
	bash scripts/deps_update.sh $(ARGS)

deps-update-all: ## Update deps across all downstream projects (dry-run default; pass ARGS="--execute" to run)
	bash scripts/deps_update_all.sh $(ARGS)

deps-upgrade: ## Upgrade deps to latest (dry-run default; pass ARGS="--execute" to run)
	bash scripts/deps_upgrade.sh $(ARGS)

deps-upgrade-all: ## Upgrade deps across all downstream projects (dry-run default; pass ARGS="--execute" to run)
	bash scripts/deps_upgrade_all.sh $(ARGS)

sync-cousins: ## Sync shared layer to cousin templates (dry-run default; pass ARGS="--execute" to run)
	bash scripts/sync_cousins.sh $(ARGS)
