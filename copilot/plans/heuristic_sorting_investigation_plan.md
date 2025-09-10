# Heuristic-sorting performance investigation plan

Goal

- Reproduce the observed slowdown when the new heuristic is enabled.
- Isolate the root cause(s): algorithmic change vs. implementation overhead.
- Produce actionable data (profiles, flamegraphs, microbenchmarks) so we can target safe optimizations.

Assumptions

- You can build and run locally on macOS and CI can run Linux. The repository has a `dtest` binary target (`//library/tests:dtest`) which can run using input lists (e.g. `hands/list100.txt`).
- The new heuristic is enabled at build time with `--define=new_heuristic=true`.

Primary success criteria

- Measured end-to-end time for a representative workload (e.g. `list100.txt`) for both heuristics (new vs legacy).
- CPU/profile artifacts that point to hotspots (function-level and inline hot loops) with an actionable list of 3–5 changes to try.
- Microbenchmarks that confirm expected improvements and no correctness regressions.

Owner & timeline

- Owner: heuristic sorting owner / performance owner (assign reviewer in PR).
- Quick triage: 1 day (reproduce & baseline numbers). 
- Profiling & narrow-down: 2–3 days. 
- Small optimizations & verification: 1–2 days.

Checklist (high-level)

- [ ] Reproduce slowdown and record baseline results (new vs legacy) using the same input and environment.
- [ ] Build instrumented binaries for profiling on macOS (Instruments) and Linux (perf / pprof) and collect CPU profiles.
- [ ] Produce flamegraphs and identify top hot call paths.
- [ ] Add microbenchmarks for hot functions to isolate data-structure vs calling-overhead vs algorithmic cost.
- [ ] Implement small, low-risk optimizations and re-run benchmarks & profiles.
- [ ] Add CI job to track performance regression (optional: compare to baseline automatically).

Step 1 — Reproduce baseline timings

1. Build optimized binaries for both variants (recommended `-c opt`):

```bash
bazel build //library/tests:dtest -c opt --define=new_heuristic=true
bazel build //library/tests:dtest -c opt --define=new_heuristic=false
```

2. Run the same workload multiple times and capture timings (3–10 runs each):

```bash
# replace with the list file you use for benchmarking
BENCH=hands/list100.txt
# new heuristic
time bazel-bin/library/tests/dtest --file "$BENCH" --runs 5  # if dtest supports repeated runs; otherwise loop
# legacy
time bazel-bin/library/tests/dtest --file "$BENCH" --runs 5 --define=new_heuristic=false
```

If `dtest` has no `--runs` flag, run a loop and capture wall-clock times. Use a dedicated CPU state (close other apps) or CI runner for consistent measurements.

Record: mean, median, stddev and raw logs in `copilot/perf/artifacts/`.

Step 2 — Quick differential smoke checks

- Run a single-board or small-batch measurement of a few boards to see if the slowdown is dominated by per-board overhead or per-search work.
- Add a minimal timing harness around the top-level call in tests (if not present) that logs per-board time (milliseconds).

Step 3 — Collect CPU profiles

macOS (developer machine)

- Use Xcode Instruments (Time Profiler) when running `bazel-bin/library/tests/dtest`. Steps:
  - Build `dtest` with symbols: `bazel build //library/tests:dtest -c opt --copt=-g --define=new_heuristic=true` (and legacy variant).
  - Open Instruments → Time Profiler, attach to the running `dtest` process or launch from Instruments while running the same workload.
  - Record ~30–120s of representative work or run a single dtest invocation that processes the list file.
  - Export stack samples (for later comparison) and note top heavy frames.

Linux / CI (recommended for final profiling and reproducible perf)

- Use `perf` + FlameGraph and (optionally) `pprof`:
  - Build with frame pointers or debug info:
    - `bazel build //library/tests:dtest -c opt --copt=-g --copt=-fno-omit-frame-pointer --define=new_heuristic=true`
  - Run under perf and produce a folded-stack file:

```bash
sudo perf record -F 99 -g -- ./bazel-bin/library/tests/dtest --file "$BENCH"
sudo perf script > perf.unfolded
# produce flamegraph (requires FlameGraph scripts in PATH)
stackcollapse-perf.pl perf.unfolded > perf.folded
flamegraph.pl perf.folded > flamegraph-new.svg
```

- Repeat for legacy build and produce `flamegraph-legacy.svg`.

Google-perftools / pprof option (if available)

- If comfortable adding a dependency, build with `libprofiler` (gperftools) and use `pprof` to get annotated source profiles.

Step 4 — Interpret profiles & identify hotspots

- Compare new vs legacy flamegraphs. Look for:
  - Big new top-level CPU consumers in `library/src/heuristic_sorting` or `moves` wrappers.
  - Heavy call/dispatch overhead (e.g. function-pointer indirections, virtual calls) showing many small samples inside call sites.
  - Memory allocator hotspots (malloc/free) or unnecessary allocations in hot loops.

- Typical categories to watch for:
  - Excessive function-pointer or std::function indirection per small operation.
  - Repeated container allocations (std::vector/strings) inside hot loops.
  - Extra normalization / sorting passes that can be combined or memoized.

Step 5 — Narrow with microbenchmarks

- Add tiny, focused benchmarks (in `library/tests/benchmarks/` or `copilot/perf/bench`) for the suspected hot functions:
  - Example harnesses: call `CallHeuristic(...)` or a single function (e.g. `GetTopNumber`, `RankForcesAce`) in a tight loop with representative hand/state setups.
  - Measure: throughput (ops/sec), mean latency, and allocation counts.

- Use `chrono` for timing and run 1e4–1e6 iterations as appropriate. Add `--benchmark` or small gtest cases if you prefer.

Step 6 — Hypothesis tests & low-risk fixes

For each hotspot produce a short hypothesis and a small experiment: e.g.

- Hypothesis: function-pointer dispatch per card is expensive.
  - Experiment: replace the indirect call with an inline templated implementation for the hot path and re-measure.
- Hypothesis: repeated allocations during move construction.
  - Experiment: reuse preallocated buffers or reserve vector capacity and re-measure.
- Hypothesis: comparator/sort is doing expensive copies or allocations.
  - Experiment: switch to index based sorts or `std::sort` with custom comparator that avoids copies.

Prioritize fixes that preserve behavior and add tests. For each fix:
- Make the change in a small PR with microbenchmarks and unit tests that assert identical move orderings on golden inputs.
- Run the global `dtest` benchmark and profiles again to confirm net improvement.

Step 7 — Verify correctness & regression tests

- Keep the golden tests in `library/tests/heuristic_sorting` (already extended) green for all variants.
- Add regression microbenchmarks to `copilot/perf/artifacts/` or as bazel benchmarks to detect future regressions.

Step 8 — Automation & CI

- Add a CI job (Linux) that runs the dtest workload and records baseline timings (artifact storage) and optionally generates perf data for sample runs.
- Consider a periodic perf job that runs flamegraph generation and uploads artifacts for review.

Artifacts to collect and store

- `copilot/perf/artifacts/baseline-new.log` and `baseline-legacy.log` with timing runs.
- `perf.data`, `perf.unfolded`, `perf.folded`, `flamegraph-*.svg` for both variants.
- Instruments trace export (macOS) for the new and legacy runs.
- Microbenchmark outputs and scripts used to produce them.

Small helper commands & examples

- Quick timed loop (if `dtest` has no internal repeats):

```bash
for i in {1..5}; do time bazel-bin/library/tests/dtest --file hands/list100.txt ; done > copilot/perf/artifacts/raw-times-new.txt
```

- Build with debug symbols but optimized:

```bash
bazel build //library/tests:dtest -c opt --copt=-g --copt=-fno-omit-frame-pointer --define=new_heuristic=true
```

- Produce flamegraphs (Linux): see Step 3 commands above.

Reporting

- Produce a short report (`copilot/perf/report-<date>.md`) that contains:
  - Baseline numbers (mean/median/stddev).
  - Top 10 hotspots (function or file:line where possible).
  - Hypotheses and experiments performed with outcomes (timings + before/after profiles).
  - Recommended next actions (1–3 safest optimizations and 1 medium-risk optimization).

Notes & caveats

- macOS profiling tools (Instruments) sample by stack and may hide very short call overheads; Linux `perf` with flamegraphs often gives clearer hotspots for tight loops.
- If profiling shows GC/allocator overhead, try building with tcmalloc or jemalloc in a controlled experiment.
- Keep runs reproducible: pin CPU frequency governor (on Linux) or use a quiet developer machine to avoid noise.

Next steps (immediate)

- Run the baseline builds and timing runs (Step 1) and save the outputs under `copilot/perf/artifacts/`.
- Collect one Instruments trace (macOS) and one perf flamegraph (Linux CI) for the new heuristic.
- Share the artifacts and I will help interpret the profiles and propose specific code changes.

---

File created by automation: copilot/plans/heuristic_sorting_investigation_plan.md
