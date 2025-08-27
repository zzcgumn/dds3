1. Task Title: Implement LHO (second hand) scoring
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Medium
4. Estimated Time: 5
5. Dependencies:
   - 04-implement-lead-hand-scoring.md
6. Description:
   Implement the second-hand (LHO) rules for NT and Trump from the spec. Maintain exact constants and parity.
7. Implementation Details:
   - Extend `scoring_rules.cpp` with LHO path and helpers.
   - Add unit tests: `lho_test.cpp`.
8. Acceptance Criteria:
   - Exact weight/order parity for curated LHO scenarios.
9. Testing Approach:
   - Table-driven unit tests compare against legacy computations.
10. Quick Status:
   - Library only; not yet wired.


