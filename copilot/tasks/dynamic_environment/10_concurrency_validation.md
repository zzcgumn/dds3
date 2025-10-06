# 10 — Concurrency validation and TSAN

Goal

- Prove multiple solver instances can run concurrently safely and deterministically.

Actions

- Add a test that runs N parallel solves (threads) with distinct boards and validates outputs against single-thread results.
- Enable a TSAN build and run the concurrency test under TSAN.

Deliverables

- Concurrency unit/integration test case(s).
- TSAN build config and CI job updates.

Acceptance criteria

- Concurrency tests pass consistently.
- TSAN reports no data races.
