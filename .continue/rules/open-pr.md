
---
name: Open Pull Request
alwaysApply: false
---

# Open Pull Request

Use the `github` MCP server to open a pull request for the current branch.

## Instructions

1. **Analyze the current branch** to understand what changes have been made
2. **Generate an appropriate PR title** based on the branch name and changes:
   - For `feature/` branches: "Add [feature description]" or "Implement [feature description]"
   - For `fix/` branches: "Fix [issue description]" or "Resolve [issue description]"  
   - For `chore/` branches: "Update [component]" or "Maintain [area]"
   - For `refactor/` branches: "Refactor [component]" or "Restructure [area]"
   - Prefix with `[AUTO-PR]` as configured in the MCP server

3. **Create a detailed PR description** that includes:
   - **Summary**: Brief overview of what was changed and why
   - **Changes**: Bulleted list of specific modifications
   - **Testing**: How the changes were tested (if applicable)
   - **Notes**: Any additional context, dependencies, or considerations

4. **Set the base branch** to `mn_main`

5. **Open the pull request** using the github MCP server

## Example Usage
```
Use this prompt when you're ready to submit your current branch for review.
The PR will be created with an appropriate title and comprehensive description.
```

## Requirements
- Current branch must have commits to push
- Changes should be committed and ready for review
- Follow the project's GitHub workflow rules
