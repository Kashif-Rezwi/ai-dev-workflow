# Pre-Merge Review Checklist

Run before merging full-gear work. AI may assist; the human decides.

- [ ] Verification green on the final branch state (not an earlier commit)
- [ ] Diff reviewed file by file — no unrelated changes, no debug leftovers
- [ ] Every acceptance criterion in the spec demonstrably met
- [ ] Docs updated where behavior changed (architecture, AGENTS.md commands, README)
- [ ] No secrets, credentials, or unintended personal data in the diff
- [ ] No dependency changes without recorded justification
- [ ] Migrations/env changes called out explicitly if present
- [ ] Commit history is clean and conventional (squash if the repo's norm)
