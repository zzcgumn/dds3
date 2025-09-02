1. Task Title: Design heuristic_sorting public API and types
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Medium
4. Estimated Time: 5
5. Dependencies:
   - 01-discovery-boundaries.md
6. Description:
   Define `HeuristicContext`, `CandidateMove`, `ScoredMove`, `HandRole`, and `ContractType`. Specify `score_and_order` API and tie-breaking/stability semantics. Plan adapters from `Moves` types to the new context.
7. Implementation Details:
   - Create header sketch in `.cursor/drafts/heuristic_sorting.h.txt` (not compiled yet).
   - Reference `doc/heuristic-sorting.md` for field requirements.
   - Use `serena` MCP to propose field coverage and detect missing dependencies.
8. Acceptance Criteria:
   - API doc finalized with fields, enums, and function signatures.
   - Tie-breaking and determinism policy documented.
9. Testing Approach:
   - Peer review of API doc; later unit tests will bind to these names.
10. Quick Status:
   - No code yet; only design documentation.


