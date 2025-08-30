## Task 3: Integration and Build System

- **Goal:** Configure the build system for the new component and integrate it into the main codebase.
- **Key Actions:**
    - In `library/src/heuristic_sorting/BUILD.bazel`, define the `cc_library` target, exposing `heuristic_sorting.h` in the `hdrs` attribute.
    - In `library/tests/BUILD.bazel`, define the `cc_test` target for `heuristic_sorting_test`, ensuring it depends on the new library.
    - In `Moves.cpp`, include `heuristic_sorting/heuristic_sorting.h`.
    - In `Moves.cpp`, replace the legacy code with a call to the new public `SortMoves()` function within the `#ifdef DDS_USE_NEW_HEURISTIC` block.
- **Deliverable:** Updated `BUILD.bazel` files and a modified `Moves.cpp` that compiles and integrates the new component.