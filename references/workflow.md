# The Two-Gear Workflow

One workflow, two gears. Adapt this procedure into the repository's development/contribution guide so it works without this skill. Keep active task state in an existing spec or the conversation.

## Choosing the gear

**Quick gear** — the intended behavior is clear, the scope is local, compatibility risk is low, and the change is readily reversible. Examples include copy corrections and contained fixes or refactors with understood effects.

**Full gear** — substantial behavior or design changes, compatibility decisions, migrations, or changes with broad effects or difficult rollback. Public APIs, authentication, payments, and infrastructure often warrant this gear; inspect their actual impact.

File count and phrases such as "just fix it" do not determine risk. Use enough planning to resolve uncertainty; do not require a spec for a clearly understood, reversible task.

## Quick gear

```
ORIENT   → read project instructions; inspect branch, commit, and working tree
PLAN     → state the intended change briefly; ask only for missing information
CHANGE   → smallest correct change, stay in scope
VERIFY   → appropriate checks under the repo's verification contract
REVIEW   → inspect the diff, assess the outcome, report evidence and limits
```

Use `checklists/quick-change.md` to close the task. No separate planning file or ADR is needed unless a durable decision merits a record. Git actions are separate from implementation completion.

## Full gear

```
ORIENT   → project instructions, relevant docs, actual Git state
SPEC     → use the existing planning format/location
PLAN     → ordered tasks inside the spec
BUILD    → implement in manageable steps within approved scope
VERIFY   → checks and review mapped to acceptance criteria
RECORD   → ADR only if a durable decision was made
REPORT   → results, limits, and handoff if work remains
```

Use `checklists/full-change.md` and the shared final review in `checklists/pre-merge-review.md`. Do not create a second tracking system.

### ORIENT
- Read `AGENTS.md`, then only the docs relevant to this task (just-in-time, not everything).
- Confirm the current branch, commit, and working tree before trusting historical notes. Remote-tracking refs can be stale. Preserve unrelated uncommitted work and follow the repo's branch/worktree conventions.

### SPEC
- Use the existing planning format/location; otherwise create `docs/specs/<feature>.md` when substantial work needs it.
- Record goal, non-goals, observable acceptance criteria, and constraints. Compare alternatives only for meaningful decisions.
- Use supplied information and approvals. Ask about missing requirements or material choices beyond the approved scope, not routine implementation details.

### PLAN
- Break the approved spec into ordered tasks: files touched, per-task verification, risks.
- Keep the plan inside the active spec. Avoid separate plans, status directories, or continuous activity logs.

### BUILD
- Work in related, manageable steps. Update the spec when findings change the approach; raise material scope changes before implementing them. Already approved choices need no repeated approval.
- Stay in scope. Found something unrelated? Note it; don't fix it mid-task.

### VERIFY
1. Follow the established verification contract using `references/detection.md`. Respect required full gates; select area-specific checks where permitted and avoid duplicate work.
2. Map automated results and manual review to each acceptance criterion. Checks can miss requirement gaps, visual behavior, and compatibility issues.
3. Review the diff for regressions, unnecessary complexity, stale docs, and scope. Additional independent review can help with substantial risk when available and authorized; it is not a mandatory new agent or tool.

### RECORD
- Add an ADR in the repo's existing location only when a durable decision needs a separate record. Otherwise keep the rationale in the spec.
- Update the existing architecture/design guide if system shape changed; do not generate a second architecture document.

### REPORT
State the outcome, actual checks, manual review, unperformed checks, and remaining risks. Report unrelated failures separately. If unfinished work crosses sessions or tools, use the checkpoint below.

## The verification contract

- Prefer the repo's existing command/sequence and order, after inspecting dependencies and lifecycle hooks. Do not separately repeat covered builds, tests, or typechecks.
- Choose checks appropriate to the changed area and contract. Instruction/config edits need syntax, reference, import, and discovery checks; they do not automatically need application tests.
- Report automated checks, manual review, and actual harness instruction-loading confirmation separately. Passing checks provide evidence; completion also requires assessing acceptance criteria.
- Repeat passing checks only after relevant changes or to resolve a concrete concern. Do not weaken checks to obtain a pass.

## Continuing in another session, editor, or harness

Read shared project instructions, the relevant guide, and the active task record. Verify the actual branch, commit, and working tree before trusting the checkpoint. A tool without checkout access needs the relevant files supplied explicitly.

At a real handoff, update the active spec; for a small task, transfer this in the next conversation instead of creating a tracking file:

```text
Goal and acceptance criteria:
Branch and base commit:
Modified files and uncommitted work:
Decisions already made:
Checks run and results:
Remaining work or blockers:
Next concrete action:
```

Include relevant constraints and prior approvals with the decisions. Record exact checks and the state they covered; do not treat an older pass as evidence for later edits. Update at a handoff, not after every edit.

Notes do not transfer uncommitted code. For another checkout or machine, transfer the actual changes through a maintainer-controlled patch or authorized Git action. Confirm the code is available before continuing. Keep durable guidance in project docs rather than copying it into editor-specific memory.

## Git actions

Respect the repo's branch, worktree, and commit-message conventions. Do not prescribe a default branch or create branches/commits as required workflow phases. Stage, commit, push, merge, publish, and deploy only when explicitly authorized. Carry that authorization forward within its scope; completing implementation and review does not require any of these actions.
