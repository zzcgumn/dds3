## Goal

Extract the heuristic move ordering (“MoveOrdering”) from `library/src/Moves.cpp` into a reusable Bazel-built library with an easier-to-read implementation and extensive unit tests. Use `doc/heuristic-sorting.md` as the specification and ensure backward compatibility with current solver behavior.

## Outcomes
- New library providing a readable, documented heuristic sorting API.
- `Moves.cpp` uses the library (adapter layer) without changing solver results.
- Bazel targets added for the library and tests.
- Extensive tests (unit, property/golden, regression) for determinism and parity with current behavior.

## Scope & Non-Goals
- In scope: refactor-only extraction, readability improvements, docstrings, test coverage, deterministic behavior.
- Out of scope: algorithmic changes that alter ordering semantics beyond trivial refactors; performance optimizations.

## High-level Phases
1) Discovery and boundaries
2) Library API design
3) Minimal adapter integration in `Moves.cpp`
4) Easier-to-read implementation (phase 1: parity)
5) Bazel wiring
6) Tests (unit, golden, regression), CI wiring
7) Documentation

## 1) Discovery and Boundaries
- Inventory functions and data used by the current heuristic:
  - Weight allocators in `Moves.cpp` (e.g., ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)`, ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)`, ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*1/*2/*3`, `MergeSort`, helpers like `RankForcesAce`, `GetTopNumber`).
  - Structures: `moveType`, `movePlyType`, `pos`, `trackType`, `relRanksType`, constants (suit indices, ranks), and tables (`highestRank`, `lowestRank`, `counttable`, `bitMapRank`).
- Define the minimal data needed for ordering as a pure function input (immutable snapshot for a trick):
  - Current trick context (lead hand, suit, trump, removed ranks, winners/seconds per suit, lengths, rankInSuit bitmasks, relative rank tables).
  - Candidate moves list for the current player with suit/rank/sequence.
- Identify invariants needed for correctness (e.g., same pre-sorted candidates as today; stable tie-breaking).

## 2) Library API Design
Create a new module `heuristic_sorting` with:
- Public types (header-only forward-friendly):
  - `HeuristicContext` (immutable state of a trick required for scoring).
  - `CandidateMove { suit, rank, sequence }`.
  - `ScoredMove { suit, rank, sequence, weight }`.
  - `HandRole` enum: lead, second (LHO), third (partner), fourth (RHO).
  - `ContractType` enum: NT or Trump with trump suit.
- Public functions:
  - `std::vector<ScoredMove> score_and_order(const HeuristicContext&, HandRole role, std::span<const CandidateMove>)`.
  - Optional: `void score_in_place(const HeuristicContext&, HandRole, gsl::span<CandidateMove>)` where `CandidateMove` carries weight.
- Design principles:
  - Pure, side-effect-free scoring; caller provides any mutable storage.
  - No dependency on `Moves`’ internal `track` layout; provide adapters.
  - Deterministic ordering (document stable sort policy for ties).

## 3) Adapter Integration in `Moves.cpp`
- Add a thin adapter that:
  - Translates `Moves` internal state (`pos`, `trackp`, globals) into `HeuristicContext`.
  - Converts `movePlyType.move[]` to `CandidateMove[]`.
  - Calls `score_and_order`, then copies weights back into `movePlyType.move[i].weight`.
  - Keeps existing `MergeSort` logic or uses the ordered output directly (toggle-able via a macro for bisecting).
- Gradual rollout strategy:
  - Start by swapping only one path (e.g., ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)`) behind a compile flag `DDS_USE_NEW_HEURISTIC`.
  - Expand to all cases once parity tests pass.

## 4) Easier-to-read Implementation (Phase 1 Parity)
- Implement `score_and_order` by directly porting rules from `doc/heuristic-sorting.md`, mapping 1:1 to named helper functions:
  - `compute_suit_bonus_*`, `compute_suit_weight_delta_*`, `is_trick_winning_move`, `encourage_discourage_patterns`, `apply_best_move_bonuses`, etc.
- Use small functions, explicit booleans, and descriptive variable names.
- Keep weights/numeric constants identical; centralize constants for future tuning.
- Add assertions for invalid inputs (e.g., unknown suit indices, out-of-range ranks).

## 5) Bazel Wiring
- New sources under `library/src/heuristic_sorting/`:
  - `heuristic_sorting.h`, `heuristic_sorting.cpp`
  - `context.h` (types), `scoring_rules.cpp`, `scoring_helpers.cpp`
- BUILD targets:
  - `cc_library(
      name = "heuristic_sorting",
      srcs = ["heuristic_sorting.cpp", "scoring_rules.cpp", "scoring_helpers.cpp"],
      hdrs = ["heuristic_sorting.h", "context.h"],
      includes = ["."],
      visibility = ["//visibility:public"],
      deps = [],
    )`
  - Update `library/src/BUILD.bazel` to depend on `:heuristic_sorting` for the `dds` library target if needed by `Moves.cpp`.
- Test targets:
  - `library/tests/heuristic_sorting/BUILD.bazel` defining `cc_test` for unit tests and golden tests.

## 6) Tests
- Unit tests (white-box of library):
  - Each role/situation from the spec: NT vs Trump; void/non-void; partner/lho/rho cases; singleton cases; sequence cases.
  - Verify exact weights for curated micro-scenarios.
- Golden parity tests:
  - Feed identical `pos`/candidate sets through old `Moves` path and new library; assert same ordering and weights.
  - Use fixtures derived from existing test suites in `library/tests/heuristic-sorting/` and `library/tests/regression/heuristic_sorting/` (extend as needed).
- Property tests (determinism and invariants):
  - Re-run randomly generated consistent states, ensure determinism and stability properties.
- Regression tests:
  - The tests in `library/tests/regression/heuristic_sorting/` are designed to check that the `Moves` algorithm has not changed. These should be expanded to cover all heuristic paths.
  - Snapshot of historical tricky cases from `doc/heuristic-sorting.md` examples (transcribed into unit vectors).
- Performance sanity:
  - Micro-benchmark optional; ensure no material slowdown compared to current path.

## 7) Documentation
- API docs in `heuristic_sorting.h` with a short rationale and examples.
- Developer README: `library/src/heuristic_sorting/README.md` explaining mapping from the original algorithm to readable helpers.

## Serena MCP Assistance
- Use `serena` MCP to:
  - Generate skeletons for headers/BUILD files and adapters.
  - Expand unit test matrices from spec bullet points into parameterized tests.
  - Automate creation of golden fixtures comparing old vs new paths.

## Migration Plan
1) Add library scaffolding and no-op adapter gated by `DDS_USE_NEW_HEURISTIC=0`.
2) Implement scoring for lead-hand (NT and Trump), wire only those behind the flag; run parity tests.
3) Implement LHO/partner/RHO paths; expand coverage; enable for all roles.
4) Remove flag or default to `1` after green tests/benchmarks.

## Risks & Mitigations
- Weight drift due to integer math: centralize constants and add parity tests; prefer identical integer operations.
- Hidden dependencies on `track` side effects: keep adapter read-only and validate inputs.
- Sorting stability: document and match current `MergeSort` tie-breaking, or apply stable sort and verify parity.

## Deliverables Checklist
- `library/src/heuristic_sorting/*` sources and headers
- `library/src/BUILD.bazel` updated with `:heuristic_sorting`
- Adapter in `library/src/Moves.cpp` (guarded by `DDS_USE_NEW_HEURISTIC`)
- Tests in `library/tests/heuristic-sorting/*` with Bazel targets
- Docs: header docstrings + `README.md`

## Success Criteria
- All existing tests pass.
- New unit/golden tests pass with identical ordering/weights to legacy path.
- Code is significantly easier to read and reason about without changing behavior.


