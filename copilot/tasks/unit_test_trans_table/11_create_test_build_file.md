# Task 11: Create Test Build Configuration

## Objective
Create the BUILD.bazel file for trans table tests with proper dependencies and test targets.

## Steps
1. Create `library/tests/trans_table/BUILD.bazel`
2. Define cc_test targets for each test file
3. Set up proper dependencies on testable libraries
4. Configure test execution parameters

## Test Targets to Create

### Individual Test Targets
- `trans_table_base_test` - Base class tests
- `trans_table_s_test` - TransTableS tests  
- `trans_table_l_test` - TransTableL tests
- `trans_table_integration_test` - Integration tests
- `trans_table_performance_test` - Performance tests

### Utility Library Target
- `test_utilities` - Test helper functions and mock generators

## Dependencies Required
- `//library/src/trans_table:testable_trans_table`
- `//library/src/utility:constants`
- `//library/src/utility:lookup_tables`
- `//library/src/api:api_definitions`
- `@googletest//:gtest_main`

## Build Configuration
- Follow existing test patterns from heuristic_sorting
- Set appropriate compilation flags
- Configure test timeouts for performance tests
- Enable memory checking flags if available

## Expected Outcome
- All test targets compile successfully
- Tests can be run individually or as a group
- Proper dependency management
- Integration with existing build system

## Files Created
- `library/tests/trans_table/BUILD.bazel`

## Dependencies
- Task 02 (testable library)
- Task 04-10 (all test source files)

## Verification
- `bazel build //library/tests/trans_table/...` succeeds
- `bazel test //library/tests/trans_table/...` runs all tests
- Individual test targets work correctly
