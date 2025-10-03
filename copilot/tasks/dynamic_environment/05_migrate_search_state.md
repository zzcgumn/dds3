# 05 — Migrate search state into SolverContext

Goal

- Move alpha-beta search mutable state to `SearchContext` within `SolverContext`.

Actions

- Identify node stacks, PV arrays, killer/history tables, pruning thresholds, and counters.
- Replace function-local `static` usage with context fields.
- Ensure per-solve reset via `ResetForSolve()` and zero-cost access in hot paths.
- Add targeted unit tests that validate deterministic behavior and invariants.

Deliverables

- `SearchContext` struct/class and refactored search code paths.
- Unit tests for basic search scenarios verifying state isolation.

Acceptance criteria

- No mutable statics/globals in search code paths.
- Equivalent results with legacy API and context-based API.
