# Tauri + Vanilla JavaScript Template

A starting point for desktop applications using [Tauri](https://tauri.app/) and vanilla JavaScript.

## Features

- Peer directory structure separating frontend and backend code
- Pre-configured CI/CD (lint, build, release)
- Linting and formatting (ESLint, Prettier, Clippy, rustfmt)
- Git hooks via Lefthook with conventional commits
- Makefile and mise for ergonomic development commands
- Version management with release-it (syncs `package.json` → `Cargo.toml`)

## Project Structure

```
template_tauri_vanillajs/
├── .github/           # CI/CD workflows
│   └── workflows/     # ci, build-check, release
├── .scripts/          # Helper scripts for CI and tooling
├── src-web/           # Frontend vanilla JS application (Vite)
│   ├── public/        # Static assets
│   ├── index.html     # Entry HTML
│   ├── main.js        # Application logic
│   └── style.css      # Styles
└── src-tauri/         # Rust/Tauri backend
    ├── src/           # Rust source code
    ├── capabilities/  # Tauri capability definitions
    └── icons/         # App icons (all platforms)
```

## Prerequisites

- [Node.js](https://nodejs.org/) (LTS) and [pnpm](https://pnpm.io/)
- [Rust](https://www.rust-lang.org/tools/install) (1.93.0+)
- [Tauri CLI](https://tauri.app/start/) v2
- **Optional**: [mise](https://mise.jdx.dev/) — auto-installs all tool versions

## Setup

```bash
# With mise (recommended — installs Node, pnpm, Rust, tauri-cli automatically):
mise install

# Then install project dependencies:
make setup        # or: pnpm run project:init && pnpm lefthook install
```

## Development Commands

### Makefile (recommended)

| Target | Description |
| --- | --- |
| make dev | Run Tauri dev server |
| make build | Production build |
| make build-debug | Build with debug symbols |
| make lint | Run all linters (frontend + Rust) |
| make lint-fix | Auto-fix lint issues |
| make format | Format all code |
| make format-check | Check formatting without changes |
| make test | Run all tests (frontend + Rust) |
| make ci | Full CI pipeline (lint, format-check, test, build) |
| make setup | Install deps and git hooks |
| make clean | Remove build artifacts |
| make help | Show all available targets |

### pnpm / cargo

```bash
pnpm tauri dev      # or: cargo tauri dev
pnpm tauri build    # or: cargo tauri build
```

## Developer Tooling

JS tooling configs (Prettier, ESLint) live in `src-web/` alongside the code they check. The root `package.json` orchestrates cross-project scripts.

### mise

[mise](https://mise.jdx.dev/) manages tool versions and provides convenience tasks. Pinned versions:

- **Node**: LTS
- **pnpm**: latest
- **Rust**: 1.93.0 (auto-installs `tauri-cli` v2.10.0)

Run `mise run dev`, `mise run build`, `mise run test_all`, etc.

### Lefthook (Git Hooks)

**pre-commit** (parallel):

- `eslint` — lint JS
- `prettier` — format check
- `clippy` — Rust lint (warnings = errors)
- `rustfmt` — Rust format check

**commit-msg**: `commitlint` enforces [Conventional Commits](https://www.conventionalcommits.org/) via `@commitlint/config-conventional`.

### EditorConfig

Consistent formatting across editors: 2-space indent (4 for Rust, tabs for Makefile), LF line endings, UTF-8.

## Linting & Formatting

| Layer | Frontend | Backend |
| --- | --- | --- |
| Lint | ESLint | cargo clippy (-D warnings) |
| Format | Prettier (no semi, single quotes, 100 width) | cargo fmt |

## Testing

| Layer | Tool | Command |
| --- | --- | --- |
| Frontend | Vitest | make test |
| Backend | cargo test | make rust-test |
| All | — | make test |

## CI/CD

| Workflow | Trigger | What it does |
| --- | --- | --- |
| ci.yml | Push/PR to main | Frontend lint + test; Rust format + clippy + test |
| build-check.yml | Push/PR to main | Full Tauri build verification |
| release.yml | Tag v* | Multi-platform build (macOS aarch64/x86_64, Ubuntu, Windows) via tauri-apps/tauri-action; creates draft GitHub release |

## Version Management

Single version source in root `package.json`, synced to `src-tauri/Cargo.toml` via [release-it](https://github.com/release-it/release-it) + `@release-it/bumper`.

```bash
pnpm run release    # bumps version, tags as v{version}, syncs Cargo.toml
```

## Tauri Configuration

- `withGlobalTauri`: enabled — exposes Tauri API to frontend
- **Default window**: 800x600
- **Build command**: `vite build` (static output)
- **Version**: reads from root `package.json`

## Acknowledgements

Build tooling and developer experience configuration (Lefthook, commitlint, Prettier, EditorConfig, Makefile) were inspired by and adapted from [oxide-dock](https://github.com/fridzema/oxide-dock) by [@fridzema](https://github.com/fridzema).

## Additional Resources

- [Tauri Documentation](https://tauri.app/v1/guides/)
- [Vite Documentation](https://vite.dev/)
