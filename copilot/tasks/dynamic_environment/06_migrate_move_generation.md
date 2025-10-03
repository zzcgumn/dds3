# 06 — Migrate move generation buffers and scratch space

Goal

- Relocate move generation scratch arrays and per-ply workspaces into `MoveGenContext`.

Actions

- Identify all shared buffers used during move generation.
- Encapsulate them in `MoveGenContext` owned by `SolverContext`.
- Replace shared/global accesses with `ctx.move_gen` references.
- Add unit tests for move generation correctness and independence across instances.

Deliverables

- Refactored move generation code to use instance-owned buffers.
- Unit tests covering representative move gen cases.

Acceptance criteria

- No shared mutable buffers remain in move generation.
- Deterministic results and identical ordering as before.
