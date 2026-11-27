# Pre-Merge Review Checklist

Shared final review for either gear, and again before a separately authorized merge if the state changed. Scale it to the affected area; mark inapplicable items rather than inventing work. A completed review does not authorize Git actions.

- [ ] Appropriate repo verification contract followed on the final changed state; no duplicate checks added
- [ ] Exact automated results, manual review, and actual harness loading confirmation reported separately, including omissions/failures
- [ ] Diff reviewed file by file — no unrelated changes, no debug leftovers
- [ ] Requested behavior and acceptance criteria assessed against evidence; remaining gaps disclosed
- [ ] Docs updated where behavior changed (architecture, AGENTS.md commands, README)
- [ ] No secrets, credentials, or unintended personal data in the diff
- [ ] No dependency changes without recorded justification
- [ ] Migrations/env changes called out explicitly if present
- [ ] Existing content and unrelated uncommitted work preserved; no unnecessary generated structure
- [ ] Completion report states remaining risks/blockers and next action; handoff included if needed
