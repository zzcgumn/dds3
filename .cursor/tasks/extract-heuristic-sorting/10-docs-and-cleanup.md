1. Task Title: Documentation, CI wiring, and flag default
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Medium
4. Estimated Time: 4
5. Dependencies:
   - 09-golden-parity-tests.md
6. Description:
   Write API docs and developer README. Add tests to CI (if applicable). Flip `DDS_USE_NEW_HEURISTIC` default to on after green tests, or document how to enable it.
7. Implementation Details:
   - Update `library/src/heuristic_sorting/README.md` and headers.
   - Add CI config updates if present; otherwise leave instructions.
8. Acceptance Criteria:
   - Docs explain mapping to spec and usage.
   - All tests green with flag on; default flipped or documented.
9. Testing Approach:
   - Rerun full test suite; verify no regressions.
10. Quick Status:
   - Finalization only; no functional changes beyond flag default.


