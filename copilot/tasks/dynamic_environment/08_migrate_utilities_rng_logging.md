# 08 — Migrate utilities: RNG, logging buffers, stats

Goal

- Move stateful utilities into `SolverContext` and deprecate any global engines/buffers.

Actions

- Introduce per-instance RNG (if needed) and avoid `rand()`/global engines.
- Relocate logging buffers and statistics collectors into context-owned storage.
- Provide accessors and ensure thread-safe read-only access where appropriate.

Deliverables

- Utility code updated to be instance-scoped.
- Unit tests verifying deterministic RNG behavior (with seeded config) and logging isolation.

Acceptance criteria

- No stateful utility globals in the solver path.
- Predictable results under seeded runs.
