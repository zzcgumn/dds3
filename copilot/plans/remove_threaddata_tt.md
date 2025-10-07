# Finalize TT Ownership: Remove ThreadData::transTable and ttExternallyOwned

Owner: Dynamic Environment Refactor
Branch: refactor/dynamic_environment_part_two
Last updated: 2025-10-06

## Objective

Complete the ownership handoff to SolverContext by deleting the legacy per-thread TT fields:
- `ThreadData::transTable`
- `ThreadData::ttExternallyOwned`

and updating all call paths to rely solely on `SolverContext` lifecycle APIs.

## Proposed timeline

- Soak window: 7–10 days after merging PR #25 with strict deprecation enabled in CI for awareness.
- Target removal window: start on or after 2025-10-20 (adjust based on soak feedback).

## Preconditions (gate checks)

- CI is green in both modes (legacy and `DDS_TT_CONTEXT_OWNERSHIP`).
- No deprecation warnings from `DDS_TT_STRICT_OWNERSHIP` in default test targets.
- Context-based tests (`context_tt_facade_test` and `_ctx_tt`) pass reliably.
- No direct non-context TT access remains outside `SolverContext` and `Memory` teardown comments.

## Deletion patch scope

1) Remove fields from `ThreadData` (in `library/src/system/Memory.h`):
   - Delete `TransTable* transTable;`
   - Delete `bool ttExternallyOwned;`

2) Update SolverContext to decouple from `ThreadData` storage:
   - Maintain the TT pointer internally within `SolverContext` and guard re-entrancy.
   - Preserve per-thread sizing hints (`ttMemDefault_MB`, `ttMemMaximum_MB`, `ttType`) and continue honoring them.
   - Ensure `maybeTransTable()` uses only context state.

3) Update Memory:
   - Teardown paths should call `SolverContext(ctx).maybeTransTable()` and clear via context APIs.
   - Remove any delete logic previously contingent on `ttExternallyOwned`.

4) Remove any legacy includes or comments referring to the deleted fields.

5) Tests:
   - Update system tests if they manipulate the thread pointer directly (e.g., `context_tt_facade_test` setup lines that nulled `transTable`).
   - Add a regression test to ensure no accidental recreation occurs during teardown.

## Validation checklist

- Build and run:
  - `bazel build //...` and `bazel test //...` with and without `--define=tt_context_ownership=true` (should be equivalent after removal).
  - Verify `dtest` runs successfully.
  - Optional: use `DDS_DEBUG_TT_CREATE=1` to trace TT lifecycle.

- Code hygiene:
  - Grep for residual usages of `transTable` and `ttExternallyOwned`.
  - Ensure no `unique_ptr<TransTable>` appears in headers to avoid incomplete-type destructor issues.

## Rollback plan

- Revert the deletion commit to restore fields.
- Keep `DDS_TT_STRICT_OWNERSHIP` scaffolding available during rollback window.

## Communication

- Update `copilot/tasks/dynamic_environment/04_migrate_transposition_table.md` to mark completion.
- Add a brief note in the ChangeLog summarizing the final handoff.
