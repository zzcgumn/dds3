# Task 06: Delegate or remove legacy symbols

## Objective
Maintain API/ABI stability while removing the legacy implementation.

## Steps
- For any externally used functions previously implemented in `Moves.cpp`:
  - If still required, re-implement as thin wrappers delegating to `library/src/heuristic_sorting`.
  - If internal/unused, remove them and update call sites.
- Update includes and namespaces accordingly.

## Verification
- All references resolve and link against the new module.
- `bazel build //...` succeeds.

## Expected outputs
- Updated `Moves.cpp` and potentially `Moves.h` or adapters.
