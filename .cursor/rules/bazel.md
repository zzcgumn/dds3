---
name: Bazel Build System Rules (MCP-Integrated)
languages: ["bazel", "starlark", "build", "bazelbuild"]
alwaysApply: false
---

# Bazel Build System Rules (MCP-Integrated)

<mcpserver name="bazel" type="mcp-bazel">
  <capabilities>
    <capability>Parse & validate BUILD/.bzl files</capability>
    <capability>Build graph analysis</capability>
    <capability>Target query & navigation</capability>
    <capability>Auto-generate build commands</capability>
  </capabilities>
  <tip>Whenever you edit a BUILD or .bzl file, run a `bazel` MCP command first to catch syntax or dependency issues.</tip>
</mcpserver>

<buildguidelines>
  <rule name="Explicit deps" meaning="List every dependency in `deps = [...]`" importance="Prevents hidden transitive pulls" />
  <rule name="No wildcards" meaning="Avoid `glob([...])` unless absolutely needed" importance="Keeps target graph deterministic" />
  <rule name="Target naming" meaning="`<component>_<purpose>_<type>`" importance="Easier to read & search" />
  <rule name="Idiomatic Starlark" meaning="Prefer built-in rules over custom macros" importance="Reduces maintenance" />
  <rule name="Consistent formatting" meaning="Follow `.bazelrc` & `.bzlformat`" importance="Keeps codebase uniform" />
</buildguidelines>

<bestpractices>
  <practice>Use `cc_library`, `cc_binary`, `cc_test` for C++ targets</practice>
  <practice>Keep test suites small & fast</practice>
  <practice>Restrict visibility (`visibility = ["//visibility:private"]`) when appropriate</practice>
  <practice>Run `bazel build //...` & `bazel test //...` locally before pushing</practice>
  <practice>Document any non-trivial macros or build logic in comments</practice>
</bestpractices>

<mcpservercommands>
  <command name="Validate BUILD file" syntax="bazel validate //path/to:BUILD" description="Validate a BUILD file" />
  <command name="Query dependencies" syntax="bazel deps //my:target" description="Query dependencies of a target" />
  <command name="Build target" syntax="bazel build //my:target" description="Generate a build command for a target" />
</mcpservercommands>



