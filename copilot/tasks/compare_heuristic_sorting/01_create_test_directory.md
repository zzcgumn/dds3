```markdown
# Task 01 — Create test directory and scaffolding

Goal
- Create the test directory `library/tests/heuristic_sorting` and initial placeholder files.

Steps
1. Create `library/tests/heuristic_sorting/BUILD.bazel` with a test target placeholder.
2. Add `library/tests/heuristic_sorting/README.md` with a description and how to run tests.
3. Add an empty `compare_harness.cpp` file (skeleton) under the directory.

Verification
- Directory and files exist and are visible in the repo.
- `bazel test //library/tests/heuristic_sorting:dummy` returns a defined result (can be a sh_test that exits 0).

Notes
- Keep the initial files minimal; real implementation will come in later tasks.

```
