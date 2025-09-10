# Task 09 — Report & store artifacts

Owner: @you
Estimate: 0.5–1 day

Goal

Produce a short report summarizing findings, include artifacts, and recommend next steps.

Steps

1. Collect key artifacts into `copilot/perf/artifacts/`:
   - baseline logs
   - flamegraphs
   - microbenchmark outputs
   - regression scripts
2. Create `copilot/perf/report-<date>.md` with:
   - Baseline numbers
   - Top hotspots
   - Experiments tried and outcomes
   - Recommended changes and risk level
3. Attach the report to the PR that contains any code changes.

Artifacts

- `copilot/perf/report-<date>.md`
- All artifacts in `copilot/perf/artifacts/`

Acceptance

- A concise report that gives maintainers enough context to approve or reject proposed optimizations.
