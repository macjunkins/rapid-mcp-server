# NFR Assessment Command

You evaluate non-functional requirements for a GitHub issue, capture the findings as Markdown, produce a gate-ready YAML block, and report the results to the team.

## Workflow

### 1. Gather Inputs
- `{{arg1}}` should be the GitHub issue number to assess; prompt if missing.
- Optional flags:
  - `-R owner/repo` for remote repositories.
  - `--out PATH` to override the default output directory (`docs/qa/assessments/`).
  - `--nfr security,performance,...` to pre-select focus areas (comma-separated).
- Record today’s date and derive a slugged title for filenames.

### 2. Fetch Context
```bash
gh issue view {{ISSUE}} {{REPO_FLAG}} --json number,title,state,body,labels,assignees,milestone,url
```

Also gather supporting material when available:
- Architecture docs (`docs/architecture/*.md`).
- Technical preferences (`docs/technical-preferences.md`).
- Existing performance dashboards or monitoring notes.
- Latest test design document (to align coverage).

### 3. Select NFR Dimensions
- Default set: security, performance, reliability, maintainability.
- Allow the user to add extras (usability, accessibility, compatibility, portability, scalability, observability).
- For each selected dimension, capture target thresholds (e.g., response time, availability, error budget). Prompt if missing; mark as “Target unknown” when no answer.

### 4. Evaluate Evidence
For each NFR:
- Inspect code, configuration, tests, and documentation.
- Note proof of compliance (logs, metrics, test suites, security reviews).
- Identify gaps or risks.
- Pay special attention to Flutter/Dart specifics:
  - Security: secret management, platform channel permissions.
  - Performance: frame build times, memory usage, asset sizes, JIT vs AOT.
  - Reliability: crash reporting, retry logic, offline support.
  - Maintainability: modular architecture, static analysis rules, test coverage.

### 5. Generate Assessment Report
Save to:
```
{{OUTPUT_DIR}}/issue-{{ISSUE}}-nfr-{{DATE}}.md
```

Populate this template:
```markdown
# NFR Assessment – Issue #{{ISSUE}} {{TITLE}}

Date: {{DATE}}  
Reviewer: {{REVIEWER}}  
Source Issue: {{ISSUE_URL}}  
Milestone: {{MILESTONE or "None"}}

## Summary

- Overall quality score: {{QUALITY_SCORE}}/100
- Key risks: {{KEY_RISKS}}
- Recommended action: {{RECOMMENDATION}}

## Dimension Findings

{{#DIMENSIONS}}
### {{NAME | Title Case}}
- Status: {{STATUS}} # PASS|CONCERNS|FAIL
- Target: {{TARGET or "Target unknown"}}
- Evidence:
  - {{EVIDENCE_1}}
  - {{EVIDENCE_2}}
- Gaps:
  - {{GAP_1}}
  - {{GAP_2}}
- Mitigations:
  - {{MITIGATION_1}}
  - {{MITIGATION_2}}

{{/DIMENSIONS}}

## Flutter/Dart Checklist

- Analyzer clean (`flutter analyze`): {{FLUTTER_ANALYZE_STATUS}}
- Widget tests present: {{WIDGET_TESTS_STATUS}}
- Integration tests per platform: {{INTEGRATION_STATUS}}
- Performance profiling captured: {{PERFORMANCE_STATUS}}
- AOT build size within target: {{AOT_STATUS}}

## Critical Issues

{{#CRITICAL_ISSUES}}
1. **{{TITLE}}** ({{DIMENSION}})  
   - Risk: {{RISK}}  
   - Impact: {{IMPACT}}  
   - Required action: {{ACTION}}
{{/CRITICAL_ISSUES}}
{{^CRITICAL_ISSUES}}
None identified.
{{/CRITICAL_ISSUES}}

## Next Steps

1. {{NEXT_STEP_1}}
2. {{NEXT_STEP_2}}
3. {{NEXT_STEP_3}}

---
<!-- Generated via /nfr-assess. -->
```

### 6. Build Gate YAML Block
Provide this snippet for `/qa-gate` consumers:
```yaml
nfr_validation:
  assessed: {{ASSESSED_LIST}}
  quality_score: {{QUALITY_SCORE}}
{{#DIMENSIONS}}
  {{KEY}}:
    status: {{STATUS}}
    notes: "{{NOTES}}"
    target: "{{TARGET or "Unknown"}}"
{{/DIMENSIONS}}
```

### 7. Comment on the Issue
```bash
gh issue comment {{ISSUE}} {{REPO_FLAG}} --body "$(cat <<'EOF'
### NFR Assessment Posted
- Report: [issue-{{ISSUE}}-nfr-{{DATE}}.md]({{REPO_RELATIVE_PATH}})
- Dimensions assessed: {{ASSESSED_LIST}}
- Quality score: {{QUALITY_SCORE}}/100

```yaml
{{GATE_YAML_BLOCK}}
```

_Generated via `/nfr-assess`._
EOF
)"
```

### 8. Summarize for the User
- Path to the assessment report.
- Key gaps or risks discovered.
- Recommendations for development and QA follow-up.
- Flutter/Dart items requiring immediate attention.

## Guardrails
- Keep assessments evidence-based; document sources or note “evidence missing”.
- If severe gaps exist, mark status as FAIL or CONCERNS—avoid optimistic PASS.
- Do not modify code; suggest actions instead.
- Ensure instructions remain self-contained with no `.bmad-core/` references.
