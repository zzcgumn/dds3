```markdown
# Task 04 — Add canonical positions and expected outputs

Goal
- Add a small set (6–10) of hand-crafted positions with expected move-order outputs for deterministic unit tests.

Steps
1. Add a `cases/` subdirectory under `library/tests/heuristic_sorting`.
2. For each hand-crafted position, add a small file describing the position and the expected normalized ordering.
3. Add a test that reads these files, runs both heuristics, and asserts equality against the expected ordering.

Verification
- The deterministic tests pass on both `use_new_heuristic=true` and `=false` builds.

Notes
- Keep the initial set focused on edge cases: ties, terminal moves, and typical mid-game positions.

```
