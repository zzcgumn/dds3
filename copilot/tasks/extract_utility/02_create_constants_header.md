# Task 02: Create Constants Header File

## Objective
Create the Constants.h header file with declarations for all constant arrays.

## Steps
1. Create `library/src/utility/Constants.h`
2. Add include guards
3. Add necessary includes (for DDS_HANDS, DDS_STRAINS constants)
4. Declare the constant arrays:
   - `extern int lho[DDS_HANDS]`
   - `extern int rho[DDS_HANDS]`
   - `extern int partner[DDS_HANDS]`
   - `extern unsigned short int bitMapRank[16]`
   - `extern unsigned char cardRank[16]`
   - `extern unsigned char cardSuit[DDS_STRAINS]`
   - `extern unsigned char cardHand[DDS_HANDS]`

## Expected Outcome
- Header file with proper declarations for all constant arrays
- Include guards to prevent multiple inclusion
- Proper types and array sizes

## Files Created
- `library/src/utility/Constants.h`

## Dependencies
- Task 01 (directory structure)
- Need to understand DDS_HANDS and DDS_STRAINS definitions

## Verification
- File compiles without errors
- All arrays are properly declared with extern
