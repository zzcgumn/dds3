# 03 – Implement TransTable creation logic in SolverContext.cpp

Goal
- Implement `SearchContext::trans_table()` and `maybe_trans_table()` in `SolverContext.cpp` with behavior parity.

Files to edit
- `library/src/solver_context/SolverContext.cpp`

Creation rules (parity)
- Choose kind from `SolverConfig.ttKind` else `thr_->ttType`.
- Derive `defMB`/`maxMB` from:
  1) `SolverConfig.ttMemDefaultMB` / `ttMemMaximumMB` if > 0
  2) `thr_->ttMemDefault_MB` / `thr_->ttMemMaximum_MB` if > 0
  3) Fallback constants (THREADMEM_* per kind)
  4) Env overrides: `DDS_TT_DEFAULT_MB` (sets default), `DDS_TT_LIMIT_MB` (caps max)
  5) Ensure `maxMB >= defMB`
- Configure and initialize:
  - `set_memory_default(defMB)`
  - `set_memory_maximum(maxMB)`
  - `make_tt()`
- Logging/stats:
  - `tt:create|S|def|max` (reuse existing pattern) when creating
  - Increment `tt_creates` when DDS_UTILITIES_STATS

Steps
1) Define `SearchContext::maybe_trans_table() const` returning `tt_.get()`.
2) Define `SearchContext::trans_table()`; if `tt_` is null, create small/large concrete TT.
3) Use `utilities()` and `arena()` from the owning `SolverContext` for logging buffer and optional small-buffer formatting (mirror current code paths).
4) Place code near other SearchContext methods for coherence.

Acceptance criteria
- No global registry usage remains in these new methods.
- Code compiles and adheres to existing logging macros.

Notes
- Keep creation on first call to `trans_table()`; avoid work in `maybe_trans_table()`.
