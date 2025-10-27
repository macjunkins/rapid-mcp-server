# GitHub Create Pull Request Command

You are creating a GitHub pull request. Your job is to gather the current state, analyze changes, and create a well-documented pull request.

## Instructions

Follow this workflow strictly:

### 1. Verify Git State

First, verify we're in a repository and on a feature branch:

```bash
# Check git status
git status

# Get current branch name
git branch --show-current

# Check if remote tracking exists
git rev-parse --abbrev-ref --symbolic-full-name @{u}
```

**Validation checks:**
- ✅ Must be in a git repository
- ✅ Must not be on `main` or `master` branch
- ✅ Must have commits to push (ahead of base branch)
- ⚠️ Warn if branch is not pushed to remote
- ⚠️ Warn if branch is behind remote (need to pull)

**If validation fails:**
- Not in git repo: Ask user to navigate to repository
- On main/master: Suggest creating a feature branch first
- No commits: Ask user if they want to commit changes first
- Behind remote: Suggest `git pull` before proceeding

### 2. Gather Branch Context

Determine the base branch and analyze changes:

```bash
# Get default branch (usually main or master)
gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'

# Get commit history from base branch
git log {{BASE_BRANCH}}..HEAD --oneline

# Get full diff from base branch
git diff {{BASE_BRANCH}}...HEAD --stat

# Check if branch is pushed to remote
git ls-remote --heads origin {{CURRENT_BRANCH}}
```

**Analyze the changes:**
- How many commits are included?
- What files are affected?
- What type of changes? (feature, fix, docs, refactor, etc.)
- Are there any related issues referenced in commits?

### 3. Extract Related Issues

Parse commit messages to find issue references:

```bash
git log {{BASE_BRANCH}}..HEAD --format=%B | grep -iE '(closes|fixes|resolves) #[0-9]+'
```

**For each referenced issue:**
- Extract issue number
- Fetch issue details: `gh issue view {{NUMBER}} --json title,state,labels`
- Include in PR context

### 4. Build Pull Request Body

Analyze all commits (NOT just the latest) and create comprehensive PR description:

**Structure:**
```markdown
## Summary

{{Comprehensive description of all changes in this PR}}

## Changes

{{For each major area of change:}}
- **{{Component/File}}:** {{What changed and why}}
- **{{Component/File}}:** {{What changed and why}}

## Related Issues

{{If issues found:}}
- Closes #{{NUMBER}} - {{ISSUE_TITLE}}
- Fixes #{{NUMBER}} - {{ISSUE_TITLE}}

{{If no issues found:}}
_No related issues_

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Performance improvement
- [ ] Test addition/update
- [ ] Chore/maintenance

## Testing

{{Describe testing performed or needed:}}
- [ ] Existing tests pass
- [ ] New tests added for new functionality
- [ ] Manual testing performed
- [ ] No tests needed (documentation only, etc.)

## Additional Context

{{Any additional information that reviewers should know}}

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings introduced
- [ ] Tests added/updated as needed
```

### 5. Generate PR Title

**Title format:** `[type]: Brief description of changes`

**Type prefixes (follow commit conventions):**
- `feat:` - New feature or enhancement
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code restructuring without behavior change
- `test:` - Test additions or modifications
- `perf:` - Performance improvements
- `chore:` - Maintenance, cleanup, dependencies
- `style:` - Code style/formatting changes

**Title guidelines:**
- Keep concise (50-72 characters)
- Be descriptive but brief
- Focus on what, not how
- If closing a single issue, mirror issue title

**Examples:**
- `feat: Add CSV export functionality to reports`
- `fix: Resolve OAuth 401 errors on token refresh`
- `docs: Update API documentation for v2 endpoints`
- `refactor: Simplify authentication middleware`

### 6. Determine Target Base Branch

**Ask the user explicitly:**
```
I'm preparing a pull request from branch "{{CURRENT_BRANCH}}".

Which branch should this PR target?
1. {{DEFAULT_BRANCH}} (default)
2. dev
3. staging
4. other (specify)

Or press Enter for default ({{DEFAULT_BRANCH}})
```

**STOP and wait for user response.**

### 7. Preview & Get Approval

Present the complete PR preview:

```
═══════════════════════════════════════
PULL REQUEST PREVIEW
═══════════════════════════════════════
Title: {{PR_TITLE}}
From: {{CURRENT_BRANCH}}
To: {{BASE_BRANCH}}
Repository: {{repo name or "current repository"}}

───────────────────────────────────────
COMMITS INCLUDED ({{N}} commits):
───────────────────────────────────────
{{git log output - show all commits}}

───────────────────────────────────────
FILES CHANGED ({{N}} files):
───────────────────────────────────────
{{git diff --stat output}}

───────────────────────────────────────
PULL REQUEST BODY:
───────────────────────────────────────
{{Full PR body from template}}

───────────────────────────────────────
ACTIONS TO BE TAKEN:
───────────────────────────────────────
{{If branch not pushed:}}
1. git push -u origin {{CURRENT_BRANCH}}
2. gh pr create --title "{{TITLE}}" --base {{BASE_BRANCH}} --body "..."

{{If branch already pushed:}}
1. gh pr create --title "{{TITLE}}" --base {{BASE_BRANCH}} --body "..."

═══════════════════════════════════════
```

**Ask explicitly:** "Should I create this pull request?"

**STOP and wait for approval.** User can request:
- Changes to title or description
- Different base branch
- More detailed summary
- Different PR type selection
- Draft PR instead
- Manual creation
- Review changes first

**IMPORTANT:** Do NOT proceed without explicit approval ("yes", "proceed", "go ahead", etc.)

### 8. Execute (Only After Approval)

**If branch not pushed to remote:**
```bash
git push -u origin {{CURRENT_BRANCH}}
```

**Create the pull request:**
```bash
gh pr create \
  --title "{{TITLE}}" \
  --base {{BASE_BRANCH}} \
  --body "$(cat <<'EOF'
{{PR_BODY}}
EOF
)"
```

**Optional flags (ask user if needed):**
- `--draft` - Create as draft PR
- `--assignee @me` - Assign to yourself
- `--reviewer username` - Request specific reviewers
- `--label "label1,label2"` - Add labels

**Error Handling:**
- If push fails: Stop and report error (may need to pull first)
- If PR creation fails: Stop and report error (may already exist)
- If not in git repo: Ask user to navigate to repository
- If `gh` not authenticated: Provide instructions for `gh auth login`
- If PR already exists: Show existing PR and ask if user wants to update it

### 9. Verify Creation & Display Results

After successful creation:

```bash
# Get PR details
gh pr view --json number,url,title,state,isDraft

# Get PR checks status (if any)
gh pr checks
```

Display results:

```
✅ Pull Request Created Successfully

PR #{{NUMBER}}: {{TITLE}}
URL: {{PR_URL}}
Status: {{OPEN/DRAFT}}
Base: {{BASE_BRANCH}} ← {{CURRENT_BRANCH}}

{{If checks are configured:}}
Checks Status:
{{List check statuses}}

Next Steps:
- View in browser: gh pr view --web
- Request reviews: gh pr edit {{NUMBER}} --add-reviewer username
- Convert to draft: gh pr ready {{NUMBER}} --undo
- Mark ready: gh pr ready {{NUMBER}}
- View checks: gh pr checks {{NUMBER}}
- Close this conversation - the PR is now live on GitHub
```

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations
- **Fallback:** Only use MCP GitHub tools if `gh` CLI cannot accomplish the task
- **Reason:** `gh` CLI is 80-85% more token-efficient than MCP tools

## Optional Arguments

**Base branch:**
```
/create-pr main
/create-pr dev
```

**Create as draft:**
```
/create-pr --draft
/create-pr main --draft
```

## Error Handling

**Not in a git repository:**
```
⚠️  Not in a git repository.
Please navigate to your repository.
```

**On main/master branch:**
```
⚠️  You're currently on the {{BRANCH}} branch.

Pull requests should be created from feature branches.
Would you like to:
1. Create a feature branch first
2. Proceed anyway (not recommended)
```

**No commits ahead of base:**
```
⚠️  No commits to include in pull request.

Your branch is up to date with {{BASE_BRANCH}}.
Would you like to:
1. Make changes and commit first
2. Cancel
```

**Branch not pushed:**
```
⚠️  Branch "{{BRANCH}}" not pushed to remote.

I'll push the branch before creating the PR.
Proceed? (yes/no)
```

**Behind remote:**
```
⚠️  Your branch is behind origin/{{BRANCH}}.

You should pull the latest changes first:
git pull

Then re-run this command.
```

**PR already exists:**
```
❌ Pull request already exists for this branch.

Existing PR: #{{NUMBER}} - {{TITLE}}
URL: {{PR_URL}}

Would you like to:
1. View the existing PR: gh pr view {{NUMBER}} --web
2. Update PR description: gh pr edit {{NUMBER}} --body "..."
3. Close existing and create new (not recommended)
```

**GitHub authentication failure:**
```
❌ GitHub CLI authentication failed.
Run: gh auth login
Then retry this command.
```

**Merge conflicts detected:**
```
⚠️  Merge conflicts detected with {{BASE_BRANCH}}.

You should resolve conflicts before creating PR:
1. git merge {{BASE_BRANCH}}
2. Resolve conflicts
3. git commit
4. Re-run this command
```

## What This Command Does vs Does NOT Do

✅ **This command DOES:**
- Analyze current branch and changes
- Extract related issues from commits
- Build comprehensive PR description
- Push branch to remote if needed
- Create the pull request using `gh` CLI
- Display PR status and next steps

❌ **This command does NOT:**
- Create feature branches (use git commands directly)
- Merge pull requests (use `/gh-merge-pr` or `gh pr merge`)
- Resolve merge conflicts
- Run tests or CI checks
- Force push or rewrite history

## Notes

- The `gh` CLI automatically infers repository from git context
- This command works globally across any git repository
- PR creation follows repository conventions and templates
- The command analyzes ALL commits in the branch, not just the latest
- Related issues are automatically detected from commit messages
- Branch must be pushed to remote before PR can be created
- If your repository has PR templates, they'll be used automatically by `gh`

## Philosophy

**Pull requests as comprehensive change documentation:**
- PR description should summarize all commits, not just echo one
- Reviewers should understand context without reading commit history
- Related issues should be clearly linked for traceability
- The PR is the narrative of the changes - commits are the implementation
- Always analyze the full scope of changes across all commits

## Usage Examples

**Example 1 - Simple PR from feature branch:**
```
User: /create-pr
Assistant:
1. Checks git status (on feature/add-export branch)
2. Analyzes 3 commits since main
3. Finds "Closes #42" in commit messages
4. Fetches issue #42 details
5. Builds PR body summarizing all 3 commits
6. Shows preview and asks approval
User: yes
Assistant: Pushes branch, creates PR #15, displays success
```

**Example 2 - PR to specific base branch:**
```
User: /create-pr dev
Assistant:
1. Analyzes changes from dev branch (not main)
2. Builds PR targeting dev
3. Shows preview
User: yes
Assistant: Creates PR with base=dev
```

**Example 3 - Draft PR:**
```
User: /create-pr --draft
Assistant:
1. [Normal workflow]
2. Shows preview mentioning draft status
User: yes
Assistant: Creates PR with --draft flag
```

**Example 4 - User modifies description:**
```
User: /create-pr
Assistant: [shows preview]
User: Add more detail about the refactoring in the Changes section
Assistant: [updates PR body, shows new preview]
User: yes
Assistant: Creates PR with updated description
```

**Example 5 - Branch already pushed:**
```
User: /create-pr
Assistant: [detects branch is already on remote]
Assistant: [shows preview without push step]
User: yes
Assistant: Creates PR directly without pushing
```

**Example 6 - PR already exists:**
```
User: /create-pr
Assistant: ❌ Pull request already exists for this branch.
Existing PR: #23 - feat: Add export functionality
URL: https://github.com/owner/repo/pull/23

Would you like to:
1. View the existing PR
2. Update PR description
3. Cancel
User: 1
Assistant: [runs gh pr view 23 --web]
```

**Example 7 - Not on feature branch:**
```
User: /create-pr
Assistant: ⚠️  You're currently on the main branch.
Pull requests should be created from feature branches.
Would you like to:
1. Create a feature branch first
2. Proceed anyway (not recommended)
User: 1
Assistant: What should the feature branch be named?
User: feature/new-dashboard
Assistant:
git checkout -b feature/new-dashboard
Branch created. Make your changes, then re-run /create-pr
```

## Integration with Workflow

This command fits into the larger GitHub workflow:

1. **Create issue:** `/create-issue` or `/gh-next-issue`
2. **Start work:** `/gh-work <number>` (creates feature branch)
3. **Make changes and commit:** (standard git workflow)
4. **Create PR:** `/create-pr` ← This command
5. **Review & merge:** Review on GitHub, merge when approved
6. **Clean up:** Delete feature branch after merge
