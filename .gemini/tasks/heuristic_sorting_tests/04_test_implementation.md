## Task 4: Test Implementation

- **Goal:** Write the unit tests to verify the correctness of the heuristic weight calculations against the specification in `doc/heuristic-sorting.md`.
- **Key Actions:**
    - In `library/tests/heuristic_sorting_test.cpp`, include `heuristic_sorting/internal.h` to directly access the internal weighting functions.
    - Create test functions for each major scenario: `TestLeadingHand()`, `TestLHO()`, `TestPartner()`, `TestRHO()`, and `TestDiscardBonus()`.
    - For each scenario, construct the required game state, call the appropriate `WeightAlloc...` function, and assert that the result matches the expected value from the documentation.
- **Deliverable:** A complete `library/tests/heuristic_sorting_test.cpp` file with comprehensive test coverage.