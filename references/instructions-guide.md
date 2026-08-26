# Writing Effective AGENTS.md

How to fill the AGENTS.md template well. The generated file is the first thing every agent reads — it must be small, factual, and operational.

## Hard rules

1. **Size discipline: target ≤120 lines.** Instruction files get truncated (Codex: 32KB default) and diluted (over-specified files get ignored). Every line must earn its place.
2. **Facts, not essays.** Commands, paths, boundaries. Prose about philosophy belongs in `docs/development.md`.
3. **Detected, not generic.** Every command in the table must actually exist in the repo. A wrong command is worse than a missing one.
4. **Formatting/lint style rules live in tooling config, not prose.** Reference the config ("ESLint flat config, Prettier") instead of restating rules agents can't verify.
5. **One AGENTS.md per repo** for small/medium projects. Nested files only for monorepos with genuinely different sub-project conventions.

## The six core areas (in order)

1. **Project identity** — one or two sentences: what it is, what it does.
2. **Stack & layout** — detected languages/frameworks; a small path→purpose table.
3. **Commands** — install, dev, build, test, lint, typecheck, verify. Only real ones.
4. **Verification** — the definition of done: what to run before declaring anything complete.
5. **Boundaries** — what agents must not do (see below).
6. **Doc map** — where deeper context lives, loaded just-in-time.

## The boundaries block (always include, adapt to the repo)

- Stay in task scope; no drive-by refactors or unrelated "cleanups".
- No new dependencies without justification and approval.
- Never commit/push without explicit approval; draft the message, human decides.
- Never modify CI, deployment config, secrets, or environment files without explicit approval.
- Never edit applied database migrations (if the repo has migrations); new changes = new files.
- Preserve working behavior; match the style of the file being edited.

Add repo-specific boundaries discovered during inspection (e.g. "`packages/types` is the shared contract — don't duplicate shapes").

## Harness pointers

AGENTS.md is the single source of truth. See `harness-adapters.md` for the thin pointer files; never duplicate AGENTS.md content into them.

## What NOT to put in AGENTS.md

- Status/progress/changelog content (rots fast; belongs in git history or a status doc the project explicitly maintains)
- Full style guides (point to formatter/linter configs)
- API references or long architecture descriptions (point to `docs/`)
- Anything the agent reliably does correctly without being told
