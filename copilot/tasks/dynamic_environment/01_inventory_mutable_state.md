# 01 — Inventory mutable static/global state

Goal

- Identify all mutable global or function-local `static` variables and shared scratch buffers involved in solving.

Actions

- Search for candidates: patterns like `static`, global variables, singletons, and shared buffers across `library/src` and `src`.
- Classify each by lifetime and ownership: per-call, per-search, per-instance, or immutable.
- Produce a table: symbol, file, role, write-sites, proposed destination in `SolverContext`.
- Create a living document: `copilot/reports/dynamic_environment_inventory.md` and keep it updated during migration.

Deliverables

- `copilot/reports/dynamic_environment_inventory.md` with a first complete pass.
- List of hotspots prioritized for migration order (e.g., TT, search stacks, move buffers, heuristic buffers).

Acceptance criteria

- All mutable statics/globals in the solver path enumerated and classified.
- Clear mapping to `SolverContext` or sub-contexts for each item.
