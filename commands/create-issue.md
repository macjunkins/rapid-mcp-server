# GitHub Create Issue Command

You are creating a new GitHub issue ONLY. Your job is to gather information, investigate context, and create a well-documented issue. **DO NOT implement solutions or write code.**

## Instructions

Follow this workflow strictly:

### 1. Acknowledge and Prompt for Input

When this command is invoked, respond with:

```
I'll help you create a GitHub issue. Please describe the problem or feature request in your own words:
- What needs to be done?
- Why is it needed?
- Any relevant context or details?
```

**STOP and wait for user response.** Do NOT proceed until user provides their description.

### 2. Parse Problem Statement

Once user provides their prose description, analyze it to identify:
- **Issue type:** bug, feature, enhancement, documentation, chore, question
- **Key components/files** mentioned or implied
- **Related features** or systems
- **Severity indicators** (critical, blocking, minor, etc.)
- **Repository context** (are we in a git repo? which one?)

### 3. Investigate Context

Use the Task tool with `subagent_type=Explore` to gather relevant context:

**For Bugs:**
- Find related code files and functions
- Check recent changes to affected areas (`git log --oneline -10 -- <file>`)
- Look for similar existing issues (`gh issue list --search "keywords"`)
- Identify error handling and test coverage

**For Features/Enhancements:**
- Locate related existing functionality
- Check architecture patterns in the codebase
- Review similar implementations
- Identify dependencies and affected components

**For Documentation:**
- Find existing documentation structure
- Locate related code that needs documenting
- Check documentation standards/patterns

**Investigation should answer:**
- Where does this affect the codebase?
- What components are involved?
- Are there similar issues or patterns?
- What's the current state of related code?

**CRITICAL:** Investigation is for gathering context to enrich the issue body, NOT for starting implementation. Do NOT use Edit, Write, or NotebookEdit tools.

### 4. Build Issue Body

Select appropriate template based on issue type and populate with investigation findings:

**Bug Report Structure:**
```markdown
## Description
[Clear description of the bug from user's prose]

## Current Behavior
[What's happening now - from investigation and user description]

## Expected Behavior
[What should happen - from user's statement]

## Affected Components
- [File/module from investigation]
- [File/module from investigation]

## Steps to Reproduce
[If provided by user, otherwise:]
_To be determined during investigation_

## Context
- **Related files:** [list from investigation]
- **Recent changes:** [relevant commits if found]
- **Similar issues:** [links if found]

## Additional Notes
[Any other findings from investigation]
```

**Feature Request Structure:**
```markdown
## Description
[Clear description from user's prose]

## Motivation
[Why is this needed - from user's statement]

## Current State
[Findings from codebase investigation]

## Proposed Solution
[User's ideas if provided, otherwise:]
_To be determined during planning_

## Affected Components
- [File/module that would need changes]
- [File/module that would need changes]

## Similar Implementations
[Examples found in codebase, or "None found"]

## Success Criteria
- [ ] [Criterion from user description or investigation]
- [ ] [Criterion from user description or investigation]

## Additional Context
[Investigation findings]
```

**Documentation Template:**
```markdown
## Description
[What needs documenting]

## Current State
[Existing documentation structure from investigation]

## Affected Components
- [Code/files that need documentation]
- [Code/files that need documentation]

## Documentation Needs
- [ ] [Item from user description]
- [ ] [Item from investigation]

## References
[Related docs or examples found in codebase]
```

**General/Chore Template:**
```markdown
## Description
[What needs to be done]

## Context
[Why this is needed - from user's statement]

## Affected Components
- [Relevant files/modules]
- [Relevant files/modules]

## Implementation Notes
[Findings from investigation that would help implementation]

## Success Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
```

### 5. Infer Labels and Metadata

**IMPORTANT:** Only use standard GitHub labels. Never suggest custom labels. If custom labels are needed for a specific project, they should be configured in that project's `CLAUDE.md` file.

**Standard GitHub Labels Available:**
- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements or additions to documentation
- `duplicate` - This issue or pull request already exists
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `invalid` - This doesn't seem right
- `question` - Further information is requested
- `wontfix` - This will not be worked on

**Labels from keywords (use standard labels only):**
- "bug", "error", "broken", "crash", "fix" → `bug`
- "feature", "add", "implement", "new", "enhancement" → `enhancement`
- "docs", "documentation", "readme" → `documentation`
- "question", "help", "how to" → `question`
- "duplicate", "already exists" → `duplicate`
- "wontfix", "won't fix", "not planned" → `wontfix`

**If keywords suggest non-standard labels:**
- "test", "testing", "spec" → use `enhancement` instead
- "security", "vulnerability" → use `bug` instead
- "performance", "slow", "optimization" → use `enhancement` instead
- "refactor", "cleanup", "tech debt" → use `enhancement` instead
- "chore", "maintenance" → use `enhancement` instead

**Generate Title:**
- If user provided a clear title in their prose, use it
- Otherwise, generate from first sentence or key phrase
- Format: `[type]: Brief description` (e.g., "feat: Add CSV export" or "fix: OAuth 401 errors")

### 6. Preview & Confirm

Present a complete preview:

```
═══════════════════════════════════════
ISSUE PREVIEW
═══════════════════════════════════════
Title: [generated or user-provided title]
Repository: [current repo or "not in a git repository"]
Type: [bug/feature/documentation/chore]
Labels: [suggested labels]

───────────────────────────────────────
ISSUE BODY:
───────────────────────────────────────
[Full formatted body with investigation context]

═══════════════════════════════════════
INVESTIGATION SUMMARY:
═══════════════════════════════════════
- Found [N] related files: [list]
- Identified components: [list]
- [Other key findings]
═══════════════════════════════════════
```

**Ask explicitly:** "Should I create this issue?"

**STOP and wait for approval.** User can request:
- Changes to title, labels, or content
- More investigation
- Different template
- Manual editing before creation
- Specify different repository

### 7. Create Issue (Only After Approval)

**Only after explicit approval**, create the issue using `gh` CLI:

```bash
gh issue create \
  --title "Title" \
  --body "$(cat <<'EOF'
[formatted body]
EOF
)" \
  --label "label1,label2" \
  [--assignee "@me"] \
  [-R owner/repo]
```

**Error Handling:**
- Not in git repo: Ask user to specify repo with `-R owner/repo`
- `gh` not authenticated: Provide instructions for `gh auth login`
- Network errors: Report and suggest retry
- Invalid labels: Remove invalid labels and create with valid ones

### 8. Confirm & Next Steps

After successful creation, display:

```
✅ Issue Created Successfully

Issue #[number]: [title]
URL: [full GitHub URL]

Next steps:
- Work on it now: /gh-work [number]
- Assign to yourself: gh issue edit [number] --add-assignee @me
- Add to milestone: gh issue edit [number] --milestone "milestone-name"
- Close this conversation - the issue is your single source of truth
```

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations
- **Investigation:** Use Task tool with `subagent_type=Explore` for codebase investigation
- **Fallback:** Only use MCP GitHub tools if `gh` CLI fails
- **Reason:** `gh` CLI is 80-85% more token-efficient than MCP tools

## What This Command Does vs Does NOT Do

✅ **This command DOES:**
- Prompt user for problem/feature description
- Investigate codebase to find relevant context
- Build a well-documented GitHub issue body
- Create the issue using `gh` CLI
- Suggest next steps after creation

❌ **This command does NOT:**
- Implement solutions
- Write or edit code files
- Execute the work described in the issue
- Use Edit, Write, or NotebookEdit tools
- Commit changes or create pull requests

**Your job ends when the issue is created.** If the user wants implementation, suggest `/gh-work <issue-number>`.

## Usage Examples

**Example 1 - Basic Bug Report:**
```
User: /create-issue
Assistant: I'll help you create a GitHub issue. Please describe the problem or feature request...

User: Users are getting 401 errors when using OAuth login, even with valid tokens