# GitHub Create Milestone Command

You are creating a GitHub milestone (formerly "epic") for organizing related issues.

## ⚠️ Important: GitHub CLI Milestone Support

**The GitHub CLI does NOT have native milestone commands.** There is no `gh milestone create` command in the official `gh` CLI.

**Solution:** Use `gh api` to call the GitHub REST API directly:
- Endpoint: `POST /repos/{owner}/{repo}/milestones`
- Get owner/repo dynamically: `gh repo view --json owner,name`
- See execution section below for complete syntax

## Instructions

Follow this workflow strictly:

### 1. Gather Milestone Details

Ask the user for essential milestone information:

**Required Information:**
- Milestone title (concise, descriptive name)
- Goal/purpose (1-2 sentences describing what this milestone will accomplish)
- Due date (optional, format: YYYY-MM-DD)

**Context to Gather:**
- What value does this milestone deliver?
- What are the key deliverables?
- Any dependencies or constraints?
- Success criteria

### 2. Create Milestone Structure

Build the milestone description using this embedded template:

```markdown
## Milestone Goal

{{1-2 sentences describing what this milestone will accomplish and why it adds value}}

## Description

**Context:**
{{Brief background on why this milestone is needed}}

**Key Deliverables:**
- {{Deliverable 1}}
- {{Deliverable 2}}
- {{Deliverable 3}}

**Success Criteria:**
- {{Measurable outcome 1}}
- {{Measurable outcome 2}}
- {{Measurable outcome 3}}

## Scope

**Included:**
- {{What's in scope}}

**Excluded:**
- {{What's explicitly out of scope}}

## Dependencies

{{Any dependencies on other milestones, systems, or external factors}}

## Technical Notes

{{Any technical constraints, patterns to follow, or important context}}

## Flutter/Dart Considerations

{{If applicable, include:}}
- Widget testing requirements
- State management approach
- Package dependencies
- Platform-specific considerations (iOS/Android/Desktop/Web)
```

### 3. Preview & Get Approval

Present the complete milestone preview:

```
═══════════════════════════════════════
CREATE MILESTONE PREVIEW
═══════════════════════════════════════
Title: {{MILESTONE_TITLE}}
Due Date: {{DUE_DATE or "No due date"}}
Repository: {{repo name or "current repository"}}

───────────────────────────────────────
MILESTONE DESCRIPTION:
───────────────────────────────────────
{{Full description from template}}

───────────────────────────────────────
ACTIONS TO BE TAKEN:
───────────────────────────────────────
1. Create milestone in GitHub with above details
2. Milestone will be available for issue assignment

═══════════════════════════════════════
```

**Ask explicitly:** "Should I create this milestone?"

**STOP and wait for approval.** User can request:
- Changes to title or description
- Different due date
- More or less detail
- Manual creation instead

**IMPORTANT:** Do NOT proceed without explicit approval ("yes", "proceed", "go ahead", etc.)

### 4. Execute (Only After Approval)

Create the milestone using GitHub CLI API:

**IMPORTANT:** The `gh` CLI does not have a native `gh milestone create` command. Instead, use `gh api` to call the GitHub REST API.

**With due date:**
```bash
gh api \
  --method POST \
  -H "Accept: application/vnd.github.v3+json" \
  /repos/{owner}/{repo}/milestones \
  -f title='{{TITLE}}' \
  -f state='open' \
  -f description='{{DESCRIPTION}}' \
  -f due_on='{{YYYY-MM-DD}}T23:59:59Z'
```

**Without due date:**
```bash
gh api \
  --method POST \
  -H "Accept: application/vnd.github.v3+json" \
  /repos/{owner}/{repo}/milestones \
  -f title='{{TITLE}}' \
  -f state='open' \
  -f description='{{DESCRIPTION}}'
```

**To get owner/repo automatically from current directory:**
```bash
OWNER=$(gh repo view --json owner -q .owner.login)
REPO=$(gh repo view --json name -q .name)

gh api \
  --method POST \
  -H "Accept: application/vnd.github.v3+json" \
  /repos/$OWNER/$REPO/milestones \
  -f title='{{TITLE}}' \
  -f state='open' \
  -f description='{{DESCRIPTION}}'
```

**Error Handling:**
- If milestone creation fails: Stop and report error
- If milestone already exists (422 error): Ask if user wants to update it
- If not in git repo: Prompt user to specify owner and repo
- If authentication fails (401/403): Run `gh auth login`

### 5. Confirm Success

After successful creation (201 status code), parse the JSON response and display:

```
✅ Milestone Created Successfully

Milestone: {{TITLE}}
Number: {{number from JSON response}}
Due Date: {{DUE_DATE or "No due date"}}
URL: {{html_url from JSON response}}

Next Steps:
- Create issues: /gh-create-issue
- Assign issue to milestone: gh issue edit <issue-number> --milestone "{{TITLE}}"
- List milestone issues: gh issue list --search "milestone:\"{{TITLE}}\""
- View milestone via API: gh api /repos/{owner}/{repo}/milestones/{{number}}
```

**Note:** The GitHub API response includes fields like `number`, `html_url`, `state`, `title`, `description`, `created_at`, etc.

## Tool Preferences

- **Primary:** Use `gh api` for milestone operations (native `gh milestone` commands don't exist)
- **Alternative:** Use MCP GitHub tools if `gh api` approach is problematic
- **Reason:** `gh` CLI is lighter on tokens and context, even when using API endpoints

## Error Handling

**Not in a git repository:**
```
⚠️  Not in a git repository.
Please navigate to your repository or manually specify owner/repo in the API call:
Example: gh api --method POST /repos/macjunkins/project/milestones -f title='...'
```

**Milestone already exists (422 Validation Failed):**
```
❌ Milestone "{{TITLE}}" already exists.

Options:
1. Use a different title
2. Update existing milestone via PATCH: gh api --method PATCH /repos/{owner}/{repo}/milestones/{number} -f description='...'
3. View existing: gh api /repos/{owner}/{repo}/milestones
```

**GitHub authentication failure (401/403):**
```
❌ GitHub CLI authentication failed.
Run: gh auth login
Then retry this command.

Note: Requires fine-grained token with "Issues" or "Pull requests" write permissions.
```

**Invalid due date format:**
```
❌ Invalid due date format.
Use: YYYY-MM-DDTHH:MM:SSZ (ISO 8601 format)
Example: 2025-12-31T23:59:59Z
```

**404 Not Found:**
```
❌ Repository not found or no access.
Check:
1. Repository owner and name are correct
2. You have access to the repository
3. gh auth status shows correct authentication
```

## Template Customization

The embedded template can be adapted based on:

**For brownfield enhancements:**
- Emphasize existing system integration
- Document compatibility requirements
- Include rollback considerations

**For greenfield projects:**
- Focus on architecture decisions
- Emphasize design patterns
- Include technology selection rationale

**For Flutter/Dart projects:**
- Widget architecture
- State management approach
- Platform targets (iOS, Android, Web, Desktop)
- Package ecosystem considerations

## Notes

- The `gh` CLI does **not** have native milestone commands (no `gh milestone create`)
- Use `gh api` to interact with the GitHub Milestones REST API
- The `gh repo view` command can extract owner/repo from git context
- This command works globally across any git repository
- Milestones organize related issues (formerly called "epics")
- GitHub labels can further categorize issues within milestones
- API responses return JSON with fields: `number`, `html_url`, `state`, `title`, `description`, etc.

## Philosophy

**Milestones as organizing containers:**
- Group related issues that deliver cohesive value
- Track progress toward a specific goal
- Provide timeline visibility with due dates
- Enable filtering and reporting
- Maintain flexibility - issues can be added/removed as needed

## Usage Examples

**Example 1 - Standard workflow:**
```
User: /gh-create-milestone
Assistant: I'll help you create a milestone. What's the milestone title?
User: User Authentication System
Assistant: Great! What's the goal/purpose of this milestone?
User: Implement secure user login and registration
Assistant: [Asks for due date, gathers more context]
Assistant: [Presents preview]
User: yes
Assistant: [Creates milestone via gh CLI]
Assistant: ✅ Milestone Created Successfully...
```

**Example 2 - Flutter project:**
```
User: /gh-create-milestone
Assistant: [Gathers details]
User: Mobile Dashboard UI
Assistant: [Builds description with Flutter/Dart section populated]
- Widget testing requirements
- State management: Riverpod
- Platforms: iOS and Android
[Shows preview]
```

**Example 3 - Brownfield enhancement:**
```
User: /gh-create-milestone
User: Payment Processing Integration
Assistant: [Template emphasizes]:
- Existing system integration points
- Compatibility with current checkout flow
- Rollback considerations
- Risk mitigation
```

**Example 4 - Different repository:**
```
User: /gh-create-milestone (for macjunkins/other-repo)
Assistant: [Same workflow but uses explicit owner/repo in API path: /repos/macjunkins/other-repo/milestones]
```

**Example 5 - User modifies description:**
```
User: /gh-create-milestone
Assistant: [shows preview]
User: Add more detail about the API integration
Assistant: [updates description, shows new preview]
User: perfect, create it
Assistant: [creates milestone]
```
