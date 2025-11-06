# 12 – Documentation and README updates

Goal
- Document the new ownership model and reset semantics for the transposition table.

Steps
1) Update `docs/BUILD_SYSTEM.md` and/or `README.md` sections mentioning TT behavior.
2) Add short developer notes in `SolverContext.hpp` near the `SearchContext` definition about TT ownership and lifecycle.
3) If public API examples exist (examples/*.cpp), ensure they continue to work and optionally add a brief comment about reusing `SolverContext` and `ResetForSolve()`.

Acceptance criteria
- Clear guidance for users on reusing a `SolverContext` across solves.
- CI/docs build (if any) PASS.
