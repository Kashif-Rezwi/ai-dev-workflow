# Roadmap

Use this page to find planned work. Detailed requirements, implementation steps, acceptance criteria, and handoffs live in the linked spec.

## Next: assess and improve existing workflows

- **Status:** proposed; implementation has not started.
- **Candidate release:** 1.2.0, after implementation and validation. The current source version remains in [SKILL.md](../SKILL.md).
- **Plan:** [Evaluate and improve existing workflows](specs/existing-workflow-assessment.md).

Extend `doctor` with an evidence-based assessment shared by `init`: recognize equivalent existing workflows, score their guidance with visible evidence limits, flag gaps, and recommend focused improvements. Capture custom requirements separately and preserve effective repository conventions and content.

### Follow-up sequence

1. Define the shared assessment rubric and integrate it with the existing modes, following the spec's [implementation plan](specs/existing-workflow-assessment.md#implementation-plan).
2. Evaluate scoring, custom requirements, preservation, and repeated-run behavior using the spec's [validation scenarios](specs/existing-workflow-assessment.md#verification-and-review).
3. Complete the acceptance review before updating the source version. Git actions, installation, and publication remain separate work requiring authorization.

### Continue the work

Read [SKILL.md](../SKILL.md) and the spec's [handoff checkpoint](specs/existing-workflow-assessment.md#handoff-checkpoint), then verify the actual branch, commit, and working tree. Preserve existing staged and uncommitted work.

**Next action:** review the proposed spec, then begin the shared assessment reference when implementation is authorized. Update task details and evidence in that spec; keep this roadmap as a short navigation and status summary.

## After the assessment phase: learn from self-use

**Status:** future exploration, after the existing-workflow assessment phase above.

Continue using the installed skill to support development of its own source
repository. Once the assessment phase is complete, revisit that experience together
to brainstorm and evaluate opportunities for the skill to improve itself. The
scope and approach for those improvements will be shaped by that discussion.
