# Mutable state guardrails

This folder contains a lightweight scan script to flag mutable globals/statics while we migrate to an instance-scoped solver.

## Tools

- `.clang-tidy` at repo root enables checks:
  - `cppcoreguidelines-avoid-non-const-global-variables`
  - `cert-err58-cpp`

- `check_mutable_statics.py`: heuristic scan for
  - function-local `static` not marked `const`/`constexpr`
  - possible non-const file-scope globals

## Run locally

```bash
python3 copilot/scripts/check_mutable_statics.py . --fail
```

Without `--fail`, it prints findings but returns 0.

## CI integration

- Add a CI step to run the script against the repository and treat findings as failures:

```bash
python3 copilot/scripts/check_mutable_statics.py . --fail
```

- Ensure clang-tidy runs in your CI (Bazel rules or a separate job) so the configured checks apply.

## Notes

- The Python scan is heuristic and may have false positives/negatives; prefer clang-tidy as the source of truth.
- Maintain a temporary whitelist by suppressing at callsites (NOLINT) or by excluding specific files in CI until migrated.
