# Plan for Unit Testing the Heuristic Sorting Component

This plan outlines the steps to create a comprehensive unit test suite for the heuristic card sorting logic, as described in `doc/heuristic-sorting.md`.

The core of this task is to isolate the heuristic calculation functions, make them accessible to a test environment, and then write targeted tests that verify the correctness of the weight calculations against the specification.

## Phase 1: Analysis and Scaffolding

1.  **Locate Heuristic Sorting Code:** The logic is not in a dedicated file. I will search the codebase (primarily `library/src/ABsearch.cpp` and `library/src/LaterTricks.cpp`) for key terms and formulas from the documentation (e.g., `suitWeightDelta`, `suitAdd`, `(suit length) * 64)/36`) to identify the exact C++ functions implementing the move weighting algorithm.

2.  **Create New Component Structure:**
    *   Create a new directory: `library/src/heuristic_sorting`.
    *   Create a new build file: `library/src/heuristic_sorting/BUILD.bazel`.

3.  **Create Test Files:**
    *   Create a new header for internal functions: `library/src/heuristic_sorting/internal.h`. This will expose the previously static functions for testing.
    *   Create the test implementation file: `library/tests/heuristic_sorting_test.cpp`.

## Phase 2: Refactoring for Testability

1.  **Extract Heuristic Logic:**
    *   Move the identified heuristic functions from their current location into a new source file: `library/src/heuristic_sorting/heuristic_sorting.cpp`.
    *   Place the corresponding function declarations into `library/src/heuristic_sorting/internal.h`. If any functions were `static`, this keyword will be removed in the header to allow external linkage for the tests.

2.  **Update Build System (Bazel):**
    *   **In `library/src/heuristic_sorting/BUILD.bazel`:**
        *   Define a `cc_library` named `heuristic_sorting` that compiles `heuristic_sorting.cpp` and exposes `internal.h` in its `hdrs`. This makes the functions available to other components, specifically our test.
    *   **In `library/tests/BUILD.bazel`:**
        *   Add a new `cc_test` target named `heuristic_sorting_test`.
        *   Set `heuristic_sorting_test.cpp` as the source.
        *   Add a dependency on the `//library/src/heuristic_sorting` library to link against the functions under test.

3.  **Integrate Refactored Code:**
    *   Modify the original source files (e.g., `ABsearch.cpp`) to `#include "heuristic_sorting/internal.h"` and ensure they call the moved functions correctly.

## Phase 3: Test Implementation

1.  **Set Up Test Harness:**
    *   In `library/tests/heuristic_sorting_test.cpp`, include the new `internal.h`.
    *   Follow the existing testing conventions found in other files like `dtest.cpp`, which likely involves simple `assert` statements or custom comparison functions.

2.  **Develop Test Cases:**
    *   Based on `doc/heuristic-sorting.md`, create distinct test functions for each major scenario. Each function will verify the `weight` calculation.
    *   **Test Scenarios:**
        *   `TestLeadingHand()`: Covers all logic for when the hand-to-play is the trick leader.
        *   `TestLHO()`: Covers logic for the Left-Hand Opponent.
        *   `TestPartner()`: Covers logic for the leader's partner.
        *   `TestRHO()`: Covers logic for the Right-Hand Opponent.
        *   `TestDiscardBonus()`: Specifically tests the `suitAdd` calculation for void-in-suit discards.
    *   For each scenario, multiple sub-tests will be created to cover all branches of the pseudo-code (e.g., winning vs. losing move, trump vs. non-trump, specific card ranks, opponent hand distributions).

3.  **Implement Tests:**
    *   For each test, I will manually construct the required game state (hands, current trick, trump, etc.).
    *   Call the heuristic weight calculation function with this state.
    *   Use assertions to compare the returned weight with the expected value calculated manually from the pseudo-code in the documentation.

## Phase 4: Verification

1.  **Run New Unit Tests:**
    *   Execute the tests using `bazel test //library/tests:heuristic_sorting_test`.
    *   Debug and refine the tests and the source code until all tests pass.

2.  **Run Full Regression Test:**
    *   Execute the entire project test suite with `bazel test //...` to ensure the refactoring did not break any existing functionality.

3.  **Final Build:**
    *   Confirm that the entire project builds successfully with `bazel build //...`.
