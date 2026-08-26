# Repository Detection

How to inspect a repository before generating anything. Gather facts with fast, read-only commands. Prefer targeted file reads over recursive scans; never read `node_modules`, `.git` internals, build output, or lockfiles in full.

## Git state

```
git rev-parse --is-inside-work-tree   # is this a repo at all?
git branch --show-current             # current branch
git status --short                    # uncommitted work — report it, don't touch it
git remote -v                         # hosting provider (github.com → CI template eligible)
git log --oneline -5                  # commit convention (conventional commits? free-form?)
```

## Package manager (JS/TS)

Check in priority order:
1. `packageManager` field in `package.json` (most authoritative)
2. Lockfile: `pnpm-lock.yaml` → pnpm · `package-lock.json` → npm · `yarn.lock` → yarn · `bun.lockb`/`bun.lock` → bun
3. Monorepo: `pnpm-workspace.yaml`, `workspaces` in `package.json`, `turbo.json`, `nx.json`, `lerna.json`

## Language & framework signals

| Signal file(s) | Conclusion |
|---|---|
| `package.json` + `tsconfig.json` | TypeScript |
| `package.json` deps: `react`, `next`, `vite`, `@nestjs/*`, `astro`, `vue`, `svelte` | corresponding framework |
| `requirements.txt` / `pyproject.toml` / `uv.lock` / `Pipfile` | Python (uv / pip / poetry / pipenv) |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `pom.xml` / `build.gradle*` | Java/Kotlin |
| `*.csproj` / `*.sln` | C#/.NET |
| `Gemfile` | Ruby |
| `composer.json` | PHP |
| `Dockerfile` / `docker-compose.yml` | containerized |
| `render.yaml` / `vercel.json` / `fly.toml` / `netlify.toml` | deployment target |

Project shape: `apps/`+`packages/` or workspaces → monorepo · `src/` with server framework → backend/API · `index.html`+`src/` → frontend · `bin` field or CLI deps → CLI · `main`/`exports` + no app entry → library.

## Tooling signals

| Check | Files |
|---|---|
| Tests | `vitest.config.*`, `jest.config.*`, `pytest.ini`/`pyproject [tool.pytest]`, `*_test.go`, `tests/` |
| Lint | `eslint.config.*`, `.eslintrc*`, `ruff.toml`, `.golangci.yml` |
| Format | `.prettierrc*`, `prettier` in package.json, `black`/`ruff format` config |
| Types | `tsconfig.json` (`strict`?), `mypy.ini`, `pyrightconfig.json` |
| CI | `.github/workflows/`, `.gitlab-ci.yml`, `.circleci/`, `Jenkinsfile` |
| Git hooks | `.husky/`, `.pre-commit-config.yaml`, `lefthook.yml` |

## Existing AI configuration

Look for: `AGENTS.md` (root + nested), `CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.codex/`, `.gemini/`, `.agents/`, `.claude/`, `.windsurf/`, `.roo/`, `.opencode/`, `.cline/`.

If any exist: **read them**. They are the user's prior intent and change what `init` is allowed to do (see `merge-rules.md`).

## Existing docs

`README.md`, `docs/`, `ARCHITECTURE.md`, `CONTRIBUTING.md`, `docs/specs/`, `docs/decisions/`, ADRs. Note what exists so `init` extends rather than duplicates.

## §verification-discovery

Build the ordered verification plan from what exists. Only include layers with real evidence:

| Layer | JS/TS evidence → command | Python evidence → command |
|---|---|---|
| format check | prettier → `<pm> exec prettier --check .` | ruff/black → `ruff format --check .` |
| lint | eslint → `<pm> run lint` or `<pm> exec eslint .` | ruff → `ruff check .` |
| typecheck | tsconfig → `<pm> run typecheck` or `tsc --noEmit` | mypy/pyright config → `mypy .` |
| unit tests | vitest/jest → `<pm> test` | pytest → `pytest` |
| build | build script → `<pm> run build` | — |
| e2e | playwright/cypress config → its command | — |

Rules:
- If the repo already has a single `verify`/`check` script, use it — do not reinvent.
- If scripts exist but no combined one, compose them (and during `init`, propose adding it).
- If a layer has no evidence, mark it `skipped-not-present`. Never fabricate a check.
- `<pm>` = the detected package manager (`pnpm`, `npm run`, `uv run`, etc.).

## Unknown stack fallback

If nothing above matches: report "unknown/minimal stack", generate the generic baseline (AGENTS.md with no command table rows beyond git, development.md, architecture.md), and list what the user should fill in manually. Do not guess.
