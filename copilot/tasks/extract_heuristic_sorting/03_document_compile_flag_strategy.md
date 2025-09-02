# Task 03: Document Compile-Time Flag Usage and Strategy

## Objective
Document the current usage of `DDS_USE_NEW_HEURISTIC` compile flag and create a strategy for maintaining both old and new implementations during the transition.

## Acceptance Criteria
- [ ] Document all current locations where `DDS_USE_NEW_HEURISTIC` is used
- [ ] Understand the flag's current behavior and scope
- [ ] Define the strategy for using the flag during migration
- [ ] Ensure the flag can control switching between old and new implementations
- [ ] Document how to build with both flag settings
- [ ] Plan for eventual removal of the flag

## Implementation Notes
- The flag is currently used in `moves.cpp` at lines 206, 212, 294, 337, and 2021
- Need to understand if this flag is defined in build system or header files
- Must ensure both code paths can coexist and be tested independently
- Consider if additional flag granularity is needed for incremental migration

## Current Known Locations
- `library/src/Moves.cpp`: Lines 206, 212, 294, 337, 2021

## Output
Create a strategy document explaining:
1. How the flag currently works
2. How it will be used during migration
3. Build instructions for both settings
4. Timeline for flag removal
