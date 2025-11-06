# 06 – Audit and update call sites

Goal
- Ensure all internal code paths access TT via `SolverContext`/`SearchContext` member and not any removed registry helpers.

Scope
- Search for usages of:
  - `maybeTransTable` / `transTable`
  - `tt:resize` / `tt:clear` / `tt:dispose` logging markers
  - Any direct reference to the old `registry()` function

Steps
1) Grep codebase for the identifiers above; verify or adjust calls to go through `SolverContext` methods.
2) If any non-SolverContext code accessed the registry or TT directly, introduce appropriate `SolverContext` usage.
3) Rebuild to catch unresolved symbol errors and iterate.

Acceptance criteria
- No references to removed registry symbols.
- All TT interactions go through the new member accessors.

Notes
- Prefer smaller targeted edits; avoid reformatting unrelated code.
- Follow `.github/instructions/git.instructions.md` for commit hygiene.
