# Decision: Adapters vs Direct Migration

Generated: 2025-09-20

Summary
- Recommendation: Direct migration — replace the legacy ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` branches in `Moves.cpp` with direct calls to `Moves::CallHeuristic(...)` (which already constructs a `HeuristicContext` and delegates to the new `heuristic_sorting` module). Keep an optional thin compatibility shim for `set_use_new_heuristic` as a no-op to preserve ABI for tests if required.

Rationale
- Low code churn: `Moves::CallHeuristic` already exists and constructs the exact `HeuristicContext` the new library expects. Replacing branching checks with direct calls is a minimal, low-risk change localized to `Moves.cpp`.
- Simpler testing and maintenance: Removing the conditional branches eliminates the build-time/runtime complexity (no more `DDS_USE_NEW_HEURISTIC` guarding), making the codebase easier to reason about.
- Performance parity: The new API is designed for hot paths and accepts `mply`/counts directly; the current `Moves::CallHeuristic` builds that context once per call to avoid per-move overhead. This keeps per-call costs low.
- ABI/compatibility mitigation: Many tests reference `set_use_new_heuristic`/`use_new_heuristic`. Rather than re-introducing the compile-time flag, keep a small, stable runtime stub:
  - Provide `bool set_use_new_heuristic(bool)` and `bool use_new_heuristic()` implementations that are no-ops or return a constant; this preserves link-time symbols so existing test code can compile without modification while removing legacy branches.

When to prefer adapters
- If we find external consumers or plugins that directly call `Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` (unlikely because these are internal member functions), we should implement thin adapters with the same signatures that delegate to `::CallHeuristic(context)` to preserve ABI. This is a fallback path; prefer removing legacy ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` in the same change if no external references exist.

Concrete migration plan (short)
1. Replace `if (use_new_heuristic()) { CallHeuristic(...) } else { `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*... }` with a single `CallHeuristic(...)` invocation in each site inside `Moves.cpp` (MoveGen0 and MoveGen123 hot paths).
2. Remove `#ifdef DDS_USE_NEW_HEURISTIC` sections from `Moves.cpp` and `Moves.h`. Replace `#ifdef`-guarded `set_use_new_heuristic`/`use_new_heuristic` with stable stub implementations if tests expect them.
3. Remove dead ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` implementations if they are no longer referenced. If a conservative approach is desired, keep them as delegating wrappers for one PR and remove them in a follow-up once CI/tests are green.
4. Update tests under `library/tests/heuristic_sorting/` to rely solely on the new library (remove `#ifdef DDS_USE_NEW_HEURISTIC`, remove runtime toggling where present). If necessary, update tests to call the no-op `set_use_new_heuristic` for compatibility.
5. Update BUILD files / `CPPVARIABLES.bzl` to remove the `new_heuristic` mapping and `.bazelrc` configs that inject the define (follow as a separate task after code compiles cleanly).

Risk analysis and mitigations
- Risk: Behavioral divergences between legacy ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` and the new heuristic cause test/regression failures.
  - Mitigation: Keep ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` as delegating wrappers for one PR so we can revert quickly if failures occur; run the comparison harness tests in `library/tests/heuristic_sorting` and performance microbenchmarks in `copilot/perf/`.
- Risk: Tests rely on runtime toggling that will disappear.
  - Mitigation: Provide a stub `set_use_new_heuristic` until tests are updated; update tests incrementally.

Acceptance criteria for this decision
- All call sites in `Moves.cpp` use `CallHeuristic` after change.
- No `#ifdef DDS_USE_NEW_HEURISTIC` remains in `Moves.cpp`/`Moves.h` (stubs allowed if kept intentionally).
- CI builds and unit tests pass. If failures occur, follow the rollback plan (restore delegating wrappers or revert commit).

Rollback plan
- If significant regressions occur, revert the PR and introduce a staged migration: 1) keep delegating wrappers and runtime toggle for testing, 2) iteratively remove legacy ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` implementations after green CI.

Decision owner
- Implementer: follow-up PR author (current branch). Reviewer: core maintainers.


