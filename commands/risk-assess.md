# Risk Assessment Command

You create a complete risk assessment for a GitHub issue and publish it directly inside GitHub (issue comment by default, milestone description optional).

## Workflow

### 1. Gather Inputs
- Expect `{{arg1}}` to be the GitHub issue number; prompt if missing.
- Optional flags you can accept:
  - `-R owner/repo` when working outside of a checked-out repo.
  - `--date YYYY-MM-DD` to override the report date (defaults to today).
  - `--target issue|milestone` to choose the publication channel (default: `issue`).
  - `--milestone-number N` when publishing to a specific milestone (defaults to the issue’s milestone if one exists).
- Remind the user that all outputs stay in GitHub; no repository files are modified.

### 2. Fetch GitHub Context
1. Issue snapshot (always):
   ```bash
   gh issue view {{ISSUE}} {{REPO_FLAG}} \
     --json number,title,body,labels,assignees,milestone,projectCards,state,url,comments
   ```
2. When a milestone is present or requested:
   ```bash
   gh milestone view "{{MILESTONE_TITLE}}" {{REPO_FLAG}} \
     --json number,title,description,dueOn,state,url
   ```
3. Ask for additional linked issues/PRs that influence risk if they are not referenced in the body.

### 3. Parse Requirements & Risk Inputs
- Pull acceptance criteria, dependencies, platform targets, and scope notes from the issue.
- Identify Flutter/Dart signals (platform channels, plugin usage, build/performance expectations) to expand the risk catalog later.
- Record any referenced GitHub work items for traceability.

### 4. Build the Assessment
- Fill out the embedded template with:
  - Executive summary (posture, top drivers, action).
  - Scope details, milestones, and linked work.
  - Risk catalog including Flutter/Dart categories (platform channels, plugin compatibility, state management, performance, etc.).
  - Mitigations, testing strategy, residual risk.
- Keep the template self-contained—do not reference external BMAD assets or docs directories.

### 5. Publish the Assessment
- Confirm the publication channel with the user (issue comment is default).
- **Issue Comment (default):**
  ```bash
  gh issue comment {{ISSUE}} {{REPO_FLAG}} --body "$(cat <<'EOF'
  {{RISK_ASSESSMENT_TEMPLATE}}
  EOF
  )"
  ```
- **Milestone Description (when `--target milestone` or user preference):**
  1. Locate the milestone number (from `gh issue view` milestone JSON or `--milestone-number`).
  2. Patch the milestone description with the filled template:
     ```bash
     OWNER=$(gh repo view {{REPO_FLAG}} --json owner -q .owner.login)
     REPO=$(gh repo view {{REPO_FLAG}} --json name -q .name)
     gh api \
       --method PATCH \
       -H "Accept: application/vnd.github+json" \
       /repos/$OWNER/$REPO/milestones/{{MILESTONE_NUMBER}} \
       -f description="$(cat <<'EOF'
     {{RISK_ASSESSMENT_TEMPLATE}}
     EOF
     )"
     ```
  3. Share the updated milestone URL with the team.
- Do not write assessment artifacts to `docs/` or other project directories.

### 6. Review with the User
- Summarize critical risks, mitigations, and Flutter/Dart focus points.
- Confirm the comment or milestone description rendered correctly.
- Capture any follow-up actions and remind the user where the assessment now lives in GitHub history.

## Embedded Template (`{{RISK_ASSESSMENT_TEMPLATE}}`)

```markdown
# Risk Assessment – {{ISSUE_REF}} {{TITLE}}

Generated: {{DATE}}  
Source Issue: {{ISSUE_URL}}  
Milestone: {{MILESTONE_TITLE or "None"}}

## Executive Summary

- **Overall Risk Posture:** {{OVERALL_RISK}}  
- **Primary Drivers:** {{TOP_DRIVERS}}  
- **Recommended Action:** {{ACTION_SUMMARY}}

## Context

### Issue Snapshot
- State: {{STATE}}
- Labels: {{LABELS}}
- Assignees: {{ASSIGNEES}}
- Linked Work: {{LINKED_ITEMS}}

### Scope & Requirements
- Story Goal: {{STORY_GOAL}}
- Key Acceptance Criteria:
  {{#AC_LIST}}
  - {{ITEM}}
  {{/AC_LIST}}
- Dependencies & Constraints: {{DEPENDENCIES}}

### Epic / Milestone Notes
{{MILESTONE_NOTES}}

## Risk Catalog

| ID | Category | Risk | Probability | Impact | Score | Mitigation | Contingency | Detection |
|----|----------|------|-------------|--------|-------|------------|-------------|-----------|
| {{RISK_ROWS}} |

**Scoring:** Probability × Impact (1–3). Critical ≥9, High =6, Medium =4, Low =2–3, Minimal =1.

### Category Guidance

- **TECH – Technical Risks:** architecture complexity, integration issues, legacy coupling.
- **SEC – Security Risks:** auth gaps, data exposure, compliance obligations.
- **PERF – Performance Risks:** regressions, resource contention, latency budgets.
- **DATA – Data Risks:** integrity, migration, retention/privacy considerations.
- **BUS – Business Risks:** customer impact, KPI degradation, revenue exposure.
- **OPS – Operational Risks:** deployment, monitoring, on-call readiness, documentation debt.
- **FLUTTER – Flutter/Dart Focus Areas:** platform channel integration, plugin compatibility, Dart package drift, state management churn, build/performance (AOT size, CI duration).

## Risk Matrix

```text
          Impact
        1   2   3
Prob 3  {{MATRIX_3_1}} {{MATRIX_3_2}} {{MATRIX_3_3}}
     2  {{MATRIX_2_1}} {{MATRIX_2_2}} {{MATRIX_2_3}}
     1  {{MATRIX_1_1}} {{MATRIX_1_2}} {{MATRIX_1_3}}
```

## Mitigation Plan

- Immediate Mitigations: {{IMMEDIATE_ACTIONS}}
- Preventative Controls: {{PREVENTATIVE_CONTROLS}}
- Monitoring & Telemetry: {{MONITORING_PLAN}}

## Risk-Based Testing Strategy

1. **Critical Risks:** {{CRITICAL_TESTS}}
2. **High Risks:** {{HIGH_TESTS}}
3. **Medium/Low Risks:** {{MEDIUM_TESTS}}

Include Flutter/Dart checks where relevant (e.g., `flutter analyze`, integration tests per platform, benchmark runs).

## Residual Risk & Acceptance

- Risks accepted (with rationale): {{ACCEPTED_RISKS}}
- Risks needing escalation: {{ESCALATIONS}}
- Decision Owner / Sign-off: {{SIGN_OFF}}

## Next Steps

1. {{NEXT_STEP_1}}
2. {{NEXT_STEP_2}}
3. {{NEXT_STEP_3}}

---
<!-- Posted as a GitHub issue comment or milestone description per selection. -->
```

## Reminders
- Publish inside GitHub only—no standalone documents.
- Keep this command self-contained; never depend on `.bmad-core/` assets.
- Ensure Flutter/Dart risk considerations are always covered where relevant.
- Test end-to-end by running the command against a real issue and (if possible) a milestone update.
