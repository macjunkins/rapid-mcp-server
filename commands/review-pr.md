# GitHub Review Pull Request Command

You are reviewing a GitHub pull request that has been analyzed by automated reviewers (like Copilot). Your job is to analyze the PR, provide code review insights, and help fix identified issues.

**Note:** This command focuses on analysis and fixing code. For GitHub PR UI interactions (viewing comments, merging, etc.), see [PR-REVIEW-GUIDE.md](../PR-REVIEW-GUIDE.md) for VS Code workflow.

## Instructions

Follow this workflow strictly:

### 1. Fetch Pull Request Details

Get comprehensive PR information:

```bash
# Get PR details
gh pr view {{arg1}} --json number,title,body,state,isDraft,baseRefName,headRefName,commits,mergeable,url,author,additions,deletions

# Get PR checks status
gh pr checks {{arg1}}

# Get file list with stats
gh pr diff {{arg1}} --name-only
```

**Display PR overview:**
```
═══════════════════════════════════════
PULL REQUEST REVIEW
═══════════════════════════════════════
PR #{{NUMBER}}: {{TITLE}}
Author: {{AUTHOR}}
Status: {{OPEN/DRAFT/MERGEABLE}}
Base: {{BASE}} ← {{HEAD}}
URL: {{PR_URL}}

Changes: {{N}} files (+{{ADDITIONS}} -{{DELETIONS}})
Commits: {{N}} commits

Checks Status:
{{List all check results - pass/fail/pending}}

───────────────────────────────────────
💡 TIP: View this PR in VS Code
   - Open Source Control panel
   - Click "GitHub Pull Requests" section
   - Select PR #{{NUMBER}} to view inline

See PR-REVIEW-GUIDE.md for VS Code workflow
───────────────────────────────────────
```

### 2. Fetch Existing Reviews & Comments

Get all reviews and comments from automated reviewers:

```bash
# Get all reviews
gh api repos/{owner}/{repo}/pulls/{{arg1}}/reviews --jq '.[] | {user: .user.login, state: .state, body: .body, submitted_at: .submitted_at}'

# Get review comments (line-specific)
gh api repos/{owner}/{repo}/pulls/{{arg1}}/comments --jq '.[] | {user: .user.login, path: .path, line: .line, body: .body, created_at: .created_at, diff_hunk: .diff_hunk}'

# Get general PR comments
gh api repos/{owner}/{repo}/issues/{{arg1}}/comments --jq '.[] | {user: .user.login, body: .body, created_at: .created_at}'
```

**Identify automated reviewers:**
- GitHub Copilot: `github-advanced-security[bot]` or `github-actions[bot]`
- Other CI/CD bots
- Code analysis tools

**Present existing review summary:**
```
───────────────────────────────────────
EXISTING REVIEWS & COMMENTS
───────────────────────────────────────

{{For each reviewer:}}
👤 {{REVIEWER_NAME}} {{If bot: 🤖}}
   State: {{APPROVED/CHANGES_REQUESTED/COMMENTED}}
   Date: {{DATE}}

{{Group line-specific comments by file:}}

📄 {{FILE_PATH}}

   Line {{LINE}}:
   {{COMMENT_BODY}}

   {{Show relevant code snippet from diff_hunk if helpful}}

───────────────────────────────────────
AUTOMATED REVIEW SUMMARY:
───────────────────────────────────────
Total Comments: {{N}}
By Copilot: {{N}}
By Other Bots: {{N}}
By Humans: {{N}}

Issue Categories:
- 🔴 Critical: {{N}}
- 🟡 Important: {{N}}
- 🟢 Suggestions: {{N}}
- 💬 Questions: {{N}}
```

### 3. Perform Claude's Code Review

**Read the actual PR diff and analyze:**

```bash
# Get full diff for analysis
gh pr diff {{arg1}}
```

**Use the Read tool** to examine specific files that changed, especially those with existing review comments.

**Code review focus areas:**

**Code Quality:**
- Logic errors or bugs
- Edge cases not handled
- Error handling completeness
- Null/undefined checks
- Type safety issues

**Architecture & Design:**
- Follows project patterns
- Code duplication (DRY)
- Single Responsibility
- Dependency management

**Performance:**
- Inefficient algorithms
- Unnecessary computations
- Database query optimization
- Memory concerns

**Security:**
- Input validation
- Injection risks (SQL, XSS)
- Authentication/authorization
- Sensitive data exposure

**Testing:**
- Test coverage adequate
- Edge cases tested
- Error scenarios tested

**Documentation:**
- Comments for complex logic
- API documentation
- Breaking changes noted

**Present Claude's review:**
```
───────────────────────────────────────
CLAUDE'S CODE REVIEW
───────────────────────────────────────

✅ STRENGTHS:
- {{Positive observation 1}}
- {{Positive observation 2}}

⚠️  ISSUES FOUND:

{{For each issue:}}
{{SEVERITY}}: {{ISSUE_TITLE}}
File: {{FILE_PATH}}:{{LINE_RANGE}}

Issue: {{DESCRIPTION}}
Impact: {{WHAT_COULD_GO_WRONG}}
Recommendation: {{HOW_TO_FIX}}

{{If applicable:}}
Example fix:
```{{LANGUAGE}}
{{CODE_SUGGESTION}}
```

💡 SUGGESTIONS (Optional):
- {{Non-critical improvement 1}}
- {{Non-critical improvement 2}}

📊 ASSESSMENT:
Overall: {{APPROVE / NEEDS_CHANGES / COMMENT_ONLY}}
Blocking Issues: {{N}}
Important Concerns: {{N}}
Minor Suggestions: {{N}}
```

### 4. Compare & Synthesize Reviews

Cross-reference automated reviews with Claude's analysis:

```
───────────────────────────────────────
REVIEW CONSENSUS ANALYSIS
───────────────────────────────────────

🤝 AGREED ISSUES (Multiple reviewers found):
{{For each agreed issue:}}
- {{ISSUE}} in {{FILE}}:{{LINE}}
  Found by: {{Copilot, Claude, etc.}}
  Priority: HIGH (multiple reviewers agree)

🤖 COPILOT-SPECIFIC ISSUES:
{{Issues only Copilot found}}
- {{ISSUE}}
  Claude's take: {{Agreement/Disagreement/Context}}

🧠 CLAUDE-SPECIFIC ISSUES:
{{Issues only Claude found}}
- {{ISSUE}}
  Why Copilot may have missed: {{REASON}}

❓ QUESTIONS TO CONSIDER:
{{Any ambiguities or areas needing human judgment}}
```

### 5. Check Related Issues & PR Goals

Verify the PR achieves its stated goals:

```bash
# Extract issue numbers from PR body
gh pr view {{arg1}} --json body --jq '.body' | grep -iE '(closes|fixes|resolves) #[0-9]+'

# For each issue, get details
gh issue view {{ISSUE_NUMBER}} --json number,title,state,labels,body
```

**Verify implementation vs. requirements:**
```
───────────────────────────────────────
REQUIREMENTS VERIFICATION
───────────────────────────────────────

{{For each related issue:}}
Issue #{{NUMBER}}: {{TITLE}}

Expected: {{What the issue requested}}
Implemented: {{What the PR actually does}}
Gap Analysis: {{Any missing pieces}}

Acceptance Criteria:
- [{{✓/✗}}] {{Criterion 1}}
- [{{✓/✗}}] {{Criterion 2}}

Assessment: {{FULLY_ADDRESSED / PARTIALLY_ADDRESSED / MISSING}}
```

### 6. Create Action Plan

Based on all reviews, create a prioritized action plan.

**IMPORTANT - Planning Mode Detection:**
- **If in Planning Mode:** Use the `ExitPlanMode` tool to present the plan
  - Format plan as markdown with clear sections
  - Do NOT use TodoWrite in planning mode
  - Let user exit planning mode to begin execution
- **If in Normal Mode:** Use the `TodoWrite` tool to create the action plan
  - Continue to step 7 (Present Plan & Get Approval)

**Action plan structure:**
```
═══════════════════════════════════════
ACTION PLAN FOR PR #{{NUMBER}}
═══════════════════════════════════════

CURRENT STATUS:
✓ Checks: {{PASSING/FAILING}}
✓ Reviews: {{N}} total ({{N}} approvals, {{N}} change requests)
✓ Mergeable: {{YES/NO/CONFLICTS}}
✓ Issues found: {{N}} critical, {{N}} important, {{N}} minor

───────────────────────────────────────
RECOMMENDED PATH: {{FIX_ISSUES / READY_TO_MERGE / NEEDS_DISCUSSION}}
───────────────────────────────────────

{{If issues exist:}}

Phase 1: Fix Critical Issues (REQUIRED before merge)
{{For each critical issue:}}
1. {{ISSUE_DESCRIPTION}}
   File: {{FILE}}:{{LINE}}
   Action: {{SPECIFIC_FIX}}

Phase 2: Address Important Concerns (RECOMMENDED)
{{For each important issue:}}
1. {{ISSUE_DESCRIPTION}}
   File: {{FILE}}:{{LINE}}
   Action: {{SPECIFIC_FIX}}

Phase 3: Optional Improvements
{{For minor suggestions:}}
1. {{SUGGESTION}}

{{If ready to merge:}}

✅ PR is ready to merge!

Pre-merge checklist:
- [ ] All checks passing
- [ ] Required reviews approved
- [ ] No blocking issues
- [ ] Related issues will auto-close
- [ ] Branch can be safely deleted after merge

Merge strategy: {{SQUASH/MERGE/REBASE}}
Rationale: {{WHY}}

Post-merge tasks:
- [ ] Verify issues auto-closed
- [ ] Delete branch ({{BRANCH_NAME}})
- [ ] Update milestone progress
- [ ] Monitor for production issues
```

### 7. Present Plan & Get Approval (Normal Mode Only)

Show the action plan and ask for direction:

```
I've analyzed PR #{{NUMBER}} including reviews from Copilot and performed my own analysis.

{{ACTION_PLAN}}

───────────────────────────────────────
What would you like to do?
───────────────────────────────────────

1. **Fix issues in this conversation**
   I'll help you make the code changes to address the issues

2. **Add my review to GitHub**
   I'll post my review comments to the PR
   (You'll still use VS Code to view/respond)

3. **Ready to merge**
   Guide me through merge and cleanup
   (Uses VS Code PR extension - see PR-REVIEW-GUIDE.md)

4. **Just the analysis**
   Thanks, I'll handle it manually from here

5. **Ask specific questions**
   Want to discuss specific findings

Please choose (1-5) or ask a question:
```

**STOP and wait for user response.**

### 8. Execute Based on User Choice (Normal Mode Only)

#### Option 1: Fix Issues in Conversation

Work through the todo list systematically:

```
Great! Let's fix the issues. I'll work through them in priority order.

{{For each issue in TodoWrite:}}
- Mark issue as in_progress
- Read the affected file
- Explain the change about to make
- Use Edit tool to fix the issue
- Mark as completed
- Continue to next issue

After all fixes:
```

After making fixes:

```bash
# Show what changed
git diff

# Stage changes
git add {{FILES}}

# Commit with descriptive message
git commit -m "fix: Address PR review feedback

- Fix {{ISSUE_1}}
- Fix {{ISSUE_2}}
- Address Copilot feedback on {{FILE}}

Related to PR #{{PR_NUMBER}}"

# Push to PR branch
git push origin {{BRANCH}}
```

**Confirm push:**
```
✅ Changes pushed to PR branch

Updated files:
{{List changed files}}

The PR will update automatically. You can view the changes in VS Code:
- Source Control > GitHub Pull Requests > PR #{{NUMBER}}

Wait for CI checks to re-run, then check if reviewers are satisfied.
```

#### Option 2: Add Review to GitHub

Ask for review type:
```
I'll add my review to the PR. How should I submit it?

1. **COMMENT** - General feedback, no approval/rejection
   (Others can still approve/merge)

2. **APPROVE** - Approve the PR
   (You must be a repository collaborator)

3. **REQUEST_CHANGES** - Formal change request
   (Blocks merge until resolved)

Choose (1-3):
```

**Then post the review:**

```bash
# Build review comments array for line-specific issues
COMMENTS=$(cat <<'EOF'
[
  {
    "path": "{{FILE}}",
    "line": {{LINE}},
    "body": "{{CLAUDE_COMMENT}}"
  },
  ...
]
EOF
)

# Submit review
gh api repos/{owner}/{repo}/pulls/{{PR_NUMBER}}/reviews \
  -f body="{{CLAUDE_SUMMARY}}" \
  -f event="{{COMMENT/APPROVE/REQUEST_CHANGES}}" \
  -F comments="${COMMENTS}"
```

**Confirm:**
```
✅ Review posted to PR #{{NUMBER}}

Review type: {{TYPE}}
Comments added: {{N}}

View in VS Code:
- Source Control > GitHub Pull Requests > PR #{{NUMBER}}
- Your review comments will appear inline

Next steps:
- Author will see your feedback
- Respond to feedback in VS Code as needed
- See PR-REVIEW-GUIDE.md for VS Code review workflow
```

#### Option 3: Ready to Merge

**Guide through merge using VS Code:**

```
✅ PR is ready to merge!

To merge using VS Code:

1. Open Source Control panel (⌃⇧G)
2. Expand "GitHub Pull Requests" section
3. Find PR #{{NUMBER}}
4. Click the ✓ merge button
5. Choose merge strategy:
   - Squash: Recommended for feature branches ({{N}} commits → 1)
   - Merge: Preserve all commits
   - Rebase: Linear history

Recommended: {{STRATEGY}}

After merge:
- Verify issues auto-closed: /verify-merge {{PR_NUMBER}}
- Branch will be deleted automatically
- PR will close automatically

See PR-REVIEW-GUIDE.md for detailed merge workflow.

Ready to merge now? (I'll verify after)
```

**After user merges in VS Code:**

```bash
# Verify the merge
gh pr view {{PR_NUMBER}} --json merged,mergedAt,mergeCommit

# Check related issues
{{For each issue:}}
gh issue view {{ISSUE_NUMBER}} --json state,closedAt
```

```
✅ Merge verified!

PR #{{NUMBER}} merged at {{TIME}}
Merge commit: {{SHA}}

Related issues:
{{For each:}}
- Issue #{{NUMBER}}: {{CLOSED ✓ / STILL OPEN ⚠️}}

{{If any issues still open:}}
⚠️  Some issues didn't auto-close. This may be because:
- Keyword (Closes/Fixes/Resolves) was in wrong location
- Issue was already closed manually
- Issue is in different repository

Would you like me to close them manually?
```

#### Option 4: Just the Analysis

```
No problem! Here's a summary for your reference:

{{EXECUTIVE_SUMMARY}}

You can find all details above. Let me know if you need anything else!
```

#### Option 5: Answer Specific Questions

Enter discussion mode:
```
Sure! What would you like to discuss about the review?

I can help with:
- Why a specific issue matters
- How to fix a particular problem
- Trade-offs between different approaches
- Understanding Copilot's feedback
- Testing strategies
- Anything else about this PR

What's your question?
```

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations
- **File Reading:** Use Read tool to examine changed files
- **Code Changes:** Use Edit tool to fix issues
- **Fallback:** Only use MCP GitHub tools if `gh` CLI fails
- **Reason:** `gh` CLI is 80-85% more token-efficient

## VS Code Integration

**This command works WITH VS Code, not instead of it:**

| Task | Tool to Use |
|------|-------------|
| View PR diff inline | VS Code PR extension |
| See Copilot comments | VS Code PR extension |
| Respond to comments | VS Code PR extension |
| Approve/Request Changes | VS Code PR extension OR this command |
| **Get Claude's analysis** | **This command** |
| **Fix code issues** | **This command** |
| Merge PR | VS Code PR extension |
| Verify merge | This command |

**See [PR-REVIEW-GUIDE.md](../PR-REVIEW-GUIDE.md) for complete VS Code workflow.**

## Error Handling

**PR not found:**
```
❌ Pull request #{{NUMBER}} not found.

Verify:
- PR number is correct
- You're in the correct repository
- You have access to the repository

List open PRs: gh pr list
```

**PR already merged:**
```
ℹ️  PR #{{NUMBER}} is already merged.

Merged: {{TIMESTAMP}} by {{AUTHOR}}

Would you like to:
1. Verify related issues were closed
2. Review for post-merge issues
3. Cancel
```

**PR is closed (not merged):**
```
⚠️  PR #{{NUMBER}} is closed without merging.

Closed: {{TIMESTAMP}}

This PR was not merged. No action needed.
```

**No Copilot review yet:**
```
ℹ️  No Copilot review found yet.

Checks status:
{{List check statuses}}

Options:
1. Continue with Claude review only
2. Wait for Copilot (check back later)
3. Cancel

Note: This command works best after automated reviews complete.

Choose (1-3):
```

**Merge conflicts:**
```
⚠️  PR has merge conflicts with {{BASE_BRANCH}}

Conflicting files:
{{List conflicts if available}}

To resolve in VS Code:
1. Open Source Control
2. Pull latest {{BASE_BRANCH}}
3. Merge {{BASE_BRANCH}} into {{HEAD_BRANCH}}
4. Resolve conflicts using VS Code's merge editor
5. Commit and push

See PR-REVIEW-GUIDE.md for conflict resolution guide.

Cannot proceed with merge until conflicts are resolved.
```

**Checks failing:**
```
⚠️  CI checks are failing:

{{For each failed check:}}
❌ {{CHECK_NAME}}
   {{ERROR if available}}

Recommendation: Fix failing checks before merge.

Would you like me to:
1. Analyze the failures and suggest fixes
2. Wait (you'll fix manually)
3. Review anyway (despite failures)

Choose (1-3):
```

## What This Command Does vs Does NOT Do

✅ **This command DOES:**
- Fetch PR details and existing reviews
- Analyze Copilot's review comments
- Perform independent code review
- Compare and synthesize multiple reviews
- Verify requirements are met
- Create prioritized action plan
- Help fix code issues via Edit tool
- Post review comments to GitHub
- Guide merge process
- Verify post-merge cleanup

❌ **This command does NOT:**
- Replace VS Code's PR UI (use VS Code for viewing)
- Show inline diff viewer (use VS Code)
- Manage conversation threads (use VS Code)
- Force merge failing PRs
- Make architectural decisions without approval
- Bypass review requirements

## Notes

- Works best after automated reviewers (Copilot) have completed
- Complements VS Code's PR features, doesn't replace them
- Can work at any PR stage (draft, open, ready)
- Reviews are posted to GitHub for permanent record
- The command focuses on analysis and fixing, VS Code handles UI
- See PR-REVIEW-GUIDE.md for VS Code workflow integration

## Philosophy

**Multi-layered review approach:**
- **Automated (Copilot):** Fast, catches common issues
- **Claude:** Deep analysis, context understanding, fixing help
- **Human (You):** Final decisions, trade-off judgments
- **VS Code:** Visual interface for all the above

**Best of both worlds:**
- Use Claude for thinking and fixing
- Use VS Code for viewing and interacting
- Keep all review history on GitHub
- Maintain clean git history

## Usage Examples

**Example 1 - Review and fix:**
```
User: /review-pr 42
Claude:
1. Fetches PR details
2. Shows Copilot found 3 issues
3. Claude finds 2 additional issues
4. Shows consensus: 1 critical, 2 important, 2 minor
5. Creates action plan with 5 todos
User: 1 (fix issues)
Claude:
1. Fixes critical issue in auth.ts
2. Fixes important issues in api.ts
3. Addresses minor suggestions
4. Commits and pushes changes
5. Shows updated PR status
```

**Example 2 - Review and approve:**
```
User: /review-pr 23
Claude:
1. Analyzes PR
2. Copilot has 2 minor suggestions
3. Claude agrees + adds 1 suggestion
4. Overall: ready to approve
5. Shows action plan
User: 2 (add review)
Claude: How should I submit? (1-3)
User: 2 (approve)
Claude: Posts approval review to GitHub
User: [Uses VS Code to merge]
```

**Example 3 - Just analysis:**
```
User: /review-pr 15
Claude:
1. Full analysis
2. Shows all reviews
3. Creates action plan
User: 4 (just analysis)
Claude: Provides summary, ends workflow
User: [Handles manually in VS Code]
```

**Example 4 - Discussion mode:**
```
User: /review-pr 33
Claude: [Shows analysis with 1 security concern]
User: 5 (questions)
User: Why is the SQL query a security risk?
Claude: [Explains SQL injection, shows example fix]
User: How should I parameterize it?
Claude: [Shows specific code example]
User: Got it. Can you fix it?
Claude: [Switches to fix mode, makes changes]
```

**Example 5 - Ready to merge:**
```
User: /review-pr 8
Claude:
1. Analyzes PR
2. All checks passing
3. No blocking issues
4. Copilot approved
5. Shows "ready to merge" plan
User: 3 (ready to merge)
Claude: [Shows VS Code merge instructions]
User: [Merges in VS Code]
User: Done
Claude: [Verifies merge, checks issue closure, confirms cleanup]
```

## Integration with Your Workflow

**Complete PR workflow:**

1. **Create PR:** `/create-pr`
2. **Wait:** Copilot reviews automatically (5-10 minutes)
3. **Review:** `/review-pr <number>` ← This command
4. **Fix issues:** Use option 1 (Claude helps fix in conversation)
5. **Verify:** Wait for CI to re-run
6. **Merge:** Use VS Code PR extension
7. **Cleanup:** Verify with this command

**When to use this command:**
- ✅ After Copilot review completes
- ✅ When you want Claude's analysis
- ✅ When you need help fixing issues
- ✅ When you want to post review comments
- ✅ When you want merge verification

**When to use VS Code instead:**
- ✅ Viewing PR diffs inline
- ✅ Reading comment threads
- ✅ Responding to reviewers
- ✅ Clicking merge button
- ✅ Visual conflict resolution
