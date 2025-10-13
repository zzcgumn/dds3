---
name: Git Commands
languages: ["git"]
alwaysApply: false
---

# Git Commands (MCP‑Integrated)

<mcpserver name="git" type="git-mcp">
  <capabilities>
    <capability>Commit & push changes</capability>
    <capability>Inspect current branch, repo, and owner</capability>
    <capability>Compare changes against a base branch</capability>
  </capabilities>
  <tip>Use the `git` MCP server for all low‑level Git operations instead of shell commands.</tip>
</mcpserver>

<commonoperations>
  <operation name="Commit" mcpcommand="git commit" example="git commit -m 'Add new helper'" />
  <operation name="Push" mcpcommand="git push" example="git push origin <branch>" />
  <operation name="Branch status" mcpcommand="git branch" example="git branch --show-current" />
  <operation name="Repo info" mcpcommand="git repo" example="git repo --owner" />
  <operation name="Diff vs base" mcpcommand="git diff" example="git diff main" />
</commonoperations>

<tip>Use the `git` MCP server's JSON‑based API. For example, to create a commit you can send:</tip>

<jsonapi>
```json
{
  "name": "git_commit",
  "arguments": {
    "message": "Add new helper"
  }
}
```
</jsonapi>

<workflowintegration>
  <step name="Create a branch" description="See github.md for naming conventions" />
  <step name="Make changes" description="Make changes locally" />
  <step name="Commit" description="Commit with a clear message" />
  <step name="Push" description="Push the branch" />
  <step name="Open a PR" description="Open PR via the github MCP server (see github.md)" />
</workflowintegration>

<note>All Git operations should be performed through the `git` MCP server to keep the environment consistent and to allow Continue.dev to track changes automatically.</note>

