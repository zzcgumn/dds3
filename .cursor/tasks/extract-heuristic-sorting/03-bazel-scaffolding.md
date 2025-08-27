1. Task Title: Scaffold Bazel library and directories
2. Parent Feature: Heuristic sorting extraction
3. Complexity: Low
4. Estimated Time: 2
5. Dependencies:
   - 02-api-design.md
6. Description:
   Create `library/src/heuristic_sorting/` with placeholder sources and headers. Add `cc_library` in `library/src/BUILD.bazel`. No integration yet.
7. Implementation Details:
   - Create files: `heuristic_sorting.h`, `heuristic_sorting.cpp`, `context.h`, `scoring_rules.cpp`, `scoring_helpers.cpp`, `README.md`.
   - Update `library/src/BUILD.bazel` with `:heuristic_sorting` target.
   - Use `serena` MCP to generate initial BUILD and file stubs.
8. Acceptance Criteria:
   - `bazel build //library/src:heuristic_sorting` succeeds (compiles empty stubs).
9. Testing Approach:
   - Run build; verify target appears with `bazel query`.
10. Quick Status:
   - Pure scaffolding; does not change runtime behavior.


