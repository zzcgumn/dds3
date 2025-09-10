# Task 06 — Hypothesis experiments & quick fixes

Owner: @you
Estimate: 2–4 days (iterative)

Goal

For the top 3–5 hotspots, run small, low-risk experiments to measure impact and preserve correctness.

Example hypotheses & experiments

- Dispatch overhead
  - Replace function-pointer dispatch with an inline templated fast path for the common case and measure.
- Allocation overhead
  - Pre-allocate move vectors or reuse buffers across calls.
- Sorting/copy cost
  - Use index-based sorting to avoid heavy copies in comparator.

Steps

1. For each hypothesis implement a small change on a feature branch and add microbenchmark + regression test (golden ordering).
2. Measure microbenchmark, run `dtest` end-to-end and update flamegraphs.
3. If improvement is verified, prepare a small PR describing the change and performance numbers.

Artifacts

- Patch branch per experiment, microbenchmark outputs, before/after flamegraphs.

Acceptance

- At least one low-risk change that measurably reduces the regression (>=5% improvement end-to-end) or a clear write-up why no safe win exists.
