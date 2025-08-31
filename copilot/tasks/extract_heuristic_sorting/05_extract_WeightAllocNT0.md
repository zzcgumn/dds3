# Task 05: Extract WeightAllocNT0 Function

## Objective
Extract the `WeightAllocNT0` function from `moves.cpp` and implement it in the heuristic sorting library.

## Acceptance Criteria
- [ ] Locate and copy `WeightAllocNT0` function from `moves.cpp`
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
- Look for shared code patterns with `WeightAllocTrump0`

## Dependencies
- Task 04 should be completed first to establish the refactoring pattern
- Learn from any issues discovered during the first function extraction

## Output
- Fully implemented `WeightAllocNT0` function in `heuristic_sorting.cpp`
- Documentation of any shared utility functions needed
- Any updates to `HeuristicContext` if additional data is required
