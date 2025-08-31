# Plan: Extract Global Definitions into Utility Library

## Overview
The current codebase has several global arrays and constants defined in `Init.cpp` and declared as extern in `dds.h`. These are utility definitions that are used across multiple modules and should be extracted into a dedicated utility library.

## Global Definitions to Extract

### 1. Hand relationship arrays:
- `int lho[DDS_HANDS]` - Left-hand opponent lookup
- `int rho[DDS_HANDS]` - Right-hand opponent lookup  
- `int partner[DDS_HANDS]` - Partner lookup

### 2. Card mapping arrays:
- `unsigned short int bitMapRank[16]` - Rank to bitmap conversion
- `unsigned char cardRank[16]` - Rank to character conversion
- `unsigned char cardSuit[DDS_STRAINS]` - Suit to character conversion
- `unsigned char cardHand[DDS_HANDS]` - Hand to character conversion

### 3. Lookup tables (computed):
- `int highestRank[8192]` - Highest rank in suit bitmap
- `int lowestRank[8192]` - Lowest rank in suit bitmap
- `int counttable[8192]` - Population count (number of bits set)
- `char relRank[8192][15]` - Relative rank lookup
- `unsigned short int winRanks[8192][14]` - Winning ranks lookup
- `moveGroupType groupData[8192]` - Move group data

## Implementation Plan

### Phase 1: Create Utility Library Structure

1. **Create utility directory structure:**
   ```
   library/src/utility/
   ├── BUILD.bazel
   ├── Constants.h
   ├── Constants.cpp
   ├── LookupTables.h
   └── LookupTables.cpp
   ```

2. **Create Constants module:**
   - Move static constant arrays to `Constants.h`/`Constants.cpp`
   - Include: `lho`, `rho`, `partner`, `bitMapRank`, `cardRank`, `cardSuit`, `cardHand`

3. **Create LookupTables module:**
   - Move computed tables to `LookupTables.h`/`LookupTables.cpp`
   - Include: `highestRank`, `lowestRank`, `counttable`, `relRank`, `winRanks`, `groupData`
   - Move `InitConstants()` function to initialize these tables

### Phase 2: Extract Definitions

1. **Create `library/src/utility/Constants.h`:**
   - Declare all constant arrays
   - Add appropriate include guards and namespace if needed

2. **Create `library/src/utility/Constants.cpp`:**
   - Define all constant arrays with their initialization values
   - Include `Constants.h`

3. **Create `library/src/utility/LookupTables.h`:**
   - Declare all computed lookup tables
   - Declare `InitConstants()` function (rename to `InitLookupTables()`)

4. **Create `library/src/utility/LookupTables.cpp`:**
   - Define all lookup table arrays
   - Move `InitConstants()` implementation (rename to `InitLookupTables()`)

### Phase 3: Update Build Configuration

1. **Create `library/src/utility/BUILD.bazel`:**
   - Define `cc_library` for constants
   - Define `cc_library` for lookup tables
   - Set appropriate visibility

2. **Update `library/src/BUILD.bazel`:**
   - Add dependency on utility libraries
   - Ensure proper linking

### Phase 4: Update Existing Files

1. **Update `Init.cpp`:**
   - Remove global variable definitions
   - Remove `InitConstants()` function
   - Update `SetResources()` to call `InitLookupTables()` from utility
   - Add includes for utility headers

2. **Update `dds.h`:**
   - Remove extern declarations
   - Add includes for utility headers

3. **Update all dependent files:**
   - Replace `#include "dds.h"` with specific utility includes where needed
   - Files to update: `LaterTricks.cpp`, `Moves.cpp`, `TransTableL.cpp`, etc.

### Phase 5: Testing and Validation

1. **Ensure all files compile without errors**
2. **Run existing tests to ensure functionality is preserved**
3. **Create unit tests for utility libraries**
4. **Verify that the refactored code maintains the same behavior**

### Phase 6: Unit Testing

1. **Create unit test structure for utility libraries**
2. **Write tests for Constants module**
3. **Write tests for LookupTables module**
4. **Integrate tests with build system**
5. **Verify test coverage and functionality**

## Benefits of This Refactoring

1. **Better organization:** Separates utility constants from initialization logic
2. **Improved maintainability:** Clear separation of concerns
3. **Reduced coupling:** Modules only include what they need
4. **Easier testing:** Utility functions can be tested independently
5. **Cleaner API:** Removes global state from main headers

## Dependencies and Files Affected

### Files that will need updates:
- `library/src/Init.cpp` - Remove definitions, update initialization
- `library/src/Init.h` - Update function declarations
- `library/src/dds.h` - Remove extern declarations, add utility includes
- `library/src/dds.cpp` - Update includes
- `library/src/SolverIF.cpp` - Update includes
- `library/src/LaterTricks.cpp` - Update includes for hand lookup arrays
- `library/src/Moves.cpp` - Update includes for hand lookup arrays
- `library/src/TransTableL.cpp` - Update includes for card arrays
- Any other files using these global variables

### New files to create:
- `library/src/utility/BUILD.bazel`
- `library/src/utility/Constants.h`
- `library/src/utility/Constants.cpp`
- `library/src/utility/LookupTables.h`
- `library/src/utility/LookupTables.cpp`

## Notes
This plan provides a systematic approach to extracting the global definitions while maintaining functionality and improving code organization. The refactoring should be done incrementally to ensure each phase works correctly before proceeding to the next.
