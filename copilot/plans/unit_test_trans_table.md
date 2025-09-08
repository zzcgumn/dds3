# Unit Test Plan for Trans Table Classes

## Overview

This plan covers comprehensive unit testing for the transposition table classes in DDS: `TransTable` (base), `TransTableS` (small memory), and `TransTableL` (large memory). The transposition table is a critical optimization component that stores intermediate search results to avoid redundant calculations.

## Understanding Trans Table Functionality

Based on the design document and source code analysis, the trans table system:

1. **Stores position state data** for completed tricks at specific depths (4, 8, 12, etc.)
2. **Uses relative ranks** instead of absolute ranks to increase position matches
3. **Tracks winning card ranks** to determine if positions are equivalent 
4. **Provides upper/lower bounds** for search pruning
5. **Implements two strategies**: small memory (TransTableS) and large memory (TransTableL)

## Test Structure

Following the existing test pattern from `heuristic_sorting`, we'll create:

- `library/tests/trans_table/` directory
- Individual test files for each class
- Mock and helper utilities for test data setup
- BUILD.bazel file for test compilation

## Core Test Categories

### 1. Base Class Tests (`TransTable`)

**Test File**: `trans_table_base_test.cpp`

- **Construction/Destruction**
  - Default constructor creates valid object
  - Virtual destructor works properly
  - Interface contracts are properly defined

- **Virtual Interface Verification**
  - All virtual methods have expected signatures
  - Default implementations return expected values
  - Interface is properly inherited by concrete classes

### 2. TransTableS Tests (`TransTableS`)

**Test File**: `trans_table_s_test.cpp`

#### Memory Management
- `SetMemoryDefault()` - Sets reasonable memory limits
- `SetMemoryMaximum()` - Handles maximum memory constraints
- `MemoryInUse()` - Reports accurate memory usage
- `ResetMemory()` - Properly clears table for different reset reasons
- `ReturnAllMemory()` - Cleans up all allocated memory

#### Initialization and Setup
- `Init()` - Properly initializes with hand lookup tables
- `MakeTT()` - Creates initial table structure
- Proper initialization of internal data structures
- Handling of invalid initialization parameters

#### Core Operations
- `Add()` - Stores position data correctly
  - Test with various trick numbers and hands
  - Test with different winning rank patterns
  - Test overwrite behavior when table is full
  - Test flag parameter effects

- `Lookup()` - Retrieves stored positions
  - Test exact matches return correct data
  - Test near-matches with relative ranks
  - Test non-matches return null
  - Test bounds checking logic
  - Test `lowerFlag` parameter behavior

#### Data Consistency
- Relative rank conversion works correctly
- Winning rank tracking preserves game logic
- Position equivalence detection
- Suit length distribution handling

#### Edge Cases
- Empty table lookups
- Table overflow behavior
- Memory exhaustion scenarios
- Invalid input parameters

### 3. TransTableL Tests (`TransTableL`)

**Test File**: `trans_table_l_test.cpp`

Similar test structure to TransTableS but with additional focus on:

#### Large Memory Specific Features
- Page-based memory management
- Hash table distribution handling
- Block allocation and recycling
- Timestamp-based aging
- Harvest mechanism for memory reclamation

#### Performance Characteristics
- Large table lookup efficiency
- Memory utilization patterns
- Hash collision handling
- Block search optimization

#### Advanced Data Structures
- `winMatchType` storage and retrieval
- `winBlockType` management
- Distribution hash handling
- Multi-level lookup verification

### 4. Integration Tests

**Test File**: `trans_table_integration_test.cpp`

#### Cross-Implementation Consistency
- TransTableS and TransTableL return equivalent results for same positions
- Memory usage differences within expected ranges
- Performance characteristics verification

#### Real Game Scenarios
- Test with actual bridge hand data
- Multi-trick sequences
- Different trump suits
- Complex winning rank patterns

#### Interface Compliance
- Both implementations properly inherit from TransTable
- Virtual method dispatch works correctly
- Polymorphic usage scenarios

### 5. Performance and Stress Tests

**Test File**: `trans_table_performance_test.cpp`

#### Memory Stress Tests
- Large number of position additions
- Memory limit boundary testing
- Rapid allocation/deallocation patterns

#### Lookup Performance
- High-frequency lookup patterns
- Cache hit/miss ratios
- Search time complexity verification

#### Concurrent Access (if applicable)
- Thread safety verification
- Shared table access patterns

## Test Utilities and Helpers

### Mock Data Generators
- `MockHandGenerator` - Creates realistic hand distributions
- `MockPositionGenerator` - Generates various position states
- `MockWinRankGenerator` - Creates winning rank patterns

### Verification Utilities
- `PositionComparator` - Verifies position equivalence
- `MemoryTracker` - Monitors memory usage patterns
- `PerformanceTimer` - Measures operation timing

### Test Fixtures
- `TransTableTestBase` - Common setup/teardown
- `TransTableSTest` - TransTableS specific fixture
- `TransTableLTest` - TransTableL specific fixture

## Test Data Requirements

### Hand Lookup Tables
- Standard 52-card deck configurations
- Various suit distributions
- Edge cases (void suits, long suits)

### Position Data
- Different trick numbers (4, 8, 12, etc.)
- All four hands as leader
- Various target values
- Different suit combinations

### Winning Rank Scenarios
- Single suit wins
- Multi-suit winning patterns
- Equivalent relative rank situations
- Complex rank sequences

## Expected Outcomes

### Coverage Metrics
- **Line Coverage**: >90% for all trans table source files
- **Branch Coverage**: >85% for critical decision points
- **Function Coverage**: 100% for public interface methods

### Quality Assurance
- No memory leaks detected
- All edge cases handled gracefully
- Performance within acceptable bounds
- Cross-implementation consistency verified

### Integration Verification
- Works correctly with existing DDS components
- Proper interaction with search algorithms
- Memory management integrates with overall system

## Implementation Priority

1. **Phase 1**: Basic functionality tests (Add, Lookup, Init)
2. **Phase 2**: Memory management and edge cases
3. **Phase 3**: Performance and stress testing
4. **Phase 4**: Integration and cross-implementation tests

## Dependencies

- GoogleTest framework (already available)
- Access to `testable_trans_table` library target (to be created)
- Constants and lookup tables for test data generation
- Data types from `dds_types` library

## Files to Create

```
library/tests/trans_table/
├── BUILD.bazel
├── trans_table_base_test.cpp
├── trans_table_s_test.cpp
├── trans_table_l_test.cpp
├── trans_table_integration_test.cpp
├── trans_table_performance_test.cpp
├── test_utilities.h
├── test_utilities.cpp
├── mock_data_generators.h
└── mock_data_generators.cpp
```

## Additional Considerations

### Memory Testing
- Use tools like Valgrind or AddressSanitizer for memory leak detection
- Monitor peak memory usage during tests
- Verify proper cleanup in destructors

### Platform Compatibility
- Test on different architectures if applicable
- Verify bit manipulation operations work consistently
- Ensure endianness doesn't affect results

### Future Extensibility
- Design tests to accommodate new trans table implementations
- Create framework for testing different memory strategies
- Plan for potential algorithm improvements

This comprehensive testing plan ensures the trans table implementations are robust, efficient, and maintain the critical performance characteristics required by the DDS solver.
