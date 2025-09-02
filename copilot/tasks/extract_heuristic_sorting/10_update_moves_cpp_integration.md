# Task 10: Update moves.cpp to Use New Library

## Objective
Update `moves.cpp` to call the new heuristic sorting library when `DDS_USE_NEW_HEURISTIC` is enabled, while maintaining the old code path for fallback.

## Acceptance Criteria
- [ ] Replace existing `DDS_USE_NEW_HEURISTIC` blocks with calls to new library
- [ ] Ensure old code path remains unchanged when flag is disabled
- [ ] Verify all integration points are updated consistently
- [ ] Add proper includes for the new library
- [ ] Maintain identical behavior when new library is used
- [ ] Test that both code paths compile successfully

## Implementation Notes
- Update the calls around lines 207, 213, 295, 338, etc. in `moves.cpp`
- Replace placeholder calls with actual `CallHeuristic` function calls
- Ensure the same parameters are passed that the heuristic functions need
- Keep the old function calls in the `#else` branches
- Verify that the same `HeuristicContext` data is available

## Dependencies
- Task 09 (CallHeuristic) must be completed
- All heuristic functions must be fully implemented
- Build system must be updated to include the new library

## Output
- Updated `moves.cpp` with proper integration
- Both code paths compile and work correctly
- No behavior changes when using the new library
