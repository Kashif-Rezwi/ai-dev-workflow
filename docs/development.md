# Developing ai-dev-workflow

Read [AGENTS.md](../AGENTS.md) for repository rules and the [README](../README.md)
for skill usage and validation limits. This guide applies to developing the skill
itself and works from a checkout without an installed skill.

## Using the skill on itself

Use the installed `ai-dev-workflow` for this repository's `init`, `inspect`,
`doctor`, `spec`, and `verify` tasks. Identify its path and `metadata.version`
before use; check installation provenance when evaluating the consumer experience.
The installed release and the source under development are separate copies:
use source instructions as the candidate under test only when explicitly requested.

For everyday implementation, follow this guide and its linked checklists; the
skill's modes are for workflow setup, inspection, diagnosis, specs, and verification.
When the skill is unavailable, this guide and the bundled references still apply.
Do not reinstall or update the installed copy as a side effect of development.

## Orient and plan

Run commands from the repository root, the directory containing `SKILL.md` and
`validate.sh`. Confirm the actual state before using a checkpoint:

```bash
git branch --show-current
git rev-parse HEAD
git status --short
```

Choose planning depth by scope, risk, compatibility, and reversibility, following
the [two-gear workflow](../references/workflow.md):

- For a clear, local, reversible change, state the intended result, affected files,
  and checks in the conversation. Use the [quick-change checklist](../checklists/quick-change.md);
  a separate spec is unnecessary.
- For substantial skill behavior or compatibility changes, use `docs/specs/`.
  Reuse the relevant spec or adapt the [feature-spec template](../templates/docs/specs/feature-spec.md.tmpl).
  Record goals, non-goals, observable acceptance criteria, constraints, and ordered
  tasks with affected files and checks. Use the [full-change checklist](../checklists/full-change.md).

Use the [roadmap](roadmap.md) to find planned work. The
[existing-workflow assessment spec](specs/existing-workflow-assessment.md) is a
proposed 1.2.0 feature, not authorization to implement it. Its historical Git
checkpoint is context, not the current checkout state. Carry existing approvals
forward; ask only for essential missing information or material scope decisions.

## Implement

Keep `SKILL.md` focused on reusable skill behavior and load supporting references
when needed. Keep repository development instructions in `AGENTS.md` and this guide.
Reuse existing references, checklists, and templates instead of copying whole
procedures or creating another planning tree. Follow the
[preservation and repeated-run rules](../references/merge-rules.md).

Make the smallest coherent patch and preserve useful existing content. Match the
surrounding Markdown and relative-link conventions. Resolve slots in generated
documents; keep intentional slots in reusable `.tmpl` files. Update the relevant
spec if findings materially change an authorized implementation plan. Do not treat
a source change as permission to bump `metadata.version`, install the skill, or
modify a globally installed copy.

## Verification

For documentation, instruction, or skill-content changes, run from the repository root:

```bash
./validate.sh
git diff --check
```

The validator uses Bash and standard Unix tools, preferring an installed
Python 3 + PyYAML or Ruby YAML runtime and otherwise warning about limited heuristics.
See the [README](../README.md#development) for exact coverage and limits. It has no
install/build hooks or publishing step. No application build, test suite, formatter,
or linter contract exists; do not install tooling without authorization.

For changed docs, check relative links and anchors, command working directories,
unresolved slots, contradictions, and overlap with existing guidance. Inspect new
files explicitly: ordinary `git diff` and `git diff --check` omit untracked files.

If changing `validate.sh`, also run `bash -n validate.sh` and exercise temporary
valid/invalid metadata fixtures. Keep each copied skill in a directory named
`ai-dev-workflow`, since the validator compares the metadata name with its containing
directory. Do not mutate the source or installed copy to create invalid fixtures.

For changes to reusable skill behavior, use the README's temporary repository
scenarios: inspect artifacts, preserved content, check execution, and repeated-run
diffs. For initialization-only documentation changes, manually reinspect coverage
for any remaining gap; distinguish that evaluation from an actual repeated agent run.

Report exact commands and results, manual review, behavioral/scenario checks, and
live harness loading separately. For discovery changes, inspect relevant settings
and import targets using the [adapter guide](../references/harness-adapters.md).
Confirm loading in a fresh real session rooted in this repository when available;
reading a file with a shell or passing static checks does not confirm automatic
loading. Disclose unperformed checks. Stop dependent checks on failure and report
unrelated failures separately; repeat passing checks only after relevant changes
or to resolve a concrete concern.

## Review and hand off

Use the [shared final review](../checklists/pre-merge-review.md) for either gear.
Read the complete diff, including new files, against the requested outcome and
acceptance criteria. Check preservation, unnecessary structure, stale links, and
scope. Review can be complete without staging or committing.

For unfinished substantial work, update the active spec's checkpoint; for a small
task, transfer it conversationally. Use the existing
[handoff format](../references/workflow.md#continuing-in-another-session-editor-or-harness):
goal and acceptance criteria, branch/base commit, modified files and uncommitted
work, decisions and approvals, exact checks/results, remaining work, and next action.
At resumption, read the instructions, guide, and relevant spec and recheck Git state.
Notes do not transfer uncommitted code; supply the actual changes to another checkout
through a maintainer-controlled patch or separately authorized Git action.

## Git conventions

Existing history uses short descriptive commit subjects; no branch naming policy
or mandatory commit format is documented. Follow current maintainer/task instructions
instead of inferring a required branch from old specs. Preserve unrelated staged
and unstaged work. Staging, commits, pushes, merges, tags, publication, and installation
are separate actions requiring explicit authorization.
