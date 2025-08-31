# Task 04: Create LookupTables Header File

## Objective
Create the LookupTables.h header file with declarations for computed lookup tables.

## Steps
1. Create `library/src/utility/LookupTables.h`
2. Add include guards
3. Add necessary includes (for moveGroupType and other types)
4. Declare the lookup table arrays:
   - `extern int highestRank[8192]`
   - `extern int lowestRank[8192]`
   - `extern int counttable[8192]`
   - `extern char relRank[8192][15]`
   - `extern unsigned short int winRanks[8192][14]`
   - `extern moveGroupType groupData[8192]`
5. Declare the initialization function:
   - `void InitLookupTables()`

## Expected Outcome
- Header file with proper declarations for all lookup tables
- Function declaration for initialization
- Proper include guards

## Files Created
- `library/src/utility/LookupTables.h`

## Dependencies
- Task 01 (directory structure)
- Need to understand moveGroupType definition

## Verification
- File compiles without errors
- All arrays are properly declared
- Function declaration is correct
