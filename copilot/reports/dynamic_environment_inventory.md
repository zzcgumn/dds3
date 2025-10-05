# Dynamic Environment Inventory — Mutable State Audit

This living document inventories all mutable globals, function-local statics, and shared scratch buffers in the solver path and maps them to their new homes under a `SolverContext` design.

Status

- Version: initial seed
- Owners: dynamic environment effort
- Last updated: 2025-10-02

How to read/update

- For each subsystem, list symbols with: name, file, kind (global, static local, singleton, shared buffer), write sites, lifetime classification, and proposed `SolverContext` destination.
- Add links to PRs as items are migrated. Keep this document up to date.

Legend

- Lifetime: per-call | per-search | per-instance | global-immutable
- Destination: `SolverContext` sub-context (e.g., `SearchContext`, `MoveGenContext`, `HeuristicContext`, `TransTable`, `Utilities`)

## Summary table (to be maintained)

- Transposition table: mutable — to `TransTable` in `SolverContext`
- Search state: mutable — to `SearchContext`
- Move generation buffers: mutable — to `MoveGenContext`
- Heuristic sorting scratch: mutable — to `HeuristicContext`
- Utilities (RNG/log/stats): mutable — to `Utilities` in `SolverContext`
- Immutable tables: keep as `constexpr`/`static const`

---

## 1. Transposition Table (TT)

### Initial findings

- Symbol: TTlowestRank[8192]
  - File: library/src/trans_table/TransTableS.cpp:21; library/src/trans_table/TransTableL.cpp:89
  - Kind: file-scope static array
  - Writes: initialized during constants setup; read in TT operations
  - Lifetime: per-instance (functionally constant after init)
  - Destination: `SolverContext::trans_table` constants (or convert to `constexpr` if derivable)
  - Notes: avoid global state; compute once per instance or make compile-time

- Symbol: maskBytes[8192][DDS_SUITS][TT_BYTES]
  - File: library/src/trans_table/TransTableL.cpp:90
  - Kind: file-scope static multi-dimensional array
  - Writes: initialized during constants setup
  - Lifetime: per-instance (functionally constant after init)
  - Destination: `SolverContext::trans_table` constants (or `constexpr`)
  - Notes: very large; consider shared immutable `constexpr` if safe

- Symbol: _constantsSet
  - File: library/src/trans_table/TransTableS.cpp:22; library/src/trans_table/TransTableL.cpp:91
  - Kind: file-scope static bool (one-time init guard)
  - Writes: set during init
  - Lifetime: per-process
  - Destination: remove; use thread-safe static init or move guard to `TransTable` instance
  - Notes: eliminate global init flags

- Symbol: players (vector<string>)
  - File: library/src/trans_table/TransTableL.cpp:93
  - Kind: file-scope static container
  - Writes: constructed at startup; possibly read-only thereafter
  - Lifetime: per-process
  - Destination: make `constexpr` array of string_views or move to `TransTable` as immutable data
  - Notes: avoid dynamic allocation at global scope

- Symbols: [TBD discovery]
  - Kind: typically global pointer/array and stats counters
  - Write sites: TT insert/replace, clear/reset, resize
  - Lifetime: per-instance (clear per-solve)
  - Proposed destination: `SolverContext::trans_table`
  - Notes: add `Clear()`, `Resize()`, configurable capacity in `SolverConfig`

### Routing status (Task 04)

- Routed via `SolverContext` accessor in the following modules:
  - `Init.cpp`: TT `Init(...)` and memory accounting now use `ctx.transTable()`.
  - `ABsearch.cpp`: TT `Lookup(...)` (two sites) and `Add(...)` routed through `ctx.transTable()`.
  - `SolverIF.cpp`: TT `MemoryInUse()` and `Print*Stats` calls routed through `ctx.transTable()`.
  - `system/Memory.cpp`: TT `ReturnAllMemory()`, `MemoryInUse()`, and setup (`SetMemoryDefault/Maximum`, `MakeTT`) routed via `ctx.transTable()`.
- Unit tests under `library/tests/trans_table` continue to construct/use `TransTable*` directly by design (no change required).

### Ownership scaffolding

- `SolverContext` now supports optional ownership of the `TransTable` via
  `adoptTransTableOwnership()`/`releaseTransTableOwnership()`. By default,
  ownership remains with `ThreadData` to preserve behavior. This enables a
  controlled handoff in a future step where `ThreadData::transTable` can be
  retired and `SolverContext` becomes the sole owner.

## 2. Search State (alpha-beta)

### Initial findings

- Symbols: [to confirm via code scan]
  - Node stacks, PV arrays, killer/history tables, pruning thresholds, node counters likely in `ABsearch.*`
  - Kind: potentially function-local statics or file-scope globals
  - Writes: during search recursion
  - Destination: `SolverContext::search`
  - Notes: replace statics with per-instance arrays; ensure reset per solve

- Symbols: stacks (ply/node), PV arrays, killer/history tables, pruning thresholds, node counters
  - Kind: function-local `static` or file-scope globals in search module(s)
  - Write sites: search entry, per-ply updates, pruning decisions
  - Lifetime: per-search
  - Proposed destination: `SolverContext::search`
  - Notes: reset via `ResetForSolve()`, ensure cache-friendly layout

## 3. Move Generation

### Initial findings

- Symbols: [to confirm]
  - Generated move arrays and helper workspaces under `library/src/moves`
  - Kind: shared scratch buffers
  - Destination: `SolverContext::move_gen`
  - Notes: evaluate sizes and lifetime to preallocate

- Symbols: generated move arrays, helper workspaces, per-ply temporary buffers
  - Kind: shared scratch buffers
  - Write sites: move generation functions
  - Lifetime: per-search (reused across plies)
  - Proposed destination: `SolverContext::move_gen`
  - Notes: avoid cross-instance sharing; size via config if needed

## 4. Heuristic Sorting

### Initial findings

- Symbols: [to confirm]
  - Weight arrays, temporary buffers likely in `library/src/heuristic_sorting`
  - Kind: shared buffers
  - Destination: `SolverContext::heuristic`
  - Notes: keep immutable tables `constexpr`

- Symbols: weight arrays, side arrays, caches
  - Kind: shared buffers or statics
  - Write sites: weight assignment, sort preparation
  - Lifetime: per-search
  - Proposed destination: `SolverContext::heuristic`
  - Notes: tables that are immutable remain `constexpr`

## 5. Utilities / I/O

### Initial findings

- Symbol: scheduler (Scheduler)
  - File: library/src/Init.cpp:40 definition; extern in multiple files
  - Kind: global object
  - Writes: during init and runtime
  - Lifetime: per-process; controls threading
  - Destination: `SolverContext::utilities` or a higher-level orchestrator decoupled from solver state
  - Notes: eliminate global, inject per-instance handle or make immutable config

- Symbol: memory (Memory)
  - File: library/src/Init.cpp:39 definition; extern in multiple files
  - Kind: global object
  - Writes: during init and runtime
  - Lifetime: per-process
  - Destination: managed by `SolverContext` allocators/arenas
  - Notes: retire global `Memory` in favor of per-instance allocators

- Symbol: sysdep (System)
  - File: extern declarations in multiple files
  - Kind: external dependency handle
  - Lifetime: global
  - Destination: pass as an immutable service or encapsulate per-instance as needed
  - Notes: avoid mutable global access

- Symbol: thrIdNext (atomic<int>)
  - File: library/src/system/System.cpp:552, 627 (function-local static)
  - Kind: function-local static atomic counter
  - Writes: thread id generation
  - Lifetime: per-process
  - Destination: move to orchestrator or `SolverContext` if solver-level threads used
  - Notes: remove reliance on function-local static mutable state

- Symbols: RNG engine/state, logging buffers, statistics accumulators
  - Kind: globals/singletons
  - Write sites: anywhere logging/randomness/stats occur
  - Lifetime: per-instance (stats may be per-batch)
  - Proposed destination: `SolverContext::utilities`
  - Notes: seed via `SolverConfig`; provide thread-safe read-only accessors

## 6. Global options / flags

### Initial findings

- Symbols: [to confirm]
  - Runtime feature toggles, search limits
  - Kind: global variables or singleton config
  - Destination: `SolverConfig` (read via `SolverContext`)
  - Notes: deprecate mutable globals; parse env/CLI into config

- Symbols: runtime toggles, limits, feature flags
  - Kind: global variables
  - Write sites: init and during solving
  - Lifetime: per-instance configuration
  - Proposed destination: `SolverConfig` (read via `SolverContext`)
  - Notes: remove mutable globals; preserve env/CLI parsing by populating config

---

## Discovery checklist (run during 01 task)

- Search patterns:
  - `\bstatic\b` and not followed by `constexpr`
  - global variables in `.cpp`/`.cc` without `const`
  - singleton-style accessors
  - large arrays/buffers at file scope in solver modules
- Trace write sites using IDE references and grep
- Classify lifetime and map to destination

Template row

- Symbol: <name>
- File: <path>
- Kind: global | static-local | singleton | shared buffer
- Writes: <functions>
- Lifetime: per-call | per-search | per-instance | global-immutable
- Destination: <SolverContext sub-context>
- Notes: <anything special>

---

## Seed candidates (to validate during inventory)

- Transposition table arrays/buckets and stats (likely under `library/src`)
- Search node stacks, PV, killer/history tables
- Move generation scratch arrays
- Heuristic sorting weight buffers
- RNG/logging/statistics globals
- Any global flags influencing search behavior

Add concrete symbols/files as they’re identified in Task 01.
