# Repository Guidelines

## Project Structure & Module Organization
The repo currently documents the planned RAPID MCP server. Keep workflow definitions in `commands/` with kebab-case filenames that match the command name (e.g., `gh-work.md`). Treat `prd.md` as the single source of architecture decisions, and extend `README.md` only with concise status updates. When Zig sources arrive, place code in `src/`, mirror tests in `test/`, and store generated YAML templates beside the originating Markdown.

## Build, Test, and Development Commands
Implementation is pending, but the roadmap assumes native Zig tooling. Use `zig build run` during development, `zig build -Drelease-safe` for release binaries, and `zig test src/<module>.zig` to exercise focused suites. While the repo remains docs-first, lint Markdown with `markdownlint **/*.md` (or equivalent) and confirm new commands align with the flows described in `prd.md`.

## Coding Style & Naming Conventions
Follow Zig defaults: four-space indentation, snake_case locals, UpperCamelCase types, and imperative function names. Run `zig fmt` (or the formatter in your editor) before committing Zig sources. Markdown should stay consistent with ATX headings, `-` bullets, language-tagged fenced code blocks, and lowercase kebab-case filenames.

## Testing Guidelines
Add `test { ... }` blocks alongside each Zig module to cover parameter validation, GitHub CLI wrappers, and prompt generation paths. Target full branch coverage for user-facing commands before marking a feature complete. For documentation updates, embed scenario notes or acceptance checklists so future automation can derive test cases. Always run `zig test` or the eventual `zig build test` target before opening a pull request.

## Commit & Pull Request Guidelines
History currently shows only an initial “first commit,” so establish clarity now. Write imperative, scope-focused commits (e.g., `Add sanity check validator`) and reference issues via `Refs #123` when applicable. Pull requests should summarize intent, call out the touched commands or modules, and list manual test or lint commands executed; include screenshots only when CLI output materially changes.

## Security & Configuration Notes
The server will invoke `gh` and `git`, so never pass unchecked user input to shells and keep configuration parsing aligned with the schemas defined in `prd.md`. Exclude personal tokens from the repo, preferring `.env.example` for local hints. Document new external dependencies with required permissions and safe fallbacks so downstream agents can audit quickly.
