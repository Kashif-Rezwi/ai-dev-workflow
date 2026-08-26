# Harness Adapters

AGENTS.md is the single source of truth. Adapters are thin pointers generated **only** for harnesses the user confirms they use, or whose config directories already exist in the repo. Never duplicate AGENTS.md content into an adapter.

## Support matrix

| Harness | AGENTS.md support | Adapter needed |
|---|---|---|
| OpenAI Codex | Native (root + nested, nearest wins) | None |
| OpenCode | Native | None |
| Cline | Native | None |
| pi | Native — Agent Skills standard; reads `~/.agents/skills` + `~/.pi/agent/skills` | None |
| Cursor | Native (root + nested) | None |
| GitHub Copilot coding agent | Native | None |
| Roo Code / Kilo Code | Native | None |
| Aider | Via config: `read: AGENTS.md` in `.aider.conf.yml` | Optional config line |
| Gemini CLI (deprecated → agy) | Via settings: `"context": { "fileName": ["AGENTS.md", "GEMINI.md"] }` in `.gemini/settings.json` (Gemini CLI is being retired for individuals; the Antigravity successor `agy` supports skills — discovery path TBD) | Settings snippet |
| Claude Code | Via pointer file | `CLAUDE.md` containing `@AGENTS.md` |
| Windsurf / Zed / Jules / Amp / Junie | Native or AGENTS.md-compatible | None |

## Adapter files the skill may generate

### Claude Code — `CLAUDE.md` (managed)

```
<!-- ai-dev-workflow:managed v1 -->
@AGENTS.md
```

One import line. Nothing else. If a human-owned `CLAUDE.md` already exists, PRESERVE it and report.

### Gemini CLI — `.gemini/settings.json` (managed)

```json
{
  "context": {
    "fileName": ["AGENTS.md", "GEMINI.md"]
  }
}
```

If `.gemini/settings.json` already exists, merge the `context.fileName` key only — never clobber other settings. Show the merged result before writing.

### Aider — `.aider.conf.yml` (managed)

```yaml
read: AGENTS.md
```

Only if the user uses Aider. If the file exists, append `read: AGENTS.md` only if absent.

## This skill's own installation (for users)

The skill folder installs by symlink into harness skill directories:

| Location | Harnesses that discover it |
|---|---|
| `~/.agents/skills/ai-dev-workflow` | Codex, OpenCode, Cline, pi and other Agent Skills standard clients |
| `~/.claude/skills/ai-dev-workflow` | Claude Code |
| `~/.cursor/skills/ai-dev-workflow` | Cursor |
| `~/.config/opencode/skills/ai-dev-workflow` | OpenCode (global config path) |
| `~/.gemini/skills/ai-dev-workflow` | Gemini CLI (deprecated → agy; discovery path TBD) |

`install.sh` in the skills repo creates these symlinks idempotently. Project-scoped installs (`.agents/skills/`, `.claude/skills/`) work the same way for teams that want the skill versioned with a repo.

Harnesses without skills support can still use the workflow: point the agent at `SKILL.md` manually, or paste the relevant procedure into the conversation. The generated repo files (AGENTS.md + docs/) carry the workflow — the skill is only the bootstrapper.
