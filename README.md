# ai-dev-workflow

A portable [Agent Skill](https://agentskills.io/) that bootstraps or audits a pragmatic AI-assisted development workflow into any software repository. Harness-agnostic — works with Claude Code, Codex, Cursor, Cline, OpenCode, Gemini CLI, and any other harness that supports the Agent Skills standard.

What it generates (minimal, only what will be read):

- `AGENTS.md` — the canonical agent-instruction file (single source of truth)
- A two-gear development workflow (quick loop for small changes, full loop for features)
- Spec + ADR templates under `docs/`
- A deterministic verification contract — nothing is "done" until the repo's checks are green
- Thin harness adapters (one-line pointers, never duplicated content)

Subcommands: `init`, `inspect`, `doctor`, `spec`, `verify`.

## Install via skills.sh

The skill is published as a one-skill repo, so it installs by `owner/repo`:

```bash
npx skills add Kashif-Rezwi/ai-dev-workflow
```

For the real provider flow — installed globally, registered in `~/.agents/.skill-lock.json`, symlinked into every detected harness, and updatable via `npx skills update`:

```bash
npx skills add Kashif-Rezwi/ai-dev-workflow -g -a '*' -y
```

`npx skills ls -g` will then list `ai-dev-workflow` with `Source: Kashif-Rezwi/ai-dev-workflow`.

## Manual install (no CLI)

Copy this skill folder into any directory your harness scans (for example the shared cross-harness store):

```bash
cp -R <this dir> ~/.agents/skills/ai-dev-workflow   # harness-agnostic standard path
```

Or into a harness-specific path, e.g. `~/.claude/skills/ai-dev-workflow` for Claude Code, `~/.codex/skills/` for Codex, etc.

## Verify the install

```bash
npx skills ls -g                 # lists ai-dev-workflow
```

Then restart any running harness session — skills are enumerated at session start.

## Use

In any repository, ask your agent:

```
Use the ai-dev-workflow skill to initialize this repository.
```

The skill inspects the repo, shows a plan, and — with your approval — generates a minimal, self-sufficient AI workflow baseline. Re-running it is a safe no-op.

## Development

- `./validate.sh` — validates this skill against the Agent Skills standard (frontmatter, YAML, progressive disclosure).
- Repo layout: `SKILL.md` (entry point) plus `references/`, `templates/`, `checklists/`.

## License

MIT — see [LICENSE](LICENSE).