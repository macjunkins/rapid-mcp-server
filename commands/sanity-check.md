# Sanity Check Command

Use mid-brainstorm to ensure alignment to original intent.

## Command

/sanity-check [–strict] [–reset] [–scope {{CUSTOM_SCOPE}}]

## Workflow (Claude must follow exactly)

### 1. Determine Original Intent
Restate the objective in one clear sentence using:
1. The explicit goal from the conversation
2. The referenced story or PRD
3. The last confirmed objective from the user

If unclear: ask user to restate goal before continuing.

### 2. Summarize Current Trajectory
Summarize the last 3 assistant messages:
- One sentence per message
- Focus on outcomes not narrative

### 3. Alignment Validation (Yes/No only)
- Same objective
- Same constraints
- Same audience
- Same boundaries and scope
- No irrelevant speculation or runaway creativity

### 4. Score and Status
Count Yes responses:

- **5/5 Yes** → ✅ On Track  
- **3–4 Yes** → ⚠️ Mild Drift  
- **0–2 Yes** → ❌ Off Track  

### 5. If Drift Detected
Provide both:

A. Drift diagnosis (≤10 words)  
B. One-sentence correction using this pattern:

RESET PROPOSAL:
Replace: {{off_track_behavior}}
With: {{aligned_behavior}}
Next will directly address: “{{ORIGINAL_INTENT}}”

Stop and ask user:
- Proceed with correction? (Yes/No)

If **--reset** flag provided:
- Apply correction automatically
- Continue only with aligned behavior

### 6. Optional Scope Override
If `--scope` flag provided:
- Anchor validation to that scope
- Example: `/sanity-check --scope "MVP medication tracking only"`

---

## Notes
- Keep responses short and analytical
- Do not expand brainstorming during this step
- If strict mode enabled → stop on any drift
