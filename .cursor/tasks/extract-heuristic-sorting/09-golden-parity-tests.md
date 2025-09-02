1. Task Title: Golden parity tests old vs new heuristic
2. Parent Feature: Heuristic sorting extraction
3. Complexity: High
4. Estimated Time: 8
5. Dependencies:
   - 08-adapter-integration-moves.md
6. Description:
   Build fixtures that pass identical states through legacy and library paths, asserting identical weights/order. Cover NT/Trump, all roles, void/non-void, singleton, ruff/overruff.
7. Implementation Details:
   - Create `library/tests/heuristic_sorting/golden/` with YAML/JSON fixtures.
   - Add a test harness to simulate `pos` and candidate lists.
   - Use `serena` MCP to enumerate edge cases from the spec and Moves.cpp.
8. Acceptance Criteria:
   - Parity across full matrix; tests green in CI.
9. Testing Approach:
   - `cc_test` comparing both paths; run with and without `DDS_USE_NEW_HEURISTIC`.
10. Quick Status:
   - Test-only; no runtime changes.


