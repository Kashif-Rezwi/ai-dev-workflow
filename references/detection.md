# Repository Detection

How to inspect a repository before generating anything. Gather facts with fast, read-only commands. Prefer targeted file reads over recursive scans; never read `node_modules`, `.git` internals, build output, or lockfiles in full.

## Git state

```
git rev-parse --is-inside-work-tree   # is this a repo at all?
git branch --show-current             # current branch
git rev-parse HEAD                    # current commit, if any
git status --short                    # uncommitted work — report it, don't touch it
git remote -v                         # hosting provider; not permission to add CI
git log --oneline -5                  # commit convention (conventional commits? free-form?)
```

Read applicable repository instructions first, including parent/nested instructions for the affected paths. Detect branch/worktree and commit conventions; do not prescribe `develop`, a new feature branch, or conventional commits. Local remote-tracking refs may be stale. A missing Git repo or an unborn branch is a fact to report, not a reason to initialize Git.

## Package manager (JS/TS)

Check in priority order:
1. `packageManager` field in `package.json` (most authoritative)
2. Lockfile: `pnpm-lock.yaml` → pnpm · `package-lock.json` → npm · `yarn.lock` → yarn · `bun.lockb`/`bun.lock` → bun
3. Monorepo: `pnpm-workspace.yaml`, `workspaces` in `package.json`, `turbo.json`, `nx.json`, `lerna.json`

Read runtime pins such as `.nvmrc`, `.node-version`, toolchain files, and manifest engines. Resolve conflicting evidence using repo docs and CI; do not choose a package manager or runtime version merely because it appears in this skill's examples.

For monorepos or repositories using several languages, inspect each affected area's instructions and tooling. Record the working directory, runtime/environment, and package manager or task runner for each command. Do not apply the root package manager or verification gate to every subproject unless the repo establishes that contract.

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

Look for: `AGENTS.md` (root + nested), `CLAUDE.md`, `GEMINI.md`, `.aider.conf.yml`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.codex/`, `.gemini/`, `.agents/`, `.claude/`, `.windsurf/`, `.roo/`, `.opencode/`, `.cline/`. Inspect relevant configuration without exposing credentials.

If any exist: **read them**. They are the user's prior intent and change what `init` is allowed to do (see `merge-rules.md`).

## Existing docs

`README.md`, `docs/`, `ARCHITECTURE.md`, `CONTRIBUTING.md`, existing plans/specs, ADRs. Read their contents and links; filenames alone do not establish coverage. Identify where setup, development, architecture, active plans, and verification already live so `init` extends rather than duplicates them.

## §verification-discovery

Discover the verification contract from repository instructions, development docs, manifests, task runners, and CI. A script's name alone does not establish its coverage or side effects.

1. Identify the changed area and any required full gate. Prefer the established `verify`/`check` command or documented sequence. Use focused checks only where that contract permits; do not bypass required gates to save time.
2. Read selected scripts and the commands they invoke, including workspace tasks, task-runner dependencies, package-manager pre/post hooks, and build/package lifecycle hooks. Check whether a build includes typechecking, tests build first, or a packaging dry run triggers another build or an external action. Do not run publishing/deployment as verification without authorization.
3. Record which checks each selected command already covers. Avoid adding separate builds, tests, or typechecks for those same checks. If the existing contract itself repeats work, preserve it during `verify`; propose a focused improvement rather than silently changing its semantics.
4. Without a contract, select only commands supported by repo scripts, installed tooling, or configuration. Order them by dependencies (for example, build before tests that import built output), then cost. There is no universal order. Document the sequence; a combined script is optional.
5. Select evidence appropriate to the change. Docs/adapters need factual, reference, syntax, and import checks. UI changes may need browser review; compatibility changes may need consumer or integration checks. Do not invent lint, tests, or commands for a minimal repo.
6. Report exact commands, coverage, results, and omissions. Stop dependent checks on failure. Keep automated checks, manual review, and real harness instruction-loading confirmation distinct. Static config validation is not a live loading test.

For example, if `test` invokes `build` and `verify` invokes `test` plus a production build that includes typechecking, run `verify` once rather than prepending another build and typecheck. Inspect the actual scripts and hooks before applying that reasoning to another repo.

## Unknown stack fallback

If nothing above matches, report "unknown/minimal stack". Reuse or create concise shared instructions and development/handoff guidance. Omit command tables, package-manager claims, and architecture/spec/ADR files without concrete content. State that no automated check was found; do not guess or imply verification passed.
