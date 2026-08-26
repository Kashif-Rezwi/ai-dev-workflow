# Full-Change Checklist

For features, architecture, and irreversible changes (full gear).

- [ ] Git-truth check done: branch/merge/origin state verified with git commands
- [ ] Spec exists: goal, non-goals, testable acceptance criteria
- [ ] ≥2 approaches documented with trade-offs; human approved the choice
- [ ] Plan: ordered tasks with files touched and per-task verification
- [ ] One atomic commit per completed task; scope held (findings noted, not fixed)
- [ ] Deterministic verification green across every existing layer
- [ ] Self-review against every acceptance criterion, item by item
- [ ] High-risk? Adversarial review done (correctness gaps only, not style)
- [ ] ADR written for any durable, hard-to-reverse decision
- [ ] `docs/architecture.md` updated if system shape changed
- [ ] Human approval obtained before merge/deploy
