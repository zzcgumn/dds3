# Task 02: Review and Enhance Heuristic Sorting Library Scaffolding

## Objective
Review the existing scaffolding in `library/src/heuristic_sorting` and ensure it has all necessary interfaces and data structures to support the migration from `moves.cpp`.

## Acceptance Criteria
- [ ] Verify `HeuristicContext` struct contains all necessary data members
- [ ] Ensure all `WeightAlloc*` function signatures are declared in `internal.h`
- [ ] Review the `SortMoves` dispatcher function design
- [ ] Validate that the library can be properly included and linked
- [ ] Check if any additional utility functions or data structures are needed
- [ ] Ensure the BUILD.bazel file is properly configured

## Implementation Notes
- Compare the `HeuristicContext` struct against the member variables used in `moves.cpp`
- Verify that all function signatures in `internal.h` match what will be extracted
- Review the dispatcher logic in `SortMoves` function
- Check for any missing includes or forward declarations

## Current Files to Review
- `library/src/heuristic_sorting/heuristic_sorting.h`
- `library/src/heuristic_sorting/heuristic_sorting.cpp`
- `library/src/heuristic_sorting/internal.h`
- `library/src/heuristic_sorting/BUILD.bazel`

## Output
Document any gaps or enhancements needed in the scaffolding before migration can begin.
