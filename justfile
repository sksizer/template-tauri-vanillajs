# Default recipe: show help
default:
    @just --list

## Initialization ------------------------------------------------------------

# Run project initialization script
initialize:
    scripts/initialize.sh

# Run project rename script
rename:
    scripts/rename.sh

## Development ---------------------------------------------------------------

# Run tauri dev server (auto-assigned port)
dev:
    pnpm tauri dev

# Build for production
build:
    pnpm tauri build

# Build with debug symbols
build-debug:
    pnpm tauri build --debug

# Show auto-assigned port block for this worktree
ports:
    @scripts/dev-port.sh --all

## Frontend ------------------------------------------------------------------

# Run Vite dev server
frontend-dev:
    cd src-web && pnpm run dev

# Build frontend for production
frontend-build:
    cd src-web && pnpm run build

# Preview frontend production build
frontend-preview:
    cd src-web && pnpm run preview

# Run frontend linter
frontend-lint:
    pnpm run frontend:lint

# Run frontend tests
frontend-test:
    pnpm run frontend:test

# Format frontend code
frontend-format:
    cd src-web && pnpm run format

# Check frontend formatting
frontend-format-check:
    cd src-web && pnpm run format:check

## Linting & Formatting ------------------------------------------------------

# Run all linters (frontend + Rust)
lint:
    pnpm run frontend:lint
    cd src-tauri && cargo clippy -- -D warnings

# Auto-fix lint issues
lint-fix:
    cd src-web && pnpm eslint . --fix
    cd src-tauri && cargo clippy --fix --allow-dirty

# Format all code
format:
    pnpm run format

# Check formatting without changes
format-check:
    pnpm run format:check
    cd src-tauri && cargo fmt -- --check

# Run all code checks (lint + format-check)
full-check: lint format-check
alias fc := full-check

# Auto-fix all formatting (frontend + Rust)
full-write:
    pnpm run format
    cd src-tauri && cargo fmt --all
alias fw := full-write

## Testing -------------------------------------------------------------------

# Run all tests (frontend + Rust)
test:
    pnpm run frontend:test
    cd src-tauri && cargo test

# Run frontend unit tests only
test-unit:
    pnpm run frontend:test

## Rust ----------------------------------------------------------------------

# Run cargo clippy
rust-lint:
    cd src-tauri && cargo clippy -- -D warnings

# Run cargo fmt
rust-format:
    cd src-tauri && cargo fmt

# Run cargo test
rust-test:
    cd src-tauri && cargo test

# Alias for rust-lint
backend-lint: rust-lint

# Check backend formatting
backend-format-check:
    pnpm run backend:format:check

# Alias for rust-test
backend-test: rust-test

## CI & Setup ----------------------------------------------------------------

# Run full CI pipeline (lint, format-check, test, build)
ci: lint format-check test build

# Install dependencies and git hooks
setup:
    pnpm run project:init
    pnpm lefthook install

# Generate changelog from conventional commits
changelog:
    git-cliff --output CHANGELOG.md

# Check template drift against upstream
template-check:
    pnpm run template:check

# Bring repo up to date with upstream template (dry-run by default; --execute to run)
bring-up-to-date *args:
    bash scripts/bring_up_to_date.sh {{args}}
alias butd := bring-up-to-date

# Bring all downstream projects up to date (dry-run by default; --execute to run)
bring-up-to-date-all *args:
    bash scripts/bring_up_to_date_all.sh {{args}}
alias butda := bring-up-to-date-all

# Update deps within semver ranges (dry-run by default; --execute to run)
deps-update *args:
    bash scripts/deps_update.sh {{args}}

# Update deps within semver ranges across all downstream projects
deps-update-all *args:
    bash scripts/deps_update_all.sh {{args}}

# Upgrade deps to latest (cross-major; dry-run by default; --execute to run)
deps-upgrade *args:
    bash scripts/deps_upgrade.sh {{args}}

# Upgrade deps to latest across all downstream projects
deps-upgrade-all *args:
    bash scripts/deps_upgrade_all.sh {{args}}

# Sync shared layer to cousin template repos (dry-run by default; --execute to run)
sync-cousins *args:
    bash scripts/sync_cousins.sh {{args}}

# Remove build artifacts
clean:
    pnpm run clean

# Install system dependencies (Debian/Ubuntu)
install-deps-debian:
    sudo apt install build-essential pkg-config libgtk-3-dev libglib2.0-dev libwebkit2gtk-4.1-dev libayatana-appindicator3-dev librsvg2-dev libssl-dev

# Create a new release
release:
    pnpm run release
