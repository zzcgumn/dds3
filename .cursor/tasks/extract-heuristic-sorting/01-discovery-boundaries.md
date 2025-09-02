1. Task Title: Define discovery scope and boundaries
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Medium
4. Estimated Time: 4
5. Dependencies:
   - None
6. Description:
   Inventory all functions, data structures, and constants used by move ordering in `library/src/Moves.cpp`. Identify minimal immutable inputs required for scoring (context and candidates). Document invariants and tie-breaking.
7. Implementation Details:
   - Files to read: `library/src/Moves.cpp`, `library/src/QuickTricks.h/cpp`, `library/src/ABsearch.*`, `doc/heuristic-sorting.md`
   - Output a short notes file: `.cursor/plans/heuristic-sorting-discovery.md`
   - Use `serena` MCP to index repository and cross-reference symbol usages.
8. Acceptance Criteria:
   - Notes file lists all weight allocators and helpers, required tables, and minimal context schema.
   - Invariants and tie-breaking policy documented.
9. Testing Approach:
   - N/A (review-only). Have another task consume the notes without missing symbols.
10. Quick Status:
   - Read-only; no code changes; system remains operational.


