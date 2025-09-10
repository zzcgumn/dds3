```markdown
# Task 02 — Create test build targets and Bazel rules

Goal
- Add Bazel build targets to compile the harness and tests for both binary and test targets.

Steps
1. Edit `library/tests/heuristic_sorting/BUILD.bazel` to add:
   - a `cc_test` target `compare_harness` that builds the harness and runs as a test.
   - a `cc_binary` `compare_binary` for smoke runs (optional).
2. Ensure test target has proper deps on `//library/src:...` and any move enumeration utilities.

Verification
- `bazel build //library/tests/heuristic_sorting:compare_harness` completes for the active build variant.

Notes
- Use `select()` on `@//:use_new_heuristic` define if the project convention supports it, otherwise rely on building with `--define` per-run.

```
