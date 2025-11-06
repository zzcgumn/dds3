# 02 – Add TT member and accessors to SearchContext

Goal
- Add `std::unique_ptr<TransTable> tt_;` to `SolverContext::SearchContext`.
- Add methods:
  - `TransTable* trans_table();` (creates lazily)
  - `TransTable* maybe_trans_table() const;` (no creation)

Files to edit
- `library/src/solver_context/SolverContext.hpp`

Steps
1) In `SearchContext` private section, add `std::unique_ptr<TransTable> tt_;`.
2) Declare the two methods above (public). Keep names snake_case for internal methods but match project conventions. If current header uses camelCase, prefer consistency; document any deviation.
3) Add a private helper declaration for creation (to be implemented in .cpp):
   - `TransTable* ensure_tt_created_(const SolverConfig&, ::dds::Utilities&, const dds::Arena*);`
4) Ensure `SearchContext` can access `thr_` and that the enclosing `SolverContext` can provide `cfg_`, `utilities()`, and `arena()`.

Acceptance criteria
- Header compiles in isolation (types resolve, no circular deps added).
- No change to external public API of `SolverContext` yet (only new internal members and declarations).

Notes
- Keep member default-initialized. Do not perform allocation in the constructor; rely on lazy creation.
- Align with `.github/instructions/cpp.instructions.md` (includes, forward decls if needed, minimal include churn).
