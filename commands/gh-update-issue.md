# GitHub Update Issue Command

You are updating a GitHub issue with work progress when pausing a Claude conversation.

## Instructions

Follow this workflow strictly:

### 1. Acknowledge and Explain

When this command is invoked, explain what will happen:

```
I'll help you update issue #{{arg1}} with your current work progress.

I will:
1. Analyze this conversation to extract work completed, blockers, and next steps
2. Fetch issue metadata from GitHub
3. Format a status update comment
4. Preview everything for your approval
5. Post the update to GitHub

Let me start by gathering the context...
```

### 2. Analyze Conversation Context

Review the current conversation to extract:

**Work Completed:**
- Look for Edit, Write, NotebookEdit tool usage (files created/modified)
- Bash commands executed (tests run, builds completed, etc.)
- Task tool usage (investigations, explorations)
- Explicit user statements about completed work

**Blockers/Challenges:**
- Error messages from tool outputs
- Failed commands or tests
- User statements about difficulties
- Unresolved issues or questions raised

**Decisions Made:**
- Architectural choices discussed and approved
- Implementation approach selected
- Technology/library decisions
- User approvals for specific directions

**Next Steps:**
- Remaining TODO items (from TodoWrite if present)
- User statements about what comes next
- Logical next phases based on work completed
- Unfinished work or pending tasks

**Open Questions:**
- Unanswered questions posed to user
- Ambiguities identified
- Areas needing clarification
- Alternative approaches under consideration

**IMPORTANT:** Extract concrete specifics, not vague summaries. Include file names, command outputs, specific decisions. The update should allow someone to resume work without reading the entire conversation.

### 3. Fetch Issue Metadata

```bash
gh issue view {{arg1}} --json title,number,state,body,milestone
```

**Error Handling:**
- If "not a git repository": Ask user to specify repo with `-R owner/repo`
- If issue not found: Verify issue number and repository
- If network error: Report and suggest retry

**Parse response to determine:**
- Issue title and number
- Current state (OPEN/CLOSED)
- Current milestone (if any)
- Issue description for context

### 4. Format Status Comment

Create status update using this template:

```markdown
## Work Session Update

**Session Date:** [Current date from system]

### Accomplished
- [Specific item from conversation analysis - include file names, commands, etc.]
- [Specific item from conversation analysis]
- [...]

### Blockers/Challenges
[If any found:]
- [Specific blocker with context]
- [...]

[If none found:]
_No blockers identified in this session._

### Decisions Made
[If any found:]
- [Decision with rationale]
- [...]

[If none found:]
_No major decisions in this session._

### Next Steps
- [ ] [Actionable next step]
- [ ] [Actionable next step]
- [ ] [...]

### Open Questions
[If any found:]
- [Question that needs answering]
- [...]

[If none found:]
_No open questions at this time._

---
_Updated via Claude Code `/gh-update-issue` command_
```

**Formatting Guidelines:**
- Use specific details (file paths, line numbers, command names)
- Make "Next Steps" actionable checkboxes
- Keep language concise but informative
- Preserve technical terminology
- Include context that helps future resumption

### 5. Preview & Confirm

Present complete preview with ASCII box formatting:

```
═══════════════════════════════════════
UPDATE ISSUE PREVIEW
═══════════════════════════════════════
Issue: #{{arg1}} - [title]
State: [OPEN/CLOSED]
Repository: [repo name or "current repository"]
Current Milestone: [milestone name or "None"]

───────────────────────────────────────
PROPOSED STATUS COMMENT:
───────────────────────────────────────
[Full formatted comment from step 4]

───────────────────────────────────────
ACTIONS TO BE TAKEN:
───────────────────────────────────────
1. Post status comment to issue #{{arg1}}

═══════════════════════════════════════
```

**Ask explicitly:** "Should I post this update to issue #{{arg1}}?"

**STOP and wait for approval.** User can request:
- Changes to status comment content
- More detail in specific sections
- Manual update instead

**IMPORTANT:** Do NOT proceed without explicit approval ("yes", "proceed", "go ahead", etc.)

### 6. Execute (Only After Approval)

**Post the comment:**

```bash
gh issue comment {{arg1}} --body "$(cat <<'EOF'
[formatted status comment from step 4]
EOF
)"
```

**Error Handling:**
- If comment post fails: Stop and report error

### 7. Confirm Success

After successful execution, display:

```
✅ Issue #{{arg1}} Updated Successfully

Comment posted: [GitHub comment URL if available from output]
Issue URL: https://github.com/[owner]/[repo]/issues/{{arg1}}

Summary:
- Work documented: [N] items accomplished
- Next steps: [N] action items identified
[If blockers:]
- ⚠️  [N] blocker(s) noted - review before next session

Next actions:
- Continue work: Resume this conversation or start new session
- Resume later: /gh-work {{arg1}} (will show this update)
- Complete work: /gh-finish {{arg1}} (commit, push, close)
```

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations
- **Fallback:** Only use MCP GitHub tools if `gh` CLI cannot accomplish the task
- **Reason:** `gh` CLI is lighter on tokens and context

## Conversation Analysis Guidelines

**What to look for:**

**File operations indicate work completed:**
- `Edit` tool → "Modified [file] to [purpose]"
- `Write` tool → "Created [file] with [purpose]"
- `NotebookEdit` tool → "Updated notebook cell [details]"

**Bash commands indicate progress:**
- `npm test` / `pytest` → "Ran tests - [results]"
- `npm build` / `cargo build` → "Built project - [results]"
- `git` commands → May indicate prior work or setup

**Task tool usage:**
- `subagent_type=Explore` → "Investigated [area] - found [findings]"
- Other agents → "[Agent type] work on [topic]"

**User approvals indicate decisions:**
- User says "yes" / "proceed" → Previous proposal was approved
- User chooses option → Decision made from alternatives presented

**Error outputs indicate blockers:**
- Command failures with error messages
- Test failures
- Build errors
- Authentication issues

**Todo items indicate next steps:**
- TodoWrite tool usage → Extract pending items
- User statements like "next we need to..."
- Incomplete work from conversation

## Error Handling

**Not in a git repository:**
```
⚠️  Not in a git repository.
Please specify the repository: /gh-update-issue {{arg1}} -R owner/repo
```

**Issue not found:**
```
❌ Issue #{{arg1}} not found.
Verify:
- Issue number is correct
- You have access to this repository
- Repository name if using -R flag
```

**Issue already closed:**
```
ℹ️  Issue #{{arg1}} is already CLOSED.
You can still post a status update if you worked on related changes.
Should I proceed?
```

**No conversation context:**
```
⚠️  I don't see any work activity in this conversation yet.

If you've just started or this is a new conversation, you may want to:
- Manually write the update
- Use /gh-work {{arg1}} to start work first
- Provide a manual status update

Would you like to provide a manual status update instead?
```

**GitHub authentication failure:**
```
❌ GitHub CLI authentication failed.
Run: gh auth login
Then retry this command.
```

**Network errors:**
```
❌ Network error communicating with GitHub.
Check your connection and retry.
```

## Notes

- The `gh` CLI automatically infers repository from git context
- This command works globally across any git repository
- If not in a git repo, specify: `/gh-update-issue 6 -R owner/repo`
- Comment updates are appended to issue - previous updates remain visible
- Status updates create a timeline of progress across sessions

## Philosophy

**GitHub issues as session continuity:**
- Each work session should document progress
- Status updates allow seamless handoff between sessions
- Issues maintain complete history: initial description → updates → closing commit
- Conversation context would be lost otherwise - capture it while fresh

## Usage Examples

**Example 1 - Standard workflow:**
```
User: /gh-update-issue 17
Assistant:
1. Analyzes conversation (found 3 Edit calls, 2 Bash commands, 1 decision)
2. Fetches issue #17 details
3. Formats status comment with accomplished work, next steps
4. Shows preview
5. Asks approval
User: yes
Assistant:
6. Posts comment to issue #17
7. Displays success with URL
```

**Example 2 - Blocked work:**
```
User: /gh-update-issue 42
Assistant:
1. Analyzes conversation (found test failures, error messages)
2. Formats update with accomplishments and blockers section filled
3. Shows preview highlighting 2 blockers
User: proceed
Assistant:
4. Posts update
5. Confirms with warning emoji about blockers
```

**Example 3 - Different repository:**
```
User: /gh-update-issue 8 -R macjunkins/other-repo
Assistant:
[Same workflow but uses -R flag for all gh commands]
```

**Example 4 - No work in conversation:**
```
User: /gh-update-issue 50
Assistant: ⚠️  I don't see any work activity in this conversation yet...
User: Let me provide a manual update
Assistant: What would you like to include in the status update?
[Switches to manual input mode]
```

**Example 5 - User modifies content:**
```
User: /gh-update-issue 15
Assistant: [shows preview with extracted work]
User: Add that we also decided to use TypeScript instead of JavaScript
Assistant: [updates preview with additional decision, shows new preview, asks approval again]
User: yes
Assistant: [posts updated comment]
```
