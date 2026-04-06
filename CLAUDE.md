# Development Instructions

When you generate new code or update existing code, run `just ci` or `make ci` to verify everything
passes (lint, format, test, build). For a quick Rust-only check, use `rust-lint` and `rust-format`.

If there are formatting issues, run `just full-write` or `make full-write` to auto-fix them,
then re-run `just full-check` or `make full-check`.

To see all available commands, run `just --list` or `make help`.

## Quick Reference

- `full-check` — Run all checks (lint + format-check)
- `full-write` — Auto-fix all formatting (frontend + Rust)
- `ci` — Full CI pipeline (lint, format, test, build)
- `test` — Run all tests (frontend + Rust)
