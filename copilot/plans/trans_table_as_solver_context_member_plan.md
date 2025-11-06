# Plan: Refactor TransTable creation to be a member of SearchContext

## Objective

Make the transposition table (TransTable) an instance-owned member of `SolverContext::SearchContext`, removing the global registry keyed by `ThreadData*`. Provide explicit lifecycle and reset APIs on `SolverContext` so client code can reuse a `SolverContext` across multiple `SolveBoard` calls and reset when TT becomes invalid.

This aligns with the instruction in `copilot/instructions/trans_table_as_solver_context_member.md` and follows the C++ style and workflow guidance in `.github/instructions/cpp.instructions.md`.

## Current state (summary)

- `SolverContext::transTable()`/`maybeTransTable()` manage a global registry mapping `ThreadData*` to `std::shared_ptr<TransTable>` guarded by a mutex.
- TT creation logic chooses `TransTableS` vs `TransTableL`, computes default/maximum MB from `ThreadData` and/or env vars, logs optionally, and initializes memory.
- `ResetForSolve`, `ClearTT`, `ResizeTT`, and `ResetBestMovesLite` interact with the TT via the registry helper.
- A similar registry exists for `dds::Arena` and a TLS shim is wired in `MoveGenContext`. The arena may be removed later, but is out-of-scope for the first minimal change.

## Design overview

- Ownership: `SearchContext` gets a private member `std::unique_ptr<TransTable> tt_;` created lazily.
- Accessors: add `TransTable* trans_table()` and `TransTable* maybe_trans_table() const` on `SearchContext` (snake_case per style). `SolverContext` maintains convenience pass-throughs for backward compatibility in the short term.
- Configuration: continue to use `SolverConfig` to provide TT kind and memory sizing. Preserve existing env var overrides (`DDS_TT_DEFAULT_MB`, `DDS_TT_LIMIT_MB`) and debug logging semantics. Maintain parity with existing defaults derived from `ThreadData` for compatibility in the transition phase.
- Lifecycle: `SolverContext` exposes explicit methods that operate on the member TT via `search_`:
  - `ResetForSolve()` -> `tt_->reset_memory(ResetReason::FreeMemory)` and reset search state
  - `ClearTT()` -> `tt_->return_all_memory()`
  - `ResizeTT(defMB, maxMB)` -> updates `tt_` limits
  - `DisposeTransTable()` -> `tt_.reset()`
- Concurrency: TT is no longer global; each `SolverContext` owns its own TT. No shared state or global mutexes required for TT; remove the registry and locks.

## API changes

- Add to `SearchContext` (header):
  - `TransTable* trans_table()`; creates if null, applies config and env overrides, runs `make_tt()` once
  - `TransTable* maybe_trans_table() const` (no create)
  - Private: `std::unique_ptr<TransTable> tt_;`
  - Private helpers for creation: `create_tt_if_needed_(const SolverConfig&, const ::dds::Utilities&, const dds::Arena*)`
- Adjust `SolverContext` methods to call through `search_`:
  - `transTable()` -> `search_.trans_table()`
  - `maybeTransTable()` -> `search_.maybe_trans_table()`
  - `DisposeTransTable()` -> `search_.dispose_tt()` or `tt_.reset()`
  - `ResetForSolve()`, `ClearTT()`, `ResizeTT()` use the member
- Remove: global TT registry map, `registry_mutex`, and associated functions.
- Keep: Arena registry and TLS shim for now (separate follow-up to retire or adapt allocator use to instance-owned arena if desired).

## Creation logic parity (port from current code)

When creating TT:
- Select kind: `TTKind::Small` -> `TransTableS`; `TTKind::Large` -> `TransTableL`. Prefer `SolverConfig.ttKind` if set; otherwise fallback to `ThreadData.ttType` to retain old behavior during migration.
- Derive `defMB` and `maxMB` in this order:
  1. `SolverConfig.ttMemDefaultMB` / `ttMemMaximumMB` if >0
  2. `ThreadData.ttMemDefault_MB` / `ttMemMaximum_MB` if >0
  3. Fallback constants per kind (`THREADMEM_*`)
  4. Env overrides: `DDS_TT_DEFAULT_MB` (sets default), `DDS_TT_LIMIT_MB` (caps maximum)
  5. Ensure `maxMB >= defMB`
- Call:
  - `tt->set_memory_default(defMB)`
  - `tt->set_memory_maximum(maxMB)`
  - `tt->make_tt()` (once)
- Optional logging/metrics parity guarded by existing macros (reuse `Utilities` log buffer and stats increments).

## Migration steps

1. Introduce member in `SearchContext`
   - Add `tt_` and new accessors in `SolverContext.hpp`
   - Implement creation logic in `SolverContext.cpp` bound to `search_`
2. Redirect existing `SolverContext` TT API to the member
   - `transTable()/maybeTransTable()/ClearTT()/ResizeTT()/DisposeTransTable()/ResetForSolve()/ResetBestMovesLite()`
   - Keep signatures stable to minimize churn
3. Remove TT registry and locks
   - Delete the unordered_map and mutex for TT
   - Replace internal uses with `search_.maybe_trans_table()` / `search_.trans_table()`
4. Preserve arena behavior as-is (temporary)
   - Keep arena registry and TLS shim to avoid unrelated changes
   - Add follow-up work item to localize arena similarly or retire it
5. Audit all call sites
   - Grep for `maybeTransTable`, `transTable`, `tt:resize`, `tt:clear`, `tt:dispose`
   - Update any external code using the free/legacy functions if present
6. ThreadData coupling reduction (incremental)
   - Continue reading TT defaults from `ThreadData` for compatibility in step 1
   - Add TODOs to remove `ttType/ttMemDefault_MB/ttMemMaximum_MB` from `ThreadData` and push configuration into `SolverConfig` only

## Testing & validation

- Build gates
  - Run the VS Code task “Bazel build all (Debug) - update SolverIF” and ensure PASS
- Unit/behavior tests
  - Reuse existing unit tests for trans table and solver paths
  - Add focused tests (if practical):
    - TT lazily constructed on first access
    - Defaults vs. env overrides produce expected sizes
    - `ResizeTT` applies limits and preserves `maxMB >= defMB`
    - `ResetForSolve` resets best-move structures and calls `reset_memory`
    - `ClearTT` frees memory (`return_all_memory`)
    - `DisposeTransTable` deletes the instance; subsequent access recreates
- Diagnostics parity
  - Confirm logging keys used today (`tt:create`, `tt:resize`, `tt:clear`, `tt:dispose`, `ctx:reset_for_solve`) still appear with the same format

## Rollout

- Branch: continue work on `refactor/trans_table_in_solver_context`
- Stepwise commits to keep diffs reviewable:
  1. Add member + accessors; redirect internal calls
  2. Remove TT registry; keep arena registry
  3. Clean up ThreadData TT defaults usage (optional)
- Open PR with CI build and test runs; ensure clang-tidy/clangd diagnostics are clean per cpp instructions

## Risks and mitigations

- Risk: missing a call site that depended on the registry
  - Mitigation: code search for `maybeTransTable|transTable` and `registry()` symbols; build with `--verbose_failures`
- Risk: memory footprint changes due to different defaults
  - Mitigation: parity tests for default/max; preserve env overrides
- Risk: hidden cross-thread sharing assumptions
  - Mitigation: note in PR that TT is now per-context; document usage pattern in README and headers

## Follow-ups (separate tasks)

- Retire `Arena` and `ScratchAllocTLS` once movegen paths are adapted to instance-owned allocator, or after confirming they’re no longer needed
- Remove TT-related fields from `ThreadData`; keep only search-state fields
- Consider exposing an explicit `ConfigureTT(TTKind, defMB, maxMB)` API to simplify runtime tuning

## Definition of Done

- No global TT registry; `SearchContext` owns TT
- All `SolverContext` TT methods operate on the member TT
- Build passes with provided Bazel tasks
- Existing solver tests pass; no regression in logging/stats
- Clear, documented reset flow that enables client reuse of `SolverContext`
