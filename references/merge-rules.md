# Merge Rules — Safety & Idempotency

Every file decision during `init`/`doctor` follows this matrix. These rules are absolute; they are what make the skill safe to run against real repositories.

## The action matrix

| Situation | Action | Behavior |
|---|---|---|
| File absent | **CREATE** | Generate from template, filled with detected facts |
| File exists, has the managed marker, content matches what the skill would generate | **NO-OP** | Report as up to date |
| File exists, has the managed marker, skill template evolved | **REFRESH** | Regenerate; show a diff summary first |
| File exists, has the managed marker, but human modified it | **PRESERVE + report** | The human's edits win. Show what a refresh would change; ask |
| File exists, no managed marker | **PRESERVE + report** | Human-owned. Never modify without explicit approval |
| File exists and contradicts detected reality | **WARN** | Flag in the report with evidence; propose a fix; change nothing |

## The managed marker

Skill-generated files carry one HTML comment on the first line:

```
<!-- ai-dev-workflow:managed v1 -->
```

- Presence = "the skill may refresh this file".
- If the human edits the file, the marker stays but the content differs → PRESERVE (treat as adopted by the human).
- If the human deletes the marker, the file is human-owned forever.
- Never add the marker to a file the skill didn't create.

## Special files

| File | Rule |
|---|---|
| `AGENTS.md` (existing, no marker) | Human-owned. If it's good → report "already AI-ready" and stop. If it has gaps → propose specific additions as a diff; apply only on approval |
| `CLAUDE.md`, `GEMINI.md`, `.cursor/`, `.github/` | Human-owned unless created by the skill. Pointer files the skill created are managed |
| `package.json` / manifests | Never edit silently. Propose script additions (e.g. `verify`) as an exact diff; apply on approval |
| CI configs | Never modify existing CI. Offer the template as a new file only when no CI exists |
| Lockfiles, `.env*`, secrets | Never touch. If secrets appear in tracked files, stop and warn |

## Idempotency contract

Re-running `init` must be boring:
1. Detection runs fresh every time (never cache conclusions).
2. Every file resolves to NO-OP, REFRESH (with diff), or PRESERVE.
3. A fully-initialized repo reports "already AI-ready. 0 changes."
4. No duplicated sections, no appended blocks, no timestamp churn in files that didn't change.

## Reversibility

- Everything generated is plain markdown/config tracked by git — `git diff` and `git checkout` are the undo mechanism.
- Before the first write in a repo with uncommitted changes, report the dirty state and ask whether to proceed.
- Never delete files during `init`. Deletions are always a human decision.

## Asking vs acting

Ask before: overwriting anything, editing manifests, creating CI, adding scripts, committing, deleting.
Act without asking: reading files, running read-only detection commands, running the repo's existing verification commands, creating files the user already approved in the plan.
