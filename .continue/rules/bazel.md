---
languages: ["bazel", "starlark", "build", "bazelbuild"]
---

# Bazel Build System Rules and MCP Integration

## Tooling Configuration
- This project uses a **Bazel MCP server** named `"bazel"` configured at `.continue/mcpServers/bazel-mcp.yaml`.
- The MCP server runs the `mcp-bazel` tool, providing:
  - Build file parsing and validation
  - Dependency graph analysis
  - Target query and navigation
  - Build command generation and troubleshooting assistance

- When suggesting changes to Bazel BUILD or `.bzl` files, prefer invoking the `"bazel"` MCP server commands for accurate dependency and syntax checks.

## Bazel Build System Guidelines
- Use explicit target dependencies; avoid wildcard globs unless necessary.
- Keep build targets focused and minimal.
- Write descriptive target names following this convention: `<component>_<purpose>_<type>`.
- Use Starlark idiomatic patterns; avoid overly complex macros where simpler solutions exist.
- Maintain consistent formatting as per `.bazelrc` and `.bzlformat` configurations.
- When refactoring BUILD files, ensure all dependent targets and tests are updated accordingly.

## Best Practices
- Prefer `cc_library`, `cc_binary`, and `cc_test` rules for C++ code.
- Keep test targets comprehensive but fast; avoid large monolithic tests.
- Use `visibility` attributes to limit target scope appropriately.
- Run `bazel build //...` and `bazel test //...` regularly and fix all errors before committing.
- Document non-trivial macros and build logic clearly.

---

**Reminder to Continue:**  
Always validate build file changes by consulting the Bazel MCP server.  
Use the `"bazel"` MCP server commands to query dependencies, check target correctness, and generate build commands.  
Prefer invoking MCP tools over guesswork for any build-related tasks.
