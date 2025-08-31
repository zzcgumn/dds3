# Task 05: Create LookupTables Implementation File

## Objective
Create the LookupTables.cpp implementation file with lookup table definitions and initialization.

## Steps
1. Create `library/src/utility/LookupTables.cpp`
2. Include `LookupTables.h` and `Constants.h`
3. Add necessary system includes (algorithm, string.h, etc.)
4. Define the lookup table arrays:
   - `int highestRank[8192]`
   - `int lowestRank[8192]`
   - `int counttable[8192]`
   - `char relRank[8192][15]`
   - `unsigned short int winRanks[8192][14]`
   - `moveGroupType groupData[8192]`
5. Copy the `InitConstants()` function from `Init.cpp` and rename to `InitLookupTables()`
6. Update the function to use the constants from the Constants module

## Expected Outcome
- Implementation file with all lookup tables defined
- Initialization function that populates the tables correctly
- Function uses constants from Constants module

## Files Created
- `library/src/utility/LookupTables.cpp`

## Dependencies
- Task 04 (LookupTables.h header)
- Task 03 (Constants implementation)
- Access to original InitConstants() function in Init.cpp

## Verification
- File compiles without errors
- InitLookupTables() function works correctly
- All lookup tables are properly initialized
