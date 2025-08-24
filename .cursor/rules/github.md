---
name: GitHub Workflow Rules
languages: ["github", "git", "pr", "workflow"]
alwaysApply: false
---

# GitHub Workflow Rules

## MCP Server
- **Name:** `github` (see `~/.cursor/mcp.json` → `github`)
- **Type:** `mcp-github`
- **Capabilities:**
  - Create branches and push commits
  - Open and manage pull requests
  - Check PR status and CI results
  - Automate GitHub workflow operations

> **Tip:** Use the `github` MCP server for all GitHub operations instead of manual git commands and web interface.

## Workflow Guidelines
| Rule     | What it means                       | Why it matters                           |
|----------|-------------------------------------|-------------------------------------------|
| Branch creation | Always create new branches for changes | Keeps main branch stable and enables parallel work |
| PR workflow | All changes must go through PRs | Ensures code review and maintains quality |
| Small PRs | Keep changes focused and logical | Easier to review and reduces merge conflicts |
| CI passing | All tests must pass before merge | Maintains code quality and prevents regressions |

## Branching Strategy
- **Default branch:** `mn_main`
- **Branch naming conventions:**
  - `feature/<short-description>` for new features
  - `fix/<short-description>` for bug fixes
  - `chore/<short-description>` for maintenance
  - `refactor/<short-description>` for refactoring
- Branch names must be lowercase and use hyphens instead of spaces

## Pull Request Rules
1. **Always** open a PR for changes — no direct commits to `mn_main`
2. **Required elements:**
   - Clear, descriptive title
   - Concise but informative description
   - At least one assigned reviewer
3. **Quality gates:**
   - CI build must pass
   - All unit and integration tests must pass
   - Lint/format checks must pass
4. **Best practices:**
   - Keep PRs small and focused
   - Use squash merging to maintain clean history

## Tooling
| Feature | What it does | When to use |
|---------|--------------|-------------|
| Branch creation | Create new feature/fix branches | Starting new work |
| PR management | Open, update, and merge PRs | Code review workflow |
| CI monitoring | Check build and test status | Before merging |
| Automation | Streamline GitHub operations | Reduce manual steps |

## Working with the MCP Server
```bash
# Create a new branch
github create-branch fix/memory-leak

# Push changes and open PR
github push-and-pr "Fix memory leak in cache manager"

# Check PR status
github list-prs

# Merge approved PR
github merge-pr 45
```

## Automation
- CI/CD runs automatically for all PRs
- Approved PRs can be merged by maintainers
- Use **squash merging** to keep history clean
- MCP server handles authentication and API calls

## Notes for Continue.dev
- You are allowed to automate branch creation and PR submission using the `github` MCP server
- If multiple PRs are required, ensure each is isolated to its own branch
- You may request human review before merging
- Use the MCP server for all GitHub operations to maintain consistency

