# Task 09: Update and run unit tests

## Objective
Make tests independent of the legacy path and the compile-time flag.

## Steps
- Update tests in `library/tests/**` that referenced the flag or legacy code.
- Ensure tests include new headers and validate behavior equivalence where applicable.
- Run `bazel test //library/tests:all`.

## Verification
- All tests pass without `--define=new_heuristic`.
- No flakiness introduced.

## Expected outputs
- Updated tests and green test run.
