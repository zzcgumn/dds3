# 10 – Follow-up: Arena and TLS allocator cleanup

Goal
- Retire or localize `Arena` and `ScratchAllocTLS` now that TT ownership is per-context.

Scope
- `dds::Arena` registry and `tls::SetAlloc` shim in `SolverContext.cpp`.

Steps
1) Evaluate whether move generation call paths still need the TLS allocator.
2) If not needed, remove shim and registry; otherwise, make allocator explicitly attached to `SolverContext` or `MoveGenContext`.
3) Validate performance and memory; ensure no regressions.

Acceptance criteria
- No global arena registry if possible.
- Build/tests PASS; performance neutral or improved for typical workloads.
