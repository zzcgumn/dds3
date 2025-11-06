# 04 – Redirect SolverContext TT APIs to SearchContext member

Goal
- Make `SolverContext` methods delegate to `search_`'s TT member:
  - `transTable()` -> `search_.trans_table()`
  - `maybeTransTable()` -> `search_.maybe_trans_table()`
  - `DisposeTransTable()` -> reset member
  - `ClearTT()` -> `return_all_memory()`
  - `ResizeTT()` -> `set_memory_default/max`, normalize `max>=def`
  - `ResetForSolve()` -> `reset_memory(FreeMemory)` plus search-state reset

Files to edit
- `library/src/solver_context/SolverContext.cpp`

Steps
1) Update each method body to use `search_.maybe_trans_table()` / `search_.trans_table()`.
2) Ensure log entries stay identical (`tt:clear`, `tt:resize`, `tt:dispose`, `ctx:reset_for_solve`).
3) Preserve `memUsed` update in `ResetBestMovesLite()` (query `tt->memory_in_use()` if TT exists).

Acceptance criteria
- No references to TT registry helpers in these methods.
- Functionality parity verified by build/tests.

Notes
- Keep function signatures unchanged to reduce external churn.
