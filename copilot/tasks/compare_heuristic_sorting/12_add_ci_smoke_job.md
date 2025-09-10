```markdown
# Task 12 — Add CI smoke job configuration

Goal
- Add a CI job that runs a reduced comparison (e.g., 100 random positions) and fails on mismatches above threshold.

Steps
1. Add a CI YAML snippet (or update existing CI) to build both variants and run the harness with `--count=100` and `--seed=<fixed>`.
2. Fail the CI job if mismatches > 0 (initially strict), or if performance regressions exceed configured threshold.
3. Store JSON logs as pipeline artifacts for review.

Verification
- CI job triggers in PRs and produces artifacts (logs) and pass/fail status.

Notes
- Keep the smoke job small to keep CI time reasonable.

```
