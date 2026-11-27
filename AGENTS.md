# Repository instructions

This repository develops `ai-dev-workflow`, a portable Agent Skill. Keep
[`SKILL.md`](SKILL.md) as the reusable skill entry point; instructions for
developing this repository belong here and in the
[development guide](docs/development.md).

For this repository's `init`, `inspect`, `doctor`, `spec`, and `verify` tasks, use
the installed `ai-dev-workflow` when available, identifying its location and version
first. See [using the skill on itself](docs/development.md#using-the-skill-on-itself).

## Layout and tooling

- `SKILL.md`: mode routing, procedures, and source version in `metadata.version`.
- `references/`, `checklists/`: detailed reusable guidance and review criteria.
- `templates/`: adaptable outputs; retain intentional template slots in `.tmpl` files.
- `docs/`: repository development guidance, roadmap, and feature specs.
- `validate.sh`: Bash static validator. There is no package manifest, build,
  application test suite, or CI configuration.

## Verification

Run from the repository root, the directory containing `SKILL.md` and `validate.sh`:

```bash
./validate.sh
git diff --check
```

If editing the validator, also run `bash -n validate.sh` and exercise temporary
metadata fixtures as described in the [development guide](docs/development.md#verification).
Check new files explicitly because ordinary `git diff` omits untracked files.
The validator checks limited metadata and reference structure. Review requirements,
paths, and the complete diff; report static checks, behavioral evidence, and actual
harness instruction loading separately.

## Boundaries

- Check branch, commit, and working tree before editing; preserve unrelated work.
- Make focused changes within the authorized scope and match existing Markdown style.
- Keep development rules out of the reusable skill procedures. Changes to skill
  behavior or version must be part of the requested work.
- Treat roadmap/spec proposals as future work until implementation is authorized.
- Do not refresh installed skill copies as part of source development or verification.
- Dependencies, tooling, CI, and harness adapters require a concrete need and scope
  authorization. Add adapters only for harnesses actually in use when discovery needs them.
- Stage, commit, push, merge, tag, publish, or install only when explicitly authorized;
  implementation and review can finish without these actions.

## Read as needed

- [README](README.md): usage, installation, validator capabilities and limitations.
- [Development guide](docs/development.md): planning, implementation, verification,
  review, Git conventions, and cross-session handoffs.
- [Roadmap](docs/roadmap.md) and [existing-workflow assessment spec](docs/specs/existing-workflow-assessment.md):
  proposed work and its acceptance criteria; verify actual Git state before trusting old checkpoints.
- [Workflow](references/workflow.md), [preservation rules](references/merge-rules.md),
  and [harness adapters](references/harness-adapters.md): detail for changes in those areas.
