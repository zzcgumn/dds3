# Task 21: Create Direct Output Comparison Tests - 🚨 CRITICAL

## Objective
Create comprehensive tests that directly compare the weight outputs between the original Moves.cpp implementation and the new heuristic_sorting library to identify any discrepancies that could explain the 2.4x performance regression.

## Critical Issue
**Current Gap**: All existing tests only validate the new implementation in isolation. No tests directly compare old vs new weight outputs for identical game states.

## Implementation Strategy

### 21.1: Create Comparison Test Framework
**Goal**: Build infrastructure to run identical scenarios through both implementations

**Implementation Plan**:
1. **Dual-Path Test Setup**
   - Create test that can be compiled with both `--define=use_new_heuristic=true/false`
   - Use compile-time flags to switch between implementations
   - Capture weight outputs from both paths for identical inputs

2. **Test Data Generation**
   - Create representative bridge game states covering all scenarios
   - Include all player positions (0-3)
   - Cover both trump and no-trump contracts
   - Include void and non-void suit conditions
   - Test edge cases (single moves, maximum moves)

3. **Weight Capture Mechanism**
   - Instrument both old and new code paths to log weights
   - Create identical game state inputs for both implementations
   - Compare weight assignments move-by-move

### 21.2: Scenario Coverage Matrix
**Goal**: Ensure comprehensive comparison across all heuristic function paths

**Required Test Scenarios**:
- [ ] **MoveGen0 Scenarios** (Leading hand):
  - Trump game with trump winner available → ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)`
  - No-trump game or no trump winner → ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)`
  - Various suit distributions and card holdings
  - Different numbers of moves (1-13)

- [ ] **MoveGen123 Scenarios** (Following hands):
  - Position 1 (handRel=1): Trump/NT × Following/Void = 4 combinations
  - Position 2 (handRel=2): Trump/NT × Following/Void = 4 combinations  
  - Position 3 (handRel=3): Trump/NT × Following/Void = 4 combinations
  - All 12 function path combinations tested

### 21.3: Weight Difference Analysis
**Goal**: Identify specific discrepancies and patterns

**Analysis Framework**:
1. **Per-Move Weight Comparison**
   - Compare weight[i] for each move i in identical scenarios
   - Report any non-zero differences
   - Calculate statistical metrics (mean, max, distribution of differences)

2. **Move Ordering Comparison**
   - Compare final move order after sorting
   - Identify if different weights lead to different move ordering
   - Measure correlation between move order differences and performance

3. **Function-Specific Analysis**
   - Group differences by which `\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic) function was called
   - Identify if specific functions have systematic weight differences
   - Check if certain game states are more prone to discrepancies

### 21.4: Debugging Output Implementation
**Goal**: Provide detailed diagnostic information for discrepancy investigation

**Debug Features**:
- [ ] **Weight Difference Reports**
  - Side-by-side weight comparison tables
  - Highlighted discrepancies with color coding
  - Move ordering changes visualization

- [ ] **Game State Logging**
  - Complete position information for each test case
  - Track information and context data
  - Function dispatch path logging

- [ ] **Statistical Summary**
  - Total discrepancies found
  - Percentage of scenarios with differences
  - Distribution of weight difference magnitudes

## Expected Outcomes

### Success Criteria
1. **Zero Weight Differences**: Ideal outcome - new implementation produces identical weights
2. **Identified Discrepancies**: If differences exist, precise identification of:
   - Which functions produce different weights
   - What game states trigger discrepancies
   - Magnitude and pattern of differences

### Performance Correlation
- Link weight differences to alpha-beta search performance
- Measure how weight discrepancies affect move ordering quality
- Quantify impact on search tree expansion

## Implementation Files
1. **`library/tests/heuristic_sorting/weight_comparison_test.cpp`**
   - Main comparison test suite
   - Dual-path testing framework
   - Comprehensive scenario coverage

2. **`library/tests/heuristic_sorting/comparison_utilities.cpp/.h`**
   - Weight capture and comparison utilities
   - Game state generation helpers
   - Difference analysis tools

3. **Test Data Files**
   - Representative bridge positions
   - Edge case scenarios
   - Performance-critical game states

## Priority
**CRITICAL**: This task should be completed immediately as it's the foundation for understanding the performance regression. All other optimization efforts should wait until we know if the implementations produce identical outputs.

## Dependencies
- Access to both old and new implementations via compile flags
- Understanding of Moves class structure for old implementation testing
- Bridge game state generation utilities

## Success Metrics
- [ ] 100+ scenarios tested across all function paths
- [ ] Complete weight difference report generated
- [ ] Root cause of performance regression identified or ruled out
- [ ] Clear action plan for fixing any discovered discrepancies
