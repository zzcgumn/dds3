# Analysis: Heuristic Sorting Code in moves.cpp

## Overview
This document provides a comprehensive analysis of the heuristic sorting implementation in `moves.cpp` to guide the extraction process.

## `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic) Functions to be Extracted

The specialized weight-allocation functions (historically called ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*`) were extracted from `moves.cpp` and implemented as standalone functions inside `library/src/heuristic_sorting/`. These functions are declared in `heuristic_sorting/internal.h` and invoked by the public `CallHeuristic(...)` entrypoint. The migration preserves the original behavior while centralizing heuristic logic.

## Function Signatures and Parameters

### Type 0 Functions (First Lead)
```cpp
void `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)(
  const pos& tpos,
  const moveType& bestMove,
  const moveType& bestMoveTT,
  const relRanksType thrp_rel[])
```

### Type 1-3 Functions (Subsequent Leads)
```cpp
void `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)(const pos& tpos)
void `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)(const pos& tpos)
// ... (similar pattern for all other functions)
```

## Member Variables Accessed by Heuristic Functions

The following Moves class member variables are accessed by the heuristic functions:

### Core State Variables
- `leadHand` - The hand that leads the current trick
- `trump` - Trump suit (0-3 for suits, 4 for no-trump)
- `suit` - Current suit being considered for MoveGen0
- `currTrick` - Current trick number (0-12)
- `currHand` - Current hand playing
- `numMoves` - Total number of moves generated
- `lastNumMoves` - Number of moves from previous iteration
- `mply` - Pointer to move array
- `trackp` - Pointer to current track data

### Data Structures
- `track[]` - Array of track data for each trick
- `moveList[][]` - Move lists by trick and hand

## Current Usage of DDS_USE_NEW_HEURISTIC

The compile flag `DDS_USE_NEW_HEURISTIC` is used in the following locations:

### MoveGen0 Function (lines 206-216)
```cpp
if (ftest)
#ifdef DDS_USE_NEW_HEURISTIC
  Moves::CallHeuristic(tpos, bestMove, bestMoveTT, thrp_rel);
#else
  Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)(tpos, bestMove, bestMoveTT, thrp_rel);
#endif
else
#ifdef DDS_USE_NEW_HEURISTIC
  Moves::CallHeuristic(tpos, bestMove, bestMoveTT, thrp_rel);
#else
  Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)(tpos, bestMove, bestMoveTT, thrp_rel);
#endif
```

### MoveGen123 Function (lines 294-298, 337-341)
```cpp
#ifdef DDS_USE_NEW_HEURISTIC
Moves::CallHeuristic(tpos, moveType{}, moveType{}, nullptr);
#else
(this->*WeightList[findex])(tpos);
#endif
```

### MergeSort Function (line 2021+)
```cpp
#ifdef DDS_USE_NEW_HEURISTIC
  // New implementation
#else
  // Old implementation (existing merge sort logic)
```

## Current CallHeuristic Implementation

The `CallHeuristic` function (line 2005) currently creates a `HeuristicContext` and calls `SortMoves`:

```cpp
void Moves::CallHeuristic(
    const pos& tpos,
    const moveType& bestMove,
    const moveType& bestMoveTT,
    const relRanksType thrp_rel[]) {
  HeuristicContext context {
      tpos,
      bestMove,
      bestMoveTT,
      thrp_rel,
  };
  SortMoves(context);
}
```

## WeightList Array and Dispatcher Logic

The `WeightList` array (initialized around line 82) maps function indices to specific `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic) functions:

```cpp
WeightList[ 4] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[ 5] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[ 6] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[ 7] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[ 8] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[ 9] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[10] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[11] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[12] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[13] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[14] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
WeightList[15] = &Moves::`\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic);
```

## Dependencies and Integration Points

### External Dependencies
- `pos` structure from dds.h
- `moveType` and `relRanksType` from dds.h
- Global helper functions like `lho[]`, `rho[]`, `partner[]`
- `relRank` global array

### Internal Dependencies
- Access to `mply` move array
- Access to member variables for game state
- Integration with `MergeSort()` function
- Statistics tracking (optional)

## Missing HeuristicContext Members

Comparing the current `HeuristicContext` with accessed member variables, the following are missing:

```cpp
struct HeuristicContext {
    // Current members:
    const pos tpos;
    const moveType bestMove;
    const moveType bestMoveTT;
    const relRanksType* thrp_rel;
    
    // Missing members needed:
    moveType* mply;           // Move array
    int numMoves;             // Total moves
    int lastNumMoves;         // Previous move count
    int trump;                // Trump suit
    int suit;                 // Current suit (for MoveGen0)
    const trackType* trackp;  // Track data
    int currTrick;            // Current trick
    int currHand;             // Current hand
    int leadHand;             // Lead hand
    int leadSuit;             // Lead suit (for MoveGen123)
};
```

## Compile Flag Strategy

Currently, `DDS_USE_NEW_HEURISTIC` is:
- Not defined by default (flag is off)
- Used to switch between old and new implementations
- Needs to be defined in build system to enable new library
- Should remain until new implementation is fully validated

## Next Steps

1. Update `HeuristicContext` with missing members
2. Extract `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic) functions incrementally
3. Implement proper dispatcher logic in `SortMoves`
4. Update integration points in `moves.cpp`
5. Create comprehensive testing strategy
