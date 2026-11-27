# Spec: Evaluate and improve existing workflows

- **Status:** proposed; planning only
- **Created:** 2026-11-28
- **Baseline:** skill 1.1.0, branch `develop`, commit `e4159cf5ef713a4c0e1aa5fa35c9a4721d2f737b`
- **Release intent:** candidate for a compatible 1.2.0 addition after implementation and validation; no version change in this phase

## Goal

When a repository already has an AI-assisted development workflow, assess and improve that workflow in place. Evaluate it against this skill's principles, explain its strengths and gaps with evidence, provide an understandable score, and incorporate the user's custom requirements without creating a competing workflow.

The current skill already preserves existing files and supports read-only diagnosis. This phase adds a shared assessment rubric, consistent scoring, explicit custom-requirement coverage, and a clearer decision between leaving a setup alone, making focused improvements, and establishing missing guidance.

## Non-goals

- Another workflow generator, command family, assessment service, or compliance certification.
- Requiring exact filenames, headings, template wording, tools, or directory layouts to earn points.
- Automatically rewriting files, running application checks, or changing settings because a score is low.
- New dependencies, hooks, MCP servers, agents, CI, tracking directories, or historical score databases.
- Assessing application-code quality or treating passing tests as proof that the workflow is effective.
- Implementing the feature, bumping the skill version, installing it, or performing Git actions during this planning phase.

## Acceptance criteria

- [ ] `doctor` can assess an existing workflow, score supported findings, identify unknowns, and recommend focused improvements without modifying repository files or settings.
- [ ] `init` uses the same assessment before writing. An adequate existing setup receives no changes; partial setups receive only useful, authorized patches; missing guidance receives a proportionate baseline.
- [ ] Equivalent guidance in contribution guides, existing planning docs, scoped instructions, or supported harness configurations receives equivalent credit. Useful existing content and conventions are retained.
- [ ] Every rating cites its evidence and rationale. Confirmed absence, insufficient access, and non-applicability are distinguishable. Configuration inspection and actual runtime/harness confirmation are reported separately.
- [ ] The score, assessed coverage, unknowns, and serious findings are visible together. No numerical threshold automatically authorizes changes or establishes readiness.
- [ ] Custom requirements are captured from the request and available context, assessed individually, and mapped to existing guidance or a proposed focused change. They cannot conceal baseline gaps or silently increase the baseline score.
- [ ] Conflicts among custom requests, repository conventions, and skill defaults are explained. Existing authorization carries forward; essential unresolved choices are raised before dependent changes.
- [ ] A repeated assessment of the same evidence and requirement set is explainable using the same anchors. Repeated `init` after improvements introduces no duplicate content or unnecessary changes.
- [ ] Large or mixed-language repositories preserve each area's instructions, working directory, tooling, and verification contract. Reports state the assessment's scope and any sampling limits.
- [ ] The generated repository workflow remains usable without the skill installed. All five modes remain available.

## Constraints and principles

Use [the skill entry point](../../SKILL.md), [detection guidance](../../references/detection.md), [preservation rules](../../references/merge-rules.md), and [work loops and handoffs](../../references/workflow.md) as the baseline. Templates illustrate useful content; they are not a conformance checklist.

Interpret guidelines by the outcome they serve. A small repository with a clear manual review contract need not add a test framework. A maintained contribution guide can hold the development workflow. A repository using one harness need not configure others. A supported existing instruction-loading mechanism need not be replaced just to adopt a preferred filename.

User instructions and applicable repository requirements take precedence over skill defaults. Preserve the underlying goals of accuracy, proportionate process, evidence, maintainability, and authorized scope; record intentional adaptations and their trade-offs instead of silently rejecting custom requirements or pretending conflicts do not exist.

Assessment is read-only by default: inspect files, configuration, and relevant existing evidence. Do not automatically execute build/test commands or launch a new harness session, since those can have side effects. If execution is requested, use the existing `verify` procedure and describe exactly what was observed. Prior results must identify the state they covered; stale results are not current confirmation.

## Approach and decision

Extend `doctor`, and share its assessment procedure with `init`. Keep `inspect` as the factual inventory, `spec` as planning, and `verify` as check execution. Natural requests such as "evaluate our workflow", "score this setup", and "audit against these requirements" route to `doctor`.

An additional `assess` command would duplicate `doctor` and create another maintenance path. An executable scoring engine would add machinery without resolving the main judgment problem: recognizing useful guidance in different repository structures. Start with a small, anchored rubric and evidence-based reports in the existing skill architecture.

Keep the detailed rubric and report guidance together in one new reference in the existing `references/` directory, loaded only for assessment or initialization. The entry point should describe routing, scope, and the resulting behavior rather than repeat the rubric.

## Assessment flow

1. **Establish scope:** identify the requested mode, existing authorization, affected repository/workspaces, harnesses in use, and any supplied custom requirements. Ask only for material missing information; do not require a questionnaire before inspecting available context.
2. **Map the current workflow:** locate actual instruction sources, development/contribution guidance, planning records, checks and their dependencies, adapters, and continuation guidance. Inspect content and relationships rather than infer coverage from filenames.
3. **Collect evidence:** record relevant file locations and observations, contradictions, and inaccessible or untested areas. Distinguish documented intent from demonstrated behavior. For large repos, state which areas were inspected and why.
4. **Assess baseline principles:** apply the shared anchored rubric below, with concise rationale and evidence for each dimension.
5. **Assess custom requirements:** show each requirement's coverage, any conflict or adaptation, and the smallest useful improvement. Reuse existing guidance instead of creating a parallel policy document.
6. **Report priorities:** present strengths worth retaining, the score and its limits, confirmed findings, unknowns, and ranked recommendations. A coherent workflow can produce "no changes recommended."
7. **Act only within the request:** an assessment-only request ends with recommendations. An authorized improvement request proceeds with focused patches under the existing preservation rules. Do not ask for approval again when it already covers the action.
8. **Validate changes and reassess affected findings:** show what actually improved, what remains unknown, and which checks were performed. Preserve a handoff only if work remains unfinished.

## Proposed baseline rubric

Use six equally weighted dimensions. Publish dimension-specific examples and anchors in the implementation so different evaluators can explain ratings consistently.

1. **Instruction accuracy and discovery:** shared guidance is findable through the tools in use, commands and paths match the repository, and scoped/harness-specific instructions do not contradict the shared contract.
2. **Proportionate work loop and authorization:** scope/risk determine planning depth, acceptance criteria guide substantial work, existing approvals carry forward, and implementation completion is separate from Git or release actions.
3. **Verification and acceptance review:** the established verification contract is clear, selected checks fit the area, dependencies/hooks are understood, duplicate work is avoided, and automated/manual evidence is mapped to outcomes.
4. **Continuation across sessions and tools:** an active spec or conversation can transfer goal/criteria, branch/base, modified files, decisions, checks/results, remaining work, and next action; code availability is checked separately from notes.
5. **Preservation and maintenance:** useful existing guidance is reused, changes are focused, duplicate rules and unnecessary structure are avoided, and repeated initialization is designed to preserve content.
6. **Repository scope and portability:** commands identify their directories/tooling, distinct workspaces are respected, adapters preserve settings, and the project workflow stands alone without this skill.

For each applicable dimension:

- **0 — missing or incorrect:** inspected evidence establishes absence or a contradiction that prevents the intended outcome.
- **1 — partial:** useful elements exist, with substantial confirmed gaps.
- **2 — usable:** the intended outcome is supported, with specific remaining improvements.
- **3 — coherent:** the inspected guidance is appropriate for the declared scope, with no confirmed material gap in this dimension.
- **Unknown:** evidence needed to rate the dimension is unavailable; state what would resolve it. Confirmed missing guidance is a gap, not Unknown.
- **Not applicable:** use only with an explicit repository-specific reason. Prefer adapting a dimension to the repo's actual scale over excluding it. Missing tooling alone is not a reason to exclude verification.

The numerical score describes assessed guidance quality, not a verified operational guarantee. An unperformed live harness check is disclosed in the evidence record; it does not by itself prove discovery is broken or force a documented discovery design to fail.

For scored dimensions, report `earned points / available points` and a whole-number percentage: `round(100 × sum(points) / (3 × number of scored dimensions))`. No subjective weighting or decimal precision is needed in this phase.

Display assessed coverage alongside the score: scored dimensions / applicable dimensions, plus counts and reasons for Unknown and Not applicable. A score with any applicable Unknown is explicitly provisional. If no dimension can be scored, omit the percentage and report "insufficient evidence" rather than divide by zero or imply a pass. For example, five dimensions totaling 12 points and one Unknown yield `12/15 (80%), provisional; 5/6 assessed`.

Serious findings remain visible regardless of the average. An unsafe side effect in a claimed verification command or a materially wrong command must not be hidden by high scores elsewhere. Do not define "ready" as exceeding an arbitrary score threshold. Include the rubric revision and skill version, assessed Git state, scope, and requirement set so later comparisons are meaningful; do not compare scores from different scopes as if they were equivalent.

## Custom requirements

Capture each distinct requirement with its acceptance evidence and status: **met**, **partially met**, **missing**, **unknown**, or **conflict/decision needed**. Keep this coverage separate from the six-dimension score; adding more easy requirements must not inflate it. Deduplicate repeated requirements.

Map a requirement to the baseline dimension it affects when useful, while retaining its own status and rationale. A documented, intentional adaptation may satisfy the underlying baseline principle; explain why. Optional preferences should be distinguished from required outcomes.

Examples to cover in implementation:

- "Require browser review for interactive changes": inspect the existing verification guide, flag missing coverage, and propose a focused addition there.
- "Keep our contribution guide and current planning location": reuse those locations; do not create a second development guide or specs tree.
- "Use our existing supported instruction source instead of adding AGENTS.md": inspect actual loading and shared-rule coverage; assess the equivalent mechanism on its merits.
- "Skip a required check for this task": respect the authorized scope, disclose the unperformed check and resulting evidence gap, and do not mark the related outcome verified. Do not silently weaken the repository's durable contract.

When a request has material consequences beyond the existing authorization, explain the conflict, consequence, and practical options. Ask only for the essential unresolved choice; continue independent assessment work meanwhile.

## Report and recommendation contract

Keep reports proportional to the request. `init` can give a concise assessment and change plan; an explicit `doctor` request receives the full evidence and recommendations. Deliver in the conversation by default; save only when requested, using an existing appropriate document or the active spec. Do not create an audit directory or an activity log.

Include:

- Scope, skill/rubric revision, Git state, evidence limits, and retained strengths.
- Baseline ratings with evidence/rationale, total score with coverage, and custom-requirement statuses.
- Findings ordered by impact, with confirmed facts distinguished from uncertainty or preference.
- Each recommendation's existing target location, proposed focused change, reason, compatibility/maintenance trade-off, validation, and whether the request authorizes it.
- Separate automated checks, manual review, and actual harness-loading confirmation; identify stale or unperformed evidence.
- A clear outcome: preserve as-is, recommend targeted improvements, establish missing guidance, or obtain a specific decision. A score alone never chooses the action.

## Implementation plan

1. **Define the shared assessment reference.** Add the rubric, anchors, evidence rules, scoring/coverage arithmetic, custom-requirement handling, and report contract in one reference. Give examples of equivalent structures, minimal repositories, unknown evidence, and serious findings. Review overlap so the six dimensions do not repeatedly penalize one issue without explaining its distinct effects.
2. **Integrate mode routing.** Update `SKILL.md`: enrich `doctor`; make `init` assess before selecting NO-OP/PATCH/CREATE; keep the five modes and existing authorization boundaries. Make `inspect` supply inventory without duplicating diagnosis. Ensure the new reference is reachable through progressive disclosure.
3. **Align supporting guidance.** Patch `references/detection.md`, `references/merge-rules.md`, and `references/instructions-guide.md` only where the shared assessment changes their decisions. Reuse `references/workflow.md` and existing checklists for authorized improvements instead of adding another execution loop. Change templates only if a confirmed requirement cannot be expressed through existing slots/guidance.
4. **Document usage.** Update `README.md` with assessment-only, assessment-plus-custom-requirements, and authorized-improvement examples. Explain score limits and distinguish skill validation from assessed-repository quality.
5. **Evaluate behavior and arithmetic.** Use the scenarios below, inspect actual reports/artifacts and preservation snapshots, and fix demonstrated failures. Keep checks lightweight; do not add an evaluator framework or persistent score store.
6. **Review and version.** Review the complete diff for consistency, unnecessary process, contradictions, scope, and portability. If the feature is complete and validation supports it, update `metadata.version` for the planned compatible release. Git actions and publication remain separately authorized work.

## Verification and review

Run the existing `./validate.sh`, `bash -n validate.sh`, relevant syntax/reference checks, and `git diff --check`. The validator establishes limited skill structure/metadata/reference evidence; it does not establish scoring quality or preservation behavior.

Evaluate these representative cases in temporary workspaces:

1. **Coherent existing setup:** existing instructions, contribution guide, planning location, and adapters satisfy the outcomes. Assessment recommends preservation; repeated `init` leaves the file set, bytes, and relevant metadata unchanged.
2. **Equivalent custom structure:** equivalent content uses different filenames/headings. Ratings and recommendations remain comparable to the first case; template resemblance earns no points.
3. **Partial or stale setup:** one command is wrong and continuation guidance is missing. Findings cite the actual evidence and propose focused changes in existing files. An assessment-only run leaves every file unchanged.
4. **Minimal repository:** a clear, relevant manual verification/review contract is credited without inventing package-manager commands, tests, CI, architecture docs, or planning directories.
5. **Mixed-language or large repository:** retain per-area commands and scoped instructions, inspect relevant workspace contracts, and disclose sampled areas. Limited inspection cannot produce an unqualified repo-wide conclusion.
6. **Custom requirements:** exercise a supported additional requirement, an intentional equivalent adaptation, a repeated requirement, and a material unresolved conflict. Custom coverage is explicit; the baseline denominator cannot be inflated by requirement count.
7. **Insufficient evidence:** unavailable files, a missing live harness session, and stale check results remain distinct from confirmed gaps. Unknowns are visible, provisional coverage is correct, and all-unknown input produces no score.
8. **Serious finding with a high average:** the actionable finding remains prominent and no readiness or repair authorization is inferred from the total.
9. **Scoring boundaries:** check all-zero/all-three scores, a mix of scored/Unknown/Not applicable, rounding, an empty denominator, and a repeated assessment with identical evidence. For the proposed example, confirm `12/15 = 80%`, with `5/6` applicable dimensions assessed.
10. **Authorized improvements:** only the requested patches are made, existing settings/instructions and unrelated work survive, and affected findings are reassessed against actual results. Repeated initialization avoids churn even when template wording changes.

Use file hashes/diffs, parsed settings, actual command coverage where authorized, and report-to-evidence inspection. Heading or wording matches are not behavioral evidence. Separately label static checks, manual scenario exercises, independent agent evaluations, and live harness loading; report whichever were not performed. Do not claim independent evaluation merely because a fixture report was authored in the same session.

## Risks and rollback

- **False precision or score gaming:** anchored ratings, visible coverage, separate custom statuses, and prominent serious findings limit overinterpretation. Scores remain a supported judgment, not certification.
- **Template bias and unnecessary process:** score outcomes, accept equivalent mechanisms, and test small/custom repositories. Do not add tooling just to improve a number.
- **Static evidence mistaken for real behavior:** label evidence type, age, scope, and unperformed checks. Do not claim preservation or loading from written policy alone.
- **Custom requirements silently changing the standard:** disclose adaptations/conflicts and keep the baseline rubric stable within a revision. Respect instruction precedence and authorized scope.
- **Maintenance drift:** keep one shared assessment reference; route modes to it instead of copying the rubric into every template or checklist.

This phase changes only the plan. During implementation, keep edits isolated to the skill entry point and affected references/documentation; rollback removes that feature's changes without disturbing unrelated work. Do not introduce a state format or migrate target repositories.

## Handoff checkpoint

- **Goal and acceptance criteria:** deliver the existing-workflow assessment above; scoring, custom coverage, preservation, and five-mode compatibility must be demonstrated.
- **Branch and base commit:** `develop`, `e4159cf5ef713a4c0e1aa5fa35c9a4721d2f737b`; verify the actual checkout before continuing.
- **Modified files and uncommitted work:** this specification only; skill behavior and version remain unchanged.
- **Decisions already made:** proposed extension of `doctor` shared with `init`; six equal-weight anchored dimensions; custom coverage and evidence confidence remain separate; no new command or scoring service. These are planning recommendations, not a claim that implementation has been approved.
- **Checks run and results:** `./validate.sh`, `bash -n validate.sh`, plan link/placeholder review, and the sample score calculation passed. The existing tracked skill files remain unchanged. These are planning/static checks; no implementation, independent-agent, or live harness evaluation has run for this feature.
- **Remaining work or blockers:** implementation and all behavioral acceptance checks remain; no essential information blocks the proposed plan.
- **Next concrete action:** review this proposed spec, then implement the shared assessment reference and mode integration when implementation is authorized.

Notes do not transfer uncommitted code. Supply this spec and any later implementation changes to another checkout explicitly, and carry existing constraints and approvals with the handoff.
