# 04 — Migrate Transposition Table (TT) into SolverContext

Goal

- Move TT data structures and configuration into `SolverContext` and remove global pointers/statics.

Actions

- Define `TransTable` as a context-owned component with configurable capacity and replacement policy.
- Add `Clear()`, `Resize()` and per-solve reset logic, invoked by `SolverContext::ResetForSolve()`.
- Replace all TT global accesses with `ctx.trans_table` references.
- Add focused unit tests for TT operations through the context.

Deliverables

- Refactored TT code under `library/src/...` owned by `SolverContext`.
- Unit tests validating inserts/lookups, resize, and clear in isolation.

Acceptance criteria

- No TT-related mutable globals remain.
- All tests pass; performance impact negligible.
