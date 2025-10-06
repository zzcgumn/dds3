# 03 — Scaffold SolverContext and instance API (no behavior change)

Goal

- Introduce `SolverConfig` and `SolverContext` types and an additive instance-based API entry point without changing behavior.

Actions

- Define `struct SolverConfig` with tunables (TT size, buffer sizes, flags) and defaults.
- Define `class SolverContext` with ownership of placeholders for subsystems and `ResetForSolve()`.
- Add new API: `Result SolveBoard(SolverContext&, const Board& input, ...)` that internally calls existing implementation paths.
- Provide legacy API shim that constructs a temporary `SolverContext` and forwards to the new entry point.
- Add unit test that calls both paths and asserts identical results.

Deliverables

- Header(s) and source(s) for `SolverConfig`/`SolverContext` and the new API.
- Basic unit test validating equivalence with legacy API on a tiny fixture.

Acceptance criteria

- Builds pass with no behavior changes.
- New API available and exercised by tests.
