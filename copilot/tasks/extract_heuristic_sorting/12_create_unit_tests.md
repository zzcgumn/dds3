# Task 12: Create Unit Tests for Heuristic Sorting Library

## Objective
Create comprehensive unit tests for the heuristic sorting library to ensure all functions work correctly and produce identical results to the original implementation.

## Acceptance Criteria
- [ ] Create test framework for heuristic sorting functions
- [ ] Write tests for each ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` function individually
- [ ] Create tests for the `SortMoves` dispatcher
- [ ] Create tests for the `CallHeuristic` integration function
- [ ] Add comparison tests between old and new implementations
- [ ] Achieve high code coverage for all heuristic functions
- [ ] Create test data that covers various game scenarios
- [ ] Ensure tests can be run with the build system

## Implementation Notes
- Tests should be placed in `library/tests/` or similar location
- Use existing test frameworks and patterns from the project
- Create test cases that exercise different code paths in each function
- Consider parameterized tests for testing multiple scenarios
- Include edge cases and boundary conditions
- Test with various trump suits and game states

## Dependencies
- Tasks 04-11 must be completed (full implementation)
- Need understanding of existing test frameworks in the project

## Output
- Comprehensive test suite for the heuristic sorting library
- Tests that validate correctness against original implementation
- Integration with the project's testing framework
- Documentation of test coverage and scenarios
