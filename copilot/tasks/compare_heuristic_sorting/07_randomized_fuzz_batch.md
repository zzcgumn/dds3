```markdown
# Task 07 — Implement randomized fuzz batch

Goal
- Implement a fuzz driver that generates N positions (or picks from `hands/`) using a fixed seed and runs comparisons across them.

Steps
1. Add `fuzz_driver.cpp` capable of generating or sampling positions based on `--seed` and `--count`.
2. Integrate it with the harness so each generated position is compared.
3. Run a medium batch locally (e.g., 1k positions) and collect mismatch stats.

Verification
- Fuzz run completes and outputs aggregate statistics: total, matched, mismatched, runtime.

Notes
- Start with a conservative batch size (100–1000) to iterate quickly.

```
