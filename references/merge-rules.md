# Merge Rules — Preservation & Repeated Runs

Use these rules during `init` and authorized repairs after `doctor`. Read the existing content before proposing a change, including files carrying a managed marker.

## The action matrix

| Situation | Action | Behavior |
|---|---|---|
| Guidance absent and useful now | **CREATE** | Adapt the relevant template using detected facts |
| Existing content already serves the need | **NO-OP** | Keep it, even if it differs from the current template |
| Confirmed gap with an authorized remedy | **PATCH** | Apply the smallest useful diff; retain surrounding content |
| Existing content outside scope or of uncertain intent | **PRESERVE** | Report only relevant gaps or questions |
| Content contradicts detected facts | **WARN** | Cite evidence; propose a focused patch, applying it only within authorization |

## The managed marker

Older generated files may carry this HTML comment:

```
<!-- ai-dev-workflow:managed v1 -->
```

The marker records provenance only. It cannot distinguish a human edit from a changed generator template, and grants no permission to regenerate. Do not infer ownership from its presence or absence. New files need no marker; leave existing markers alone unless their removal is part of the requested work. No hashes, state database, or ownership registry are needed.

## Special files

| File | Rule |
|---|---|
| Instructions and docs | Reuse existing locations. Patch missing guidance without duplicating sections or replacing project rules |
| Harness settings and adapters | Preserve unrelated fields, comments, and instructions. See `references/harness-adapters.md` for structural merges |
| Manifests | Show the exact proposed script change and its dependency/hook analysis; apply only when authorized |
| CI configs | Preserve existing CI. New CI needs explicit authorization; a GitHub remote alone is not permission |
| Lockfiles, `.env*`, secrets | Outside workflow initialization. Do not modify or copy credentials into generated guidance |

## Repeated-run contract

Re-running `init` must be boring:
1. Detection runs fresh every time (never cache conclusions).
2. Match guidance by its purpose and actual behavior, not exact headings or template wording.
3. A coherent repo reports "already AI-ready. 0 changes." An incomplete setup receives only the missing, authorized additions.
4. No duplicate sections, imports, or settings entries; no timestamp, formatting, or path churn in unchanged content.

## Reversibility

- Generated guidance is ordinary Markdown/config. Review `git diff` and revert only this task's changes if necessary; broad checkout/reset commands can discard unrelated work.
- Identify existing uncommitted work and preserve it. A dirty tree alone does not require confirmation. Ask if overlapping work creates a material ambiguity you cannot resolve safely.
- Do not delete existing files during `init`.

## Asking vs acting

Carry existing approvals forward. An initialization or repair request authorizes the relevant doc/config changes, not unrelated tooling, dependency, CI, or Git actions. Read and plan first; ask only for essential information, a material scope decision, or an action not yet authorized. `inspect` and ordinary `doctor` remain read-only.
