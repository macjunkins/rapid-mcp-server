# GitHub Issue Workflow Command

You are working on a GitHub issue using the standardized investigate → plan → execute workflow.

## Instructions

Follow this workflow strictly:

### 1. Investigate
- Use `gh issue view {{arg1}} --json title,body,labels,milestone,state,number,assignees` to fetch issue details
- If the command fails with "not a git repository", ask the user to specify the repo: `gh issue view {{arg1}} -R owner/repo --json ...`
- Present a clear summary of the issue including:
  - Title and number
  - Current state (open/closed)
  - Labels and milestone (if any)
  - Full description/body
  - Key tasks or requirements

### 2. Analyze
- Review the issue body and identify all tasks
- Note any dependencies on other issues
- Identify success criteria
- Check current state of codebase related to the issue

### 3. Plan
Break down the work into specific, actionable steps including:
- Investigation/research (if needed)
- Implementation
- Testing
- Documentation updates
- Any other requirements from the issue

**IMPORTANT - Planning Mode Detection:**
- **If in Planning Mode:** Use the `ExitPlanMode` tool to present the plan
  - Format plan as markdown with clear sections
  - Do NOT use TodoWrite in planning mode
  - Let user exit planning mode to begin execution
- **If in Normal Mode:** Use the `TodoWrite` tool to create the implementation plan
  - Continue to step 4 (Present & Get Approval)

### 4. Present & Get Approval (Normal Mode Only)
- Show the complete plan to the user
- Explicitly ask: **"Should I proceed with implementation?"**
- Wait for explicit approval ("yes", "proceed", "go ahead", etc.)
- If user says "no" or asks for changes, adjust the plan

### 5. Execute (Normal Mode Only)
- **ONLY after receiving approval**, begin implementation
- Work through each todo item systematically
- Mark todos as in_progress when starting, completed when done
- Follow all approval checkpoints from CLAUDE.md (commits, PRs, etc.)

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations (issues, PRs, etc.)
- **Fallback:** Only use MCP GitHub tools if `gh` CLI cannot accomplish the task
- **Reason:** `gh` CLI is lighter on tokens and context

## Notes

- The `gh` CLI automatically infers repository from git context
- This command works globally across any git repository
- If not in a git repo, the user can specify: `/gh-work 6 -R owner/repo`

## Usage Examples

**Normal mode (full workflow):**
```
/gh-work 6
```
→ Investigates issue #6, creates todo list, asks approval, then executes

**Planning mode (plan only):**
```
[User enables planning mode first]
/gh-work 6
```
→ Investigates issue #6, creates plan, uses ExitPlanMode to present plan
→ User reviews plan and exits planning mode to execute later
