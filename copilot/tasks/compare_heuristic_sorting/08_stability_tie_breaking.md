```markdown
# Task 08 — Stability and tie-breaking experiments

Goal
- Detect nondeterminism and fragile tie-breaking differences by re-running candidate positions multiple times.

Steps
1. For positions flagged as having ties or mismatches, run the harness `--runs=R` times (R >= 10).
2. Collect the distribution of outputs for each implementation and compare stability.
3. Flag positions where outputs are nondeterministic or the two implementations differ in tie-breaking.

Verification
- A per-position stability report showing variability and which implementation is stable/unstable.

Notes
- If nondeterminism is found, attempt to trace to uninitialized state or non-deterministic container iteration.

```
