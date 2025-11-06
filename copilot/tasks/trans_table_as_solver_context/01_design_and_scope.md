# 01 – Design and scope for TransTable in SearchContext

Goal
- Replace the global ThreadData*→TransTable registry with an instance-owned TransTable inside `SolverContext::SearchContext`.
- Preserve behavior and defaults (kind, memory sizes, env overrides, logging/stats) while eliminating global state.

Context
- Source: `library/src/solver_context/SolverContext.hpp` and `SolverContext.cpp`.
- Instruction: `copilot/instructions/trans_table_as_solver_context_member.md`.
- Style: follow `.github/instructions/cpp.instructions.md` and `.github/instructions/bazel.instructions.md`.

Deliverables
- Clear API shape on `SearchContext`: `TransTable* trans_table()` and `TransTable* maybe_trans_table() const`.
- Explicit ownership: `std::unique_ptr<TransTable> tt_;` in `SearchContext`.
- No global TT registry or registry mutex remains.

Acceptance criteria
- Code compiles and links (Debug) via Bazel tasks; unit tests continue to pass.
- Logging/stats events unchanged in content and order: `tt:create`, `tt:resize`, `tt:clear`, `tt:dispose`, `ctx:reset_for_solve`.
- Reusing a single `SolverContext` across multiple `SolveBoard` calls works, with `ResetForSolve()` and `DisposeTransTable()` behaving as expected.

Notes
- Arena/TLS allocator stays unchanged in this refactor. Plan follow-up tasks to retire or adapt.
- Keep interface compatibility for `SolverContext` methods to reduce churn.
