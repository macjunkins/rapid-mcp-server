# GitHub Create Next Issue Command

You are creating the next sequential GitHub issue within a milestone.

## Instructions

Follow this workflow strictly:

### 1. Identify Target Milestone

**If milestone is provided as argument:**
- Use `{{arg1}}` as the milestone name

**If no argument provided:**
- List available milestones: `gh api repos/{owner}/{repo}/milestones --jq '.[].title'`
- Ask user which milestone to add the issue to

### 2. Gather Milestone Context

Fetch milestone details and existing issues:

```bash
# Get milestone details by title (requires filtering)
gh api repos/{owner}/{repo}/milestones --jq '.[] | select(.title == "{{MILESTONE}}")' 

# Get issues for specific milestone number
gh issue list --milestone "{{MILESTONE}}" --json number,title,state
```

**Note:** Since GitHub CLI doesn't have native milestone commands, we use the API directly. The milestone title can be used with `gh issue list --milestone` but milestone details require API calls.

**Analyze the milestone:**
- What is the milestone goal?
- What issues already exist?
- What's the logical next issue in the sequence?
- What gaps exist in the milestone's coverage?

### 3. Prompt for Issue Details

Based on the milestone context, guide the user:

```
I found milestone "{{MILESTONE}}" with {{N}} existing issues.

Current issues:
{{List existing issue titles}}

What should the next issue be? Please provide:
- What needs to be done?
- How does it build on or complement existing issues?
- Any specific requirements or constraints?
```

**STOP and wait for user input.**

### 4. Build Next Issue

Create issue body using the standard template, informed by milestone context:

```markdown
## Description

{{What needs to be done - from user input}}

## Context

**Milestone:** {{MILESTONE}}

**Related Issues:**
{{List related issues from milestone that this builds on or depends on}}

**Milestone Progress:**
{{X of Y issues complete}}

## Acceptance Criteria

- [ ] {{Criterion 1 from user input}}
- [ ] {{Criterion 2 from user input}}
- [ ] {{Criterion 3 from user input}}

## Technical Notes

{{Technical approach, constraints, or patterns to follow}}

## Dependencies

{{If this issue depends on other issues in the milestone}}
- Depends on #{{NUMBER}} - {{TITLE}}

{{If this issue blocks other work}}
- Blocks future work on: {{DESCRIPTION}}

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Code follows project standards
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No regression in existing functionality
- [ ] Milestone progress updated
```

### 5. Preview & Get Approval

Present the complete issue preview:

```
═══════════════════════════════════════
CREATE NEXT ISSUE PREVIEW
═══════════════════════════════════════
Title: {{ISSUE_TITLE}}
Milestone: {{MILESTONE}}
Labels: {{SUGGESTED_LABELS}}
Repository: {{repo name or "current repository"}}

───────────────────────────────────────
MILESTONE CONTEXT:
───────────────────────────────────────
Goal: {{MILESTONE_DESCRIPTION}}
Due: {{DUE_DATE or "No due date"}}
Progress: {{X}}/{{Y}} issues complete

───────────────────────────────────────
ISSUE BODY:
───────────────────────────────────────
{{Full issue body from template}}

───────────────────────────────────────
ACTIONS TO BE TAKEN:
───────────────────────────────────────
1. Create GitHub issue with above details
2. Assign to milestone: {{MILESTONE}}
3. Apply labels: {{LABELS}}

═══════════════════════════════════════
```

**Ask explicitly:** "Should I create this issue?"

**STOP and wait for approval.** User can request:
- Changes to title or description
- Different acceptance criteria
- More or less detail
- Different labels
- Manual creation instead

**IMPORTANT:** Do NOT proceed without explicit approval ("yes", "proceed", "go ahead", etc.)

### 6. Execute (Only After Approval)

Create the issue using GitHub CLI:

```bash
gh issue create \
  --title "{{TITLE}}" \
  --milestone "{{MILESTONE}}" \
  --label "{{LABELS}}" \
  --body "$(cat <<'EOF'
{{ISSUE_BODY}}
EOF
)"
```

**Error Handling:**
- If milestone doesn't exist: Report error and suggest creating it first
- If issue creation fails: Stop and report error
- If not in git repo: Prompt for `-R owner/repo` flag

### 7. Confirm Success

After successful creation, display:

```
✅ Issue Created Successfully

Issue: #{{NUMBER}} - {{TITLE}}
Milestone: {{MILESTONE}} ({{X+1}}/{{Y}} issues complete)
Labels: {{LABELS}}
URL: https://github.com/{{owner}}/{{repo}}/issues/{{number}}

Milestone Progress:
{{Progress bar or percentage}}

Next Steps:
- Create another: /gh-next-issue {{MILESTONE}}
- Start work: /gh-work {{NUMBER}}
- View milestone: gh api repos/{owner}/{repo}/milestones --jq '.[] | select(.title == "{{MILESTONE}}")'
- Update progress: /gh-update-issue {{NUMBER}}
```

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations
- **Fallback:** Only use MCP GitHub tools if `gh` CLI cannot accomplish the task
- **Reason:** `gh` CLI is lighter on tokens and context

## Error Handling

**Not in a git repository:**
```
⚠️  Not in a git repository.
Please navigate to your repository or specify: -R owner/repo
Example: /gh-next-issue "Milestone Name" -R macjunkins/project
```

**Milestone doesn't exist:**
```
❌ Milestone "{{MILESTONE}}" not found.

Available milestones:
{{List from gh api repos/{owner}/{repo}/milestones --jq '.[].title'}}

Options:
1. Create milestone first: /gh-create-milestone
2. Use different milestone name
3. Create issue without milestone: /create-issue
```

**No milestones in repository:**
```
⚠️  No milestones found in this repository.

Would you like to:
1. Create a milestone first: /gh-create-milestone
2. Create a standalone issue: /create-issue
```

**GitHub authentication failure:**
```
❌ GitHub CLI authentication failed.
Run: gh auth login
Then retry this command.
```

## Issue Numbering and Sequencing

This command helps create **logically sequential** issues, not necessarily numerically sequential:

**Logical Sequence Examples:**

**For a "User Authentication" milestone:**
1. Set up authentication framework
2. Implement user registration
3. Implement login flow
4. Add password reset
5. Add session management

**For a "Dashboard UI" milestone:**
1. Create dashboard layout
2. Implement data fetching
3. Add chart components
4. Add filters and controls
5. Add export functionality

The command analyzes existing issues and suggests what would logically come next.

## Notes

- The `gh` CLI automatically infers repository from git context
- This command works globally across any git repository
- Issues are created within a milestone context
- The command helps maintain logical progression of work
- If not in a git repo, specify: `-R owner/repo`

## Philosophy

**Milestones as incremental delivery:**
- Each issue builds toward the milestone goal
- Issues should have logical dependencies and sequencing
- Progress is tracked incrementally
- The "next" issue should advance the milestone meaningfully
- Context from existing issues informs new issue creation

## Usage Examples

**Example 1 - With milestone argument:**
```
User: /gh-next-issue "User Authentication"
Assistant: I found milestone "User Authentication" with 3 existing issues.

Current issues:
- #12 Set up authentication framework ✅
- #13 Implement user registration ✅
- #14 Implement login flow (open)

What should the next issue be?
User: Add password reset functionality
Assistant: [Gathers acceptance criteria]
Assistant: [Presents preview showing dependency on #14]
User: yes
Assistant: ✅ Issue Created Successfully - #15
```

**Example 2 - No argument provided:**
```
User: /gh-next-issue
Assistant: Available milestones:
1. User Authentication (3/5 issues complete)
2. Dashboard UI (1/4 issues complete)
3. Payment Integration (0/3 issues complete)

Which milestone?
User: Dashboard UI
Assistant: [Continues with milestone context...]
```

**Example 3 - First issue in milestone:**
```
User: /gh-next-issue "New Feature X"
Assistant: Milestone "New Feature X" has no issues yet.

This will be the first issue. What should it be?
User: Research and spike for Feature X
Assistant: [Creates foundational/research issue]
```

**Example 4 - Milestone complete:**
```
User: /gh-next-issue "Sprint 1"
Assistant: Milestone "Sprint 1" shows 5/5 issues complete.

This milestone appears to be complete. Would you like to:
1. Add an additional issue anyway
2. Create a new milestone: /gh-create-milestone
3. Close this milestone: gh api repos/{owner}/{repo}/milestones/{{MILESTONE_NUMBER}} -X PATCH -f state=closed
```

**Example 5 - Different repository:**
```
User: /gh-next-issue "Milestone Name" -R macjunkins/other-repo
Assistant: [Same workflow but uses -R flag for all gh commands]
```

## Integration with Workflow

This command fits into the larger GitHub workflow:

1. **Create milestone:** `/gh-create-milestone`
2. **Create first issue:** `/gh-next-issue "Milestone Name"` ← Creates foundational issue
3. **Create subsequent issues:** `/gh-next-issue "Milestone Name"` ← This command
4. **Work on issue:** `/gh-work <number>`
5. **Update progress:** `/gh-update-issue <number>`
6. **Complete work:** `/gh-finish <number>`
7. **Repeat steps 3-6** until milestone complete
8. **Close milestone** when all issues done
