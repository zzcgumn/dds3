# Task 14: Write unit tests for Constants module

## Objective
Create comprehensive unit tests for the Constants module that verify all constant arrays have correct values and properties.

## Files to create
- `library/tests/utility/constants_test.cpp`

## Test coverage

1. **Hand relationship arrays**:
   - Test lho array values (left-hand opponent mappings)
   - Test rho array values (right-hand opponent mappings)  
   - Test partner array values (partner mappings)
   - Verify array bounds and complete coverage

2. **Card mapping arrays**:
   - Test bitMapRank array for bit patterns
   - Test cardRank array for rank mappings
   - Test cardSuit array for suit mappings
   - Test cardHand array for hand mappings
   - Verify expected values match original Init.cpp values

3. **Array properties**:
   - Test array sizes are correct
   - Test boundary values
   - Test symmetry properties where applicable

## Test structure
- Use Google Test framework with TEST_F or TEST functions
- Create test fixture if needed for setup/teardown
- Group related tests logically
- Include descriptive test names and assertions

## Expected outcome
- Comprehensive test coverage for all constant arrays
- Tests pass and verify correct values from original implementation
- Clear test documentation and maintainable test code
