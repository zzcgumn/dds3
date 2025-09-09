```markdown
# Task 03 — Add test utilities and normalization helpers

Goal
- Implement small utilities used by tests: move serialization, normalization, and a small logging helper.

Steps
1. Create `library/tests/heuristic_sorting/test_utils.h/.cpp` exposing:
   - `std::string serialize_move_list(const Moves&)`
   - `std::string normalize_ordering(const Moves&, bool include_scores=false)`
   - simple JSON logging helper `write_json_log(path, data)`
2. Reuse existing project helpers where available.

Verification
- Unit compile of `test_utils` succeeds.
- A small smoke program can call `serialize_move_list` and print output.

Notes
- Keep normalization deterministic: canonical move notation and stable sorting for ties.

```
