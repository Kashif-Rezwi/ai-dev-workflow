---
name: ai-dev-workflow
description: "Bootstrap or audit a pragmatic AI-assisted development workflow in any software repository: generates AGENTS.md, a two-gear development workflow, spec and ADR templates, a verification contract, and thin harness adapters. Use when the user asks to initialize, set up, inspect, audit, or improve a repo's AI/agent development workflow, AGENTS.md, or AI instruction files, or to scaffold a feature spec with this workflow. Subcommands: init, inspect, doctor, spec, verify. Not for everyday coding tasks, bug fixes, or debugging failing tests, builds, or CI."
---

# AI Development Workflow

Bootstrap a pragmatic, harness-agnostic AI development workflow into any repository — or audit an existing one. The goal: **maximum practical leverage with minimum generated structure**.

## Core principles (apply to every command)

1. **Preserve, never fight.** Existing tooling, docs, scripts, CI, and AI configuration are the user's prior intent. Detect → analyze → preserve → extend → warn → ask. Never blindly overwrite.
2. **Single source of truth.** `AGENTS.md` is the canonical agent-instruction file. Harness-specific files are one-line pointers, never duplicated content.
3. **Deterministic verification is the definition of done.** An agent never declares work "done" on reasoning alone — the repo's checks must be green.
4. **Two gears, not bureaucracy.** Small changes use the quick loop; features/architecture use the full loop. See `references/workflow.md`.
5. **Minimum files.** Generate only what will be read. No empty directories, no placeholder docs, no process for its own sake.
6. **Idempotent.** Re-running `init` on an initialized repo reports "already AI-ready" and changes nothing.

## Commands

The user's request determines the command. When ambiguous, ask.

| Command | Trigger examples | What it does |
|---|---|---|
| `init` | "initialize", "set up", "bootstrap", "make this repo AI-ready" | Inspect → plan → generate baseline → validate → report |
| `inspect` | "inspect", "analyze", "what's the workflow here" | Read-only report of stack, tooling, AI config, gaps |
| `doctor` | "doctor", "check", "audit", "what's missing/stale" | Detect missing/stale/contradictory config; propose fixes, change nothing |
| `spec <feature>` | "create a spec for X", "spec out X" | Scaffold `docs/specs/<feature>.md` from template |
| `verify` | "verify", "run the checks" | Discover and run the repo's deterministic checks in order |

## Procedure: `init`

Work through these steps in order. Load reference files only when you reach the step that needs them.

### 1. INSPECT

Load `references/detection.md` and follow it to detect: git state, languages, frameworks, package manager, test/build/lint/format tooling, CI, Docker, existing docs, existing AI configuration (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursor/`, `.github/`, `.codex/`, `.gemini/`).

Present a concise detection report to the user.

### 2. PLAN

Decide the action for every candidate file using `references/merge-rules.md` (load it now). The matrix is: **CREATE** (absent) / **REFRESH** (skill-managed, human-unmodified) / **PRESERVE + report** (human-owned) / **WARN** (contradicts detected reality).

If the repo already has a good `AGENTS.md` and coherent AI setup: report **"already AI-ready"**, list any `doctor`-style observations, and stop. That is a successful run.

Present the plan as a table (file → action → reason) and **ask for confirmation before writing anything**, unless the user already approved generation.

### 3. GENERATE

Load `references/instructions-guide.md` and the relevant templates from `templates/`. Fill every `{{SLOT}}` with detected facts — never leave generic filler.

Mandatory baseline (create if absent):
- `AGENTS.md` — from `templates/AGENTS.md.tmpl`, filled with detected stack/commands
- `docs/development.md` — from `templates/docs/development.md.tmpl` (the two-gear workflow + verification contract, so the repo works without this skill installed)
- `docs/architecture.md` — from `templates/docs/architecture.md.tmpl`, seeded with detected structure

Conditional:
- `docs/specs/feature-spec.md` — always create the template file so specs are one step away
- `docs/decisions/` — do **not** create at init; on the first real decision, create `docs/decisions/NNNN-<slug>.md` from `templates/docs/decisions/adr.md.tmpl`
- CI workflow — from `templates/ci/github-actions.yml.tmpl`, **only if** no CI exists and a GitHub remote is present; otherwise note it in the report
- Harness adapters — load `references/harness-adapters.md`; generate thin pointers **only** for harnesses the user confirms they use or that are already present in the repo
- `verify` script — if a package manager exists, **propose** composing existing scripts into one `verify` script and ask before editing the manifest. For non-JS repos, document the equivalent command sequence in `docs/development.md` instead.

Never generate: duplicated `.cursor/rules`, nested `AGENTS.md` in small repos, `.ai/`/`.agent/` directory trees, status/evidence docs, or tooling the repo doesn't have (recommend it in the report instead).

### 4. VALIDATE

- Re-read every file you created: all `{{SLOTS}}` filled, no contradictions with detection.
- If a `verify` command exists or was created, run it. Report the result honestly — if it fails on pre-existing issues, say so and do not fix unrelated failures without asking.
- `git status --short` — show exactly what changed.

### 5. REPORT

Close with: what was detected, what was created/preserved/warned, what needs the user's attention, and the suggested next step (usually: commit, then start the first feature with `spec`).

## Procedure: `inspect`

Load `references/detection.md`, run detection, and present the report. Also list: existing AI config files found, doc coverage, and which `init` actions would apply. **Write nothing.**

## Procedure: `doctor`

Run `inspect`, then check for problems:
- `AGENTS.md` contradictions (wrong commands, wrong package manager, dead file paths)
- missing verification path (no way to run checks in one step)
- duplicated/conflicting instruction files (`CLAUDE.md` copy-pasted from `AGENTS.md`, etc.)
- stale docs vs git reality (docs claim work lives on a branch that was merged)

Propose a numbered fix list. Change nothing without explicit approval.

## Procedure: `spec <feature>`

1. Slugify the feature name (`<feature>` → `kebab-case`).
2. Interview the user first: goal, non-goals, acceptance criteria, constraints. Then draft **at least two approaches with a trade-off table** and recommend one. The spec is not complete until the user approves the approach.
3. If `docs/specs/` has no template, copy `templates/docs/specs/feature-spec.md.tmpl` there.
4. Only now create `docs/specs/<slug>.md` from the template, filled with the approved results — every `{{SLOT}}` resolved, no half-filled file on disk.
5. Remind the user: the spec is the source of truth for implementation; the full gear in `docs/development.md` applies.

## Procedure: `verify`

1. Discover available checks from the repo's manifests/config (see `references/detection.md` §verification-discovery).
2. Run what exists, in this order, stopping at the first failure: **format check → lint → typecheck → unit tests → integration tests → build → e2e**.
3. Report each layer as pass/fail/skipped-not-present. Never claim success for a layer that didn't run.

## Working on changes (any command)

When implementing or modifying code in a repo that uses this workflow, follow the two-gear loop in `references/workflow.md`: quick gear for small changes, full gear for features/architecture. Gear rule: touching >3 files, public API, data model, or infra — or not trivially reversible — means full gear. Close quick-gear work against `checklists/quick-change.md`; track full-gear work with `checklists/full-change.md`, and complete `checklists/pre-merge-review.md` before requesting merge approval.

## Boundaries

- Never overwrite human-owned files (see `references/merge-rules.md`).
- Never install dependencies, add tooling, or change CI without explicit approval.
- Never commit or push without explicit approval; draft the message, let the human decide.
- Stay in scope: no drive-by refactors, no unsolicited "cleanups".
- If the repo has its own `AGENTS.md` rules, they outrank this skill's defaults.
