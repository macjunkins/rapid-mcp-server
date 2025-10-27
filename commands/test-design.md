# Test Design Command

You design a complete testing strategy for a GitHub issue, capture it as project documentation, open a linked execution issue, and leave a traceable comment on the source ticket.

## Workflow

### 1. Gather Inputs
- Expect `{{arg1}}` to be the GitHub issue number. If missing, ask for it before continuing.
- Support optional flags:
  - `-R owner/repo` for repos outside the current git workspace.
  - `--out PATH` to override the output directory (default: `docs/qa/assessments/`).
- Capture today’s date (`YYYY-MM-DD`) and derive a slug from the issue title (`kebab-case`); use these when naming files and labels.

### 2. Fetch GitHub Context
Run:
```bash
gh issue view {{ISSUE}} {{REPO_FLAG}} --json number,title,body,labels,assignees,milestone,projectCards,state,url
```

From the response:
- Pull acceptance criteria, task lists, and explicit requirements.
- Note linked issues/PRs for risk and dependency context.
- Detect Flutter/Dart cues (widgets, platform integrations, performance limits) to drive specialized test coverage.
- Record milestone and labels for later reuse.

### 3. Plan Test Coverage
Break the issue down into testable units:
1. **Acceptance Criteria Mapping** – Ensure every AC has at least one scenario; highlight gaps.
2. **Test Levels** – Classify each scenario as `unit`, `widget`, `integration`, `e2e`, or specialized Flutter checks (golden tests, platform channels, performance benchmarks).
3. **Priorities** – Assign P0–P3 urgency using risk, user impact, and compliance cues.
4. **Risk Alignment** – Tie scenarios to known risks or linked issues; note mitigations.

### 4. Generate Test Design Artifact
Write the plan to:
```
{{OUTPUT_DIR}}/issue-{{ISSUE}}-test-design-{{DATE}}.md
```

Use the embedded template:
```markdown
# Test Design – Issue #{{ISSUE}} {{TITLE}}

Date: {{DATE}}  
Designer: {{AUTHOR}}  
Source Issue: {{ISSUE_URL}}  
Milestone: {{MILESTONE or "None"}}  
Assignees: {{ASSIGNEES or "Unassigned"}}

## Overview

- Total scenarios: {{TOTAL_SCENARIOS}}
- Level mix: Unit {{UNIT_COUNT}}, Widget {{WIDGET_COUNT}}, Integration {{INT_COUNT}}, E2E {{E2E_COUNT}}, Other {{OTHER_COUNT}}
- Priority mix: P0 {{P0_COUNT}}, P1 {{P1_COUNT}}, P2 {{P2_COUNT}}, P3 {{P3_COUNT}}
- Flutter/Dart focus: {{FLUTTER_NOTES}}

## Acceptance Criteria Coverage

{{#AC_LIST}}
### {{AC_HEADING}}
- Goal: {{AC_DESCRIPTION}}
- Notes: {{AC_NOTES}}

| ID | Level | Priority | Scenario | Justification | Related Risks |
|----|-------|----------|----------|---------------|---------------|
{{#SCENARIOS}}
| {{ID}} | {{LEVEL}} | {{PRIORITY}} | {{DESCRIPTION}} | {{JUSTIFICATION}} | {{RISKS}} |
{{/SCENARIOS}}

{{/AC_LIST}}

## Risk-Based Testing Addendum

- High-risk areas: {{HIGH_RISKS}}
- Mitigations via tests: {{MITIGATIONS}}
- Dependencies & blockers: {{DEPENDENCIES}}

## Flutter/Dart Guidance

1. Run `flutter analyze` and `dart test`.
2. Add widget tests for UI state changes (`flutter test --platform chrome` as needed).
3. For platform channels, include integration tests per target platform.
4. Capture performance baselines with `flutter drive` or `flutter run --profile`.
5. Track golden images if UI regressions are critical.

## Execution Checklist

- [ ] All P0 scenarios implemented
- [ ] All P1 scenarios implemented
- [ ] Required tooling/fixtures committed
- [ ] Coverage thresholds validated
- [ ] Results reported back on Issue #{{ISSUE}}

## Gate YAML Snippet

```yaml
test_design:
  scenarios_total: {{TOTAL_SCENARIOS}}
  by_level:
    unit: {{UNIT_COUNT}}
    widget: {{WIDGET_COUNT}}
    integration: {{INT_COUNT}}
    e2e: {{E2E_COUNT}}
    other: {{OTHER_COUNT}}
  by_priority:
    p0: {{P0_COUNT}}
    p1: {{P1_COUNT}}
    p2: {{P2_COUNT}}
    p3: {{P3_COUNT}}
  coverage_gaps: {{COVERAGE_GAPS}} # [] if none
```

---
<!-- Generated via /test-design. -->
```

### 5. Create Execution Issue
Open a sibling issue dedicated to implementing the tests:
```bash
gh issue create {{REPO_FLAG}} \
  --title "Test Execution: {{TITLE}}" \
  --body "$(cat <<'EOF'
## Summary
Implements the test scenarios defined in [issue-{{ISSUE}}-test-design-{{DATE}}.md]({{REPO_RELATIVE_PATH}})

## Linked Work
- Source issue: #{{ISSUE}}
- Test design artifact: {{REPO_RELATIVE_PATH}}

## TODO
{{#SCENARIOS}}
- [ ] Implement {{ID}} ({{LEVEL}}, {{PRIORITY}})
{{/SCENARIOS}}

## Notes
- Follow Flutter/Dart guidance in the design document.
- Post completion results back on #{{ISSUE}}.
EOF
)" \
  --label "qa" --label "testing" \
  --json number,url
```

Store the returned `number` and `url` for the next step.

### 6. Comment on Source Issue
Leave a traceable comment on the original issue:
```bash
gh issue comment {{ISSUE}} {{REPO_FLAG}} --body "$(cat <<'EOF'
### Test Design Added
- Design document: [issue-{{ISSUE}}-test-design-{{DATE}}.md]({{REPO_RELATIVE_PATH}})
- Execution issue: #{{TEST_ISSUE_NUMBER}} ({{TEST_ISSUE_URL}})

```yaml
{{GATE_YAML_BLOCK}}
```

_Generated via `/test-design`._
EOF
)"
```

### 7. Present Results
Summarize for the user:
- File path of the test design document.
- New execution issue number and URL.
- Reminder to copy the gate YAML into the QA gate file if needed.
- Any Flutter/Dart follow-ups or blockers discovered during planning.

## Guardrails
- Do **not** mutate code or tests; this command is planning/documentation only.
- Abort if `gh` commands fail due to authentication or context; surface the error and ask the user to resolve.
- Keep all paths project-relative; never reference `.bmad-core/`.
- Ensure identifiers are stable to support automation (issue IDs, slugs, filenames).
