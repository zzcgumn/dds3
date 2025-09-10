```markdown
# Task 06 — Wire unit tests into Bazel and run locally

Goal
- Wire the canonical tests and harness into Bazel and execute them locally to validate basic correctness.

Steps
1. Ensure `library/tests/heuristic_sorting/BUILD.bazel` includes the new `cc_test` target.
2. Run:
   - `bazel test //library/tests/heuristic_sorting:compare_harness --test_output=all --define=use_new_heuristic=false`
   - repeat with `--define=use_new_heuristic=true`
3. Fix compile and runtime issues as they appear.

Verification
- Tests pass for both build variants for the canonical cases.

Notes
- Iteratively fix missing includes, link errors or API mismatches.

```
