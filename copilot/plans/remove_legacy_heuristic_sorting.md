# Plan: Remove Legacy Heuristic Sorting (Moves.cpp)

## Context
- There are two heuristic sorting implementations:
  - Legacy: in `library/src/moves/Moves.cpp`
  - New: in `library/src/heuristic_sorting/`
The new implementation is now the default. Goal: Remove the legacy implementation from `Moves.cpp` and make the new implementation the only one.

## Goals
- Consolidate all heuristic sorting logic under `library/src/heuristic_sorting/`.
- Remove all conditional compilation paths related to `DDS_USE_NEW_HEURISTIC`.
- Keep public APIs stable for external callers (minimize breaking changes).
- Ensure Bazel builds and tests pass without special flags.

## Non-goals
- Changing heuristic behavior or tuning scores (functional parity expected).
- Performance optimization beyond any changes needed for consolidation.

## Affected areas (expected)
- Source:
  - `library/src/moves/Moves.cpp` (remove legacy implementation / redirection)
  - Possibly `library/src/moves/Moves.h` (if exposes heuristic-related interfaces)
  - `library/src/heuristic_sorting/*` (may add adapters or exports)
- Build & config:
  - `BUILD.bazel` and `library/**/BUILD.bazel` (dependencies/visibility)
  - `CPPVARIABLES.bzl` or similar mapping from `--define=new_heuristic` to preprocessor macros
  - Any `.bzl` or config that defines `DDS_USE_NEW_HEURISTIC`
- Tests:
  - `library/tests/**` (ensure tests don’t rely on old flag or legacy code)
- Docs & tooling:
  - `doc/heuristic-sorting.md` and any developer docs referencing the switch
  - Local tasks/scripts that build with `--define=new_heuristic` (cleanup follow-up)

## Step-by-step plan
1. Inventory and API surface
   - Search codebase for `DDS_USE_NEW_HEURISTIC` and references to legacy heuristic functions in `Moves.cpp`.
   - List all public-facing functions/types used by callers for heuristic sorting.
   - Compare with the public API in `library/src/heuristic_sorting/` and identify gaps.

2. Stabilize/Align API
   - If callers include `Moves.h` for sorting, add thin forwarders or migrate includes to the new module’s header.
   - Prefer updating call sites to include the new headers directly; if broad changes are risky, introduce transitional wrappers in a header with same signatures delegating to the new module.
   - Ensure the new module exports everything needed (headers and Bazel targets with proper visibility).

3. Refactor Moves.cpp
   - Remove all `#if/#else` blocks using `DDS_USE_NEW_HEURISTIC`.
   - Delete legacy sorting code paths; if `Moves.cpp` must still provide symbols for ABI/API stability, replace with calls into the new module.
   - Remove unused includes, helpers, and private types tied to the legacy path.

4. Remove compile-time switch and build defines
   - Remove `DDS_USE_NEW_HEURISTIC` from codebase.
   - Remove mapping from Bazel `--define=new_heuristic=...` to preprocessor defines (likely in `CPPVARIABLES.bzl` or toolchain config).
   - Update any BUILD files that conditionally add sources/defines based on the flag.

5. Update Bazel targets
   - Ensure `heuristic_sorting` is a `cc_library` and is depended on by targets that need it.
   - Remove dependencies on legacy code in `cc_library`/`cc_binary` rules.
   - Build graph sanity check with `bazel build //...`.

6. Tests and validation
   - Remove/adjust tests that depend on the flag or legacy behavior.
   - Ensure unit/integration tests pass using the new implementation only.
   - Optional: run performance/microbenchmarks in `copilot/perf/` to confirm no regressions.

7. Cleanup and dead code removal
   - Run include pruning and remove unused symbols.
   - Delete any remaining legacy files or code blocks exclusively used by the legacy path.
   - Grep for the removed macro to ensure it’s fully gone.

8. Documentation & developer experience
   - Update docs (e.g., `doc/heuristic-sorting.md`) to remove mentions of the legacy path and flag.
   - Update any scripts or local tasks that reference `--define=new_heuristic=...`.

9. Git & PR
   - Commit changes with a clear message: `refactor(heuristic): remove legacy sorting from Moves.cpp`.
   - Open a PR; request review focusing on API stability, call-site coverage, and build/test results.

## Acceptance criteria
- No remaining references to `DDS_USE_NEW_HEURISTIC` or `--define=new_heuristic`.
- `Moves.cpp` contains no legacy heuristic implementation; any remaining symbols delegate to `library/src/heuristic_sorting` or are removed if internal.
- `bazel build //...` and all tests pass without extra defines.
- Callers compile and link using the new module.
- Docs updated; local build tasks referencing the old define are either removed or marked deprecated.

## Risk & rollback
- Risk: Hidden callers rely on subtle differences in legacy behavior. Mitigation: targeted tests and optional benchmark comparison using `copilot/perf` scripts.
- Rollback: Revert the PR or temporarily restore a wrapper function that adapts inputs/outputs while investigating discrepancies.

## Follow-ups (optional)
- Performance verification report comparing pre/post removal using existing scripts under `copilot/perf`.
- Remove or update any developer scripts that are kept outside the repo (e.g., VS Code tasks) to avoid confusion.
