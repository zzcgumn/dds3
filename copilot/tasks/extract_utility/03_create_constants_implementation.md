# Task 03: Create Constants Implementation File

## Objective
Create the Constants.cpp implementation file with definitions of all constant arrays.

## Steps
1. Create `library/src/utility/Constants.cpp`
2. Include `Constants.h`
3. Copy the constant array definitions from `Init.cpp`:
   - `int lho[DDS_HANDS] = { 1, 2, 3, 0 }`
   - `int rho[DDS_HANDS] = { 3, 0, 1, 2 }`
   - `int partner[DDS_HANDS] = { 2, 3, 0, 1 }`
   - `unsigned short int bitMapRank[16] = { ... }`
   - `unsigned char cardRank[16] = { ... }`
   - `unsigned char cardSuit[DDS_STRAINS] = { ... }`
   - `unsigned char cardHand[DDS_HANDS] = { ... }`

## Expected Outcome
- Implementation file with all constant arrays properly defined
- Arrays initialized with correct values from original Init.cpp

## Files Created
- `library/src/utility/Constants.cpp`

## Dependencies
- Task 02 (Constants.h header)
- Access to original Init.cpp to copy values

## Verification
- File compiles without errors
- All constant values match original definitions
- No missing initializations
