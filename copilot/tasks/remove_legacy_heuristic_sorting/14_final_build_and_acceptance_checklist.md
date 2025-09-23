# Task 14: Final build and acceptance checklist

## Objective
Validate the acceptance criteria are fully met.

## Steps
- Run `bazel build //...` and `bazel test //...` with no special defines.
- Grep repo for `DDS_USE_NEW_HEURISTIC` and `--define=new_heuristic` (should be zero occurrences).
- Confirm `Moves.cpp` no longer contains legacy heuristic code.
- Confirm all callers build/link via the new module.
- Confirm docs and tasks are updated.

## Verification
- All acceptance criteria satisfied.

## Expected outputs
- Checklist marked complete and attached to the PR description.
