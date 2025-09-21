# Task 03 — Collect CPU profiles on macOS (Instruments)

Owner: @you
Estimate: 1 day

Goal

Collect Time Profiler traces using Xcode Instruments for the new heuristic and legacy runs.

Steps

1. Build with debug info (optimized with symbols):

```bash
bazel build //library/tests:dtest -c opt --copt=-g
```

Note: older instructions referenced `--define=new_heuristic` to enable a runtime toggle. The new heuristic is now the default and the build-time flag is no longer used in the mainline.

2. Open Instruments → Time Profiler and attach to a running `dtest` process, or launch `dtest` from Instruments while processing `hands/list100.txt`.
3. Record for a representative period (30–120s) or until the run completes.
4. Export the trace (`.trace` bundle) and store under `copilot/perf/artifacts/trace-new.trace` and `trace-legacy.trace`.

Notes

- If Instruments sampling misses short inlined functions, compare with Linux perf. Keep both artifacts.

Artifacts

- `copilot/perf/artifacts/trace-new.trace`
- `copilot/perf/artifacts/trace-legacy.trace`

Acceptance

- Both traces uploaded and an initial list of top CPU-consuming symbols recorded in `copilot/perf/artifacts/macos-hotlist.md`.
