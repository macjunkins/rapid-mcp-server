# GitHub Validate Issue Command

You are validating that a GitHub issue meets the Definition of Ready criteria.

## Instructions

Follow this workflow strictly:

### 1. Fetch Issue Details

**If issue number is provided as argument:**
- Use `{{arg1}}` as the issue number

**If no argument provided:**
- Ask user for the issue number to validate

Fetch complete issue details:

```bash
gh issue view {{ISSUE_NUMBER}} --json number,title,body,state,labels,milestone,assignees,comments
```

**Error Handling:**
- If issue not found: Verify issue number and repository
- If not in git repo: Ask user to specify repo with `-R owner/repo`

### 2. Present Issue Summary

Display issue details for validation:

```
═══════════════════════════════════════
ISSUE VALIDATION
═══════════════════════════════════════
Issue: #{{NUMBER}} - {{TITLE}}
State: {{STATE}}
Labels: {{LABELS or "None"}}
Milestone: {{MILESTONE or "None"}}
Assignees: {{ASSIGNEES or "None"}}

───────────────────────────────────────
ISSUE BODY:
───────────────────────────────────────
{{FULL_BODY}}

═══════════════════════════════════════
```

### 3. Apply Definition of Ready Checklist

Systematically validate the issue against Definition of Ready criteria:

#### A. Title Validation

```
TITLE VALIDATION:
─────────────────
Current: "{{TITLE}}"

[ ] Clear and specific (not vague)
[ ] Describes outcome, not implementation
[ ] Follows naming conventions
[ ] Actionable and concrete

Status: {{PASS/FAIL}}
{{If FAIL: Suggested improvements}}
```

#### B. Description Validation

```
DESCRIPTION VALIDATION:
───────────────────────
[ ] Problem/goal is clearly stated
[ ] Context explains why this is needed
[ ] Value/benefit is evident
[ ] Scope boundaries are defined

Status: {{PASS/FAIL}}
{{If FAIL: Missing elements}}
```

#### C. Acceptance Criteria Validation

```
ACCEPTANCE CRITERIA VALIDATION:
────────────────────────────────
{{Parse issue body for acceptance criteria}}

[ ] Acceptance criteria are present
[ ] Criteria are specific and testable
[ ] Criteria cover functional requirements
[ ] Criteria cover quality/non-functional requirements
[ ] Criteria use checkbox format for tracking
[ ] All edge cases are considered

Found {{N}} acceptance criteria:
{{List each criterion}}

Status: {{PASS/FAIL}}
{{If FAIL: What's missing or unclear}}
```

#### D. Technical Context Validation

```
TECHNICAL CONTEXT VALIDATION:
──────────────────────────────
[ ] Affected components/files identified
[ ] Dependencies are noted
[ ] Technical constraints are documented
[ ] Implementation hints provided (if needed)
[ ] Integration points identified

Status: {{PASS/FAIL}}
{{If FAIL: Missing technical context}}
```

#### E. Metadata Validation

```
METADATA VALIDATION:
────────────────────
[ ] Appropriate labels applied
[ ] Assigned to milestone (if applicable)
[ ] Priority is indicated
[ ] Type is clear (bug/feature/enhancement/etc.)

Current Labels: {{LABELS}}
Current Milestone: {{MILESTONE}}

Status: {{PASS/FAIL}}
{{If FAIL: Missing or incorrect metadata}}
```

#### F. Dependencies Validation

```
DEPENDENCIES VALIDATION:
────────────────────────
[ ] Dependencies on other issues identified
[ ] Blocking relationships documented
[ ] External dependencies noted
[ ] All dependencies are actionable

Status: {{PASS/FAIL}}
{{If FAIL: Unclear or missing dependencies}}
```

#### G. Size and Scope Validation

```
SIZE AND SCOPE VALIDATION:
──────────────────────────
[ ] Issue is appropriately sized (not too large)
[ ] Issue can be completed in a single session/sprint
[ ] Issue has clear boundaries
[ ] If too large, can be broken down

Status: {{PASS/FAIL}}
{{If FAIL: Issue too large, suggest breaking down}}
```

### 4. Overall Validation Summary

Present consolidated validation results:

```
═══════════════════════════════════════
VALIDATION SUMMARY
═══════════════════════════════════════
Issue: #{{NUMBER}} - {{TITLE}}

VALIDATION RESULTS:
✅ Title: {{PASS/FAIL}}
{{✅/❌}} Description: {{PASS/FAIL}}
{{✅/❌}} Acceptance Criteria: {{PASS/FAIL}}
{{✅/❌}} Technical Context: {{PASS/FAIL}}
{{✅/❌}} Metadata: {{PASS/FAIL}}
{{✅/❌}} Dependencies: {{PASS/FAIL}}
{{✅/❌}} Size and Scope: {{PASS/FAIL}}

───────────────────────────────────────
OVERALL: {{✅ READY / ⚠️ NEEDS WORK / ❌ NOT READY}}
───────────────────────────────────────

{{If READY}}:
✅ This issue meets Definition of Ready criteria and is ready for implementation.

{{If NEEDS WORK}}:
⚠️  This issue needs minor improvements:
{{List specific items to address}}

{{If NOT READY}}:
❌ This issue is not ready for implementation. Critical gaps:
{{List blocking issues}}

═══════════════════════════════════════
```

### 5. Provide Recommendations

Based on validation results, provide actionable recommendations:

**If issue is READY:**
```
✅ Issue #{{NUMBER}} is ready!

Next Steps:
- Start work: /gh-work {{NUMBER}}
- Assign to yourself: gh issue edit {{NUMBER}} --add-assignee @me
- Begin implementation following acceptance criteria
```

**If issue NEEDS WORK:**
```
⚠️  Issue #{{NUMBER}} needs improvements:

Recommended Actions:
{{For each failing criterion:}}
1. {{Action to address the gap}}
   Suggestion: {{Specific recommendation}}

Would you like to:
1. Review and update the issue: /gh-review-issue {{NUMBER}}
2. Add missing information manually
3. Proceed anyway (not recommended)
```

**If issue is NOT READY:**
```
❌ Issue #{{NUMBER}} has critical gaps and should not be started yet.

BLOCKING ISSUES:
{{List each critical gap}}

Required Actions:
{{For each blocking issue:}}
1. {{Required action}}
   Impact: {{Why this blocks implementation}}

Recommended Workflow:
1. Review issue: /gh-review-issue {{NUMBER}}
2. Address all blocking issues
3. Re-validate: /gh-validate-issue {{NUMBER}}
4. Only start work when validation passes
```

### 6. Ask for Next Action

```
What would you like to do?
1. Review and fix issues: /gh-review-issue {{NUMBER}}
2. Accept and start work anyway: /gh-work {{NUMBER}}
3. Re-validate after manual changes: /gh-validate-issue {{NUMBER}}
4. Close this validation session
```

**STOP and wait for user input.**

## Tool Preferences

- **Primary:** Use `gh` CLI for all GitHub operations
- **Fallback:** Only use MCP GitHub tools if `gh` CLI cannot accomplish the task
- **Reason:** `gh` CLI is lighter on tokens and context

## Error Handling

**Not in a git repository:**
```
⚠️  Not in a git repository.
Please navigate to your repository or specify: -R owner/repo
Example: /gh-validate-issue 42 -R macjunkins/project
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

Closed issues don't need validation for implementation,
but you can still validate for historical review.

Should I proceed with validation?
```

**GitHub authentication failure:**
```
❌ GitHub CLI authentication failed.
Run: gh auth login
Then retry this command.
```

## Definition of Ready Criteria

### Core Requirements (Must Have)

**1. Clear Title:**
- Specific and unambiguous
- Actionable (describes outcome)
- Follows project conventions

**2. Defined Problem/Goal:**
- Why this work is needed
- What value it delivers
- Who benefits

**3. Testable Acceptance Criteria:**
- Specific and measurable
- Covers functional requirements
- Covers quality requirements
- Uses checkbox format

**4. Technical Context:**
- Affected components identified
- Constraints documented
- Integration points noted

**5. Appropriate Metadata:**
- Type labeled (bug/feature/etc.)
- Priority indicated
- Milestone assigned (if applicable)

### Additional Considerations (Should Have)

**6. Dependencies:**
- Blocking issues identified
- External dependencies noted
- All dependencies are clear

**7. Appropriate Scope:**
- Not too large to complete
- Has clear boundaries
- Can be tested independently

## Validation Strictness Levels

The validation can be applied with different strictness:

**Strict (Default):**
- All criteria must pass
- Any failures block implementation
- Recommended for critical work

**Moderate:**
- Core requirements must pass
- Minor gaps noted but not blocking
- Acceptable for less critical work

**Lenient:**
- Only critical gaps block
- Many warnings acceptable
- Use sparingly, for experimental work

**User can specify strictness as argument:**
```
/gh-validate-issue 42 --strict
/gh-validate-issue 42 --moderate
/gh-validate-issue 42 --lenient
```

Default is moderate if not specified.

## Notes

- The `gh` CLI automatically infers repository from git context
- This command works globally across any git repository
- Validation prevents wasted effort on unclear issues
- Issues can be re-validated after updates
- If not in a git repo, specify: `-R owner/repo`

## Philosophy

**Definition of Ready as quality gate:**
- Prevents starting work on unclear requirements
- Reduces implementation churn and rework
- Ensures team alignment before coding
- Makes acceptance easier (criteria pre-defined)
- Improves estimation accuracy
- Reduces back-and-forth during implementation

## Usage Examples

**Example 1 - Issue passes validation:**
```
User: /gh-validate-issue 42
Assistant: [Fetches issue, applies checklist]

VALIDATION SUMMARY:
✅ Title: PASS
✅ Description: PASS
✅ Acceptance Criteria: PASS (5 criteria found)
✅ Technical Context: PASS
✅ Metadata: PASS
✅ Dependencies: PASS (depends on #40)
✅ Size and Scope: PASS

OVERALL: ✅ READY

✅ Issue #42 is ready for implementation!

User: Great, start work
Assistant: [Launches /gh-work 42]
```

**Example 2 - Issue needs work:**
```
User: /gh-validate-issue 18
Assistant: [Validates]

VALIDATION SUMMARY:
✅ Title: PASS
✅ Description: PASS
❌ Acceptance Criteria: FAIL (too vague, not testable)
✅ Technical Context: PASS
⚠️  Metadata: NEEDS WORK (no labels)
✅ Dependencies: PASS
✅ Size and Scope: PASS

OVERALL: ⚠️ NEEDS WORK

Recommended Actions:
1. Add specific, testable acceptance criteria
2. Add type label (bug/feature/enhancement)

Would you like to review and update?
User: Yes
Assistant: [Launches /gh-review-issue 18]
```

**Example 3 - Issue not ready:**
```
User: /gh-validate-issue 7
Assistant: [Validates]

VALIDATION SUMMARY:
⚠️  Title: NEEDS WORK (too vague)
❌ Description: FAIL (missing context)
❌ Acceptance Criteria: FAIL (not present)
❌ Technical Context: FAIL (missing)
✅ Metadata: PASS
⚠️  Dependencies: NEEDS WORK (unclear)
❌ Size and Scope: FAIL (too large)

OVERALL: ❌ NOT READY

BLOCKING ISSUES:
- No acceptance criteria defined
- Missing technical context
- Issue scope is too large (needs breakdown)

This issue should not be started yet.
```

**Example 4 - Re-validate after updates:**
```
User: /gh-validate-issue 15
Assistant: ⚠️ NEEDS WORK
User: [Updates issue]
User: /gh-validate-issue 15
Assistant: ✅ READY
All issues addressed! Ready for implementation.
```

**Example 5 - Different repository:**
```
User: /gh-validate-issue 99 -R macjunkins/other-repo
Assistant: [Same workflow but uses -R flag for all gh commands]
```

## Integration with Workflow

This command fits into the issue lifecycle:

1. **Create issue:** `/create-issue` or `/gh-next-issue`
2. **Validate readiness:** `/gh-validate-issue <number>` ← This command
3. **If not ready:** `/gh-review-issue <number>` to fix
4. **Re-validate:** `/gh-validate-issue <number>`
5. **When ready:** `/gh-work <number>` to start implementation
6. **Track progress:** `/gh-update-issue <number>`
7. **Complete:** `/gh-finish <number>`
