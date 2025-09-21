# Task 01: Analyze Heuristic Sorting Code in moves.cpp

## Objective
Analyze the current heuristic sorting implementation in `moves.cpp` to understand all functions, data structures, and dependencies that need to be extracted.

## Acceptance Criteria
- [ ] Document all ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` functions in `moves.cpp`
- [ ] Identify all data structures used by heuristic sorting functions
- [ ] Map dependencies between heuristic functions and other parts of the codebase
- [ ] Document the current usage of `DDS_USE_NEW_HEURISTIC` compile flag
- [ ] Create a list of all member variables accessed by heuristic functions
- [ ] Document the flow of how heuristic sorting is called from `MoveGen0` and `MoveGen123`

## Implementation Notes
- Focus on ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` functions starting around line 2021 in `moves.cpp`
- Look for the compile flag `DDS_USE_NEW_HEURISTIC` usage patterns
- Pay attention to member variable access patterns that will need to be passed via `HeuristicContext`
- Document any shared state or dependencies between different ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)` functions

## Output
Create a comprehensive analysis document listing:
1. All heuristic functions to be moved
2. All data dependencies
3. Current integration points
4. Compile flag usage patterns
