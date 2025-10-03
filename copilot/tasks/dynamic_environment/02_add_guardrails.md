# 02 — Add guardrails against new mutable globals

Goal

- Prevent introduction of new mutable globals/statics during the migration.

Actions

- Enable clang-tidy checks for globals: `cppcoreguidelines-avoid-non-const-global-variables`, `cert-err58-cpp`.
- Add a lightweight script/lint to flag suspicious `static` outside headers unless `constexpr` or clearly immutable.
- Wire checks into CI as a non-blocking warning initially, then make blocking after stabilization.

Deliverables

- clang-tidy configuration update and/or CI job references.
- Script placed under `copilot/scripts/check_mutable_statics.py` (or similar) with README note.

Acceptance criteria

- CI surfaces warnings/errors when new mutable globals/statics are introduced.
- Documented whitelist (temporary) for legacy code until fully migrated.
