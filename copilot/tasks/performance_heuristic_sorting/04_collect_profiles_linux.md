# Task 04 — Collect perf flamegraphs on Linux / CI

Owner: CI / you
Estimate: 1–2 days

Goal

Collect perf-based flamegraphs for new and legacy builds on Linux (preferred for tight-loop sampling).

Steps

1. Build with frame pointers and debug info on Linux runner:

```bash
bazel build //library/tests:dtest -c opt --copt=-g --copt=-fno-omit-frame-pointer
```

Note: older guidance suggested using `--define=new_heuristic`; the flag has been removed from the mainline. The new heuristic is now the default; to reproduce legacy behavior, use an older commit or archived binaries.

2. Run under `perf` and produce a folded stack file:

```bash
sudo perf record -F 99 -g -- ./bazel-bin/library/tests/dtest --file "hands/list100.txt"
sudo perf script > perf.unfolded
stackcollapse-perf.pl perf.unfolded > perf.folded
flamegraph.pl perf.folded > flamegraph-new.svg
```

3. Repeat for legacy build and produce `flamegraph-legacy.svg`.

Artifacts

- `copilot/perf/artifacts/perf-new.data`
- `copilot/perf/artifacts/perf.unfolded` (new/legacy)
- `copilot/perf/artifacts/flamegraph-new.svg`
- `copilot/perf/artifacts/flamegraph-legacy.svg`

Acceptance

- Flamegraphs for both variants available and stored in `copilot/perf/artifacts/`.
