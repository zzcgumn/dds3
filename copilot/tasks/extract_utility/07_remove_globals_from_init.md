# Task 07: Remove Global Definitions from Init.cpp

## Objective
Remove the global variable definitions from Init.cpp that have been moved to the utility library.

## Steps
1. Open `library/src/Init.cpp`
2. Remove the following global variable definitions:
   - `int lho[DDS_HANDS] = { 1, 2, 3, 0 }`
   - `int rho[DDS_HANDS] = { 3, 0, 1, 2 }`
   - `int partner[DDS_HANDS] = { 2, 3, 0, 1 }`
   - `unsigned short int bitMapRank[16] = { ... }`
   - `unsigned char cardRank[16] = { ... }`
   - `unsigned char cardSuit[DDS_STRAINS] = { ... }`
   - `unsigned char cardHand[DDS_HANDS] = { ... }`
   - `int highestRank[8192]`
   - `int lowestRank[8192]`
   - `int counttable[8192]`
   - `char relRank[8192][15]`
   - `unsigned short int winRanks[8192][14]`
   - `moveGroupType groupData[8192]`
3. Remove the `InitConstants()` function completely
4. Add includes for the utility headers:
   - `#include "utility/Constants.h"`
   - `#include "utility/LookupTables.h"`

## Expected Outcome
- Init.cpp no longer contains the global variable definitions
- Init.cpp includes the utility headers
- InitConstants() function is removed

## Files Modified
- `library/src/Init.cpp`

## Dependencies
- Tasks 02-06 (all utility files created)

## Verification
- Init.cpp compiles without errors
- No duplicate symbol errors
- Utility headers are properly included
