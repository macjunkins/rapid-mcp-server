# QA Gate Command

You evaluate delivery readiness for a GitHub issue, produce a formal quality gate YAML, and report the decision back to the team with full traceability.

## Workflow

### 1. Gather Inputs
- Expect `{{arg1}}` to be the GitHub issue number. Halt and ask for it if absent.
- Support optional flags:
  - `-R owner/repo` when working outside the current git repo.
  - `--out PATH` to override the gate directory (default: `docs/qa/gates/`).
  - `--design PATH` to link an existing test design file (optional).
  - `--nfr PATH` to link an existing NFR assessment file (optional).
- Capture today’s timestamp in ISO-8601 and derive a slug from the issue title (`kebab-case`) to keep outputs deterministic.

### 2. Fetch Source Context
Run:
```bash
gh issue view {{ISSUE}} {{REPO_FLAG}} --json number,title,state,labels,assignees,milestone,body,url,comments
```

From the response:
- Identify acceptance criteria, outstanding tasks, and linked blockers.
- Note milestone, assignees, and labels.
- Extract Flutter/Dart-specific cues (platform targets, performance goals, widget references) for targeted validation.
- Surface recent comments for QA signals (e.g., execution issue updates).

### 3. Collect Evidence
- Load referenced artifacts:
  - Test design markdown (`--design` flag or prompt for location). Confirm paths like `docs/qa/assessments/issue-{{ISSUE}}-test-design-*.md`.
  - NFR assessment markdown (`--nfr` flag or look up `issue-{{ISSUE}}-nfr-*.md`).
  - Execution issue status (if applicable) using `gh issue view`.
- Request additional evidence from the user when gaps appear (missing test runs, logs, screenshots).
- Expect proof of passing automation: `flutter test`, `dart test`, integration jobs, platform-specific checks.

### 4. Determine Gate Status
Choose one of:
- **PASS** – All acceptance criteria satisfied, evidence covers critical risks, no high-severity gaps.
- **CONCERNS** – Non-blocking issues remain, or evidence is incomplete.
- **FAIL** – Blocking defects, failing tests, or unmet acceptance criteria.
- **WAIVED** – Known gaps explicitly accepted; require approval details.

Severity guidance:
- `low` – cosmetic, tracked for follow-up.
- `medium` – meaningful but non-blocking; should be scheduled.
- `high` – release-blocking or critical risk; gate cannot PASS with unresolved `high`.

### 5. Generate Gate YAML
Save to:
```
{{OUTPUT_DIR}}/issue-{{ISSUE}}-{{SLUG}}-gate-{{DATE}}.yml
```

Use the embedded template:
```yaml
schema: 2
issue: {{ISSUE}}
title: "{{TITLE}}"
gate: {{GATE_STATUS}} # PASS|CONCERNS|FAIL|WAIVED
status_reason: "{{STATUS_REASON}}"
reviewer: {{REVIEWER}}
updated: "{{ISO_TIMESTAMP}}"
milestone: {{MILESTONE or null}}
assignees: {{ASSIGNEES_LIST}}
labels: {{LABELS_LIST}}
test_design:
  document: {{TEST_DESIGN_PATH or null}}
  scenarios_total: {{TOTAL_SCENARIOS}}
  coverage_gaps: {{COVERAGE_GAPS}}
nfr_validation:
  assessed: {{NFR_LIST}} # [] if none
  summary: {{NFR_SUMMARY}}
top_issues:
{{#TOP_ISSUES}}
  - id: "{{ID}}"
    severity: {{SEVERITY}} # low|medium|high
    finding: "{{FINDING}}"
    suggested_action: "{{ACTION}}"
{{/TOP_ISSUES}}
waiver:
  active: {{WAIVER_ACTIVE}} # true|false
  reason: "{{WAIVER_REASON}}"
  approved_by: "{{WAIVER_APPROVER}}"
flutter_focus:
  analyze_ran: {{FLUTTER_ANALYZE_STATUS}}
  widget_tests: {{WIDGET_TEST_STATUS}}
  integration_tests: {{INTEGRATION_STATUS}}
  performance_notes: "{{PERF_NOTES}}"
traceability:
  linked_issues: {{LINKED_ITEMS}}
  blocking_items: {{BLOCKERS}}
next_steps: {{NEXT_STEPS}}
```

Fill `top_issues` with concrete evidence; if none, set to an empty list (`[]`). Keep text concise and actionable.

### 6. Post Decision to GitHub
Comment on the source issue:
```bash
gh issue comment {{ISSUE}} {{REPO_FLAG}} --body "$(cat <<'EOF'
### QA Gate Decision: {{GATE_STATUS}}
- Gate file: `{{REPO_RELATIVE_PATH}}`
- Reviewer: {{REVIEWER}}
- Summary: {{STATUS_REASON}}

Key findings:
{{#TOP_ISSUES}}
- {{ID}} ({{SEVERITY}}): {{FINDING}} → _{{ACTION}}_
{{/TOP_ISSUES}}

```yaml
{{GATE_YAML_SNIPPET}}
```

_Generated via `/qa-gate`._
EOF
)"
```

Include the pared-down YAML snippet (gate status, scenarios_total, coverage_gaps, waiver state) to make commenting lightweight.

### 7. Deliver Summary
Report back to the user:
- Gate status and rationale.
- Storage path of the YAML file.
- Follow-up items (e.g., execution issue IDs, required re-tests).
- Flutter/Dart actions still outstanding, if any.

## Guardrails
- Do **not** modify source code; this command is assessment only.
- Abort gracefully if evidence is incomplete—return CONCERNS with explicit missing items.
- Keep all instructions self-contained; never reference `.bmad-core/`.
- Preserve confidentiality: redact sensitive logs before embedding them.
- Encourage rerunning `flutter analyze`, `dart test`, and integration suites when the gate is CONCERNS or FAIL.
