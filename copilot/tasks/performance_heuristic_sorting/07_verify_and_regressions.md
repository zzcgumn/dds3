# Task 07 — Verify correctness & add regression checks

Owner: @you
Estimate: 1–2 days

Goal

Ensure that optimizations preserve move orderings and add regression checks to catch future slowdowns.

Steps

1. Keep golden tests (`library/tests/heuristic_sorting`) green for all PRs.
2. Add microbenchmark regression checks (baseline numbers) to `copilot/perf/artifacts/` and include a small script that fails if regression > X% (configurable).
3. Document how to run the scripts and where artifacts are stored.

Artifacts

- `copilot/perf/artifacts/microbench-baselines/*`
- Regression-check script: `copilot/perf/regression_check.sh`

Acceptance

- CI or local script that can compare current runs to baselines and report regressions.
