# GitHub Review Issue Command

You are reviewing and potentially updating an existing GitHub issue.

## Instructions

Follow this workflow strictly:

### 1. Fetch Issue Details

**If issue number is provided as argument:**
- Use `{{arg1}}` as the issue number

**If no argument provided:**
- Ask user for the issue number to review

Fetch complete issue details:

```bash
gh issue view {{ISSUE_NUMBER}} --json number,title,body,state,labels,milestone,assignees,comments,createdAt,updatedAt
```

**Error Handling:**
- If issue not found: Verify issue number and repository
- If not in git repo: Ask user to specify repo with `-R owner/repo`

### 2. Present Current Issue State

Display the full issue details for review:

```
═══════════════════════════════════════
ISSUE REVIEW
═══════════════════════════════════════
Issue: #{{NUMBER}} - {{TITLE}}
State: {{OPEN/CLOSED}}
Created: {{CREATED_DATE}}
Last Updated: {{UPDATED_DATE}}

Labels: {{LABELS or "None"}}
Milestone: {{MILESTONE or "None"}}
Assignees: {{ASSIGNEES or "None"}}

───────────────────────────────────────
ISSUE BODY:
───────────────────────────────────────
{{FULL_BODY}}

───────────────────────────────────────
RECENT ACTIVITY:
───────────────────────────────────────
{{Show last 2-3 comments if any, or "No comments"}}

═══════════════════════════════════════
```

### 3. Review Checklist

Present a review checklist to guide the user:

```
REVIEW CHECKLIST:

Title:
  [ ] Clear and specific
  [ ] Accurately describes the issue
  [ ] Follows project conventions

Content:
  [ ] Problem/goal is well-defined
  [ ] Acceptance criteria are clear and testable
  [ ] Technical context is sufficient
  [ ] Dependencies are identified
  [ ] Success criteria are measurable

Metadata:
  [ ] Appropriate labels applied
  [ ] Assigned to correct milestone
  [ ] Assigned to appropriate person (if applicable)
  [ ] Priority is indicated (via labels or description)

Completeness:
  [ ] All necessary information is present
  [ ] No ambiguities or unclear requirements
  [ ] Ready for implementation (if applicable)

What would you like to review or update?
Options:
1. Title
2. Body/description
3. Labels
4. Milestone
5. Assignees
6. Add a comment
7. Close issue
8. No changes needed
```

**STOP and wait for user input.**

### 4. Gather Update Details

Based on user's selection, gather the necessary information:

**For Title Updates:**
- Ask for new title
- Preview the change

**For Body Updates:**
- Ask what sections need updating
- Options:
  - Add missing acceptance criteria
  - Clarify technical requirements
  - Add context or dependencies
  - Update success criteria
  - Restructure for clarity
- Show before/after preview

**For Label Updates:**
- Show current labels
- Ask which to add or remove
- Remind about standard GitHub labels only

**For Milestone Updates:**
- List available milestones
- Ask which to assign to (or remove)

**For Assignee Updates:**
- Ask who to assign to
- Option to assign to self: `@me`

**For Comments:**
- Ask for comment text
- Use for status updates, questions, or clarifications

**For Closing:**
- Confirm reason for closing
- Ensure issue is actually complete or no longer needed

### 5. Preview Changes

Show a clear before/after preview:

```
═══════════════════════════════════════
UPDATE PREVIEW
═══════════════════════════════════════
Issue: #{{NUMBER}}

{{For each change type, show:}}

───────────────────────────────────────
CHANGE: {{TITLE/BODY/LABELS/etc}}
───────────────────────────────────────
Before: {{CURRENT_VALUE}}
After:  {{NEW_VALUE}}

───────────────────────────────────────
ACTIONS TO BE TAKEN:
───────────────────────────────────────
1. {{Action 1 - e.g., "Update issue title"}}
2. {{Action 2 - e.g., "Add labels: enhancement"}}
3. {{Action 3 - e.g., "Add comment with clarification"}}

═══════════════════════════════════════
```

**Ask explicitly:** "Should I apply these changes?"

**STOP and wait for approval.** User can request:
- Modifications to the changes
- Different approach
- Additional changes
- Cancel updates

**IMPORTANT:** Do NOT proceed without explicit approval ("yes", "proceed", "go ahead", etc.)

### 6. Execute (Only After Approval)

Apply the changes using appropriate `gh` commands:

**Update title:**
```bash
gh issue edit {{NUMBER}} --title "{{NEW_TITLE}}"
```

**Update body:**
```bash
gh issue edit {{NUMBER}} --body "$(cat <<'EOF'
{{NEW_BODY}}
EOF
)"
```

**Add labels:**
```bash
gh issue edit {{NUMBER}} --add-label "{{LABEL1}},{{LABEL2}}"
```

**Remove labels:**
```bash
gh issue edit {{NUMBER}} --remove-label "{{LABEL1}},{{LABEL2}}"
```

**Change milestone:**
```bash
gh issue edit {{NUMBER}} --milestone "{{MILESTONE}}"
```

**Remove from milestone:**
```bash
gh issue edit {{NUMBER}} --milestone ""
```

**Add assignee:**
```bash
gh issue edit {{NUMBER}} --add-assignee "{{USERNAME}}"
```

**Add comment:**
```bash
gh issue comment {{NUMBER}} --body "$(cat <<'EOF'
{{COMMENT_TEXT}}
EOF
)"
```

**Close issue:**
```bash
gh issue close {{NUMBER}} --reason "{{completed/not planned}}"
```

**Error Handling:**
- If update fails: Stop and report error
- If milestone doesn't exist: Ask if user wants to create it
- If label doesn't exist: Warn and proceed without that label

### 7. Confirm Success

After successful updates, display:

```
✅ Issue Updated Successfully

Issue: #{{NUMBER}} - {{TITLE}}
State: {{STATE}}
URL: https://github.com/{{owner}}/{{repo}}/issues/{{number}}

Changes Applied:
{{List each change made}}

Next Steps:
- View updated issue: gh issue view {{NUMBER}}
- Continue review: /gh-review-issue {{NUMBER}}
- Start work: /gh-work {{NUMBER}}
- Validate readiness: /gh-validate-issue {{NUMBER}}
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
Example: /gh-review-issue 42 -R macjunkins/project
```

**Issue not found:**
```
❌ Issue #{{NUMBER}} not found.

Verify:
- Issue number is correct
- You have access to this repository
- Repository name if using -R flag
```

**Issue already closed:**
```
ℹ️  Issue #{{NUMBER}} is CLOSED.

You can still review and update closed issues if needed.
Should I proceed with the review?
```

**GitHub authentication failure:**
```
❌ GitHub CLI authentication failed.
Run: gh auth login
Then retry this command.
```

## Review Best Practices

**What makes a good issue:**

**Clear Title:**
- Specific and actionable
- Describes what, not how
- Follows conventions (e.g., "feat:", "fix:", "docs:")

**Well-Defined Problem/Goal:**
- Context explains why this is needed
- Problem is clearly articulated
- Value is evident

**Testable Acceptance Criteria:**
- Concrete and measurable
- Uses checkboxes for tracking
- Covers both functional and quality requirements

**Sufficient Technical Context:**
- Relevant files/components identified
- Constraints and dependencies noted
- Implementation hints (without prescribing solution)

**Appropriate Metadata:**
- Labels reflect type and priority
- Milestone groups related work
- Assignee is clear (or unassigned if open)

## Common Review Actions

**Clarify Requirements:**
- Add missing acceptance criteria
- Specify edge cases
- Define success metrics

**Add Context:**
- Link to related issues
- Reference relevant documentation
- Note dependencies

**Improve Organization:**
- Break complex issue into smaller ones
- Restructure for clarity
- Add checklists for tracking

**Update Metadata:**
- Correct labels
- Assign to milestone
- Set priority

**Add Comments:**
- Answer questions
- Provide updates
- Document decisions

## Notes

- The `gh` CLI automatically infers repository from git context
- This command works globally across any git repository
- Reviews help maintain issue quality and clarity
- Regular review prevents issues from becoming stale
- If not in a git repo, specify: `-R owner/repo`

## Philosophy

**Issues as living documents:**
- Issues evolve as understanding improves
- Reviews catch ambiguities early
- Updates keep issues actionable
- Comments preserve decision history
- Well-maintained issues reduce implementation friction

## Usage Examples

**Example 1 - Clarify requirements:**
```
User: /gh-review-issue 42
Assistant: [Shows current issue state]
REVIEW CHECKLIST:
[Presents checklist]

User: The acceptance criteria are too vague
Assistant: What should we add or clarify?
User: Add specific validation rules for the email field
Assistant: [Shows preview with updated acceptance criteria]
User: yes
Assistant: ✅ Issue Updated Successfully
Changes Applied:
- Updated body with specific email validation criteria
```

**Example 2 - Update metadata:**
```
User: /gh-review-issue 18
Assistant: [Shows issue review]
User: This should be in the "Phase 2" milestone
Assistant: [Shows preview]
Before: Milestone: None
After:  Milestone: Phase 2
User: proceed
Assistant: ✅ Issue Updated Successfully
```

**Example 3 - Add comment:**
```
User: /gh-review-issue 7
Assistant: [Shows issue]
User: Add a comment
Assistant: What would you like to say?
User: Discovered this depends on completing #5 first
Assistant: [Previews comment]
User: yes
Assistant: ✅ Comment Added Successfully
```

**Example 4 - Break into smaller issues:**
```
User: /gh-review-issue 33
Assistant: [Shows large complex issue]
User: This is too big, needs to be broken up
Assistant: This issue has 8 acceptance criteria. Should we:
1. Update this issue to be an epic/milestone
2. Create separate issues for each major requirement
3. Both - create milestone and split into issues

User: Option 3
Assistant: Let me help you create a milestone and split this...
[Guides through /gh-create-milestone and /create-issue]
```

**Example 5 - Close as not planned:**
```
User: /gh-review-issue 15
Assistant: [Shows issue]
User: Close this, we're not doing it
Assistant: Should I close with reason "not planned" or "completed"?
User: not planned
Assistant: [Closes issue]
✅ Issue #15 Closed (not planned)
```

**Example 6 - Different repository:**
```
User: /gh-review-issue 99 -R macjunkins/other-repo
Assistant: [Same workflow but uses -R flag for all gh commands]
```
