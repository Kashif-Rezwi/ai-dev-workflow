# Writing Effective AGENTS.md

How to adapt the AGENTS.md template. Keep shared instructions small, factual, and operational; actual discovery must be confirmed for the harness in use.

## Hard rules

1. **Size discipline: aim for a short root guide.** Keep detail in the relevant documents and load it when needed. Respect the installed harness's context limits; a line count alone does not establish quality.
2. **Facts, not essays.** Commands, paths, boundaries. Detailed procedures belong in the repo's existing development/contribution guide.
3. **Detected, not generic.** Every command in the table must actually exist in the repo. A wrong command is worse than a missing one.
4. **Formatting/lint style rules live in tooling config, not prose.** Reference the config ("ESLint flat config, Prettier") instead of restating rules agents can't verify.
5. **Avoid unnecessary instruction files.** A root AGENTS.md is often sufficient; add scoped files only for genuinely different conventions. Preserve useful existing scoped guidance.

## The six core areas (in order)

1. **Project identity** — one or two sentences: what it is, what it does.
2. **Stack & layout** — detected languages/frameworks; a small path→purpose table.
3. **Commands** — install, dev, build, test, lint, typecheck, verify. Only real ones, with their working directory and relevant environment. Keep distinct subproject tooling and verification contracts explicit.
4. **Verification** — the established contract, area-specific checks, and evidence needed to assess completion.
5. **Boundaries** — what agents must not do (see below).
6. **Doc map** — where deeper context lives, loaded just-in-time.

## Boundaries (adapt to the repo and authorized task)

- Stay in task scope; no drive-by refactors or unrelated "cleanups".
- No new dependencies without justification and approval.
- Stage, commit, push, merge, publish, or deploy only when explicitly authorized; implementation completion does not require Git actions.
- Never modify CI, deployment config, secrets, or environment files without explicit approval.
- Never edit applied database migrations (if the repo has migrations); new changes = new files.
- Preserve working behavior; match the style of the file being edited.

Add repo-specific boundaries discovered during inspection (e.g. "`packages/types` is the shared contract — don't duplicate shapes").

Preserve the repo's branch, runtime, package-manager, and commit conventions. Ask only for missing information or material decisions beyond the authorized scope. Existing approvals remain valid; do not generate repeated approval gates.

## Adapting templates and document links

Templates are starting points, not a mandatory file tree. Reuse existing development, contribution, architecture, and planning docs. Populate the documentation map with actual paths only; omit rows for absent specs/ADRs. Point workflow and handoff guidance at its real location.

Resolve every slot in generated output. Remove sections without evidence rather than adding filler. In a minimal repository, omit package-manager claims, empty layout/command tables, and speculative architecture. If adapting a reusable spec template into the repo, replace skill slots with clear writing prompts; active specs should contain concrete task information.

## Harness pointers

Keep shared rules in AGENTS.md. See `references/harness-adapters.md` for discovery and adapters; preserve useful harness-specific instructions without duplicating shared rules.

## What NOT to put in AGENTS.md

- Status/progress/changelog content (keep active task state in the spec or conversation; do not add a continuous activity log)
- Full style guides (point to formatter/linter configs)
- API references or long architecture descriptions (point to `docs/`)
- Anything the agent reliably does correctly without being told
