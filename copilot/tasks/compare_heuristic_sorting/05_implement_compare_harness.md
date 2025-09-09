```markdown
# Task 05 — Implement `compare_harness.cpp`

Goal
- Implement the harness that runs both heuristic implementations for a given position and compares normalized outputs.

Steps
1. Implement `compare_harness.cpp` to:
   - accept a list of input file paths or seeds
   - call `set_use_new_heuristic(false)` and collect ordering A
   - call `set_use_new_heuristic(true)` and collect ordering B
   - normalize and compare; on mismatch write JSON diffs to `build/compare-results/<timestamp>/`
2. Add command-line flags for `--seed`, `--cases-dir`, `--out-dir`, and `--runs`.

Verification
- Running the harness on canonical cases produces identical outputs for matching cases and detailed diffs for mismatches.

Notes
- If runtime switching is not available, implement a mode that reads `--mode=legacy|new` and the test runner will build and run twice.

```
