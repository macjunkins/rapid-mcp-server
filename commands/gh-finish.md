# GitHub Finish Issue Command

You are completing work on a GitHub issue using the standardized commit → push → close workflow.

## Instructions

Follow this workflow strictly:

### 1. Review Current Changes

- Use `git status` to see all changed, staged, and untracked files
- Use `git diff` to review changes (if output is very large, summarize key changes)
- Confirm with user that changes are ready to commit
- If working directory is not clean and ready, stop and ask user to prepare changes

### 2. Fetch Issue Context

- Use `gh issue view {{arg1}} --json title,body,labels,milestone,state,number` to fetch issue details
- If the command fails with "not a git repository", ask the user to specify the repo: `gh issue view {{arg1}} -R owner/repo --json ...`
- Verify the issue is currently OPEN (warn if already closed)
- Parse issue details to understand scope of work for commit message

### 3. Generate Commit Message

Create a detailed commit message following repository conventions:

**Check recent commit style:**
- Run `git log --oneline -5` to see recent commit message patterns
- Identify common prefixes (feat:, fix:, docs:, chore:, etc.)

**Commit message structure:**
```
type: Short description of changes

Detailed explanation including:
- What was changed and why
- Key implementation details
- Any important context or decisions
- Impact or side effects (if any)

Closes #{{arg1}}
```

**Type prefixes:**
- `feat:` - New feature or enhancement
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `chore:` - Maintenance, cleanup, archiving
- `refactor:` - Code restructuring without behavior change
- `test:` - Test additions or modifications
- `perf:` - Performance improvements
- `style:` - Code style/formatting changes

**Commit message guidelines:**
- First line: concise summary (50-72 chars)
- Body: detailed explanation of what and why (not just what)
- Reference issue number in footer with `Closes #X`
- Be specific and informative - this is the single source of truth
- Explain context and decisions, not just file changes

### 4. Preview & Get Approval

Present a complete preview:

```
═══════════════════════════════════════
COMMIT & CLOSE PREVIEW
═══════════════════════════════════════
Issue: #{{arg1}} - [title]
Status: [OPEN/CLOSED]
Repository: [repo name or "current repository"]

───────────────────────────────────────
PROPOSED COMMIT MESSAGE:
───────────────────────────────────────
[Full commit message with Closes footer]

───────────────────────────────────────
ACTIONS TO BE TAKEN:
───────────────────────────────────────
1. git add . (stage all changes)
2. git commit -m "[message above]"
3. git push (will auto-close issue #{{arg1}})

───────────────────────────────────────
CHANGED FILES:
───────────────────────────────────────
[List from git status]

═══════════════════════════════════════
```

**Ask explicitly:** "Should I proceed with commit, push, and close?"

Wait for approval. User can request:
- Changes to commit message
- Different commit type
- More detailed explanation
- Review specific changes first
- Manual commit instead

**IMPORTANT:** Do NOT proceed without explicit approval ("yes", "proceed", "go ahead", etc.)

### 5. Execute (Only After Approval)

Execute the following commands sequentially:

```bash
git add .
git commit -m "$(cat <<'EOF'
[commit message from step 3]
EOF
)"
git push
```

**IMPORTANT - Commit Message Formatting:**
- Always use HEREDOC format for multi-line commit messages
- Ensures proper formatting and preserves line breaks
- Example format shown above

**Error Handling:**
- If `git add` fails: Stop and report error
- If `git commit` fails: Stop and report error (may be pre-commit hooks)
- If `git push` fails: Stop and report error (may need to pull first)
- If any command fails, do NOT proceed to next step

### 6. Verify Issue Closure

After successful push:

```bash
gh issue view {{arg1}} --json state,closedAt,title
```

Verify that:
- Issue state is "CLOSED"
- closedAt timestamp is recent
- The closing commit is linked to the issue

### 7. Confirm Completion

Display final status including:

```
✅ Work Completed on Issue #{{arg1}}

Commit: [SHA from git push output]
Issue: [GitHub issue URL]
Status: CLOSED at [timestamp]

Git log entry:
[show last commit with git log -1 --oneline]
```

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations
- **Fallback:** Only use MCP GitHub tools if `gh` CLI cannot accomplish the task
- **Reason:** `gh` CLI is lighter on tokens and context

## Error Handling

**Not in a git repository:**
- Inform user and suggest navigating to correct directory
- Or ask user to specify repo with `-R owner/repo` flag

**No changes to commit:**
- Warn user that working directory is clean
- Ask if they want to close issue without committing

**Issue already closed:**
- Warn user but allow proceeding with commit/push
- Commit message will reference closed issue

**Push fails (behind remote):**
- Suggest `git pull --rebase` first
- Do NOT automatically pull - let user decide

**Issue not found:**
- Verify issue number is correct
- Ask if user meant different repository

**Merge conflicts after pull:**
- Stop and ask user to resolve conflicts
- User can re-run `/gh-finish` after resolving

## Notes

- The `gh` CLI automatically infers repository from git context
- This command works globally across any git repository
- The `Closes #X` keyword in commit message automatically closes the issue on push
- No separate closing comment is needed - git history is the source of truth
- If not in a git repo, the user can specify: `/gh-finish 6 -R owner/repo`

## Philosophy

**Git history as single source of truth:**
- Commit messages should be detailed enough to understand changes without reading code
- Comments on issues are for discussions, not logs
- The closing commit explains what was done and why
- GitHub automatically links the commit to the issue closure

## Usage Examples

**Example 1 - Simple workflow:**
```
User: /gh-finish 7
Assistant:
1. Shows git status and diff
2. Fetches issue #7 details
3. Generates commit message: "chore: Archive BMAD framework files..."
4. Shows preview and asks approval
5. Commits, pushes (auto-closes #7)
6. Displays completion summary
```

**Example 2 - Different repository:**
```
User: /gh-finish 42 -R macjunkins/other-repo
Assistant:
[Same workflow but uses -R flag for all gh commands]
```

**Example 3 - User modifies commit message:**
```
User: /gh-finish 15
Assistant: [shows preview]
User: Change the commit type to "feat:" instead of "fix:"
Assistant: [regenerates with feat: prefix, shows new preview, asks approval again]
```

**Example 4 - Issue already closed:**
```
User: /gh-finish 10
Assistant: "⚠️  Issue #10 is already CLOSED. Do you still want to commit and push these changes?"
[If yes, proceeds but issue won't re-close]
```
