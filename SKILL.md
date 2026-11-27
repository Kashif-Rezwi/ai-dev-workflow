---
name: ai-dev-workflow
description: "Establish or improve a portable AI-assisted repository workflow with shared instructions, proportionate planning, verification, and cross-session handoffs. Use to initialize, inspect, or audit a repo's AI workflow or instruction files, or to create a feature spec. Modes: init, inspect, doctor, spec, verify. Not for everyday coding or debugging failing checks."
metadata:
  version: "1.1.1"
---

# AI Development Workflow

Bootstrap a pragmatic, harness-agnostic AI development workflow into any repository — or audit an existing one. The goal: **maximum practical leverage with minimum generated structure**.

## Core principles (apply to every command)

1. **Preserve and extend.** Inspect existing tooling, docs, scripts, CI, and AI configuration. Preserve useful content; address confirmed gaps with focused patches, not regeneration.
2. **Shared instructions.** Use `AGENTS.md` for shared project rules and thin adapters where needed. Preserve existing scoped or harness-specific guidance; link detailed procedures in their current documents.
3. **Evidence and review.** Follow the repository's verification contract and check acceptance criteria. Passing automated checks is evidence, not proof of every requirement or of harness instruction loading.
4. **Two gears, not bureaucracy.** Choose planning depth by scope, risk, compatibility, and reversibility. See `references/workflow.md` for the loops and handoff format.
5. **Minimum files.** Reuse existing guidance. Create a document only when it serves a concrete need. The repository workflow must work without this skill installed.
6. **Stable repeated runs.** Detect afresh; avoid duplicated sections, settings entries, and unnecessary changes. A coherent setup needs no edits just because templates changed.

## Commands

Infer the command from the request and context. Ask only when missing information changes the action.

| Command | Trigger examples | What it does |
|---|---|---|
| `init` | "initialize", "set up", "bootstrap", "make this repo AI-ready" | Inspect → plan → generate baseline → validate → report |
| `inspect` | "inspect", "analyze", "what's the workflow here" | Read-only report of stack, tooling, AI config, gaps |
| `doctor` | "doctor", "check", "audit", "what's missing/stale" | Detect missing/stale/contradictory config; propose fixes, change nothing |
| `spec <feature>` | "create a spec for X", "spec out X" | Create a concrete spec in the repo's planning location |
| `verify` | "verify", "run the checks" | Discover and run the repo's appropriate checks |

## Procedure: `init`

Work through these steps in order. Load reference files only when you reach the step that needs them.

### 1. INSPECT

Load `references/detection.md` and follow it to detect: git state, languages, frameworks, package manager, test/build/lint/format tooling, CI, Docker, existing docs, existing AI configuration (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursor/`, `.github/`, `.codex/`, `.gemini/`).

Present a concise detection report to the user.

### 2. PLAN

Decide the action for each candidate using `references/merge-rules.md` (load it now): **CREATE** (missing guidance with a purpose) / **NO-OP** (need already covered) / **PATCH** (focused, authorized improvement) / **PRESERVE** / **WARN** (contradicts detected facts). A managed marker does not establish whether a human or a template changed the content.

If existing instructions and docs cover the workflow, verification, and handoffs coherently: report **"already AI-ready"**, list any observations, and stop. Different filenames or formatting are not gaps.

Present a concise plan (file → action → reason), then carry out the authorized work. Carry existing approvals forward. Ask only for essential missing information or material decisions beyond that scope; do not add a routine confirmation gate.

### 3. GENERATE

Load `references/instructions-guide.md` and only the templates needed. Adapt their structure to the repo; resolve every `{{SLOT}}` and remove unsupported sections or rows. Do not invent commands, architecture, or links to paths that do not exist.

Baseline guidance (reuse first):
- Shared project instructions: extend existing instructions or create `AGENTS.md` from `templates/AGENTS.md.tmpl`.
- Development workflow, verification, and handoffs: extend the existing development/contribution guide, or create `docs/development.md` from `templates/docs/development.md.tmpl`. Include enough procedure to work without skill references.

Conditional:
- Architecture guidance: reuse existing design docs; use `templates/docs/architecture.md.tmpl` only if the detected system needs a separate map. A minimal repo does not need filler architecture.
- Feature template: reuse the repo's planning format. Adapt `templates/docs/specs/feature-spec.md.tmpl` only when substantial work needs one; do not create a specs directory for a hypothetical future task.
- ADR: use `templates/docs/decisions/adr.md.tmpl` in the repo's decision-record location only for a real durable decision. Do not create an empty directory.
- CI workflow: `templates/ci/github-actions.yml.tmpl` is optional, only when GitHub-hosted, CI is absent, and CI creation is explicitly authorized. Detect runtime/setup conventions; do not add CI as a baseline requirement.
- Harness adapters: load `references/harness-adapters.md` only for harnesses in use. Add an adapter only if needed, preserving existing settings and instructions.
- Combined verification command: prefer an existing contract. If a new command would help, propose its exact composition after inspecting script dependencies and lifecycle hooks. Edit manifests only within the authorized scope; a documented sequence is sufficient in any stack.

Avoid duplicated `.cursor/rules`, unnecessary nested instructions, `.ai/`/`.agent/` tracking trees, status/evidence docs, and unrequested tooling. Preserve useful existing structure rather than replacing it.

### 4. VALIDATE

- Re-read changed files for unresolved slots, missing references, contradictions, duplicated rules, and preserved content.
- Select checks using the `verify` procedure below. For instruction/config changes, check syntax, paths, imports, and discovery configuration; application tests do not establish that a harness loaded guidance. Confirm loading in a fresh real session when available; otherwise report it as unperformed.
- Review the resulting diff and evaluate a repeated `init` against the resulting files: does any concrete gap remain? Avoid writes when nothing needs changing. Separate failures introduced here from unrelated failures.
- `git status --short` — show exactly what changed.

### 5. REPORT

Close with what was detected, changed or preserved, validation evidence and limits, and any remaining work. Implementation completion does not require a Git action. Include a handoff checkpoint if work remains unfinished.

## Procedure: `inspect`

Load `references/detection.md`, run detection, and present the report. Also list: existing AI config files found, doc coverage, and which `init` actions would apply. **Write nothing.**

## Procedure: `doctor`

Run `inspect`, then check for problems:
- `AGENTS.md` contradictions (wrong commands, wrong package manager, dead file paths)
- missing or contradictory verification guidance (a documented sequence is sufficient)
- duplicated/conflicting instruction files (`CLAUDE.md` copy-pasted from `AGENTS.md`, etc.)
- stale docs vs Git state, broken references, missing handoff guidance, or adapters inconsistent with the harness version/settings

Report evidence and focused proposed fixes. `doctor` is read-only unless the user also authorizes repairs; that authorization need not be requested again.

## Procedure: `spec <feature>`

1. Read the relevant docs and existing planning format. Use its location; otherwise use `docs/specs/<slug>.md` with a kebab-case feature name. Preserve existing specs.
2. Derive goal, non-goals, acceptance criteria, and constraints from the request and available context. Ask only for missing information that matters. Compare alternatives when there is a meaningful design decision; record already approved choices without reopening them.
3. Adapt the repo's template or `templates/docs/specs/feature-spec.md.tmpl`. Write concrete requirements, ordered tasks with affected files/checks, and realistic risks. Resolve slots and remove unused sections; no extra template copy is required.
4. Link the actual development guide if one exists. Include the handoff checkpoint when work will cross sessions. A request for a spec does not itself authorize implementation or Git actions.

## Procedure: `verify`

1. Load `references/detection.md` and follow its verification-discovery guidance: identify the changed area, established contract, script dependencies, and lifecycle hooks before selecting commands.
2. Prefer the repository's established `verify`/`check` command or documented sequence, including its order and required full gates. Use area-specific checks where the contract permits. Do not separately rerun builds, tests, or typechecks already covered by the selected command. If no contract exists, order supported checks by their actual dependencies.
3. Run the selected checks. Stop dependent checks on failure; run independent checks if they add useful evidence. Do not weaken checks or fix unrelated failures to obtain a pass.
4. Report exact commands/results, manual review performed, and actual instruction-loading confirmation separately. Identify checks absent, skipped with a reason, blocked, or unperformed. Map evidence to acceptance criteria; green checks alone do not establish completion.

## Working on changes (any command)

When modifying a repo's workflow, follow `references/workflow.md`. Choose the gear by scope, risk, compatibility, and reversibility, not a file count or the user's phrasing. Use `checklists/quick-change.md` or `checklists/full-change.md` as appropriate; both share the final review in `checklists/pre-merge-review.md`. Keep unfinished-work checkpoints in an active spec, or transfer them conversationally for small tasks. Notes do not transfer uncommitted code.

## Boundaries

- Preserve existing content; apply focused patches within scope (see `references/merge-rules.md`).
- Never install dependencies, add tooling, or change CI without explicit approval.
- Respect established branch and commit conventions. Stage, commit, push, merge, publish, or deploy only when explicitly authorized; do not make them part of implementation completion.
- Stay in scope: no drive-by refactors, no unsolicited "cleanups".
- If the repo has its own `AGENTS.md` rules, they outrank this skill's defaults.
