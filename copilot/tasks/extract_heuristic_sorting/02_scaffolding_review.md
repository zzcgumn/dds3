# Review: Heuristic Sorting Library Scaffolding

## Overview
This document reviews the existing scaffolding in `library/src/heuristic_sorting` and identifies enhancements needed to support the migration from `moves.cpp`.

## HeuristicContext Struct Analysis

### Current Implementation
```cpp
struct HeuristicContext {
    const pos tpos;
    const moveType bestMove;
    const moveType bestMoveTT;
    const relRanksType* thrp_rel;
    moveType* mply;
    int numMoves;
    int lastNumMoves;
    int trump;
    int suit; // For MoveGen0, the suit being considered
    const trackType* trackp;
    int currTrick;
    int currHand;
    int leadHand;
    int leadSuit; // For MoveGen123
};
```

### ✅ Assessment: COMPLETE
The `HeuristicContext` struct contains all necessary members identified in the analysis. It includes:
- All original function parameters (`tpos`, `bestMove`, `bestMoveTT`, `thrp_rel`)
- All required member variables from the Moves class
- Proper const-correctness for read-only data

### ⚠️ Missing Includes
The struct uses `trackType` but only has a forward declaration. This will need to be resolved.

## Function Signatures in internal.h

### Current Declarations
All 13 `WeightAlloc*` functions are properly declared:
- ✅ `WeightAllocTrump0`
- ✅ `WeightAllocNT0`
- ✅ `WeightAllocTrumpNotvoid1`
- ✅ `WeightAllocNTNotvoid1`
- ✅ `WeightAllocTrumpVoid1`
- ✅ `WeightAllocNTVoid1`
- ✅ `WeightAllocTrumpNotvoid2`
- ✅ `WeightAllocNTNotvoid2`
- ✅ `WeightAllocTrumpVoid2`
- ✅ `WeightAllocNTVoid2`
- ✅ `WeightAllocCombinedNotvoid3`
- ✅ `WeightAllocTrumpVoid3`
- ✅ `WeightAllocNTVoid3`

### ✅ Assessment: COMPLETE
All function signatures match the expected pattern and use the correct `HeuristicContext&` parameter.

## SortMoves Dispatcher Function

### Current Implementation
```cpp
void SortMoves(HeuristicContext& context) {
    // This is a simplified dispatcher. The actual logic to choose the
    // correct WeightAlloc function will be more complex and based on the
    // logic in Moves::MoveGen0 and Moves::MoveGen123.
    // For now, we'll just call one of them as a placeholder.
    WeightAllocTrump0(context);
}
```

### ⚠️ Assessment: NEEDS IMPLEMENTATION
The dispatcher is currently a placeholder. It needs to implement the logic from:
- `MoveGen0`: Choose between `WeightAllocTrump0` and `WeightAllocNT0`
- `MoveGen123`: Use the `WeightList[findex]` selection logic

## BUILD.bazel Configuration

### Current Configuration
```starlark
cc_library(
    name = "heuristic_sorting",
    srcs = glob(["*.cpp"]),
    hdrs = glob(["*.h"]),
    visibility = ["//visibility:public"],
    deps = [
        "//library/src/utility:constants",
        "//library/src/utility:lookup_tables",
    ],
    copts = DDS_CPPOPTS,
    linkopts = DDS_LINKOPTS,
    local_defines = DDS_LOCAL_DEFINES,
)
```

### ✅ Assessment: GOOD FOUNDATION
The BUILD file provides:
- Proper visibility for library consumers
- Dependencies on utility libraries
- Standard compilation options
- Separate testable target for testing

### ⚠️ Missing Dependencies
The library will need access to:
- Global arrays like `relRank`, `lho`, `rho`, `partner`
- Constants and helper functions from the main DDS library

## Required Enhancements

### 1. Resolve trackType Definition
**Priority: HIGH**

The `trackType` forward declaration needs to be resolved. Options:
1. Include the full definition in the header
2. Create a public interface that doesn't expose `trackType`
3. Extract `trackType` to a shared header

**Recommendation**: Extract `trackType` and related structures to a shared header since they're needed by both the main library and heuristic sorting.

### 2. Add Missing Includes
**Priority: HIGH**

The library needs access to:
```cpp
#include "dll.h" // For helper functions and global arrays
```

### 3. Implement CallHeuristic Function
**Priority: MEDIUM**

Add a `CallHeuristic` function to match the interface expected by `moves.cpp`:
```cpp
void CallHeuristic(
    const pos& tpos,
    const moveType& bestMove,
    const moveType& bestMoveTT,
    const relRanksType thrp_rel[],
    moveType* mply,
    int numMoves,
    int lastNumMoves,
    int trump,
    int suit,
    const trackType* trackp,
    int currTrick,
    int currHand,
    int leadHand,
    int leadSuit);
```

### 4. Implement Dispatcher Logic
**Priority: HIGH**

The `SortMoves` function needs to implement the selection logic currently in `moves.cpp`.

### 5. Add Utility Functions
**Priority: MEDIUM**

Consider if any utility functions from `moves.cpp` need to be extracted, such as:
- Helper functions used by multiple `WeightAlloc` functions
- Constants or lookup tables specific to heuristic sorting

## Dependencies Analysis

### Current Dependencies
```starlark
deps = [
    "//library/src/utility:constants",
    "//library/src/utility:lookup_tables",
],
```

### Additional Dependencies Needed
1. Main DDS library for `pos`, `moveType`, etc.
2. Access to global helper arrays (`relRank`, `lho`, `rho`, `partner`)
3. Potentially the main library for `trackType` definition

## Include Strategy

### Current Includes
```cpp
// heuristic_sorting.h
#include "dds/dds.h"

// heuristic_sorting.cpp
#include "internal.h"
#include "dds/dds.h"
```

### Missing Includes
```cpp
// Need to add:
#include "dll.h" // For global arrays and helper functions
```

## Recommendations

### Immediate Actions (Before Starting Extraction)
1. ✅ **RESOLVED**: `HeuristicContext` is complete
2. ⚠️ **TODO**: Resolve `trackType` forward declaration
3. ⚠️ **TODO**: Add missing includes for global arrays
4. ⚠️ **TODO**: Add `CallHeuristic` function declaration

### During Extraction
1. Implement proper dispatcher logic in `SortMoves`
2. Extract and implement each `WeightAlloc` function
3. Add any needed utility functions

### Final Integration
1. Update BUILD dependencies as needed
2. Ensure all functions compile and link correctly
3. Validate the interface works with `moves.cpp`

## Conclusion

The scaffolding provides a solid foundation with:
- ✅ Complete `HeuristicContext` structure
- ✅ All function signatures declared
- ✅ Proper build configuration

The main gaps are:
- ⚠️ Missing `trackType` definition resolution
- ⚠️ Placeholder dispatcher implementation
- ⚠️ Missing `CallHeuristic` integration function

These issues should be addressed before beginning the function extraction process.
