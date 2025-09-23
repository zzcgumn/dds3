# Strategy: DDS_USE_NEW_HEURISTIC Compile Flag

## Overview
This document defines the strategy for using the `DDS_USE_NEW_HEURISTIC` compile flag during the heuristic sorting extraction and migration process.

## Current Flag Status

### Definition Location
- ⚠️ **The flag is NOT currently defined anywhere in the codebase**
- It exists only as conditional compilation blocks in `moves.cpp`
- By default, the OLD implementation is used (flag undefined)

### Current Usage Locations

#### 1. MoveGen0 Function (moves.cpp lines 206-216)
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

#### 2. MoveGen123 Function (moves.cpp lines 294-298)
```cpp
#ifdef DDS_USE_NEW_HEURISTIC
Moves::CallHeuristic(tpos, moveType{}, moveType{}, nullptr);
#else
(this->*WeightList[findex])(tpos);
#endif
```

#### 3. MoveGen123 Function (moves.cpp lines 337-341)
```cpp
#ifdef DDS_USE_NEW_HEURISTIC
Moves::CallHeuristic(tpos, moveType{}, moveType{}, nullptr);
#else
(this->*WeightFnc)(tpos);
#endif
```

#### 4. MergeSort Function (moves.cpp lines 2021+)
```cpp
#ifdef DDS_USE_NEW_HEURISTIC
  // New implementation
#else
  // Old implementation (existing merge sort logic)
#endif
```

## Flag Strategy During Migration

### Phase 1: Setup and Initial Implementation
**Status**: Ready to implement

1. **Define the flag in build system**
   - Add to Bazel build configuration
   - Add to Makefiles for non-Bazel builds
   - Default to OFF (undefined) for safety

2. **Validate both code paths compile**
   - Test with flag OFF (old implementation)
   - Test with flag ON (new implementation)
   - Ensure no compilation errors in either mode

### Phase 2: Incremental Implementation
**Status**: During function extraction

1. **Keep flag OFF during development**
   - All development and testing uses old implementation
   - New implementation is built but not used
   - Prevents breaking existing functionality

2. **Enable flag for specific testing**
   - Use flag ON for unit testing new functions
   - Compare results between old and new implementations
   - Validate correctness incrementally

### Phase 3: Validation and Testing
**Status**: After all functions extracted

1. **Comprehensive testing with both settings**
   - Run full test suites with flag OFF and ON
   - Performance testing with both implementations
   - Regression testing to ensure identical behavior

2. **Default remains OFF until fully validated**
   - Conservative approach to prevent production issues
   - Only switch default after extensive validation

### Phase 4: Production Transition
**Status**: After validation complete

1. **Switch default to ON**
   - Change default from OFF to ON
   - Monitor for any issues
   - Keep old implementation available for quick rollback

2. **Deprecation timeline**
   - Announce deprecation of old implementation
   - Set timeline for removing old code (e.g., 2-3 releases)
   - Document migration path for users

## Implementation Strategy

### Build System Integration

#### Bazel Configuration
Add to `CPPVARIABLES.bzl`:
```starlark
# Heuristic sorting implementation selection
DDS_USE_NEW_HEURISTIC = select({
    "//config:new_heuristic": ["DDS_USE_NEW_HEURISTIC"],
    "//conditions:default": [],
})
```

Add to appropriate BUILD.bazel:
```starlark
local_defines = DDS_LOCAL_DEFINES + DDS_USE_NEW_HEURISTIC
```

#### Makefile Configuration
Add option to Makefiles:
```makefile
# Add to CFLAGS when new heuristic is desired
ifdef USE_NEW_HEURISTIC
CFLAGS += -DDDS_USE_NEW_HEURISTIC
endif
```

### Code Organization

#### Current CallHeuristic Function
The `CallHeuristic` function in `moves.cpp` (line 2005) is already partially implemented:
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

#### Required Updates
1. **Complete HeuristicContext construction**
   - Add missing member variables to context
   - Ensure all required data is passed to new library

2. **Handle MergeSort integration**
   - New library should handle sorting internally
   - Or provide interface for external sorting

## Testing Strategy

### Dual-Path Testing
1. **Automated testing with both flags**
   ```bash
   # Test old implementation
   bazel test //... --define=use_new_heuristic=false
   
   # Test new implementation
   bazel test //... --define=use_new_heuristic=true
   ```

2. **Comparison testing**
   - Run same scenarios with both implementations
   - Compare results for identity
   - Performance benchmarking

### Continuous Integration
1. **Matrix builds**
   - Test all platforms with both flag settings
   - Ensure no regressions in either mode

2. **Performance monitoring**
   - Track performance metrics for both implementations
   - Alert on significant regressions

## Migration Timeline

### Immediate (Tasks 4-11)
- [ ] Define flag in build systems
- [ ] Ensure both paths compile
- [ ] Implement new library incrementally
- [ ] Keep flag OFF by default

### Short-term (Tasks 12-13)
- [ ] Comprehensive testing with both flags
- [ ] Validate identical behavior
- [ ] Performance comparison

### Medium-term (Task 14-15)
- [ ] Switch default to ON
- [ ] Monitor production usage
- [ ] Document any differences

### Long-term (Future release)
- [ ] Remove old implementation
- [ ] Clean up flag usage
- [ ] Update documentation

## Rollback Strategy

### Immediate Rollback
If issues are discovered after switching default to ON:
1. Change default back to OFF in build system
2. Rebuild and redeploy
3. Investigate and fix issues

### Code Rollback
If fundamental issues are found:
1. Old implementation remains intact
2. Can completely disable new library
3. Remove new library integration if necessary

## Flag Removal Plan

### Conditions for Removal
1. ✅ New implementation fully validated
2. ✅ Performance acceptable or better
3. ✅ No significant behavior differences
4. ✅ Production usage stable for X releases
5. ✅ Team confidence in new implementation

### Removal Process
1. **Announce deprecation**
   - Update documentation
   - Notify users of timeline

2. **Remove old code**
   - Delete old `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic) functions from moves.cpp
   - Remove flag conditionals
   - Clean up related code

3. **Update documentation**
   - Remove flag references
   - Update build instructions

## Risk Mitigation

### Development Risks
- **Risk**: Breaking existing functionality
- **Mitigation**: Keep flag OFF during development

### Testing Risks
- **Risk**: Missing edge cases in comparison
- **Mitigation**: Comprehensive test suite with real game data

### Performance Risks
- **Risk**: New implementation slower
- **Mitigation**: Performance benchmarking before switching default

### Production Risks
- **Risk**: Subtle behavior differences
- **Mitigation**: Extensive validation and careful rollout

## Conclusion

The `DDS_USE_NEW_HEURISTIC` flag provides a safe mechanism for:
- ✅ Incremental development without breaking existing functionality
- ✅ Comprehensive testing of both implementations
- ✅ Safe production transition
- ✅ Quick rollback if issues arise

The flag should remain until the new implementation is proven reliable through extensive testing and production usage.
