# Task 04: Extract `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic) Function

## Objective
Extract the ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)` function from `moves.cpp` and implement it in the heuristic sorting library as the first concrete migration.

## Acceptance Criteria
- [ ] Locate and copy ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)` function from `moves.cpp`
- [ ] Refactor function to use `HeuristicContext` instead of class members
- [ ] Update all member variable accesses to use context parameters
- [ ] Ensure function compiles without errors
- [ ] Maintain identical algorithmic behavior
- [ ] Add appropriate comments documenting the refactoring

## Implementation Notes
- This function should be found around line 2021+ in `moves.cpp`
- Replace `this->` or direct member access with `context.` access
- Be careful to maintain exact same logic and behavior
- Consider any helper functions or macros that might be used
- Ensure all data types and includes are available in the new library

## Dependencies
- Task 01 (analysis) should be completed first
- Task 02 (scaffolding review) should identify any missing context members

## Output
- Fully implemented ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)` function in `heuristic_sorting.cpp`
- Updated function signature if needed
- Documentation of any changes made during refactoring
