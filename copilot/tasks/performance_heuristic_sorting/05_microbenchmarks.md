# Task 05 — Microbenchmarks for hot functions

Owner: @you
Estimate: 1–2 days

Goal

Add focused microbenchmarks to isolate CPU cost of suspected hot functions (e.g. `CallHeuristic`, `GetTopNumber`, `RankForcesAce`).

Steps

1. Create a small benchmark harness under `library/tests/benchmarks/heuristic/` (or `copilot/perf/bench`) that:
   - Constructs representative `HeuristicContext` and hand states.
   - Calls a single function in a tight loop (1e4–1e6 iterations) and records throughput.
2. Build and run with `-c opt` and capture outputs.

Example timing harness snippet (C++ chrono) should be sufficient; avoid adding external dependencies.

Artifacts

- `copilot/perf/artifacts/microbench-<function>-new.txt`
- `copilot/perf/artifacts/microbench-<function>-legacy.txt`

Acceptance

- For each microbenchmark we have a reproducible ops/sec number and a short note if there is a significant regression in the micro-level hot function.
