# Course Correction Command

You run a structured course-correction analysis and publish the sprint change proposal directly inside GitHub (issue comment by default, milestone description optional).

## Workflow

### 1. Confirm Task & Inputs
- Identify the course-correction trigger (GitHub issue, incident ticket, user feedback). Expect `{{arg1}}` to be the GitHub issue number when the trigger is an issue; prompt if missing.
- Support optional flags:
  - `-R owner/repo` for remote repositories.
  - `--target issue|milestone` to choose the publication channel (default: `issue`).
  - `--milestone-number N` to override the milestone target when publishing there.
- Collect essentials:
  - Problem summary and urgency.
  - Desired outcome and constraints (timeline, scope, stakeholders).
  - Associated milestones or epics.
- Agree on collaboration mode:
  1. **Incremental (default):** Walk through the checklist interactively.
  2. **Batch:** Gather inputs up front and return a consolidated proposal.

### 2. Collect GitHub Context
- Issue context (when triggered by an issue):
  ```bash
  gh issue view {{ISSUE}} {{REPO_FLAG}} \
    --json number,title,body,labels,assignees,milestone,state,projectCards,comments,url
  ```
- Milestone context (if present or requested):
  ```bash
  gh milestone view "{{MILESTONE_TITLE}}" {{REPO_FLAG}} \
    --json number,title,description,dueOn,state,url
  ```
- Request any supplementary artifacts (architecture notes, PRs, QA results) via GitHub links rather than local file paths.

### 3. Execute the Embedded Checklist
- Work through Sections 1–4 of the checklist below.
- Capture findings, decisions, and follow-ups inline, marking items `[x]`, `[ ]`, or `[n/a]`.
- Surface Flutter/Dart considerations for each relevant area (state management, plugin compatibility, platform channels, build/performance impacts).

### 4. Draft the Course-Correction Proposal
- Translate checklist outcomes into concrete changes:
  - Updated scope or acceptance criteria.
  - Tasks/backlog items, documentation edits, diagram updates.
  - QA/test adjustments and telemetry updates.
- Consolidate everything inside the embedded proposal template—no external documents.

### 5. Publish the Proposal
- Confirm where to publish (issue comment default, milestone description optional via `--target milestone`).
- **Issue Comment (default):**
  ```bash
  gh issue comment {{ISSUE}} {{REPO_FLAG}} --body "$(cat <<'EOF'
  {{SPRINT_CHANGE_TEMPLATE}}
  EOF
  )"
  ```
- **Milestone Description (when `--target milestone` or user preference):**
  1. Determine the milestone number (from `gh issue view` or explicit flag).
  2. Update the milestone description:
     ```bash
     OWNER=$(gh repo view {{REPO_FLAG}} --json owner -q .owner.login)
     REPO=$(gh repo view {{REPO_FLAG}} --json name -q .name)
     gh api \
       --method PATCH \
       -H "Accept: application/vnd.github+json" \
       /repos/$OWNER/$REPO/milestones/{{MILESTONE_NUMBER}} \
       -f description="$(cat <<'EOF'
     {{SPRINT_CHANGE_TEMPLATE}}
     EOF
     )"
     ```
  3. Share the milestone URL as the durable record.
- Never write proposals to README or other repository files.

### 6. Review & Follow Through
- Provide a concise briefing: key decisions, recommended path, Flutter/Dart impacts, required approvals.
- Confirm the GitHub comment or milestone description rendered correctly.
- Capture next steps, owners, and timelines directly in the published artifact.

## Embedded Checklist

```markdown
## Course Correction Checklist

### 1. Change Context
- [ ] Confirm change trigger and urgency
- [ ] Identify stakeholders and decision owners
- [ ] Capture success criteria for the correction
- [ ] Note time or release constraints

### 2. Impact Analysis
- [ ] Affected epics/milestones
- [ ] Impacted issues or backlog items
- [ ] Architecture/tech debt implications
- [ ] Flutter/Dart considerations (state management, plugin compat, platform channels, build/perf)
- [ ] QA/testing implications

### 3. Artifact Review
- [ ] Documents that require updates (PRD, architecture, runbooks)
- [ ] Diagrams or models needing revision
- [ ] Test plans or automation impacted
- [ ] Monitoring/alerting adjustments

### 4. Path Evaluation
- [ ] Options explored (rollback, scope adjust, redesign)
- [ ] Risks for each option
- [ ] Recommended path with rationale
- [ ] Decision checkpoints or approvals required
```

## Embedded Template (`{{SPRINT_CHANGE_TEMPLATE}}`)

```markdown
# Sprint Change Proposal – {{CHANGE_TITLE}}

Generated: {{DATE}}  
Author: {{AUTHOR}}  
Source Trigger: {{TRIGGER_DESCRIPTION}}  
Linked Issue: {{ISSUE_URL or "N/A"}}  
Milestone: {{MILESTONE_TITLE or "None"}}

## 1. Executive Summary
- Problem Statement: {{PROBLEM_STATEMENT}}
- Urgency / Timing: {{URGENCY}}
- Recommended Path: {{RECOMMENDED_PATH}}
- Decision Owners: {{DECISION_OWNERS}}

## 2. Checklist Outcomes

### Change Context
{{CHECKLIST_CONTEXT_NOTES}}

### Impact Analysis
{{CHECKLIST_IMPACT_NOTES}}

### Artifact Review
{{CHECKLIST_ARTIFACT_NOTES}}

### Path Evaluation
{{CHECKLIST_PATH_NOTES}}

## 3. Proposed Changes

| Artifact | Current State | Proposed Update | Owner | Status |
|----------|---------------|----------------|-------|--------|
| {{PROPOSED_CHANGES_ROWS}} |

### Detailed Edits
{{#ARTIFACT_EDITS}}
#### {{ARTIFACT_NAME}}
- Location: {{LOCATION}}
- Update Type: {{UPDATE_TYPE}}
- Draft Text / Instructions:
```
{{DRAFT_CONTENT}}
```
- Flutter/Dart Implications: {{FLUTTER_IMPACTS}}
{{/ARTIFACT_EDITS}}

## 4. Risk & Mitigation
- Key Risks: {{KEY_RISKS}}
- Mitigation Plan: {{MITIGATION_PLAN}}
- Validation Steps: {{VALIDATION_STEPS}}

## 5. Implementation Plan
1. {{STEP_ONE}}
2. {{STEP_TWO}}
3. {{STEP_THREE}}

## 6. Approvals & Follow-up
- Required Approvals: {{APPROVALS}}
- Follow-up Actions: {{FOLLOW_UPS}}
- Target Review Date: {{REVIEW_DATE}}

<!-- Posted as a GitHub issue comment or milestone description per selection. -->
```

## Reminders
- Keep the workflow self-contained; do not reference `.bmad-core/` or local doc directories.
- Publish only inside GitHub (issue comment or milestone description).
- Ensure Flutter/Dart impacts are captured in both the checklist and proposal.
- Test this command end-to-end against an issue and a milestone scenario to confirm behavior.
