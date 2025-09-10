# Task 08 — CI integration for performance artifacts

Owner: CI / @you
Estimate: 1–2 days

Goal

Add a CI job (Linux) that builds the instrumented binary, runs the dtest workload, and uploads perf artifacts.

Steps

1. Create a CI job that:
   - Checks out the branch and builds `dtest` with frame pointers.
   - Runs `perf record` on `bazel-bin/library/tests/dtest --file hands/list100.txt`.
   - Runs `perf script` and produces folded stacks + flamegraph.
   - Uploads artifacts (raw perf data, flamegraph svg) to the build artifacts.
2. Optionally, add a scheduled job that runs nightly to detect slow regressions.

Artifacts

- CI job definition (e.g. `.github/workflows/perf.yml` or equivalent)
- Uploaded artifacts in CI run.

Acceptance

- A CI run that produces `flamegraph-*.svg` artifacts for review.
