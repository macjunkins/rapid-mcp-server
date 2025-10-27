# QA Apply Fixes Command

You address QA findings for a GitHub issue, implementing code and test changes, validating results, and reporting back to stakeholders.

## Workflow

### 1. Gather Inputs
- Expect `{{arg1}}` to be the GitHub issue number under remediation. Prompt if missing.
- Optional flags:
  - `-R owner/repo` for non-local repositories.
  - `--gate PATH` to point at a specific gate YAML (otherwise resolve automatically).
  - `--design PATH` to reference the latest test design file.
  - `--nfr PATH` for the latest NFR assessment.
- Confirm you have repository write access and a clean workspace snapshot (`git status`).

### 2. Load Context
1. View the issue:
   ```bash
   gh issue view {{ISSUE}} {{REPO_FLAG}} --json number,title,state,labels,assignees,milestone,body,url
   ```
2. Locate QA artifacts:
   - Gate YAML: default search `docs/qa/gates/issue-{{ISSUE}}-*-gate-*.yml`.
   - Test design: `docs/qa/assessments/issue-{{ISSUE}}-test-design-*.md`.
   - NFR assessment: `docs/qa/assessments/issue-{{ISSUE}}-nfr-*.md`.
3. Identify the linked execution issue (from gate/test design comments) and pull current status.

### 3. Parse Findings
- Extract from gate YAML:
  - `gate` status.
  - `top_issues[]` (id, severity, finding, suggested_action).
  - `test_design.coverage_gaps`.
  - `flutter_focus` entries (analyze/widget/integration/performance).
  - `next_steps`.
- From test design:
  - Outstanding checklist items.
  - Scenario definitions (ID, level, priority, description).
- From NFR assessment:
  - Failing or concern attributes with required remediation.
- Capture any blockers or dependencies called out in linked issues.

### 4. Build Deterministic Fix Plan
Prioritize in this order:
1. High-severity `top_issues`.
2. Failing/concern NFR attributes.
3. Coverage gaps and unimplemented scenarios (start with P0/P1).
4. Linked blockers that require updates.
5. Medium then low severity issues.

For each item, outline:
- Root cause / affected component.
- Proposed code/tests updates.
- Verification steps (unit/widget/integration/e2e, `flutter analyze`, `dart test`, etc.).

### 5. Implement Changes
- Apply code modifications and tests per plan.
- Keep commits atomic and well-described.
- Follow project conventions (e.g., centralize imports, respect architecture boundaries).
- For Flutter/Dart work:
  - Run `flutter analyze` until clean.
  - Implement/extend widget tests (`flutter test`).
  - Add integration tests with platform coverage where required.
  - Capture performance metrics if the gate flagged performance notes.

### 6. Validate
Run the required commands, for example:
```bash
flutter analyze
dart test
flutter test --platform chrome
flutter test integration_test
```
Include any domain-specific scripts (linters, coverage tools). Stop if failures persist and assess root cause.

### 7. Update Artifacts
- Mark completed scenarios in the execution issue (convert checklist items to `[x]` via issue comment or `gh issue edit` body update).
- Update relevant documentation (e.g., test design file) only if material changes occurred—append a change log section with today’s date.
- Do **not** edit the existing gate YAML; notify QA instead.

### 8. Report Back to GitHub
Comment on the source issue summarizing the outcome:
```bash
gh issue comment {{ISSUE}} {{REPO_FLAG}} --body "$(cat <<'EOF'
### QA Fixes Applied
- Gate status targeted: {{GATE_STATUS}}
- High severity items addressed: {{HIGH_COUNT}}
- Remaining concerns: {{REMAINING_ITEMS or "None"}}
- Tests executed: `flutter analyze`, `dart test`, `flutter test{{ADDITIONAL_TESTS}}`
- Updated artifacts: {{UPDATED_ARTIFACTS}}

Execution issue{{#EXEC_ISSUE}} #{{NUMBER}} {{URL}}{{/EXEC_ISSUE}} checklist has been updated. QA can now rerun `/qa-gate`.
EOF
)"
```
- If new files were added (e.g., integration tests), mention their paths explicitly.
- Keep the comment concise but actionable.

### 9. Hand Off to QA
- Flag any residual medium/low issues requiring follow-up.
- Recommend next QA steps (rerun gate, refresh NFR assessment).
- Ensure CI pipelines are green before declaring completion.

## Completion Checklist
- [ ] All high-severity findings resolved or replaced with approved waiver.
- [ ] Flutter analysis/tests pass locally.
- [ ] New/updated tests committed.
- [ ] Execution issue checklist reflects current state.
- [ ] Source issue comment posted.
- [ ] Ready for QA confirmation (`/qa-gate` rerun).

## Guardrails
- Never delete or overwrite QA history; create additive updates.
- Escalate blockers or new high-severity issues immediately.
- Maintain traceability: reference scenario IDs, risk IDs, or issue numbers in commits and comments.
- Keep the workflow self-contained—no `.bmad-core/` dependencies or external templates.
