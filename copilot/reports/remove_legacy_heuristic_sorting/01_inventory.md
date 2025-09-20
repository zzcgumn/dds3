# Inventory: DDS_USE_NEW_HEURISTIC and --define=new_heuristic

Generated: 2025-09-20

This report lists discovered references to the compile-time macro `DDS_USE_NEW_HEURISTIC` and the Bazel define `new_heuristic` (or variants like `use_new_heuristic`) across the repo. Context snippets are included.

---

# Key source locations

- `library/src/moves/Moves.cpp`
  - Contains `#ifdef DDS_USE_NEW_HEURISTIC` and runtime toggles (set_use_new_heuristic / use_new_heuristic).
  - Snippets:
    - `#ifdef DDS_USE_NEW_HEURISTIC`
    - `static bool use_new_heuristic_flag = true;`
    - `bool set_use_new_heuristic(const bool val) {` and `bool use_new_heuristic() { return use_new_heuristic_flag; }`
    - Multiple `if (use_new_heuristic()) {` branches.

- `library/src/moves/Moves.h`
  - Declaration of `set_use_new_heuristic` / `use_new_heuristic` and `#ifdef DDS_USE_NEW_HEURISTIC` guarded sections.

- `CPPVARIABLES.bzl`
  - Contains mapping: `"//:new_heuristic": ["DDS_USE_NEW_HEURISTIC"],`

- `library/tests/heuristic_sorting/*`
  - Several test files (`canonical_cases_test.cpp`, `targeted_unit_tests.cpp`, `fuzz_driver.cpp`, `compare_harness.cpp`, etc.) use `#ifdef DDS_USE_NEW_HEURISTIC` or call `set_use_new_heuristic(...)`.

- `copilot/perf/weight_alloc_microbench.cpp`
  - Contains `#ifdef DDS_USE_NEW_HEURISTIC` and runtime toggles in microbench harness.

- `copilot/heuristic_sorting_comparison_instructions.md`
  - References building with `--define=new_heuristic=true` and runtime switch availability.

- Build and config files
  - `.bazelrc` contains `build:new_heuristic --define=new_heuristic=true` (and related configs)
  - `BUILD.bazel` references a `new_heuristic` config in `config_setting` / `select()` usage
  - `docs/BUILD_SYSTEM.md` documents `new_heuristic` configurations and mapping to `DDS_USE_NEW_HEURISTIC`
  - `.github/workflows/ci_linux.yml` runs builds with `--define=new_heuristic=true`

- Other docs and plans
  - Several plan/task docs (e.g., `copilot/plans/extract_heuristic_sorting.md`, `.gemini/*`, `.cursor/*`) include references and guidance around `DDS_USE_NEW_HEURISTIC` usage during the extraction/migration.

---

# Observations and notes

- The codebase contains both a compile-time switch mapping (`CPPVARIABLES.bzl`, `.bazelrc`, `BUILD.bazel`) and runtime toggles in `Moves.cpp` for toggling between implementations when built with the flag.
- Tests rely on the flag to enable runtime toggles; many test harnesses expect the runtime `set_use_new_heuristic` when built with `--define=new_heuristic=true`.
- Removing the macro will require updating tests and build configs that assume runtime toggling is available.

---

# Next actions (per Task 01)

- Review and confirm this inventory.
- Use this inventory when planning code edits (Tasks 02-07).


Report generated automatically by the task runner.