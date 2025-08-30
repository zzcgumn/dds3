# Plan for Unit Testing the Heuristic Sorting Component

This plan outlines the steps to refactor the heuristic card sorting logic into a standalone, testable component and to create a comprehensive unit test suite for it, based on the specification in `doc/heuristic-sorting.md`.

The refactoring will be done behind the existing `DDS_USE_NEW_HEURISTIC` flag.

## Phase 1: Analysis and Scaffolding

1.  **Locate Heuristic Sorting Code:** Identify the C++ functions in `library/src/Moves.cpp` that implement the move weighting algorithm by searching for key terms from the documentation. (Completed)

2.  **Create New Component Structure:**
    *   Create a new directory: `library/src/heuristic_sorting`.
    *   Create a new build file: `library/src/heuristic_sorting/BUILD.bazel`.
    *   Create the public API header: `library/src/heuristic_sorting/heuristic_sorting.h`.
    *   Create a header for internal functions for testing: `library/src/heuristic_sorting/internal.h`.
    *   Create the implementation file: `library/src/heuristic_sorting/heuristic_sorting.cpp`.
    *   Create the test file: `library/tests/heuristic_sorting_test.cpp`.

## Phase 2: API Design and Implementation

1.  **Design Public API:** In `heuristic_sorting.h`, define a public function (e.g., `SortMoves()`). This function will serve as the single entry point for the new component and will take all necessary game state data as arguments via a struct.

2.  **Extract and Refactor Logic:** Move the `WeightAlloc...` functions from `Moves.cpp` into `heuristic_sorting.cpp`. These will be refactored into standalone, non-class functions. Their declarations will be placed in `internal.h`.

3.  **Implement Public API:** The public `SortMoves()` function will internally dispatch to the appropriate private `WeightAlloc...` functions based on the game state.

## Phase 3: Integration and Build System Configuration

1.  **Update Build System (Bazel):**
    *   **In `library/src/heuristic_sorting/BUILD.bazel`:** Define a `cc_library` that exposes `heuristic_sorting.h` as its public header.
    *   **In `library/tests/BUILD.bazel`:** Add a `cc_test` target named `heuristic_sorting_test` that depends on the new `//library/src/heuristic_sorting` library.

2.  **Integrate with `Moves.cpp`:**
    *   In `Moves.cpp`, include the public `heuristic_sorting/heuristic_sorting.h`.
    *   Within the `#ifdef DDS_USE_NEW_HEURISTIC` blocks, replace the legacy logic with a call to the new public `SortMoves()` function.

## Phase 4: Test Implementation

1.  **Set Up Test Harness:**
    *   In `library/tests/heuristic_sorting_test.cpp`, include `heuristic_sorting/internal.h` to gain access to the individual `WeightAlloc...` functions for granular testing.
    *   Follow existing project testing conventions.

2.  **Develop and Implement Test Cases:**
    *   Create distinct test functions for each major scenario described in the documentation (`TestLeadingHand`, `TestLHO`, etc.).
    *   For each scenario, create sub-tests to cover all logical branches.
    *   In each test, construct the required game state, call the specific `WeightAlloc...` function, and assert that the calculated move weights are correct.

## Phase 5: Verification

1.  **Run New Unit Tests:** Execute `bazel test //library/tests:heuristic_sorting_test` and ensure all new tests pass.

2.  **Run Full Regression Test:** Execute `bazel test //...` to ensure the refactoring has not introduced any regressions.

3.  **Final Build:** Confirm the project builds successfully with `bazel build //...`.

4.  **Future Work (Out of Scope for this Plan):** Once the new implementation is fully validated by the tests, the legacy code and the `DDS_USE_NEW_HEURISTIC` flag will be removed.