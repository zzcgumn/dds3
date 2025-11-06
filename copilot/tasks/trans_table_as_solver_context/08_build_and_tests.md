# 08 – Build and tests for refactor

Goal
- Validate the refactor via Bazel builds and existing tests; add targeted checks if feasible.

Steps
1) Build (Debug): run task “Bazel build all (Debug) - update SolverIF”.
2) If errors occur, iterate on missing includes/usages; avoid broad changes.
3) Run unit tests related to trans table and solver code (if tasks exist).
4) Optional: add small tests (or temporary asserts) to confirm:
   - TT is lazily created on first access
   - `ResizeTT` normalizes `max>=def`
   - `ResetForSolve` calls `reset_memory(FreeMemory)` and clears search state
   - `ClearTT` calls `return_all_memory()`
   - `DisposeTransTable` deletes the instance; subsequent access recreates

Acceptance criteria
- Build PASS (Debug) with no new warnings or style violations.
- Existing solver tests PASS.

Notes
- Follow `.github/instructions/bazel.instructions.md` for build flags and workflow.
