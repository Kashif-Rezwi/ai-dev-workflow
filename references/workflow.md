# The Two-Gear Workflow

One workflow, two gears. The gear is chosen by change size and risk — never by habit. This file is the full procedure; the generated `docs/development.md` carries the same content into the target repo so it works without this skill.

## Choosing the gear

**Quick gear** — the change is small, local, and trivially reversible:
- bug fixes, typos, copy changes, config tweaks, small refactors, dependency patch bumps
- touches ≤3 files, no public API / data model / infra changes

**Full gear** — anything else:
- new features, architectural changes, new applications, major refactors, infrastructure changes
- touches >3 files, public API, data model, auth, payments, deploy config — or is not trivially reversible

When in doubt, full gear. When the user says "just fix it", quick gear — but the VERIFY step is never skipped.

## Quick gear

```
ORIENT   → read AGENTS.md + git status (branch, uncommitted work)
CHANGE   → smallest correct change, stay in scope
VERIFY   → run the repo's verification (verify command or discovered checks)
COMMIT   → one atomic conventional commit; agent drafts, human approves
```

No spec doc, no plan doc, no ADR — unless a genuinely durable decision was made. Before committing, confirm every item in `checklists/quick-change.md`.

## Full gear

```
ORIENT   → AGENTS.md, relevant docs, git-truth check
SPEC     → docs/specs/<feature>.md
PLAN     → ordered tasks inside the spec
BUILD    → implement task by task, atomic commits
PROVE    → deterministic verify green → self-review vs acceptance criteria
RECORD   → ADR only if a durable decision was made
GATE     → human approval before merge/deploy/irreversible
```

Track the loop against `checklists/full-change.md`; complete `checklists/pre-merge-review.md` before requesting GATE approval.

### ORIENT
- Read `AGENTS.md`, then only the docs relevant to this task (just-in-time, not everything).
- **Git-truth check:** confirm current branch, merge state, and origin refs with git commands before trusting any prose about "where the work lives". Docs drift; git doesn't.

### SPEC
- Create `docs/specs/<feature>.md` from the repo's spec template (the `spec` command does this).
- Required content: goal, non-goals, acceptance criteria (testable), constraints, ≥2 approaches with a trade-off table, recommended approach.
- The human approves the approach before implementation. The spec is the source of truth for the rest of the loop.

### PLAN
- Break the approved spec into ordered tasks: files touched, per-task verification, risks.
- Keep the plan inside the spec file. A separate plan doc is optional and only for large efforts.

### BUILD
- One task at a time, smallest useful steps, one atomic commit per task.
- Stay in scope. Found something unrelated? Note it; don't fix it mid-task.

### PROVE
1. Run the full deterministic verification — all layers green.
2. Self-review against every acceptance criterion in the spec, item by item.
3. Optional, for high-risk changes: adversarial AI review — a fresh reviewer checks **correctness and stated-requirement gaps only**. Not style, not hypotheticals. Treat findings as advisory; the human arbitrates.

### RECORD
- Add an ADR (`docs/decisions/NNNN-<slug>.md`) only for durable, hard-to-reverse decisions. Reversible choices need no ADR.
- Update `docs/architecture.md` if the system shape changed.

### GATE
Stop and get explicit human approval before: merging to a protected branch, deploying, changing scope, deleting functionality, or anything irreversible. The agent drafts the commit/PR summary; the human decides.

## The verification contract

- Definition of done = deterministic checks green, never the agent's say-so.
- Order: format → lint → typecheck → unit tests → integration tests → build → e2e. Run only what exists.
- AI review judges architecture, requirement coverage, edge cases, maintainability. Tools judge correctness. Never substitute one for the other.

## Git conventions (defaults — the repo's own conventions win)

- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:` with optional scope.
- Atomic commits: one logical change each.
- Full-gear work on a short-lived `feat/<slug>` or `fix/<slug>` branch; quick-gear may commit directly to the working branch if that's the repo's norm.
- Agent never commits/pushes without explicit approval.
