# Task 09: Create CallHeuristic Integration Function

## Objective
Create a `CallHeuristic` function in the heuristic sorting library that can be called from `moves.cpp` when `DDS_USE_NEW_HEURISTIC` is enabled, replacing the old heuristic calls.

## Acceptance Criteria
- [ ] Create `CallHeuristic` function with appropriate signature
- [ ] Function should accept parameters that can be passed from `moves.cpp`
- [ ] Build `HeuristicContext` from the provided parameters
- [ ] Call `SortMoves` dispatcher with the constructed context
- [ ] Ensure function integrates cleanly with existing code
- [ ] Add function declaration to public header
- [ ] Document the function's purpose and usage

## Implementation Notes
- Study the current calls to heuristic functions in `moves.cpp` (around lines 207, 213, etc.)
- The function signature should match what's convenient for `moves.cpp` to call
- Consider if multiple variants are needed for different calling contexts
- Ensure the function is exported properly from the library

## Dependencies
- Task 08 (dispatcher) must be completed
- All `WeightAlloc*` functions must be implemented
- Understanding of how the functions are currently called from `moves.cpp`

## Output
- `CallHeuristic` function implemented and properly exposed
- Function declaration in appropriate header file
- Documentation of the integration interface
