## Task 1: Analysis and Scaffolding

- **Goal:** Locate the heuristic sorting code and create the necessary file and directory structure for the new component and its tests.
- **Key Actions:**
    - Search the codebase (primarily `library/src/ABsearch.cpp` and `library/src/LaterTricks.cpp`) for key terms from `doc/heuristic-sorting.md` to identify the functions implementing the move weighting algorithm.
    - Create the directory `library/src/heuristic_sorting`.
    - Create an empty build file `library/src/heuristic_sorting/BUILD.bazel`.
    - Create the header file `library/src/heuristic_sorting/internal.h` for test-visible functions.
    - Create the test implementation file `library/tests/heuristic_sorting_test.cpp`.
- **Deliverable:** A new directory structure and empty files prepared for the refactoring and testing work.