# Task 02 — Quick differential smoke checks

Owner: @you
Estimate: 2–4 hours

Goal

Determine whether slowdown is dominated by per-board overhead (startup) or per-search (inner loop) cost.

Steps

1. Add a minimal timing harness (if not present) around the top-level solve loop to log per-board timings in milliseconds (a one-off change to tests is OK). Example: print time before/after each board.
2. Run a small batch (10–50 boards) and capture per-board timings for both variants.

Commands

```bash
# run a small list
bazel-bin/library/tests/dtest --file hands/list10.txt > copilot/perf/artifacts/per-board-new.txt
# legacy run
# (rebuild or run legacy binary)
bazel-bin/library/tests/dtest --file hands/list10.txt > copilot/perf/artifacts/per-board-legacy.txt
```

Artifacts

- `copilot/perf/artifacts/per-board-new.txt`
- `copilot/perf/artifacts/per-board-legacy.txt`

Acceptance

- Determine whether majority of extra time is per-board (flat overhead) or concentrated in a small number of boards (hot loops). Note findings in `copilot/perf/artifacts/per-board-summary.md`.
