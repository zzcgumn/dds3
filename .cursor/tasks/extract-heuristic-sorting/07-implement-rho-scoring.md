1. Task Title: Implement RHO (fourth hand) scoring
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Medium
4. Estimated Time: 5
5. Dependencies:
   - 06-implement-partner-scoring.md
6. Description:
   Implement fourth-hand (RHO) rules for NT and Trump from the spec, including ruffing/overruff and discard cases.
7. Implementation Details:
   - Extend `scoring_rules.cpp` with RHO path and helpers.
   - Add unit tests: `rho_test.cpp`.
8. Acceptance Criteria:
   - Parity for curated RHO scenarios; deterministic ordering.
9. Testing Approach:
   - Table-driven unit tests.
10. Quick Status:
   - Library only; not yet wired.


