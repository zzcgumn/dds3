# Task 13: Create BUILD.bazel file for utility unit tests

## Objective
Create a BUILD.bazel file in library/tests/utility directory to configure Google Test builds for the utility library tests.

## Files to modify/create
- `library/tests/utility/BUILD.bazel`

## Actions

1. Create BUILD.bazel file following the pattern from library/tests/regression/heuristic_sorting/
2. Include cc_test targets for:
   - Constants module tests
   - LookupTables module tests  
3. Add dependencies on:
   - @googletest//:gtest_main
   - //library/src/utility:constants
   - //library/src/utility:lookup_tables
4. Configure proper test environments and data

## Expected outcome
- Properly configured test build file that can compile and run unit tests for utility modules
- Follows established patterns from existing test directories
- Ready for test implementation files
