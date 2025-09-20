# Task 07: Remove macro and Bazel defines

## Objective
Remove `DDS_USE_NEW_HEURISTIC` and Bazel `--define=new_heuristic` wiring.

## Steps
- Remove macro usages from the codebase.
- Update `CPPVARIABLES.bzl` (or equivalent) to remove defines mapping.
- Remove any conditional `defines` or `select()` in BUILD files referring to the flag.
- Update toolchain config if it injects the macro.

## Verification
- Grep shows no references to `DDS_USE_NEW_HEURISTIC` or `new_heuristic` define.
- Full repo builds without passing `--define=new_heuristic`.

## Expected outputs
- Cleaned build config and code without the legacy switch.
