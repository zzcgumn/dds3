# Plan: Dynamic, Instance-Scoped Solver Environment (remove static mutable state)

## Objective
Enable safe parallel solving by eliminating mutable static/global state across the solver and encapsulating all runtime memory within an explicit solver instance (context). Preserve correctness and performance, maintain a stable public API, and provide a migration path for existing users.

## Problem summary
- Current code uses static storage in multiple modules (global variables, function-level `static`, singletons, and shared scratch buffers).
- This prevents running multiple solves concurrently and makes behavior dependent on implicit global state.
- We want a design where each "solver instance" holds all mutable state, enabling reentrancy and multi-threading.

## Scope and definitions
- In-scope: All mutable runtime state used by solving (search, move gen, heuristic sorting, transposition table, scratch buffers, RNG/stateful utilities, logging buffers, statistics, and caches).
- Out-of-scope: Immutable compile-time constants and read-only lookup tables (these may remain static/constexpr if strictly immutable and thread-safe).
- Solver instance: A user-visible or internal object/handle that owns all per-solver mutable state and is passed to all operations that read/write state.

## Non-goals (for this phase)
- Implementing an internal thread pool or parallel algorithm changes. The goal is enabling concurrency, not adding it.
- Public API redesign for end users beyond providing an additive instance-based entry point and maintaining legacy APIs via adapters.

## Design principles
- Reentrancy: No reliance on mutable global/static state during solving.
- Ownership: Every mutable allocation has a clear owner (the instance), managed via RAII.
- Performance: Prefer preallocation and arenas to avoid repeated allocations; keep hot-path data contiguous and cache-friendly.
- Backwards compatibility: Keep legacy entry points functional via on-the-fly instance adapters.
- Testability: Make state explicit to simplify deterministic tests and tooling (TSAN, fuzzing).

## Target architecture
- Introduce `SolverContext` (or `DdsSolver`) that aggregates all per-instance data:
  - Configuration: limits, memory sizes, feature toggles (e.g., TT capacity, heuristics).
  - Transposition table (TT): instance-owned, configurable capacity, clear/reset per solve or per batch.
  - Search state: stacks, node buffers, PV storage, killer/history tables, pruning state.
  - Move generation: scratch buffers for moves, per-ply workspaces.
  - Heuristic sorting: any weight caches, temporary arrays.
  - Utility state: RNG, statistics, logging buffers.
  - Allocators: bump/arena or pools for short-lived allocations.

All subsystems consume a reference to `SolverContext` (or a sub-view like `SearchContext&`). No function writes to file-static or global mutable state.

## Phased plan

### Phase 0 — Inventory and guardrails
1. Inventory mutable static/global state
   - Grep and static analysis: identify variables declared at namespace/global scope or with function-level `static` that are written to.
   - Classify by lifetime: per-call, per-search, per-instance, global-immutable.
   - Output a living document: `copilot/reports/dynamic_environment_inventory.md` with owners and planned homes in `SolverContext`.
2. CI guardrails
   - Add clang-tidy checks and/or a pre-commit/CI lint to forbid new mutable globals (exceptions list for legacy until migrated).
   - Allow `static constexpr` and immutable tables.

### Phase 1 — Context scaffolding and adapters
1. Define core types
   - `struct SolverConfig { ... }`
   - `class SolverContext { public: explicit SolverContext(const SolverConfig&); ~SolverContext(); void ResetForSolve(); /* accessors */ }`
   - Sub-contexts (if useful): `SearchContext`, `MoveGenContext`, `HeuristicContext`, `TransTable`.
2. Public API (additive)
   - New entry points: `Result SolveBoard(SolverContext&, const Board& input, ...);`
   - Batch helpers using a single `SolverContext&` across multiple boards.
3. Legacy API shims
   - Keep existing `SolveBoard(...)` creating a transient `SolverContext` internally; identical results, slightly higher overhead.
   - Mark legacy entry points as deprecated in docs once stable.

### Phase 2 — Migrate major subsystems (small PRs)
Each bullet should be a focused PR with unit tests and no cross-module rewrites. Keep changes mechanical where possible.

1. Transposition table
   - Move TT storage (buckets, locks, stats) into `SolverContext`.
   - Add config: size (MB/entries), replacement policy, clear policy (per-call vs per-batch).
   - Provide `TT::Clear()`, `TT::Resize()`; remove global pointers.
2. Search state (alpha-beta)
   - Migrate node stacks, PV arrays, killer/history tables, pruning thresholds, and counters.
   - Replace `static` locals in search with fields in `SearchContext` accessed via `SolverContext`.
3. Move generation
   - Relocate scratch arrays for generated moves and helper workspaces.
   - Ensure no shared mutable buffers across instances.
4. Heuristic sorting
   - Relocate weight buffers, side arrays, and any caches to `HeuristicContext`.
   - Immutable tables remain `constexpr`/`static const`.
5. Utility and I/O state
   - Logging buffers, temporary strings, and formatted output scratch moved into context.
   - RNG/stateful helpers stored per instance; avoid `rand()`/global engines.
6. Global options / flags
   - Replace global flags with `SolverConfig` fields; thread-safe reads; remove mutable globals.

### Phase 3 — Performance alignment
1. Allocation strategy
   - Replace ad-hoc new/delete with preallocated arenas/pools sized from `SolverConfig`.
   - Reuse buffers across solves via `ResetForSolve()`.
2. Hot path checks
   - Ensure passing context by reference doesn’t block inlining; avoid virtual indirection in hot loops.
   - Keep tight structs POD-like; prefer fixed-size arrays when sizes are bounded.
3. Benchmarks and profiles
   - Compare before/after on representative inputs (hands/list*.txt). Record CPU, allocations, and peak memory.

### Phase 4 — Hardening and enablement
1. Concurrency validation
   - Add multi-threaded tests that run N solver instances concurrently on distinct boards; assert identical results to single-thread runs.
   - Run under TSAN in CI.
2. Correctness invariants
   - Unit tests to ensure legacy entry points and instance API produce identical outputs and node counts (if available).
   - Fuzz small boards comparing legacy vs instance API.
3. Documentation & examples
   - Add `docs/dynamic-environment.md` with guidance and migration notes.
   - Provide example usage of creating one `SolverContext` per thread.

## Work breakdown (suggested PR sequence)
1. Add `SolverConfig` and `SolverContext` scaffolding + new instance-based API, no behavior change. Add unit tests for basic lifecycle.
2. TT extraction into context + tests. Keep legacy shims calling into context path.
3. Search state migration (stacks, PV, killer/history) + tests.
4. Move generation buffers migration + tests.
5. Heuristic sorting buffers migration + tests.
6. Utilities (RNG/log/stats) migration + tests.
7. Performance pass (arenas, ResetForSolve) + benchmarks.
8. Concurrency tests + TSAN CI job + docs.

## Acceptance criteria
- No mutable global/static writes remain in solving code paths. Exceptions list is empty or limited to immutable `constexpr`/`static const` tables.
- New instance-based API can run multiple solves in parallel threads with bitwise-identical results to single-thread.
- Legacy API remains functional via adapter and produces identical results.
- Performance delta within ±5% of baseline (or improved). Peak memory usage predictable and bounded by `SolverConfig`.
- CI: unit tests, TSAN job green; lint rules prevent reintroduction of mutable globals.

## Testing strategy
- Unit tests per subsystem verifying state isolation and determinism.
- Equivalence tests: legacy vs instance API on curated board sets.
- Concurrency tests: run M instances across K boards; validate outputs.
- TSAN builds: ensure no data races.
- Optional fuzzing on small depths/boards.

## Tooling & CI
- Add clang-tidy rules to flag mutable globals (`cppcoreguidelines-avoid-non-const-global-variables`, `cert-err58-cpp`).
- Optional script to grep for suspicious patterns (e.g., `\bstatic\b` outside headers and not `constexpr`).
- Bazel configs for TSAN builds (`--config=tsan`) and perf builds (`-c opt -g -fno-omit-frame-pointer`).

## Risks and mitigations
- Hidden implicit globals (through third-party code): Mitigate by wrapping through context-owned adapters; document exceptions.
- Performance regressions due to indirection: Keep context access flat and inline-friendly; avoid virtuals; pre-size arenas.
- Large PRs hard to review: Ship small, mechanical PRs per subsystem with strong tests.

## Timeline estimate (rough)
- Phase 0–1: 1–2 weeks (inventory, scaffolding, adapters, lint/CI).
- Phase 2: 2–4 weeks (subsystems, incremental PRs).
- Phase 3: 1 week (performance alignment, benches).
- Phase 4: 1 week (concurrency tests, docs, TSAN CI).

## Notes on what may remain static
- Purely immutable tables (rank masks, suit maps, precomputed constants) can remain `constexpr`/`static const` as shared read-only data.
- Any mutable caching or memoization must be owned by `SolverContext`.

## Next steps (actionable)
- Land `SolverConfig`/`SolverContext` skeleton with no behavior changes and add a trivial instance-based API entry point.
- Produce the static/global inventory document and map each item to its new home in the context.
- Start with TT migration (lowest coupling) and wire tests.
