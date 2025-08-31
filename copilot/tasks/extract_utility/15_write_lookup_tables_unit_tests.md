# Task 15: Write unit tests for LookupTables module

## Objective
Create comprehensive unit tests for the LookupTables module that verify the InitLookupTables function and all computed lookup tables.

## Files to create
- `library/tests/utility/lookup_tables_test.cpp`

## Test coverage

1. **InitLookupTables function**:
   - Test that function can be called without errors
   - Test that function properly initializes all tables
   - Test idempotency (calling multiple times is safe)

2. **Lookup table properties**:
   - Test highestRank array has valid values
   - Test lowestRank array has valid values  
   - Test counttable array has correct bit counts
   - Test relRank array dimensions and value ranges
   - Test winRanks array dimensions and value ranges
   - Test groupData array has valid moveGroupType entries

3. **Table consistency**:
   - Test relationships between different tables
   - Verify computed values make sense for bridge logic
   - Test edge cases and boundary conditions

4. **moveGroupType struct**:
   - Test that struct can be created and used
   - Test struct member access
   - Test array of structs (groupData)

## Test structure
- Use Google Test framework with TEST_F for fixture-based tests
- Create test fixture that calls InitLookupTables in SetUp
- Group tests by table type
- Include performance tests if needed
- Test both individual table entries and overall properties

## Expected outcome
- Comprehensive test coverage for lookup table initialization and usage
- Tests verify computed tables are correctly initialized
- Performance validation that initialization completes in reasonable time
- Clear documentation of expected table behaviors
