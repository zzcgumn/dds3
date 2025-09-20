# Task 10: Optional performance check

## Objective
Sanity-check performance to catch unintended regressions.

## Steps
- Use scripts in `copilot/perf/` (e.g., `weight_alloc_microbench.cpp` or existing harnesses).
- Run a small sample; collect time/alloc metrics.
- Compare with prior snapshots if available.

## Verification
- No significant regressions or documented justification if changes are expected.

## Expected outputs
- Brief performance note in `copilot/reports/remove_legacy_heuristic_sorting/10_perf_notes.md`.
