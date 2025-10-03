# 09 — Performance alignment and allocation strategy

Goal

- Recover or improve performance while using instance-owned state.

Actions

- Implement arenas/pools for short-lived allocations and size via `SolverConfig`.
- Ensure `ResetForSolve()` reuses buffers without churn.
- Validate inlining and avoid virtual dispatch in hot loops.
- Benchmark representative workloads and compare with baseline.

Deliverables

- Allocation strategy implemented and documented.
- Benchmark numbers captured in `copilot/perf/artifacts/` with notes.

Acceptance criteria

- End-to-end performance within ±5% of baseline (or better).
- Stable peak memory usage per `SolverConfig` sizing.
