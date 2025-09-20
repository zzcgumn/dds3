# API Map: Legacy vs New Heuristic

Generated: 2025-09-20

This report maps the heuristic-related API surface in `Moves` (legacy) to the new `heuristic_sorting` module and lists call sites that will need changes or adapters.

---

## 1) Legacy API (in `Moves.h` / `Moves.cpp`)

Primary heuristic-related symbols declared in `library/src/moves/Moves.h`:

- set_use_new_heuristic(const bool val)
- use_new_heuristic()
- CallHeuristic(const pos& tpos, const moveType& bestMove, const moveType& bestMoveTT, const relRanksType thrp_rel[])
- WeightAlloc* family (legacy implementations that compute move weights):
  - WeightAllocTrump0(...)
  - WeightAllocNT0(...)
  - WeightAllocTrumpNotvoid1(...)
  - WeightAllocNTNotvoid1(...)
  - WeightAllocTrumpVoid1(...)
  - WeightAllocNTVoid1(...)
  - WeightAllocTrumpNotvoid2(...)
  - WeightAllocNTNotvoid2(...)
  - WeightAllocTrumpVoid2(...)
  - WeightAllocNTVoid2(...)
  - WeightAllocCombinedNotvoid3(...)
  - WeightAllocTrumpVoid3(...)
  - WeightAllocNTVoid3(...)

Notes:
- `CallHeuristic` is implemented as a member that constructs a HeuristicContext and calls the global `::CallHeuristic(context)`.
- Legacy `WeightAlloc*` functions are used directly in hot paths inside `MoveGen0` and `MoveGen123` when `use_new_heuristic()` is false.
- `set_use_new_heuristic` and `use_new_heuristic` are provided as runtime toggles only when built with `DDS_USE_NEW_HEURISTIC`.

---

## 2) New API (`library/src/heuristic_sorting`)

Public header: `library/src/heuristic_sorting/heuristic_sorting.h`

- HeuristicContext struct (aggregates all inputs needed by heuristic)
- void CallHeuristic(const pos& tpos, const moveType& bestMove, const moveType& bestMoveTT, const relRanksType thrp_rel[], moveType* mply, int numMoves, int lastNumMoves, int trump, int suit, const trackType* trackp, int currTrick, int currHand, int leadHand, int leadSuit)
- void CallHeuristic(const HeuristicContext& context)

Notes:
- The new module exposes a single entrypoint `CallHeuristic` that takes either a raw parameter set or a `HeuristicContext`.
- The new API expects the caller to provide `mply` (array of moves) and numeric parameters (numMoves, lastNumMoves, trump, suit, trackp, etc.) rather than relying on internal `Moves` member variables.

---

## 3) Call sites inside `Moves` that must be reconciled

Observed call sites in `library/src/moves/Moves.cpp`:

- MoveGen0 (hot path):
  - If `ftest` (some contract condition) true: either `WeightAllocTrump0` or `CallHeuristic(...)` is invoked depending on `use_new_heuristic()`.
  - Else: either `WeightAllocNT0` or `CallHeuristic(...)`.

- MoveGen123:
  - Single-suit branch: either `CallHeuristic(...)` or `(this->*WeightList[findex])(tpos)`
  - Multi-suit loop: for each suit either `CallHeuristic(...)` or `(this->*WeightFnc)(tpos)`

- The `CallHeuristic` member method constructs a `HeuristicContext` and calls the global `::CallHeuristic(context)` which matches the new module's API.

- Legacy `WeightAlloc*` functions operate only on internal state (`mply`, `numMoves`, `lastNumMoves`, etc.) and are implemented as `Moves::WeightAlloc*` member functions.

---

## 4) Gap analysis & migration notes

- The new `CallHeuristic` API already provides the necessary functionality and an integration point: `Moves::CallHeuristic` constructs a `HeuristicContext` with member variables and calls `::CallHeuristic(context)`. This means the bridging code already exists and is in use when the build enables `DDS_USE_NEW_HEURISTIC`.

- For call sites that currently use `WeightAlloc*`, the migration approach is one of:
  - Replace direct calls to `WeightAlloc*` with `CallHeuristic(...)` calls (preferred when correctness and signatures match). `Moves::CallHeuristic` already handles context construction; it can be invoked with appropriate arguments in all locations that currently call `WeightAlloc*`.
  - Alternatively, keep `WeightAlloc*` as thin wrappers that delegate to `::CallHeuristic(context)` (if some call sites or tests rely on WeightAlloc* symbols directly). However, since `WeightAlloc*` are private member functions, replacing their direct use inside `Moves.cpp` is low-risk.

- The major code change will be removing conditional logic around `use_new_heuristic()` and replacing legacy `WeightAlloc*` branch uses with a single `CallHeuristic` call at each site.

- Tests and harnesses relying on runtime `set_use_new_heuristic` will need updating: either removing the runtime toggle (if runtime toggling is no longer supported) or retaining a no-op `set_use_new_heuristic` API that does nothing but keeps ABI compatibility. Currently, `Moves.h` provides `constexpr` stub implementations of `set_use_new_heuristic` when `DDS_USE_NEW_HEURISTIC` is not defined. After removing the macro and legacy code, consider keeping a simple `set_use_new_heuristic` runtime function that returns true (or is a no-op) if tests expect it.

---

## 5) Concrete tasks produced from mapping

- Update `Moves.cpp`:
  - Remove `#ifdef DDS_USE_NEW_HEURISTIC` blocks and `use_new_heuristic()` checks.
  - Replace `if (use_new_heuristic()) { CallHeuristic(...) } else { WeightAlloc... }` with direct `CallHeuristic(...)` calls.
  - Remove (or refactor) `WeightAlloc*` implementations if they are no longer referenced.

- Update tests under `library/tests/heuristic_sorting/`:
  - Remove `#ifdef DDS_USE_NEW_HEURISTIC` guards in tests and `set_use_new_heuristic` usage; tests should assume the new implementation.

- Update build/config: ensure `heuristic_sorting` library is exported and visible; remove `CPPVARIABLES.bzl` mapping if appropriate.

---

## 6) Next step

- Implement the `Moves.cpp` edits described above (Task 05) in a safe, incremental PR, keeping a small adapter if necessary for ABI compatibility.


Report saved to `copilot/reports/remove_legacy_heuristic_sorting/02_api_map.md`.