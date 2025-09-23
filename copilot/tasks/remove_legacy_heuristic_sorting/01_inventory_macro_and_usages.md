# Task 01: Inventory macro and usages

## Objective
Identify all references to the compile-time switch and build flags controlling heuristic selection.

## Steps
- Search for `DDS_USE_NEW_HEURISTIC` across the repo (code and headers).
- Search for Bazel `--define=new_heuristic` usage in BUILD files, `.bzl` files (e.g., `CPPVARIABLES.bzl`), and scripts.
- Capture file paths and a short note on how each reference is used (e.g., `#if`, `defines`, target select, script arg).

## Verification
- A complete list of references exists (no false negatives in subsequent steps).
- Output saved as a checklist in `copilot/reports/remove_legacy_heuristic_sorting/01_inventory.md` (create dir if needed).

## Expected outputs
- Reference list with paths and context snippets.
