# 07 — Migrate heuristic sorting buffers and caches

Goal

- Ensure all heuristic sorting mutable state (weights, side arrays, caches) lives in `HeuristicContext` within `SolverContext`.

Actions

- Audit heuristic sorting code for any remaining shared state.
- Move weight arrays, temporary buffers into the context.
- Keep immutable tables `constexpr`/`static const`.
- Add unit tests that compare outputs to pre-migration golden cases.

Deliverables

- Heuristic sorting code updated to accept and use `HeuristicContext`.
- Unit tests validating identical weight outputs and ordering.

Acceptance criteria

- No mutable heuristic state outside the context.
- Identical sorting results across runs and instances.
