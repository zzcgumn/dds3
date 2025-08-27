1. Task Title: Implement lead-hand scoring (NT and Trump) with parity
2. Parent Feature: Heuristic sorting extraction
3. Complexity: High
4. Estimated Time: 8
5. Dependencies:
   - 03-bazel-scaffolding.md
6. Description:
   Implement rules from the spec for the trick-leading role (NT and Trump). Keep constants and integer math identical to legacy behavior. Provide small, named helpers.
7. Implementation Details:
   - Files: `scoring_rules.cpp`, `heuristic_sorting.cpp`, `context.h`.
   - Functions: `compute_suit_bonus_lead_*`, `is_trick_winning_move`, `apply_best_move_bonuses`.
   - Add unit tests for curated cases.
8. Acceptance Criteria:
   - For fixed micro-scenarios, weights match legacy `WeightAllocNT0/Trump0`.
   - Sorting order identical for those scenarios.
9. Testing Approach:
   - Add `cc_test` under `library/tests/heuristic_sorting/lead_hand_test.cpp` with table-driven cases.
10. Quick Status:
   - Library only; not yet wired into `Moves.cpp`.


