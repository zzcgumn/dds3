# Task 02: Create Testable Trans Table Library

## Objective
Modify the trans table BUILD.bazel file to include a testable library target, similar to how heuristic_sorting has a testable version.

## Steps
1. Open `library/src/trans_table/BUILD.bazel`
2. Add a `testable_trans_table` cc_library target
3. Include both .cpp and .h files in srcs for testing access
4. Set appropriate visibility for test packages
5. Ensure all dependencies are included

## Expected Outcome
- `testable_trans_table` target available for unit tests
- Test code can access internal implementation details
- Follows same pattern as `testable_heuristic_sorting`

## Files Modified
- `library/src/trans_table/BUILD.bazel`

## Dependencies
- Task 01 (test directory structure)

## Verification
- `bazel build //library/src/trans_table:testable_trans_table` succeeds
- Target has proper visibility for tests
