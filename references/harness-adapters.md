# Harness Adapters

Keep shared project rules in `AGENTS.md`. Add thin adapters only for harnesses in use when discovery needs them. Existing scoped or harness-specific guidance remains useful; preserve it rather than replacing it with a pointer. Skill installation and project-instruction loading are separate mechanisms.

## Support matrix

| Harness | Project instruction discovery | Adapter decision |
|---|---|---|
| Codex | Native `AGENTS.md`, with directory scope and configurable discovery | Usually none; inspect existing configuration |
| Cursor | Supports `AGENTS.md` alongside project rules | Usually none; preserve scoped rules |
| OpenCode | Supports `AGENTS.md`; discovery depends on workspace and settings | Usually none; inspect effective configuration |
| Claude Code | Native `AGENTS.md` from v2.1.277, subject to session/settings and existing Claude instruction files | Use native loading when confirmed, or an `@AGENTS.md` import in `CLAUDE.md` |
| Gemini CLI | Default `GEMINI.md`; configurable `context.fileName` | Add `AGENTS.md` to the configured names, or use an existing `GEMINI.md` import |
| Aider | Read-only context via `read` in `.aider.conf.yml` | Merge `AGENTS.md` into the existing read entries |
| Other harnesses | Consult official docs for the installed version and effective settings | Use native discovery if supported, otherwise its documented adapter or explicitly supplied instructions |

Support varies by version, workspace root, trust, and user/organization settings. Inspect those facts rather than assuming a config directory proves instructions load. Do not add agents, hooks, permissions, or global settings to solve discovery by default.

## Adapter files the skill may generate

### Claude Code — native discovery or `CLAUDE.md` import

```
@AGENTS.md
```

For versions before v2.1.277, or sessions where native discovery is unavailable, use the import. On supported versions, existing `CLAUDE.md`, `.claude/CLAUDE.md`, or `CLAUDE.local.md` in the working directory or its ancestors can take precedence over direct `AGENTS.md` loading. Check the installed version and effective Project instructions setting. Earlier supported versions also have session limitations; consult the official memory guide below.

If a `CLAUDE.md` already exists, preserve its instructions and add the import only if needed and authorized; do not duplicate an existing import. Resolve the path relative to the importing file (`.claude/CLAUDE.md` needs a different relative path). Prefer a project import over changing personal/global settings. A new adapter can be just the import line.

### Gemini CLI — `.gemini/settings.json`

```json
{
  "context": {
    "fileName": ["AGENTS.md", "GEMINI.md"]
  }
}
```

This is a minimal new-file example, not a replacement for existing settings. Read the config and merge only `context.fileName`:

- If absent, add `["AGENTS.md", "GEMINI.md"]` to retain default discovery.
- If a string, retain that filename and add `AGENTS.md`; if an array, preserve its entries/order and add `AGENTS.md` only when absent. Do not force `GEMINI.md` into an explicitly customized list.
- Preserve other `context` fields, top-level settings, and comments. If a different format or schema is present, inspect the version's docs before editing.
- If an existing `GEMINI.md` already imports `AGENTS.md` using `@` syntax, an additional settings adapter may be unnecessary. Avoid loading the same shared content through multiple paths.

### Aider — `.aider.conf.yml`

```yaml
read:
  - AGENTS.md
```

For an existing file, merge structurally into its single `read` key. Preserve existing filenames and other settings. A scalar path can become a list with that path and `AGENTS.md`; an existing list gains `AGENTS.md` only if absent (including an equivalent `./AGENTS.md` entry). Never append a second `read:` key. Keep YAML comments where possible; do not install a parser just for this edit. If duplicate keys or unexpected value types already exist, report the ambiguity and resolve it before writing.

For example, `read: [CONVENTIONS.md]` becomes `read: [CONVENTIONS.md, AGENTS.md]`, leaving model, lint, and other options intact. A repeated run leaves it unchanged. Inspect effective config sources: Aider loads home, repo-root, and current-directory configs in order, or only the file passed with `--config`.

## Validate discovery

First check config syntax, preserved fields, import targets, and duplicate entries. Then, when a live session is available, start in the intended repository/workspace and confirm the loaded instructions:

- Claude Code: `/memory` can show loaded files. Directly loaded `AGENTS.md` is listed from v2.1.280; older native-support versions need the startup loading message or a check of the actual project instructions instead. Imported instructions can be inspected through their `CLAUDE.md`.
- Gemini CLI: `/memory show` displays loaded context; reload or start a fresh trusted session after changing discovery settings.
- Other harnesses: use their current inspection facility or observe the loaded context in a fresh session. Do not use application tests as a substitute.

Report static config checks and live instruction-loading confirmation separately, including version, workspace, and any unperformed live check.

## Installation and official references

See `README.md` for installing this skill. Installing it makes its procedures available to a harness; it does not establish that the harness loaded a target project's `AGENTS.md`. Conversely, the generated instructions, development guide, and active specs remain usable without installing this skill. A tool without discovery support can receive the relevant files explicitly.

Consult these official sources when adapting to an installed version (reviewed 2026-11-28):

- [Codex project instructions](https://developers.openai.com/codex/guides/agents-md)
- [Cursor rules and AGENTS.md](https://cursor.com/docs/rules)
- [OpenCode instructions](https://opencode.ai/docs/instructions/)
- [Claude Code memory, imports, and AGENTS.md](https://code.claude.com/docs/en/memory)
- [Gemini CLI context files and filename settings](https://geminicli.com/docs/cli/gemini-md/)
- [Aider YAML configuration and lists](https://aider.chat/docs/config/aider_conf.html)
