# Plan: Extract Heuristic Sorting from moves.cpp to heuristic_sorting Library

## Objective
Refactor the heuristic sorting logic from `moves.cpp` into the new `heuristic_sorting` library (`library/src/heuristic_sorting`). Maintain the existing compile-time flag to allow switching between the old and new implementations until the new library is fully validated with extensive unit tests.

## Steps

1. **Review Existing Heuristic Sorting Logic**
   - Analyze the current implementation in `moves.cpp`.
   - Identify all functions, data structures, and dependencies related to heuristic sorting.

2. **Review New Library Scaffolding**
   - Examine the scaffolding in `library/src/heuristic_sorting`.
   - Ensure the new library has the necessary interfaces and data structures to support the migration.

3. **Define Compile-Time Flag Usage**
   - Locate the existing compile-time flag controlling heuristic sorting.
   - Plan to keep this flag in place, allowing selection between the old and new implementations.

4. **Move Heuristic Sorting Code**
   - Extract relevant code from `moves.cpp` and refactor it into the new library.
   - Update includes and dependencies as needed.
   - Ensure the new library is self-contained and modular.

5. **Integrate New Library**
   - Update `moves.cpp` to use the new library when the compile-time flag is enabled.
   - Maintain the old code path for fallback.
   - Ensure build system (Bazel, Makefiles) includes the new library.

6. **Write/Update Unit Tests**
   - Create or update unit tests for the new library in `library/tests` or appropriate test location.
   - Ensure coverage of all heuristic sorting logic.
   - Compare results between old and new implementations for consistency.

7. **Validation and Review**
   - Run all tests with both code paths (old and new).
   - Fix any discrepancies or bugs.
   - Document any differences or limitations.

8. **Prepare for Full Migration**
   - Once the new library passes all tests and is validated, plan to remove the compile-time flag and old code path.
   - Update documentation and changelogs.

## Notes
- The compile-time flag must remain until the new library is proven reliable through extensive testing.
- Refactoring should not change the external behavior of heuristic sorting.
- All changes should be tracked and reviewed for correctness and maintainability.
