---
name: C++ Development Rules (clangd MCP)
languages: ["cpp", "c++", "h", "hpp", "cc"]
alwaysApply: true
---

# C++ Development Rules with clangd MCP Integration

<mcpserver name="cpp" type="clangd integration" status="Must be running for all C++ work">
  <capabilities>
    <capability>Real-time error reporting</capability>
    <capability>Auto-apply clangd fixes</capability>
    <capability>Code completion and signature help</capability>
    <capability>Go-to-definition and references</capability>
    <capability>Cross-file rename operations</capability>
    <capability>Include management and organization</capability>
    <capability>Style and safety checks</capability>
  </capabilities>
</mcpserver>

<tooling>
  <tool name="Diagnostics" purpose="Real-time error reporting" usage="Before building" />
  <tool name="Fix suggestions" purpose="Auto-apply clangd fixes when diagnostics appear" usage="When errors are detected" />
  <tool name="Code completion" purpose="Signature help" usage="While typing" />
  <tool name="Go-to-definition" purpose="Navigate code during refactoring" usage="During code navigation" />
  <tool name="Rename-symbol" purpose="Cross-file rename" usage="Renaming identifiers" />
  <tool name="Organize-includes" purpose="Remove unused includes" usage="Before committing" />
  <tool name="clang-tidy" purpose="Style & safety checks in the CI pipeline" usage="Before committing" />
</tooling>

<tip>If a clangd command fails, fall back to manual analysis and report the issue.</tip>

<workflow>
  <step name="Diagnostics" description="Run first to catch compile errors before any changes" />
  <step name="Refactor" description="Use find-references to locate all usages during refactoring" />
  <step name="Rename" description="Use rename-symbol for safe cross-file changes when renaming identifiers" />
  <step name="Include management" description="Run organize-includes before committing to remove unused includes" />
  <step name="Post-change diagnostics" description="Verify no new errors after code changes" />
</workflow>

<codingguidelines>
  <standard>C++20 (`-std=c++20`)</standard>
  <principle name="RAII" description="Manage resources via destructors" />
  <principle name="Smart pointers" description="Prefer std::unique_ptr / std::shared_ptr" />
  <principle name="Const-correctness" description="Mark data/functions const where possible" />
  <principle name="No using namespace" description="No `using namespace` in headers" />
  <principle name="C++ Core Guidelines" description="[Style Guide](https://isocpp.github.io/CppCoreGuidelines/) follow naming, formatting, and layout" />
  <principle name="Enums" description="Use enum class" />
  <principle name="Functions" description="Keep short; extract helpers if > 20 lines" />
  <principle name="Variables" description="snake_case; classes – PascalCase" />
  <principle name="Header guards" description="#pragma once or traditional guards" />
</codingguidelines>

<safety>
  <rule>Initialize all variables</rule>
  <rule>Check bounds on container access</rule>
  <rule>Prefer exceptions over error codes when appropriate</rule>
  <rule>Use std::optional for nullable values</rule>
  <rule>Mark compile-time constants with constexpr</rule>
</safety>

<documentation>
  <requirement>Public APIs: Doxygen-style comments</requirement>
  <requirement>Explain non-obvious design choices</requirement>
  <requirement>Provide usage examples for complex interfaces</requirement>
</documentation>

<testing>
  <framework>GoogleTest</framework>
  <coverage>Cover normal, edge, and failure cases</coverage>
  <requirement>Keep tests fast and focused</requirement>
</testing>

<buildsystem>
  <system>Bazel is the sole build system</system>
  <requirement>Generate BUILD files automatically</requirement>
  <flags>-Wall -Wextra -Werror</flags>
  <requirement>Ensure WORKSPACE is up-to-date</requirement>
</buildsystem>

<reminder>All changes should be reviewed via a pull request. Use the `github` MCP server to create remote branches and open PRs.</reminder>

