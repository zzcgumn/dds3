1. Task Title: Integrate adapter in Moves.cpp behind flag
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Medium
4. Estimated Time: 6
5. Dependencies:
   - 07-implement-rho-scoring.md
6. Description:
   Add an adapter layer in `Moves.cpp` to map internal state to `HeuristicContext` and call `score_and_order`. Guard with `DDS_USE_NEW_HEURISTIC` compile flag; initially switch only lead-hand path.
7. Implementation Details:
   - Files: `library/src/Moves.cpp` (guarded edits), new `adapter_heuristic_sorting.h/cpp` if needed.
   - Preserve existing `MergeSort` tie-breaking; verify stability.
8. Acceptance Criteria:
   - Build passes with flag off (default) and on for lead-hand only.
   - No change in solver outputs for test fixtures when flag off.
9. Testing Approach:
   - Run existing solver tests with both configurations.
10. Quick Status:
   - Controlled integration; easy rollback.


