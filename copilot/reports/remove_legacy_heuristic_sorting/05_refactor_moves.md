Task 05: Refactor `Moves.cpp` and remove conditional compilation

Summary of changes
- Removed the `#ifdef DDS_USE_NEW_HEURISTIC` runtime flag in `Moves.cpp` and replaced hot-path branches that called legacy ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` functions with direct calls to `Moves::CallHeuristic(...)`.
- Added compatibility stubs for `set_use_new_heuristic(const bool)` and `use_new_heuristic()` in `Moves.cpp`. These are no-ops that return `true` to preserve ABI for existing tests while ensuring the codebase uniformly uses the new heuristic implementation.
- Updated `Moves.h` to expose the runtime stubs unconditionally (stable prototypes).

Verification
- Built `//library/src/moves:moves` successfully.
- Ran the heuristic tests: `bazel test //library/tests/heuristic_sorting:all` — all tests passed (11/11).

Notes and next steps
- Tests call `set_use_new_heuristic(...)` in multiple places; the stubs preserve link-time compatibility but do not toggle behavior. Update tests to stop toggling when convenient.
- Next: Task 06 — remove the `DDS_USE_NEW_HEURISTIC` define wiring from Bazel (`CPPVARIABLES.bzl` and any docs), and delete any remaining `#ifdef DDS_USE_NEW_HEURISTIC` occurrences across repo.

