# Remove Legacy Heuristic Sorting Tasks

This directory contains small, actionable tasks to remove the legacy heuristic sorting from `Moves.cpp` and consolidate on the implementation in `library/src/heuristic_sorting`.

## Phases and Tasks

- Phase 1: Discovery
  - 01 — Inventory macro and usages
  - 02 — Map public API and call sites
- Phase 2: API alignment
  - 03 — Choose adapters vs direct migration
  - 04 — Ensure exports and visibility in `heuristic_sorting`
- Phase 3: Refactor `Moves.cpp`
  - 05 — Remove conditional compilation
  - 06 — Delegate or remove legacy symbols
- Phase 4: Build config cleanup
  - 07 — Remove macro and Bazel defines
  - 08 — Update BUILD targets and deps
- Phase 5: Tests and validation
  - 09 — Update and run unit tests
  - 10 — Optional performance check
- Phase 6: Cleanup and docs
  - 11 — Dead code and include pruning
  - 12 — Update docs and developer scripts
  - 13 — Update local build tasks (VS Code tasks)
  - 14 — Final build and acceptance checklist
  - 15 — Prepare PR

Complete tasks in order. Each file specifies objective, concrete steps, verification, and expected outputs.
