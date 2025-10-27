# Traceability Matrix Command

You generate a requirements traceability matrix for a GitHub issue and publish it directly inside GitHub (issue comment by default, milestone description optional).

## Workflow

### 1. Gather Inputs
- Expect `{{arg1}}` to be the GitHub issue number; ask for it if missing.
- Supported flags:
  - `-R owner/repo` when you are outside the repo workspace.
  - `--date YYYY-MM-DD` to override the report date (default: today).
  - `--target issue|milestone` to choose the publication channel (default: `issue`).
  - `--milestone-number N` to explicitly target a milestone (uses the issue milestone when omitted).
- Remind the user that the traceability matrix stays in GitHub—no repository files or docs directories are touched.

### 2. Fetch GitHub Data
1. Issue context (always):
   ```bash
   gh issue view {{ISSUE}} {{REPO_FLAG}} \
     --json number,title,body,labels,assignees,milestone,projectCards,state,url,comments
   ```
2. Milestone (when present or explicitly requested):
   ```bash
   gh milestone view "{{MILESTONE_TITLE}}" {{REPO_FLAG}} \
     --json number,title,description,dueOn,state,url
   ```
3. Ask the user for additional linked issues/PRs if the trace needs broader coverage.

### 3. Extract Requirements
- Normalize acceptance criteria, checklists, and user needs into atomic requirements (AC1, AC2, ...).
- Capture non-functional and quality attributes (performance, security, accessibility, localization).
- Note Flutter/Dart-specific elements (state management, platform channels, plugin dependencies, build/performance constraints).
- Gather current verification artifacts (tests, automation jobs, manual evidence) from issue comments or linked work.

### 4. Build the Traceability Matrix
- Populate the embedded template:
  - Fill coverage totals, YAML summary, and requirement details.
  - Map each requirement to tests and related GitHub items.
  - Highlight Flutter/Dart considerations for each requirement and in the global checks section.
- Keep the template self-contained; never refer to BMAD files or extra directories.

### 5. Publish the Matrix
- Confirm the publishing target (issue comment default).
- **Issue Comment (default):**
  ```bash
  gh issue comment {{ISSUE}} {{REPO_FLAG}} --body "$(cat <<'EOF'
  {{TRACEABILITY_TEMPLATE}}
  EOF
  )"
  ```
- **Milestone Description (when `--target milestone` or user preference):**
  1. Determine the milestone number.
  2. Patch the milestone description with the filled template:
     ```bash
     OWNER=$(gh repo view {{REPO_FLAG}} --json owner -q .owner.login)
     REPO=$(gh repo view {{REPO_FLAG}} --json name -q .name)
     gh api \
       --method PATCH \
       -H "Accept: application/vnd.github+json" \
       /repos/$OWNER/$REPO/milestones/{{MILESTONE_NUMBER}} \
       -f description="$(cat <<'EOF'
     {{TRACEABILITY_TEMPLATE}}
     EOF
     )"
     ```
  3. Share the milestone URL with stakeholders so the matrix is easy to locate.
- Never write the matrix to `docs/analysis/` or other repository files.

### 6. Present Results
- Summarize total requirements, coverage ratios, and the most critical gaps.
- Call out Flutter/Dart coverage status (widget tests, platform channels, plugin risk, build/perf).
- Confirm the GitHub comment or milestone description renders as expected and capture any follow-up tasks.

## Embedded Template (`{{TRACEABILITY_TEMPLATE}}`)

```markdown
# Requirements Traceability Matrix – {{ISSUE_REF}} {{TITLE}}

Generated: {{DATE}}  
Source Issue: {{ISSUE_URL}}  
Milestone: {{MILESTONE_TITLE or "None"}}

## Coverage Summary

- Total Requirements: {{TOTAL_REQ}}
- Fully Covered: {{FULL_COUNT}} ({{FULL_PCT}}%)
- Partially Covered: {{PARTIAL_COUNT}} ({{PARTIAL_PCT}}%)
- Not Covered: {{NONE_COUNT}} ({{NONE_PCT}}%)

### YAML Summary Block

```yaml
trace:
  totals:
    requirements: {{TOTAL_REQ}}
    full: {{FULL_COUNT}}
    partial: {{PARTIAL_COUNT}}
    none: {{NONE_COUNT}}
  planning_ref: "{{PLANNING_REF}}"
  uncovered:
    {{#UNCOVERED_LIST}}
    - requirement: "{{REQ_ID}}"
      reason: "{{GAP_REASON}}"
      suggested_test: "{{SUGGESTED_TEST}}"
    {{/UNCOVERED_LIST}}
  notes: "See {{ISSUE_URL}}"
```

## Requirement Coverage Details

{{#REQUIREMENTS}}
### {{REQ_ID}}: {{REQ_TITLE}}

- Source: {{SOURCE}}
- Acceptance Criterion: {{AC_TEXT}}
- Criticality: {{CRITICALITY}}
- Coverage: **{{COVERAGE_LEVEL}}**
- Related GitHub Items: {{RELATED_ITEMS}}

#### Test Mappings
| Test Type | Location | Given | When | Then | Coverage |
|-----------|----------|-------|------|------|----------|
| {{TEST_ROWS}} |

##### Notes
- Gaps: {{GAPS}}
- Flutter/Dart Considerations: {{FLUTTER_NOTES}}

---
{{/REQUIREMENTS}}

## Coverage Gaps & Risks

| Requirement | Gap | Severity | Suggested Test | Owner |
|-------------|-----|----------|----------------|-------|
| {{GAP_ROWS}} |

## Recommendations

1. {{RECOMMENDATION_1}}
2. {{RECOMMENDATION_2}}
3. {{RECOMMENDATION_3}}

### Flutter/Dart Focus Checks
- Widget testing coverage: {{WIDGET_STATUS}}
- Platform channel validation: {{CHANNEL_STATUS}}
- Plugin compatibility notes: {{PLUGIN_STATUS}}
- Build & performance checks: {{BUILD_STATUS}}

## Next Actions

1. {{NEXT_STEP_1}}
2. {{NEXT_STEP_2}}
3. {{NEXT_STEP_3}}

<!-- Posted as a GitHub issue comment or milestone description per selection. -->
```

## Reminders
- Publish traceability insights in GitHub (issue or milestone) only.
- No `.bmad-core/` references or external template dependencies.
- Validate the command by running it end-to-end against a real issue and milestone scenario.
