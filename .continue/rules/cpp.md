---
name: C++ Development Rules with clangd MCP
languages: ["cpp", "c++", "h", "hpp", "cc"]
alwaysApply: false
---

# C++ Development Rules with clangd MCP Integration

## MCP Server Configuration
- **Server Name**: `cpp` (defined in `.continue/mcpServers/cpp-mcp.yaml`)
- **Type**: clangd integration
- **Status**: Should be running and available for all C++ development tasks

## Tooling Awareness
- **clangd MCP server** is running and available to Continue.
- **Always prefer clangd MCP commands** over static analysis or assumptions about code.
- Capabilities include:
  - Real-time diagnostics and fix suggestions
  - Code completion and signature help
  - Go-to-definition and go-to-declaration
  - Find-references and find-implementations
  - Rename-symbol (with cross-file updates)
  - Organize includes and remove unused includes
  - clang-tidy checks based on `.clang-tidy` config
  - Hover information for types and documentation

## MCP Server Integration Best Practices
- If clangd MCP commands fail, mention this to the user and fall back to standard analysis
- When diagnostics show errors, prioritize fixing compilation issues before style issues
- Use clangd's fix suggestions when available rather than generating custom solutions

## Workflow Integration
When working with code:
- **Before making changes**: Run diagnostics to understand current issues
- **During refactoring**: Use find-references to identify all usage sites
- **After renaming**: Always use rename-symbol tool rather than manual find-replace
- **Before suggesting fixes**: Use go-to-definition to understand the complete context
- **After code changes**: Run diagnostics again to verify fixes worked
- **For include management**: Use organize-includes rather than manual sorting
- **When unsure about APIs**: Use hover or go-to-definition for documentation

## General
- Use **C++20** standard for all code.
- Follow RAII principles for resource management.
- Prefer smart pointers (`std::unique_ptr`, `std::shared_ptr`) instead of raw pointers.
- Maintain **const correctness** consistently.
- Avoid `using namespace` in headers.

## Code Style
- Follow the **Google C++ Style Guide** (https://google.github.io/styleguide/cppguide.html).
- Use range-based for loops and `<algorithm>` where possible.
- Use strongly typed enums (`enum class`) over unscoped enums.
- Avoid macros except for header guards (or `#pragma once`).
- Keep functions short and focused; extract helpers if logic is too long.
- Use `snake_case` for variables/functions, `PascalCase` for classes/types.

## Safety
- Initialize all variables before use.
- Avoid undefined behavior; check bounds on all container accesses.
- Prefer exceptions for error handling; avoid error codes where exceptions are practical.
- Ensure thread safety when working with shared state.
- Use `std::optional` for values that may not exist instead of nullable pointers.
- Prefer `constexpr` for compile-time constants.

## Documentation
- Document all public classes and functions with **Doxygen-style** comments.
- Explain the reasoning behind non-obvious implementation choices.
- Include usage examples for complex APIs

## Testing
- Write unit tests using **GoogleTest** for new code.
- Test normal cases, edge cases, and failure scenarios.

## Build System
- Use **Bazel** as the build system for all projects.
- Generate appropriate `BUILD` files and maintain `WORKSPACE` configuration.
- Use **Clang** as the compiler with appropriate flags.
- Configure builds with `-std=c++20 -Wall -Wextra -Werror`.

---

**Reminder to Continue:**  
When generating or editing C++ code, apply these rules automatically, and explain changes briefly if they improve clarity, safety, or performance.