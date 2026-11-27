# ai-dev-workflow

A portable [Agent Skill](https://agentskills.io/) for establishing and maintaining a practical AI-assisted workflow in a software repository. It helps work continue across chats, editors, and harnesses through ordinary project instructions, development guidance, and concise handoff checkpoints.

It reuses existing docs and configuration first, adding only what has a concrete purpose:

- Shared `AGENTS.md` instructions and thin harness adapters where discovery needs them
- A two-gear workflow, with planning depth based on scope, risk, compatibility, and reversibility
- A verification contract based on the repo's actual commands, dependencies, and lifecycle hooks
- Feature specs when substantial work needs them; separate ADRs only for real durable decisions
- Handoff checkpoints in active specs, or conversationally for small tasks, without another tracking directory

The resulting workflow remains usable without this skill installed. Passing checks provide evidence; completion also requires reviewing acceptance criteria and disclosing unperformed checks. Handoff notes describe the state of work but do not transfer uncommitted code.

Subcommands: `init`, `inspect`, `doctor`, `spec`, `verify`.

## Install via skills.sh

The skill is published as a one-skill repo, so it installs by `owner/repo`:

```bash
npx skills add Kashif-Rezwi/ai-dev-workflow
```

For a global installation targeting all supported agents:

```bash
npx skills add Kashif-Rezwi/ai-dev-workflow -g -a '*' -y
```

For a repeatable trial of **1.1.0**, pin the skill's source commit. This example
targets Codex globally; select the agent you actually use:

```bash
npx skills add Kashif-Rezwi/ai-dev-workflow@f48d74589a3c52c600b5fd156f540163e0f73d32 --skill ai-dev-workflow --global --agent codex
```

The unpinned examples follow the repository's default branch at installation time.
A source commit identifies the selected contents; `metadata.version` identifies
the declared release. The pinned example is a known release, not an automatic
request for the newest revision.

Review the CLI's output for the installed locations and selected agents. See the [official CLI reference](https://github.com/vercel-labs/skills/blob/main/docs/commands.md) for current flags and update behavior. The separate [skills catalog](https://github.com/Kashif-Rezwi/skills) lists skills; this repository is the source for `ai-dev-workflow`.

## Manual install (no CLI)

Copy the complete skill folder into a directory supported by your harness. For example, if it supports the shared store:

```bash
cp -R /path/to/ai-dev-workflow ~/.agents/skills/ai-dev-workflow
```

Check the harness's current skill-discovery documentation for its supported locations. Copy only into an absent destination; preserve an existing installation rather than nesting or overwriting it. No repository install script is required.

## Verify the install

```bash
npx skills ls -g                 # lists ai-dev-workflow
```

Open `SKILL.md` at the **installed location reported by the CLI**, rather than
reading a source checkout. Check `metadata.version`; the pinned trial above should
show `1.1.0`. For the shared-store Unix installation, that file is
`~/.agents/skills/ai-dev-workflow/SKILL.md`.

For a CLI-managed global installation, inspect the `ai-dev-workflow` entry in
`~/.agents/.skill-lock.json` when present. Check its source and recorded commit
against the revision selected above. Metadata and bookkeeping do not detect every
manual edit; a stronger integrity check compares the installed file set and bytes
with that commit, including references, templates, and checklists.

The CLI listing checks a CLI-managed installation, not actual harness loading or a manual copy. Start a fresh session and confirm the harness can discover/use `ai-dev-workflow` through its supported skill interface.

Installing a skill makes its procedures available. Loading a project's instructions is a separate step: see [harness adapters and discovery](references/harness-adapters.md). A harness without skills support can read `SKILL.md` explicitly; the generated repository guidance does not depend on skill discovery.

## Use

Open a fresh agent session in the root of the repository you want to set up, then ask:

```
Use the ai-dev-workflow skill to initialize this repository.
First report the installed skill path and metadata.version.
Inspect existing instructions, Git state, docs, and checks, then state a plan.
Apply scoped workflow documentation/configuration changes and preserve existing content.
Do not install dependencies, change CI, or stage, commit, push, merge, tag, or publish.
Run appropriate checks and report evidence, limitations, and unperformed checks.
```

The skill inspects the repo, states a concise plan, then performs the authorized changes. It asks only for essential missing information or material scope decisions. Existing instructions, docs, settings, scripts, branch conventions, and uncommitted work are preserved through focused patches. Re-running `init` makes no changes when the needs are already covered; a managed marker is not permission to regenerate a file.

- `init`: establish or improve the workflow with minimal additions.
- `inspect`: read-only inventory and coverage report.
- `doctor`: read-only diagnosis and focused proposed fixes, unless repairs are also authorized.
- `spec <feature>`: create a concrete spec using the existing planning format/location.
- `verify`: follow the repository's appropriate verification contract and report evidence and limits.

### Confirm setup in your repository

1. Review the actual diff: shared instructions, a development/verification workflow,
   and handoff guidance should be usable, reusing existing docs where appropriate.
   Commands must match the target repository and identify their working directories.
2. Start a fresh session rooted in that repository and confirm which project
   instructions the harness loaded through its supported inspection facility.
   Report this separately from static file/config checks.
3. Repeat `init` on the resulting setup. If its needs are covered, it should make
   no further changes. Use `doctor` for read-only diagnosis and `verify` for the
   target repository's checks. This skill's `validate.sh` checks the skill package;
   it does not validate another repository's setup.

Record the skill revision, target Git state, changes, checks, and loading evidence
when reporting a trial. An existing-install comparison or static validation is
not a clean-user installation and first-session test.

## Development

- [Development guide](docs/development.md) and [repository instructions](AGENTS.md) — planning, implementation, verification, review, and handoffs for contributors to this repository.
- [Roadmap](docs/roadmap.md) — planned work, linked specs, and where to resume.
- The source release version lives in `SKILL.md` under `metadata.version`; it does not version or automatically refresh generated repository files.
- `./validate.sh` — lightweight static checks: frontmatter structure, required string fields with a YAML runtime, name syntax/length and matching folder name, description length, and recognized skill-path references. It also checks that reference/checklist files are mentioned by another Markdown file; this is not a proof of full reachability or behavior.
- YAML parsing uses an available Python+PyYAML or Ruby runtime, accepting LF or CRLF frontmatter; without one, the validator warns and uses limited single-line name/description heuristics confined to the frontmatter. It does not install dependencies or establish complete Agent Skills compliance.
- The validator does not evaluate generated repo behavior, preservation, repeated initialization, requirement coverage, or live harness loading. Validate changes with temporary valid/invalid metadata fixtures and representative minimal, configured, and customized repos. Inspect actual artifacts, preserved content, repeated-run diffs, and check execution; matching headings/wording is insufficient. Report static/scenario checks separately from any live agent/harness evaluation.
- Repo layout: `SKILL.md` (entry point) plus `references/`, `templates/`, `checklists/`.

## License

MIT — see [LICENSE](LICENSE).
