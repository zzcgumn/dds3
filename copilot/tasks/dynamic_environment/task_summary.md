# Dynamic environment — Task summary

Initial actionable tasks (independent of investigation outcomes):

1. 01_inventory_mutable_state — Inventory all mutable statics/globals and map to SolverContext.
2. 02_add_guardrails — Add lint/CI guardrails to prevent new mutable globals.
3. 03_scaffold_solver_context — Introduce SolverConfig/SolverContext and instance-based API with shims.
4. 04_migrate_transposition_table — Move TT into SolverContext.
5. 05_migrate_search_state — Move search state into SearchContext.
6. 06_migrate_move_generation — Move move-generation buffers into MoveGenContext.
7. 07_migrate_heuristic_sorting_buffers — Move heuristic scratch/caches into HeuristicContext.
8. 08_migrate_utilities_rng_logging — Move RNG/log/stats into SolverContext.
9. 09_performance_alignment — Arenas, buffer reuse, benchmarks.
10. 10_concurrency_validation — Parallel instance tests and TSAN.
11. 11_docs_and_examples — Document architecture and provide usage examples.

Deferred tasks (to be created later, dependent on findings):
- Deep profiling-guided adjustments if performance regressions persist.
- API consolidation/removal of legacy shims once stable and adopted.
- Optional: per-thread vs per-instance resource sharing strategies.
