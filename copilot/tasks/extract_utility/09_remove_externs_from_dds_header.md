# Task 09: Remove Extern Declarations from dds.h

## Objective
Remove the extern declarations for global variables from dds.h since they're now in utility headers.

## Steps
1. Open `library/src/dds.h`
2. Remove the following extern declarations:
   - `extern int lho[DDS_HANDS]`
   - `extern int rho[DDS_HANDS]`
   - `extern int partner[DDS_HANDS]`
   - `extern unsigned short int bitMapRank[16]`
   - `extern unsigned char cardRank[16]`
   - `extern unsigned char cardSuit[DDS_STRAINS]`
   - `extern unsigned char cardHand[DDS_HANDS]`
   - `extern int highestRank[8192]`
   - `extern int lowestRank[8192]`
   - `extern int counttable[8192]`
   - `extern char relRank[8192][15]`
   - `extern unsigned short int winRanks[8192][14]`
   - `extern moveGroupType groupData[8192]`
3. Add includes for utility headers:
   - `#include "utility/Constants.h"`
   - `#include "utility/LookupTables.h"`

## Expected Outcome
- dds.h no longer has extern declarations for moved variables
- dds.h includes utility headers to provide access to the variables
- Other files including dds.h will still have access to the global variables

## Files Modified
- `library/src/dds.h`

## Dependencies
- Tasks 02-06 (utility headers created)

## Verification
- dds.h compiles without errors
- Files that include dds.h can still access the global variables
- No duplicate declarations
