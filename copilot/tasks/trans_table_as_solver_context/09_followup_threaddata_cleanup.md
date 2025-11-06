# 09 – Follow-up: ThreadData TT fields cleanup

Goal
- Reduce coupling by removing TT-related config/state from `ThreadData` once `SolverConfig` fully drives TT.

Scope
- Fields: `ttType`, `ttMemDefault_MB`, `ttMemMaximum_MB`.

Steps
1) Identify all remaining references to the fields above.
2) Replace with `SolverConfig` consumption or `SolverContext` method calls.
3) Remove fields from `ThreadData` and update serialization/initialization paths if any.

Acceptance criteria
- No TT-config fields remain in `ThreadData`.
- Build and tests still PASS.

Notes
- Perform after main refactor lands to minimize risk.
