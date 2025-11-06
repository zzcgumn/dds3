# 11 – Follow-up: Explicit ConfigureTT API

Goal
- Provide a simple API for runtime TT configuration without touching internals.

Proposal
- Add `SolverContext::ConfigureTT(TTKind kind, int defMB, int maxMB)` which updates internal config and applies to an existing TT (resizing if present) or to future creation.

Steps
1) Add method to `SolverContext` header; implement in `.cpp`.
2) Ensure `maxMB >= defMB`; respect env limit if still desired.
3) Update docs and tests.

Acceptance criteria
- API available and covered by minimal tests.
- No behavior change unless invoked by clients.
