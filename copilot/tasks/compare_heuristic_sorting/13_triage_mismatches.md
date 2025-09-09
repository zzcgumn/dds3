```markdown
# Task 13 — Triage mismatches and add focused tests

Goal
- Systematically triage mismatches, classify causes, and add focused unit tests to lock down behavior.

Steps
1. For each mismatch entry in the logs, classify into categories: tie-break, score difference, bug (logic), nondeterminism.
2. Add a focused deterministic test for each triaged case that reproduces the mismatch.
3. Work with maintainers to decide correct behavior and update implementation or tests accordingly.

Verification
- Each triaged mismatch has a reproducer test and a classification entry in the report.

Notes
- Prioritize mismatches that occur frequently in fuzz runs or are easy-to-reproduce.

```
