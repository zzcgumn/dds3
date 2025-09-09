```markdown
# Compare Heuristic Sorting Tasks

This directory contains actionable tasks for implementing the comparison between the legacy heuristic sorting (in `moves.cpp`) and the new implementation in `library/src/heuristic_sorting`.

## Task Overview

Tasks are organized in a sequence to implement a repeatable harness, tests, reporting, and CI integration.

### Phase 1: Foundation (Tasks 01-03)
- **Task 01**: Create test directory and scaffolding
- **Task 02**: Create test build targets and Bazel rules
- **Task 03**: Add test utilities and normalization helpers

### Phase 2: Deterministic unit tests (Tasks 04-06)
- **Task 04**: Add a small set of canonical positions and expected outputs
- **Task 05**: Implement `compare_harness.cpp` to run both heuristics and compare outputs
- **Task 06**: Wire the unit tests into Bazel and run locally

### Phase 3: Randomized and stability testing (Tasks 07-09)
- **Task 07**: Implement randomized fuzz batch with fixed seed
- **Task 08**: Implement stability/tie-breaking experiments
- **Task 09**: Collect performance metrics

### Phase 4: Reporting and CI (Tasks 10-12)
- **Task 10**: Add differential reporting and JSON logs
- **Task 11**: Author equivalence report template
- **Task 12**: Add CI smoke job configuration

### Phase 5: Triage and follow-up (Tasks 13-14)
- **Task 13**: Triage mismatches and add focused tests
- **Task 14**: Finalize documentation and close the effort

## Execution Guidelines

Complete tasks sequentially. Each task file contains concrete steps, verification criteria, and expected outputs.

``` 
