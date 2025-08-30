## Task 2: Refactoring for Testability

- **Goal:** Extract the heuristic sorting logic into the new component and update the build system to make it testable.
- **Key Actions:**
    - Move the identified heuristic functions into `library/src/heuristic_sorting/heuristic_sorting.cpp`.
    - Add the declarations of the moved functions to `library/src/heuristic_sorting/internal.h`, ensuring they are not `static`.
    - In `library/src/heuristic_sorting/BUILD.bazel`, define a `cc_library` named `heuristic_sorting`.
    - In `library/tests/BUILD.bazel`, define a `cc_test` target named `heuristic_sorting_test` that depends on the new library.
    - Modify the original source files to `#include` the new header and call the refactored functions.
- **Deliverable:** Refactored source code and updated Bazel build files. The project should compile successfully after this step.