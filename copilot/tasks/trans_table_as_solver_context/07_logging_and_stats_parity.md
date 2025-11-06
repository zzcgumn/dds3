# 07 – Maintain logging and stats parity

Goal
- Preserve existing logging and stats outputs for observability and compatibility with diagnostics tooling.

Checklist
- On TT creation: optional `DDS_DEBUG_TT_CREATE` print and `utilities().logAppend("tt:create|<S|L>|<def>|<max>")`
- On resize: `utilities().logAppend("tt:resize|<def>|<max>")`
- On clear: `utilities().logAppend("tt:clear")`
- On dispose: `utilities().logAppend("tt:dispose")`
- On reset-for-solve: `utilities().logAppend("ctx:reset_for_solve")`
- Stats counters guarded by `DDS_UTILITIES_STATS`: `tt_creates++`, `tt_disposes++`

Steps
1) Ensure log writes are preserved in the refactored method bodies.
2) Where buffer formatting used arena-backed small buffers, maintain the same behavior when available.
3) Verify by building and, if possible, running a small scenario that triggers each path.

Acceptance criteria
- Grep logs emitted during tests reflect the same keys and formats.
- No new unconditional logging introduced.
