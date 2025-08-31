# Task 06: Create Utility BUILD.bazel File

## Objective
Create the BUILD.bazel file for the utility library with proper Bazel targets.

## Steps
1. Create `library/src/utility/BUILD.bazel`
2. Load necessary Bazel rules
3. Create cc_library target for constants:
   - Name: "constants"
   - Sources: Constants.cpp
   - Headers: Constants.h
   - Include appropriate compiler options and dependencies
4. Create cc_library target for lookup tables:
   - Name: "lookup_tables"
   - Sources: LookupTables.cpp
   - Headers: LookupTables.h
   - Dependencies: ":constants"
5. Set appropriate visibility for both targets

## Expected Outcome
- Working BUILD.bazel file that compiles the utility libraries
- Proper dependencies between lookup tables and constants
- Correct visibility settings

## Files Created
- `library/src/utility/BUILD.bazel`

## Dependencies
- Task 03 (Constants implementation)
- Task 05 (LookupTables implementation)
- Understanding of existing BUILD.bazel structure

## Verification
- `bazel build //library/src/utility:constants` succeeds
- `bazel build //library/src/utility:lookup_tables` succeeds
- No compilation errors
