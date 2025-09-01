# Plan: Extract Heuristic Sorting from moves.cpp to heuristic_sorting Library

## Objective
Refactor the heuristic sorting logic from `moves.cpp` into the new `heuristic_sorting` library (`library/src/heuristic_sorting`). Maintain the existing compile-time flag to allow switching between the old and new implementations until the new library is fully validated with extensive unit tests.

## Steps

1. **Review Existing Heuristic Sorting Logic** ✅ COMPLETED
   - Analyze the current implementation in `moves.cpp`.
   - Identify all functions, data structures, and dependencies related to heuristic sorting.

2. **Review New Library Scaffolding** ✅ COMPLETED
   - Examine the scaffolding in `library/src/heuristic_sorting`.
   - Ensure the new library has the necessary interfaces and data structures to support the migration.

3. **Define Compile-Time Flag Usage** ✅ COMPLETED
   - Locate the existing compile-time flag controlling heuristic sorting.
   - Plan to keep this flag in place, allowing selection between the old and new implementations.

4. **Move Heuristic Sorting Code** ✅ COMPLETED
   - Extract relevant code from `moves.cpp` and refactor it into the new library.
   - Update includes and dependencies as needed.
   - Ensure the new library is self-contained and modular.

5. **Integrate New Library** ✅ COMPLETED
   - Update `moves.cpp` to use the new library when the compile-time flag is enabled.
   - Maintain the old code path for fallback.
   - Ensure build system (Bazel, Makefiles) includes the new library.

6. **Write/Update Unit Tests** ✅ COMPLETED
   - Create or update unit tests for the new library in `library/tests` or appropriate test location.
   - Ensure coverage of all heuristic sorting logic.
   - Compare results between old and new implementations for consistency.

7. **Validation and Review** ✅ COMPLETED
   - Run all tests with both code paths (old and new).
   - Fix any discrepancies or bugs.
   - Document any differences or limitations.

8. **Performance Investigation** 🔍 IDENTIFIED ISSUE
   - **CRITICAL**: New heuristic library shows 31% performance regression
   - Old implementation: 4.73ms per hand avg
   - New implementation: 6.21ms per hand avg
   - Need investigation and optimization

9. **Validate Heuristic Sorting Algorithm Correctness** ⚠️ REQUIRED - CRITICAL FOR PERFORMANCE
   - **Poor heuristic sorting will result in the A/B search expanding more nodes. This is a likely cause of the performance degradation**
   - Compare weights calculated with the new and legacy version of heuristic sorting
   - **Sub-tasks for heuristic validation:**
     - **9.1**: Create weight comparison tests that capture weight values from both implementations
     - **9.2**: Verify weight calculation consistency across different game scenarios:
       - Leading hand vs following hands (positions 1-3) 
       - Trump vs No-Trump contracts
       - Different suit distributions and void hands
       - Various trick numbers (early vs late game)
     - **9.3**: Analyze alpha-beta search node expansion metrics:
       - Add instrumentation to count nodes visited in search
       - Compare node counts between old and new implementations
       - Measure correlation between move ordering quality and search efficiency
     - **9.4**: Test move ordering effectiveness:
       - Verify that higher-weighted moves are indeed better choices
       - Validate that move ordering reduces alpha-beta cutoffs
       - Check for any weight calculation bugs causing poor move ordering
     - **9.5**: Create diagnostic tools:
       - Weight comparison utility showing side-by-side weight calculations
       - Search tree analysis showing node expansion patterns
       - Move ordering quality metrics for performance correlation

10. **Requirements Compliance Verification** ⚠️ REQUIRED
    - **Validate against `heuristic_analysis.md` specification**
    - Verify all 13 WeightAlloc functions implemented correctly
    - Test function dispatch logic matches original WeightList array behavior
    - Validate HeuristicContext contains all required data from specification
    - Compare MergeSort behavior with original hardcoded sorting network
    - **Critical**: Ensure implementation errors aren't causing performance regression

11. **Comprehensive Performance Analysis** ⚠️ REQUIRED
   - Profile the new heuristic library to identify bottlenecks
   - Compare assembly output between old and new implementations  
   - Investigate potential causes:
     - Function call overhead from modular design
     - Context object creation/copying overhead
     - Memory access patterns
     - Compiler optimization differences
   - Optimize critical paths to match or exceed original performance

12. **Benchmark Validation** ⚠️ REQUIRED
    - Create comprehensive performance benchmarks comparing old vs new
    - Test with various hand configurations (different number of moves)
    - Validate performance across different build configurations
    - Ensure micro-benchmarks align with integration performance

13. **Prepare for Full Migration** ⏳ PENDING PERFORMANCE FIX
    - Once the new library passes all tests and performance requirements, plan to remove the compile-time flag and old code path.
    - Update documentation and changelogs.

## Performance Investigation Details

### Current Status
- ✅ Build system supports both old and new implementations via `--define=use_new_heuristic=true/false`
- ✅ Unit tests pass for both implementations  
- ❌ **Performance regression detected**: 31% slower with new implementation
- ❌ **Integration performance**: Both implementations slower than expected (4-6ms per hand vs sub-microsecond heuristic operations)

### Investigation Priorities
1. **CRITICAL: Verify calculated weights and move ordering** - Poor heuristics directly cause more AB search nodes
   - Compare weight outputs between old and new implementations
   - Verify move ordering produces optimal alpha-beta cutoffs
   - Measure correlation between heuristic quality and search performance
2. **Profile search tree expansion** to quantify the impact of heuristic quality
   - Instrument alpha-beta search to count nodes visited
   - Compare node expansion patterns between implementations
   - Identify if performance regression correlates with increased search nodes
3. **Profile heuristic computation performance** to identify specific bottlenecks
   - Measure time spent in weight calculation vs search tree expansion
   - Compare micro-benchmark performance with integration performance
4. **Compare generated assembly** between old and new code paths
5. **Analyze context creation overhead** in new modular design
6. **Investigate memory layout** and cache performance
7. **Review compiler optimization** effectiveness on new code structure

### Performance Requirements
- New implementation must match or exceed old implementation performance
- Target: <4.73ms per hand (match old performance)
- Stretch goal: Improve upon original performance through better optimization

## Requirements Validation (from `heuristic_analysis.md`)

### Function Coverage Analysis
✅ **All 13 Required Functions Implemented**:
- `WeightAllocTrump0`, `WeightAllocNT0` (leading player - position 0)
- `WeightAllocTrumpNotvoid1`, `WeightAllocNTNotvoid1`, `WeightAllocTrumpVoid1`, `WeightAllocNTVoid1` (follower position 1)
- `WeightAllocTrumpNotvoid2`, `WeightAllocNTNotvoid2`, `WeightAllocTrumpVoid2`, `WeightAllocNTVoid2` (follower position 2)  
- `WeightAllocCombinedNotvoid3`, `WeightAllocTrumpVoid3`, `WeightAllocNTVoid3` (follower position 3)

### Interface Compliance
✅ **Required Data Structures**: All interfaced correctly via `HeuristicContext`
- `pos` structure (card holdings, aggregates, winners, lengths)
- `trackType` (lead information, played cards, trick progress)
- `moveType` arrays for generated moves and transposition table hints
- `relRanksType` for relative rank calculations
- Trump suit and player position information

✅ **Core Function Logic**: 
- `MoveGen0` logic integrated into dispatcher for leading player
- `MoveGen123` logic integrated for following players (positions 1-3)
- Proper trump/no-trump and void/not-void condition handling

### Potential Implementation Concerns
⚠️ **Areas Requiring Investigation** (may explain performance regression):
1. **Function Dispatch Method**: Switch statement vs original function pointer array (`WeightList`)
2. **Context Assembly**: `HeuristicContext` struct creation vs direct parameter passing
3. **Data Access Patterns**: Reference-based access vs pointer-based in original
4. **MergeSort Implementation**: Verify hardcoded sorting network unchanged
5. **Memory Layout**: Large struct passing vs individual parameters
6. **Compiler Optimization**: Verify inlining and optimization effectiveness

### Required Validation Tests
Based on `heuristic_analysis.md`, ensure:
- Move generation produces identical results for same game states
- Weight allocation functions assign same weights for equivalent positions
- Sort order matches original implementation exactly
- All 13 function variants handle their specific game state conditions correctly

## Notes
- The compile-time flag must remain until the new library is proven reliable AND performant.
- Performance regression must be resolved before considering the migration complete.
- All changes should be tracked and reviewed for correctness and maintainability.
- Consider this a blocking issue for completion of the heuristic extraction project.
