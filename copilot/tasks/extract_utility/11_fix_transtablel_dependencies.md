# Task 11: Fix Specific File Dependencies - TransTableL.cpp

## Objective
Update TransTableL.cpp which has local extern declarations for some global variables.

## Steps
1. Open `library/src/TransTableL.cpp`
2. Find the local extern declarations:
   - `extern unsigned char cardRank[16]`
   - `extern char relRank[8192][15]`
3. Remove these local extern declarations
4. Add include for utility headers at the top:
   - `#include "utility/Constants.h"`
   - `#include "utility/LookupTables.h"`
5. Verify the file still compiles and works correctly

## Expected Outcome
- TransTableL.cpp uses utility headers instead of local extern declarations
- No compilation errors
- Functionality remains the same

## Files Modified
- `library/src/TransTableL.cpp`

## Dependencies
- Tasks 02-10 (utility library fully set up)

## Verification
- TransTableL.cpp compiles without errors
- No duplicate declaration warnings
- Functionality is preserved
