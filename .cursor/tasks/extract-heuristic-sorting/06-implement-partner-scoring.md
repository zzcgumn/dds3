1. Task Title: Implement partner (third hand) scoring
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Medium
4. Estimated Time: 5
5. Dependencies:
   - 05-implement-lho-scoring.md
6. Description:
   Implement partner-hand rules for NT and Trump from the spec.
7. Implementation Details:
   - Extend `scoring_rules.cpp` with partner path and helpers.
   - Add unit tests: `partner_test.cpp`.
8. Acceptance Criteria:
   - Parity for curated partner scenarios (win/lose, ruff/void cases).
9. Testing Approach:
   - Table-driven unit tests; verify determinism and order parity.
10. Quick Status:
   - Library only; not yet wired.


