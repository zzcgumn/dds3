# Task 08: Update BUILD targets and deps

## Objective
Ensure targets depend on the new module and no longer on legacy code.

## Steps
- Add `heuristic_sorting` library to `deps` where needed.
- Remove obsolete source files or deps tied to legacy heuristic.
- Ensure `visibility` of the new module covers all consumers.

## Verification
- `bazel build //...` succeeds locally.
- No duplicate/unused dependencies.

## Expected outputs
- Updated BUILD files reflecting the new dependency graph.
