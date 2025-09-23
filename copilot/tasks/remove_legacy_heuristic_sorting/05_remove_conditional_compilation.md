# Task 05: Remove conditional compilation from `Moves.cpp`

## Objective
Eliminate `#if/#else` branches around `DDS_USE_NEW_HEURISTIC` in `Moves.cpp`.

## Steps
- Open `library/src/moves/Moves.cpp`.
- Remove all code guarded by the legacy path; keep only the logic that will remain (delegation to new module or nothing if fully removed).
- Ensure includes and helper functions referenced exclusively by the legacy path are removed.

## Verification
- No occurrences of `DDS_USE_NEW_HEURISTIC` remain in `Moves.cpp`.
- File compiles as part of `bazel build //library/...`.

## Expected outputs
- Simplified `Moves.cpp` free of legacy heuristic code.
