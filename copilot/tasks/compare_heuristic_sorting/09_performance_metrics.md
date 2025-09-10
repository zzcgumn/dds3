```markdown
# Task 09 — Collect performance and behavioural metrics

Goal
- Measure wall-time and other cheap metrics for ordering computation for both implementations.

Steps
1. Instrument the harness to time each ordering call (high-resolution wall clock) and record times in the JSON logs.
2. Run the harness on a representative sample (e.g., 500 positions) and compute aggregate metrics (median, p95).
3. Produce a small CSV/JSON summary that can be used to detect regressions.

Verification
- Metrics JSON produced with per-position times and aggregate summary.

Notes
- Keep instrumentation lightweight to avoid perturbing timings significantly.

```
