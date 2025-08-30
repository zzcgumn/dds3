## Task 3: Test Implementation

- **Goal:** Write the unit tests to verify the correctness of the heuristic weight calculations against the specification in `doc/heuristic-sorting.md`.
- **Key Actions:**
    - In `library/tests/heuristic_sorting_test.cpp`, include `heuristic_sorting/internal.h`.
    - Create test functions for each major scenario: `TestLeadingHand()`, `TestLHO()`, `TestPartner()`, `TestRHO()`, and `TestDiscardBonus()`.
    - Within each test function, create specific sub-tests to cover all logical branches from the documentation.
    - For each sub-test, construct the required game state, call the appropriate weighting function, and assert that the result matches the expected value.
- **Deliverable:** A complete `library/tests/heuristic_sorting_test.cpp` file with comprehensive test coverage.