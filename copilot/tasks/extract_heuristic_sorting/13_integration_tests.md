# Task 13: Integration Tests - Comparing Old vs New Implementations

## Objective
Create comprehensive integration tests that verify the new modular heuristic sorting library produces identical results to the original implementation across various game scenarios.

## Implementation Plan

### 13.1 Test Framework Design
- Create integration test suite using Google Test
- Design test scenarios covering different bridge game states
- Implement comparison utilities for validating identical behavior

### 13.2 Test Scenarios
- **Leading Hand Tests**: Various trump/NT scenarios with different move sets
- **Following Hand Tests**: Void and non-void situations across all positions
- **Edge Cases**: Boundary conditions and unusual game states
- **Comprehensive Coverage**: All 13 `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic) function paths

### 13.3 Comparison Methodology
- Run identical inputs through both implementations
- Compare resulting move weights exactly
- Validate dispatcher routing logic
- Test with various move set sizes (1-13 moves)

### 13.4 Test Data Generation
- Create representative bridge positions
- Generate diverse move combinations
- Include problematic edge cases from real games
- Test with different trick levels and game states

## Expected Outcomes
- All integration tests pass with 100% weight matching
- Confidence in behavioral equivalence between implementations
- Comprehensive test coverage for future maintenance
- Documentation of any discovered edge cases

## Files to Create/Modify
- `library/tests/heuristic_sorting/integration_test.cpp`
- `library/tests/heuristic_sorting/BUILD.bazel` (add integration test target)
- Test data files or generators as needed

## Success Criteria
- Integration tests compile and run successfully
- All old vs new comparisons show identical results
- Test coverage includes all major heuristic function paths
- No regressions detected in move sorting behavior
