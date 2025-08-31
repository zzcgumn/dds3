# Task 08: Update Init.cpp to Use Utility Functions

## Objective
Update the SetResources() function in Init.cpp to call InitLookupTables() from the utility library.

## Steps
1. Open `library/src/Init.cpp`
2. Find the `SetResources()` function
3. Locate the call to `InitConstants()` inside the initialization block
4. Replace `InitConstants()` with `InitLookupTables()`
5. Ensure the function call is in the same location (within the `if (! _initialized)` block)

## Expected Outcome
- SetResources() function calls InitLookupTables() instead of InitConstants()
- Initialization logic remains the same
- Function is called at the right time during initialization

## Files Modified
- `library/src/Init.cpp`

## Dependencies
- Task 07 (globals removed from Init.cpp)
- Task 05 (InitLookupTables() function created)

## Verification
- Init.cpp compiles without errors
- SetResources() function works correctly
- Lookup tables are properly initialized when called
