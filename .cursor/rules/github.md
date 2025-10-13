---
name: GitHub Workflow Rules
languages: ["github", "git", "pr", "workflow"]
alwaysApply: false
---

# GitHub Workflow Rules

<mcpserver name="github" type="mcp-github">
  <capabilities>
    <capability>Create branches and push commits</capability>
    <capability>Open and manage pull requests</capability>
    <capability>Check PR status and CI results</capability>
    <capability>Automate GitHub workflow operations</capability>
  </capabilities>
  <tip>Use the `github` MCP server for all GitHub operations instead of manual git commands and web interface.</tip>
</mcpserver>

<workflowguidelines>
  <rule name="Branch creation" meaning="Always create new branches for changes" importance="Keeps main branch stable and enables parallel work" />
  <rule name="PR workflow" meaning="All changes must go through PRs" importance="Ensures code review and maintains quality" />
  <rule name="Small PRs" meaning="Keep changes focused and logical" importance="Easier to review and reduces merge conflicts" />
  <rule name="CI passing" meaning="All tests must pass before merge" importance="Maintains code quality and prevents regressions" />
</workflowguidelines>

<branchingstrategy>
  <defaultbranch>main</defaultbranch>
  <namingconventions>
    <convention type="feature" format="feature/&lt;short-description&gt;" />
    <convention type="fix" format="fix/&lt;short-description&gt;" />
    <convention type="chore" format="chore/&lt;short-description&gt;" />
    <convention type="refactor" format="refactor/&lt;short-description&gt;" />
  </namingconventions>
  <requirement>Branch names must be lowercase and use hyphens instead of spaces</requirement>
  <requirement>All feature/fix/chore/refactor branches must be created from main</requirement>
  <requirement>All pull requests must target main as the base branch</requirement>
</branchingstrategy>

<pullrequestrules>
  <rule name="Always use PRs" description="Always open a PR for changes — no direct commits to main" />
  <rule name="Base branch" description="All PRs must target main branch (not develop or other branches)" />
  <requiredelements>
    <element>Clear, descriptive title</element>
    <element>Concise but informative description</element>
    <element>At least one assigned reviewer</element>
    <element>Correct base branch (main)</element>
  </requiredelements>
  <qualitygates>
    <gate>CI build must pass</gate>
    <gate>All unit and integration tests must pass</gate>
    <gate>Lint/format checks must pass</gate>
  </qualitygates>
  <bestpractices>
    <practice>Keep PRs small and focused</practice>
    <practice>Use squash merging to maintain clean history</practice>
    <practice>Verify base branch is main before creating PR</practice>
  </bestpractices>
</pullrequestrules>

<tooling>
  <tool name="Branch creation" purpose="Create new feature/fix branches" usage="Starting new work" />
  <tool name="PR management" purpose="Open, update, and merge PRs" usage="Code review workflow" />
  <tool name="CI monitoring" purpose="Check build and test status" usage="Before merging" />
  <tool name="Automation" purpose="Streamline GitHub operations" usage="Reduce manual steps" />
</tooling>

<mcpservercommands>
  <command name="Create branch" syntax="github create-branch fix/memory-leak" description="Create a new branch from main" />
  <command name="Push and PR" syntax="github push-and-pr 'Fix memory leak in cache manager'" description="Push changes and open PR targeting main" />
  <command name="List PRs" syntax="github list-prs" description="Check PR status" />
  <command name="Merge PR" syntax="github merge-pr 45" description="Merge approved PR" />
  <command name="Check base branch" syntax="gh pr view --json baseRefName" description="Verify PR targets main" />
</mcpservercommands>

<automation>
  <feature>CI/CD runs automatically for all PRs</feature>
  <feature>Approved PRs can be merged by maintainers</feature>
  <feature>Use squash merging to keep history clean</feature>
  <feature>MCP server handles authentication and API calls</feature>
</automation>

<notesforcontinuedev>
  <permission>You are allowed to automate branch creation and PR submission using the github MCP server</permission>
  <requirement>If multiple PRs are required, ensure each is isolated to its own branch</requirement>
  <requirement>You may request human review before merging</requirement>
  <requirement>Use the MCP server for all GitHub operations to maintain consistency</requirement>
</notesforcontinuedev>

