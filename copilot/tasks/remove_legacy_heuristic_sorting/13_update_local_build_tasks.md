# Task 13: Update local build tasks (VS Code tasks)

## Objective
Avoid confusion by removing obsolete `--define=new_heuristic` usage from local tasks.

## Steps
- Update workspace tasks (if any) to drop `--define=new_heuristic=...`.
- Ensure provided tasks in the repo reflect the new default behavior.

## Verification
- Running build tasks succeeds without the define.

## Expected outputs
- Cleaned task definitions.
