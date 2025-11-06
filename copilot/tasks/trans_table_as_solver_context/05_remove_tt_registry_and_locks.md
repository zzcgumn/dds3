# 05 – Remove global TT registry and registry mutex

Goal
- Eliminate the per-thread global TT registry and its mutexes in `SolverContext.cpp`.

Files to edit
- `library/src/solver_context/SolverContext.cpp`

Steps
1) Delete:
   - `registry()` map (ThreadData* → shared_ptr<TransTable>)
   - `registry_mutex()`
2) Remove dependent code paths that consult/insert into the registry.
3) Ensure all internal TT access now uses the member via `search_`.
4) Keep arena registry code unchanged for now.

Acceptance criteria
- No remaining references to the TT registry symbol names or mutex.
- Build still succeeds after refactor is complete.

Notes
- If helper functions were made `static` in anonymous namespace, remove them entirely.
