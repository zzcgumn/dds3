# Task 08: Implement SortMoves Dispatcher Logic

## Objective
Implement the `SortMoves` dispatcher function to correctly route to the appropriate ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` function based on the game state, matching the logic currently in `moves.cpp`.

## Acceptance Criteria
- [ ] Analyze the current logic that selects which ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` function to call
- [ ] Implement the dispatcher logic in `SortMoves` function
- [ ] Ensure the same function selection occurs as in the original code
- [ ] Handle all different game states and conditions properly
- [ ] Add comprehensive comments explaining the dispatch logic
- [ ] Validate that the dispatcher works for all scenarios

## Implementation Notes
- Study how `MoveGen0` and `MoveGen123` currently select heuristic functions
- Look at the `WeightList` array initialization around line 82 in `moves.cpp`
- Understand the conditions that determine which function to call
- The dispatcher should encapsulate the same decision logic
- Consider if the dispatcher needs additional context information

## Dependencies
- Tasks 04-07 must be completed (all functions extracted)
- Task 01 analysis should identify the current selection logic

## Output
- Fully implemented `SortMoves` dispatcher function
- Documentation of the dispatch logic and decision criteria
- Validation that all code paths are handled correctly
