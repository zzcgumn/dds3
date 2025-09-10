# Task 01 — Reproduce baseline timings

Owner: @you
Estimate: 0.5–1 day

Goal

Reproduce the slowdown and capture stable timing numbers for the new heuristic vs legacy.

Steps

1. Ensure branch with the changes is checked out and clean.
2. Build optimized binaries with symbols for both variants:

```bash
bazel build //library/tests:dtest -c opt --define=new_heuristic=true
bazel build //library/tests:dtest -c opt --define=new_heuristic=false
```

3. Choose benchmark input (e.g. `hands/list100.txt`). Run 5–10 runs for each variant and collect wall-clock times:

```bash
BENCH=hands/list100.txt
mkdir -p copilot/perf/artifacts
for i in {1..5}; do time bazel-bin/library/tests/dtest --file "$BENCH" ; done > copilot/perf/artifacts/raw-times-new.txt
# switch to legacy binary (or rebuild with false) and run
for i in {1..5}; do time bazel-bin/library/tests/dtest --file "$BENCH" ; done > copilot/perf/artifacts/raw-times-legacy.txt
```

4. Compute mean/median/stddev (use `awk`/python locally) and place a short summary: `copilot/perf/artifacts/baseline-summary.md`.

Artifacts

- `copilot/perf/artifacts/raw-times-new.txt`
- `copilot/perf/artifacts/raw-times-legacy.txt`
- `copilot/perf/artifacts/baseline-summary.md`

Acceptance

- Recorded timings for both variants with basic stats (mean/median/stddev).
- If slowdown is not reproducible, attach environment notes (macOS version, CPU, bazel version).
