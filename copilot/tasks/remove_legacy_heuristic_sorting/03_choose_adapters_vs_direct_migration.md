# Task 03: Choose adapters vs direct migration

## Objective
Decide whether to:
- Update call sites to include and use the new module directly, or
- Add transitional adapters that keep existing signatures but delegate to the new module.

## Steps
- Evaluate the number and complexity of call sites from Task 02.
- If few and simple: plan direct migrations.
- If many or risky: design thin adapters (headers only if possible) maintaining ABI/API.
- Document decision and list impacted files.

## Verification
- Decision documented with rationale and risk assessment.
- Saved at `copilot/reports/remove_legacy_heuristic_sorting/03_decision.md`.

## Expected outputs
- Migration plan (direct vs adapter) and file list.
