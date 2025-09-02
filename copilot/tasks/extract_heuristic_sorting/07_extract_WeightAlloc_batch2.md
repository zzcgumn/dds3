# Task 07: Extract Remaining WeightAlloc Functions (Batch 2)

## Objective
Extract the final set of `WeightAlloc*` functions from `moves.cpp`: `WeightAllocTrumpNotvoid2`, `WeightAllocNTNotvoid2`, `WeightAllocTrumpVoid2`, `WeightAllocNTVoid2`, and the level 3 functions.

## Acceptance Criteria
- [ ] Extract `WeightAllocTrumpNotvoid2` function
- [ ] Extract `WeightAllocNTNotvoid2` function
- [ ] Extract `WeightAllocTrumpVoid2` function
- [ ] Extract `WeightAllocNTVoid2` function
- [ ] Extract `WeightAllocCombinedNotvoid3` function
- [ ] Extract `WeightAllocTrumpVoid3` function
- [ ] Extract `WeightAllocNTVoid3` function
- [ ] Refactor all functions to use `HeuristicContext`
- [ ] Ensure all functions compile without errors
- [ ] Maintain identical algorithmic behavior for all functions

## Implementation Notes
- Complete the migration of all heuristic sorting functions
- The `WeightAllocCombinedNotvoid3` function may be more complex
- Ensure all function signatures match the declarations in `internal.h`
- Look for any remaining utility functions that need to be extracted

## Dependencies
- Tasks 04-06 should be completed
- All previous refactoring patterns and utilities should be established

## Output
- All remaining `WeightAlloc*` functions implemented in `heuristic_sorting.cpp`
- Complete migration of heuristic sorting logic from `moves.cpp`
- Documentation of the final function set and any special considerations
