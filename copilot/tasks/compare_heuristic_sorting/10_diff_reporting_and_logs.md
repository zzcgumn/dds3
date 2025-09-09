```markdown
# Task 10 — Add differential reporting and JSON logs

Goal
- Implement structured logging and reporting for mismatches and runs so engineers can triage easily.

Steps
1. Define a JSON schema for per-position results (position id, seed, ordering_legacy, ordering_new, time_legacy, time_new, diff_summary).
2. Implement `write_json_log(out_dir, results)` in `test_utils` and ensure harness writes per-run logs to `build/compare-results/<timestamp>/`.
3. Add a small aggregator script `scripts/aggregate_compare_results.py` to produce summary tables.

Verification
- Running the harness creates JSON logs and the aggregator produces a readable summary.

Notes
- Keep logs compact but include enough context for triage (first N differing moves, full serializations on demand).

```
