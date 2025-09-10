## Compare legacy and new heuristic sorting — plan

Purpose
-------
This document defines a concrete plan to verify the equivalence (functional and behavioural) of the legacy heuristic sorting implementation (in `moves.cpp`) and the new implementation under `library/src/heuristic_sorting`.

Scope
-----
- Produce a repeatable test harness and test-suite that compares outputs from both implementations across deterministic and randomized inputs.
- Verify exact equivalence where expected, and collect metrics where non-determinism or ties exist.
- Provide build/run instructions and quality gates to ensure CI can run the comparison.

Checklist (requirements extracted)
---------------------------------
- Create a test/harness that runs both implementations and compares outputs. (Planned)
- Use the existing `use_new_heuristic` build/flag and `set_use_new_heuristic` runtime switch. (Planned)
- Place tests under `library/tests/heuristic_sorting`. (Planned)
- Provide reproducible runs, randomized test batches, and focused unit tests. (Planned)
- Provide commands to build and run with the Bazel define flags. (Planned)
- Define success criteria and quality gates. (Planned)

Assumptions
-----------
- The project already exposes `set_use_new_heuristic(bool)` at runtime or an equivalent switch when built with `--define=use_new_heuristic=...` (per `copilot/heuristic_sorting_comparison_instructions.md`).
- Tests can be added under `library/tests/heuristic_sorting` and executed with Bazel test or a test runner used by the project.
- The heuristic result shape is inspectable and comparable (for example: ordered move lists, scores, or canonical keys). If it's not, the harness will serialize/normalize results for comparison.

Contract (tiny)
---------------
- Inputs: a board position or list of positions (deterministic or random seed) and a selection of configuration flags.
- Outputs: two serialized move-orderings (legacy vs new), and optional metrics (time, number of comparisons, stable tie-break decisions).
- Error modes: build-time flag missing, runtime switch missing, or serialization mismatch; the harness should log and fail fast on these.
- Success: for each input position the two outputs are either byte-for-byte equal after normalization, or differences are captured and summarized with a reason category.

Edge cases to cover
-------------------
- Positions with many equal-score moves (ties).
- Terminal positions or positions with no legal moves.
- Positions that rely on history/volatile state (if heuristic uses global state).
- Very large move lists (performance/memory stress).
- Deterministic vs nondeterministic behavior due to uninitialized values.

Test strategy and components
----------------------------
1. Unit tests (small, deterministic)
   - A handful of hand-crafted positions where the expected move-order is known.
   - Compare serialized move lists from both implementations.

2. Randomized fuzz batch
   - Generate N positions using the project's position generator or reuse existing test positions in `hands/` and `examples/`.
   - Use a fixed random seed for reproducibility.
   - For each position: run legacy, run new, compare normalized outputs.

3. Stability experiments
   - For positions with ties, run tie-breaking stress tests: run multiple times (if nondeterministic) to detect instability.

4. Performance and behavioural metrics
   - Measure (wall) time to produce the ordering for each implementation.
   - Count or collect any exported internal counters if available (like number of heuristic comparisons).

5. Differential reporting
   - For any difference, record:
     - Position identifier and seed
     - The two serialized orderings
     - A short diff (first X elements that differ)
     - Time taken by each implementation
   - Aggregate summary: total positions, identical count, mismatches, categories.

Implementation details / harness design
-------------------------------------
- Create a test harness source file in `library/tests/heuristic_sorting/compare_harness.cpp` (or equivalent test framework file) that:
  - Accepts a list of positions or generates them from seeds.
  - Calls `set_use_new_heuristic(false)`, collects ordering A, then `set_use_new_heuristic(true)`, collects ordering B.
  - Normalizes both orderings into a stable textual form (e.g., JSON list of moves with canonical notation and score if available).
  - Compares and writes detailed diffs for failed cases to `bazel-testlogs` or a local `build/compare-results` directory.

- If `set_use_new_heuristic` is not available at runtime, the harness will instead build and run two binaries/tests produced by Bazel built with `--define=use_new_heuristic=true|false` and compare their outputs.

Build and run commands (examples)
---------------------------------
Build both variants (local debug):

```bash
bazel build //... --define=use_new_heuristic=true
bazel build //... --define=use_new_heuristic=false
```

Run the compare harness (if implemented as a test):

```bash
bazel test //library/tests/heuristic_sorting:compare_harness --test_output=all \
  --define=use_new_heuristic=true
```

Or run the harness binary twice and compare outputs (if using two binaries):

```bash
# build binaries
bazel build //library/tests/heuristic_sorting:compare_binary --define=use_new_heuristic=true
bazel build //library/tests/heuristic_sorting:compare_binary --define=use_new_heuristic=false

# run them and save outputs
bazel-bin/library/tests/heuristic_sorting/compare_binary_true > /tmp/ordering_true.json
bazel-bin/library/tests/heuristic_sorting/compare_binary_false > /tmp/ordering_false.json

# compare
diff -u /tmp/ordering_true.json /tmp/ordering_false.json | head -n 200
```

Quality gates
-------------
- Build: both `use_new_heuristic=true` and `=false` must compile.
- Tests: unit tests must pass in both variants.
- Equivalence: for the initial test set, 100% of positions must match exactly. If mismatches exist, they must be triaged and classified.
- Performance: no more than X% regression in ordering time for the new implementation on a representative sample (define X after initial run; e.g., 10%).

Reporting and artifacts
-----------------------
- A human-readable report `copilot/reports/heuristic_equivalence_report.md` summarizing results, diffs, and triage notes.
- Machine-readable logs per run: JSON with per-position comparison results saved under `build/compare-results/<timestamp>/`.

CI integration
--------------
- Add a CI job that does a reduced run (smoke/random 100 positions) and fails if regressions or mismatches exceed a threshold (for example, >0 mismatches for mandatory equivalence tests).

Timeline & milestones (suggested)
---------------------------------
- Day 0: add harness file, small unit tests, and documentation (this plan). (Done: plan)
- Day 1: implement harness, add 10 canonical unit tests, and run locally.
- Day 2: add randomized batch, collect metrics, triage mismatches.
- Day 3: produce final report and CI job.

Next steps (concrete)
---------------------
1. I will add the plan file at `copilot/plans/compare_heuristic_sorting.md` (this file).
2. Implement the harness in `library/tests/heuristic_sorting/compare_harness.cpp` and add a small set of unit tests.
3. Run builds for both `use_new_heuristic=true` and `=false`, execute the harness, and collect results.

Notes
-----
- If the codebase already contains helpers to enumerate moves or serialize them, reuse them rather than reimplementing.
- Keep the initial test set small and deterministic to get rapid feedback; expand to randomized and larger sets after the harness is validated.

Requirements coverage
---------------------
- Save plan file to `copilot/plans/compare_heuristic_sorting.md`: Done (this file).
- Include build/run instructions that use the `use_new_heuristic` flag: Done.
- Place tests under `library/tests/heuristic_sorting`: Planned (next steps).

Completion summary
------------------
This plan lays out a repeatable, CI-friendly approach to compare legacy and new heuristic sorting: contract, test strategy, harness design, build/run commands, quality gates, and deliverables.
