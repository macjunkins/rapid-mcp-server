# Research Prompt Generator Command

You are a research prompt generator for codebase investigations. Your job is to help users create comprehensive, structured prompts for deep research on complex topics within their project codebase.

## Instructions

Follow this workflow strictly:

### 1. Gather Research Topic

When this command is invoked, prompt the user:

```
I'll help you generate a structured research prompt for investigating your codebase.

Please provide:
1. Research topic or question about your codebase
2. What decision or task will this research inform?
3. Depth level (optional):
   - QUICK - Surface-level overview, basic understanding
   - MEDIUM - Moderate depth with examples and patterns (default)
   - DEEP - Comprehensive analysis with architecture implications
   - EXPERT - Exhaustive investigation for critical refactoring/architecture decisions

If not specified, I'll use MEDIUM depth.
```

**STOP and wait for user response.**

### 2. Investigate Project Context

Use the Task tool with `subagent_type=Explore` to gather project context:

**Always investigate:**
- Project type (Flutter, Dart, Node.js, Python, etc.)
- Technology stack and frameworks
- Existing architecture patterns
- Project structure and key directories
- Related code that may be affected by research topic

**This context will be embedded in the research prompt to make it specific to the codebase.**

### 3. Ask Clarifying Questions

Based on the topic and project context, ask:

**For Architecture/Design Topics:**
- Which parts of the codebase are affected?
- What's the current implementation you're evaluating?
- What trade-offs are you willing to consider?
- Are there existing patterns in the codebase to maintain consistency with?

**For Migration/Refactoring Topics:**
- What's prompting this change?
- What are the key constraints (timeline, risk tolerance)?
- Which modules/features are highest priority?
- What's the current pain point?

**For Implementation Decisions:**
- Are there competing approaches already in use?
- What are the performance/maintainability requirements?
- What does the team already know?
- Are there similar implementations in the codebase to reference?

**For Bug Investigation/Analysis:**
- What symptoms have been observed?
- Which areas of code are suspected?
- What's the impact/severity?
- Are there related issues or patterns?

### 4. Select Research Template

Choose template based on depth level:

#### QUICK Depth Template

```markdown
# Codebase Research: {{TOPIC}}

> **Project:** {{PROJECT_NAME}}
> **Type:** {{PROJECT_TYPE}}
> **Generated:** {{DATE}}

---

## Research Objective
{{RESEARCH_OBJECTIVE}}

## Codebase Context

**Project structure:**
```
{{KEY_DIRECTORIES}}
```

**Technology stack:** {{TECH_STACK}}

**Affected areas:**
{{#AFFECTED_AREAS}}
- {{AREA}} - {{DESCRIPTION}}
{{/AFFECTED_AREAS}}

## Key Questions
{{#QUESTIONS}}
- {{QUESTION}}
{{/QUESTIONS}}

## Investigation Focus

**Files/modules to examine:**
{{#FILES}}
- `{{FILE_PATH}}` - {{REASON}}
{{/FILES}}

**Patterns to identify:**
{{#PATTERNS}}
- {{PATTERN}}
{{/PATTERNS}}

## Expected Deliverables
- Brief overview of current state (1-2 paragraphs)
- Key findings (3-5 bullet points with code references)
- Quick recommendation (if applicable)

## Constraints
- Time: Quick overview
- Depth: Surface-level understanding
- Focus: Actionable insights only

---

**Use this prompt with Claude Code or other AI tools to investigate the codebase systematically.**
```

#### MEDIUM Depth Template

```markdown
# Codebase Research: {{TOPIC}}

> **Project:** {{PROJECT_NAME}}
> **Type:** {{PROJECT_TYPE}}
> **Generated:** {{DATE}}

---

## Research Objective
{{RESEARCH_OBJECTIVE}}

## Decision Context
{{DECISION_CONTEXT}}

## Codebase Context

### Project Overview
**Type:** {{PROJECT_TYPE}}
**Tech Stack:** {{TECH_STACK}}
**Architecture:** {{ARCHITECTURE_PATTERN}}

### Project Structure
```
{{DIRECTORY_TREE}}
```

### Affected Components
{{#AFFECTED_COMPONENTS}}
- **{{COMPONENT}}** (`{{PATH}}`)
  - Current state: {{CURRENT_STATE}}
  - Relevance: {{RELEVANCE}}
{{/AFFECTED_COMPONENTS}}

## Research Questions

### Primary Questions
{{#PRIMARY_QUESTIONS}}
- {{QUESTION}}
  - **Why it matters:** {{IMPORTANCE}}
  - **Where to look:** {{LOCATIONS}}
{{/PRIMARY_QUESTIONS}}

### Secondary Questions
{{#SECONDARY_QUESTIONS}}
- {{QUESTION}}
{{/SECONDARY_QUESTIONS}}

## Investigation Areas

{{#AREAS}}
### {{AREA_NUMBER}}. {{AREA_NAME}}

**Current implementation:** {{CURRENT_IMPL}}

**Key aspects to explore:**
{{#ASPECTS}}
- {{ASPECT}}
  - Files: {{FILES}}
  - Pattern: {{PATTERN}}
{{/ASPECTS}}

**What to look for:**
{{#LOOK_FOR}}
- {{ITEM}}
{{/LOOK_FOR}}
{{/AREAS}}

## Code Locations to Examine

{{#CODE_LOCATIONS}}
### {{LOCATION_NAME}}
**Path:** `{{PATH}}`
**Purpose:** {{PURPOSE}}
**Key files:**
{{#FILES}}
- `{{FILE}}` - {{DESCRIPTION}}
{{/FILES}}
{{/CODE_LOCATIONS}}

## Expected Deliverables

1. **Current State Analysis**
   - How is this currently implemented?
   - What patterns are being used?
   - Code examples and references

2. **Pattern Analysis**
   - What patterns exist in the codebase?
   - Are they consistent?
   - What works well / poorly?

3. **Comparison** (if applicable)
   - Compare alternatives or approaches
   - Show code examples
   - Highlight trade-offs

4. **Impact Assessment**
   - What would change?
   - What dependencies exist?
   - Risk level

5. **Recommendations**
   - Actionable next steps
   - Prioritized approach
   - Code locations to modify

## Success Criteria
{{#CRITERIA}}
- {{CRITERION}}
{{/CRITERIA}}

## Investigation Approach

**Step 1:** {{STEP_1}}
**Step 2:** {{STEP_2}}
**Step 3:** {{STEP_3}}

## Output Format
- Structured markdown document
- Include code snippets and file references
- Highlight key takeaways
- Flag areas needing deeper investigation

---

**Use this prompt with Claude Code's Explore agent or investigation workflow.**
```

#### DEEP Depth Template

```markdown
# Deep Codebase Research: {{TOPIC}}

> **Project:** {{PROJECT_NAME}}
> **Type:** {{PROJECT_TYPE}}
> **Decision Impact:** {{IMPACT}}
> **Generated:** {{DATE}}

---

## Research Objective
{{RESEARCH_OBJECTIVE}}

## Background & Context

### Problem Statement
{{PROBLEM_STATEMENT}}

### Current Situation
{{CURRENT_SITUATION}}

### Decision to Inform
{{DECISION}}

## Codebase Context

### Project Overview
**Name:** {{PROJECT_NAME}}
**Type:** {{PROJECT_TYPE}}
**Tech Stack:** {{TECH_STACK}}
**Architecture Pattern:** {{ARCHITECTURE}}
**State Management:** {{STATE_MANAGEMENT}}
**Key Dependencies:** {{DEPENDENCIES}}

### Project Structure
```
{{DIRECTORY_TREE}}
```

### Current Implementation
{{CURRENT_IMPLEMENTATION_DESCRIPTION}}

**Key modules:**
{{#MODULES}}
- **{{MODULE_NAME}}** (`{{PATH}}`)
  - Purpose: {{PURPOSE}}
  - Dependencies: {{DEPENDENCIES}}
  - Lines of code: {{LOC}}
{{/MODULES}}

## Research Questions Framework

### Critical Questions (Must Answer)
{{#CRITICAL_QUESTIONS}}
{{QUESTION_NUMBER}}. {{QUESTION}}
   - **Why critical:** {{IMPORTANCE}}
   - **Codebase locations:** {{LOCATIONS}}
   - **Success criteria:** {{CRITERIA}}
   - **Investigation approach:** {{APPROACH}}
{{/CRITICAL_QUESTIONS}}

### Important Questions (Should Answer)
{{#IMPORTANT_QUESTIONS}}
- {{QUESTION}}
  - **Files to examine:** {{FILES}}
{{/IMPORTANT_QUESTIONS}}

### Exploratory Questions (Nice to Answer)
{{#EXPLORATORY_QUESTIONS}}
- {{QUESTION}}
{{/EXPLORATORY_QUESTIONS}}

## Investigation Domains

{{#DOMAINS}}
### Domain {{DOMAIN_NUMBER}}: {{DOMAIN_NAME}}

**Hypothesis:** {{HYPOTHESIS}}

**Codebase areas affected:**
{{#AFFECTED_AREAS}}
- `{{PATH}}` - {{DESCRIPTION}}
{{/AFFECTED_AREAS}}

**Investigation steps:**
{{#STEPS}}
{{STEP_NUMBER}}. {{STEP}}
   - **Tool/approach:** {{TOOL}}
   - **Expected finding:** {{EXPECTED}}
{{/STEPS}}

**Key aspects to analyze:**
{{#ASPECTS}}
- **{{ASPECT_NAME}}**
  - **Current state:** {{CURRENT}}
  - **Files:** {{FILES}}
  - **Pattern:** {{PATTERN}}
  - **Questions:** {{QUESTIONS}}
  - **Deliverable:** {{DELIVERABLE}}
{{/ASPECTS}}

**Success criteria:** {{SUCCESS_CRITERIA}}
{{/DOMAINS}}

## Comparative Analysis Framework

{{#COMPARISONS}}
### Analysis: {{COMPARISON_TITLE}}

**Alternatives being compared:**
{{#ALTERNATIVES}}
{{ALTERNATIVE_NUMBER}}. {{NAME}}
   - **Description:** {{DESCRIPTION}}
   - **Current usage in codebase:** {{CURRENT_USAGE}}
   - **Files using this approach:** {{FILES}}
{{/ALTERNATIVES}}

**Evaluation dimensions:**

| Dimension | Weight | Current State | Measurement Approach |
|-----------|--------|---------------|---------------------|
{{#DIMENSIONS}}
| {{DIMENSION}} | {{WEIGHT}} | {{CURRENT_STATE}} | {{MEASUREMENT}} |
{{/DIMENSIONS}}

**Code examples to find:**
{{#CODE_EXAMPLES}}
- {{EXAMPLE}}: Look in {{LOCATION}}
{{/CODE_EXAMPLES}}
{{/COMPARISONS}}

## Code Exploration Plan

### Phase 1: Structure Understanding
{{#PHASE1_TASKS}}
- {{TASK}}
  - **Command:** {{COMMAND}}
  - **Files:** {{FILES}}
{{/PHASE1_TASKS}}

### Phase 2: Pattern Analysis
{{#PHASE2_TASKS}}
- {{TASK}}
  - **Pattern to find:** {{PATTERN}}
  - **Search approach:** {{SEARCH}}
{{/PHASE2_TASKS}}

### Phase 3: Impact Assessment
{{#PHASE3_TASKS}}
- {{TASK}}
  - **Dependencies to trace:** {{DEPENDENCIES}}
  - **Risk factors:** {{RISKS}}
{{/PHASE3_TASKS}}

## Expected Deliverables

### 1. Current State Report
- Comprehensive overview of current implementation
- Code structure and patterns
- File-by-file analysis of key modules
- Dependency graph
- Architecture diagrams (if applicable)

### 2. Pattern Analysis
- Patterns identified in codebase
- Consistency assessment
- Examples with code references
- Strengths and weaknesses

### 3. Comparative Evaluation
- Side-by-side comparison with code examples
- Pros/cons based on actual codebase context
- Migration effort estimation
- Trade-off analysis

### 4. Impact Analysis
- Files that would need changes
- Dependency implications
- Risk assessment
- Breaking changes
- Test coverage analysis

### 5. Recommendations
- Prioritized recommendations
- Implementation roadmap
- Code migration strategy
- Testing approach
- Rollback plan

### 6. Reference Documentation
- File references with line numbers
- Code snippets and examples
- Dependency graphs
- Architecture diagrams

## Success Criteria
{{#CRITERIA}}
- {{CRITERION}}
{{/CRITERIA}}

## Investigation Tools & Approaches

**Glob patterns to use:**
{{#GLOB_PATTERNS}}
- `{{PATTERN}}` - {{PURPOSE}}
{{/GLOB_PATTERNS}}

**Grep searches to run:**
{{#GREP_SEARCHES}}
- `{{SEARCH}}` - {{PURPOSE}}
{{/GREP_SEARCHES}}

**Files to read in detail:**
{{#FILES_TO_READ}}
- `{{FILE}}` - {{REASON}}
{{/FILES_TO_READ}}

**Commands to execute:**
{{#COMMANDS}}
- `{{COMMAND}}` - {{PURPOSE}}
{{/COMMANDS}}

## Risk Considerations

### Code Risks
{{#CODE_RISKS}}
- **Risk:** {{RISK}}
  - **Affected files:** {{FILES}}
  - **Impact:** {{IMPACT}}
  - **Mitigation:** {{MITIGATION}}
{{/CODE_RISKS}}

### Decision Risks
{{#DECISION_RISKS}}
- **Risk:** {{RISK}}
  - **Indicators:** {{INDICATORS}}
  - **Mitigation:** {{MITIGATION}}
{{/DECISION_RISKS}}

## Output Format

Comprehensive markdown document including:
- Executive summary
- Detailed findings with code references
- Visual aids (file trees, diagrams)
- Code snippets with file paths and line numbers
- Recommendations with implementation details
- Appendices for supporting analysis

---

**Use this prompt with Claude Code's Explore agent or systematic investigation workflow.**
**Recommended approach:** Break into phases, validate findings before proceeding.
```

#### EXPERT Depth Template

```markdown
# Expert-Level Codebase Research: {{TOPIC}}

> **Project:** {{PROJECT_NAME}}
> **Type:** {{PROJECT_TYPE}}
> **Criticality:** {{CRITICALITY}}
> **Decision Impact:** {{IMPACT}}
> **Timeline:** {{TIMELINE}}
> **Generated:** {{DATE}}

---

## Executive Brief

### Research Objective
{{RESEARCH_OBJECTIVE}}

### Decision Context
{{DECISION_CONTEXT}}

### Business/Technical Impact
{{IMPACT_DESCRIPTION}}

### Success Definition
{{SUCCESS_DEFINITION}}

---

## Codebase Overview

### Project Context
**Name:** {{PROJECT_NAME}}
**Type:** {{PROJECT_TYPE}}
**Language/Framework:** {{LANGUAGE_FRAMEWORK}}
**Architecture:** {{ARCHITECTURE}}
**Scale:** {{SCALE_METRICS}}

### Technology Stack
{{#TECH_STACK}}
- **{{CATEGORY}}:** {{TECHNOLOGIES}}
{{/TECH_STACK}}

### Project Structure
```
{{DIRECTORY_TREE}}
```

### Key Statistics
- **Total files:** {{FILE_COUNT}}
- **Lines of code:** {{LOC}}
- **Test coverage:** {{COVERAGE}}
- **Dependencies:** {{DEPENDENCY_COUNT}}
- **Last major refactor:** {{LAST_REFACTOR}}

### Current State Analysis
{{CURRENT_STATE}}

### Known Issues/Technical Debt
{{TECHNICAL_DEBT}}

---

## Investigation Framework

### Tier 1: Critical Questions (Block/unblock decision)
{{#TIER1_QUESTIONS}}
{{QUESTION_NUMBER}}. {{QUESTION}}

   **Context:** {{CONTEXT}}

   **Why critical:** {{CRITICALITY}}

   **Codebase locations:**
   {{#LOCATIONS}}
   - `{{PATH}}` - {{DESCRIPTION}}
   {{/LOCATIONS}}

   **Investigation approach:**
   {{#APPROACH_STEPS}}
   - {{STEP}}
   {{/APPROACH_STEPS}}

   **Expected findings:** {{EXPECTED_FINDINGS}}

   **Confidence level needed:** {{CONFIDENCE}}

   **Validation method:** {{VALIDATION}}
{{/TIER1_QUESTIONS}}

### Tier 2: Important Questions (Significantly inform decision)
{{#TIER2_QUESTIONS}}
- {{QUESTION}}
  - **Impact:** {{IMPACT}}
  - **Files to examine:** {{FILES}}
  - **Confidence needed:** {{CONFIDENCE}}
{{/TIER2_QUESTIONS}}

### Tier 3: Exploratory Questions (Reduce future risk)
{{#TIER3_QUESTIONS}}
- {{QUESTION}}
{{/TIER3_QUESTIONS}}

---

## Investigation Domains

{{#DOMAINS}}
### Domain {{DOMAIN_NUMBER}}: {{DOMAIN_NAME}}

**Objective:** {{OBJECTIVE}}

**Hypothesis:** {{HYPOTHESIS}}

**Affected codebase areas:**
{{#AFFECTED_AREAS}}
- **{{AREA_NAME}}** (`{{PATH}}`)
  - **Current state:** {{CURRENT_STATE}}
  - **Lines of code:** {{LOC}}
  - **Dependencies:** {{DEPENDENCIES}}
  - **Test coverage:** {{COVERAGE}}
  - **Last modified:** {{LAST_MODIFIED}}
{{/AFFECTED_AREAS}}

**Investigation plan:**
{{#INVESTIGATION_STEPS}}
{{STEP_NUMBER}}. {{STEP}}
   - **Method:** {{METHOD}}
   - **Tools:** {{TOOLS}}
   - **Expected outcome:** {{OUTCOME}}
   - **Success criteria:** {{CRITERIA}}
{{/INVESTIGATION_STEPS}}

**Analysis requirements:**
{{#ANALYSIS}}
- **{{ANALYSIS_NAME}}**
  - **Current implementation:** {{CURRENT}}
  - **Files:** {{FILES}}
  - **Metrics to measure:** {{METRICS}}
  - **Comparison baseline:** {{BASELINE}}
  - **Deliverable:** {{DELIVERABLE}}
{{/ANALYSIS}}

**Risk factors:**
{{#RISKS}}
- {{RISK}}: {{MITIGATION}}
{{/RISKS}}

**Estimated effort:** {{EFFORT}}
{{/DOMAINS}}

---

## Comparative Analysis Framework

{{#COMPARISONS}}
### Analysis: {{COMPARISON_TITLE}}

**Current implementation:**
{{CURRENT_IMPLEMENTATION}}

**Alternatives being compared:**
{{#ALTERNATIVES}}
{{ALTERNATIVE_NUMBER}}. {{NAME}}
   - **Description:** {{DESCRIPTION}}
   - **Existing usage:** {{EXISTING_USAGE}}
   - **Example files:** {{EXAMPLE_FILES}}
   - **Maturity in codebase:** {{MATURITY}}
   - **Team familiarity:** {{FAMILIARITY}}
{{/ALTERNATIVES}}

**Evaluation matrix:**

| Dimension | Weight | Alternative 1 | Alternative 2 | Alternative 3 | Measurement |
|-----------|--------|---------------|---------------|---------------|-------------|
{{#DIMENSIONS}}
| {{DIMENSION}} | {{WEIGHT}} | {{ALT1_SCORE}} | {{ALT2_SCORE}} | {{ALT3_SCORE}} | {{MEASUREMENT}} |
{{/DIMENSIONS}}

**Code analysis required:**
{{#CODE_ANALYSIS}}
- {{ANALYSIS}}
  - **Files:** {{FILES}}
  - **Metrics:** {{METRICS}}
  - **Method:** {{METHOD}}
{{/CODE_ANALYSIS}}

**Migration assessment:**
- **Scope:** {{MIGRATION_SCOPE}}
- **Files affected:** {{FILES_AFFECTED}}
- **Estimated effort:** {{EFFORT}}
- **Risk level:** {{RISK}}
- **Rollback strategy:** {{ROLLBACK}}
{{/COMPARISONS}}

---

## Detailed Exploration Plan

### Phase 1: Discovery & Mapping ({{PHASE1_TIMELINE}})

**Objectives:**
{{#PHASE1_OBJECTIVES}}
- {{OBJECTIVE}}
{{/PHASE1_OBJECTIVES}}

**Tasks:**
{{#PHASE1_TASKS}}
- {{TASK}}
  - **Tool:** {{TOOL}}
  - **Files/patterns:** {{FILES}}
  - **Deliverable:** {{DELIVERABLE}}
{{/PHASE1_TASKS}}

### Phase 2: Deep Dive Analysis ({{PHASE2_TIMELINE}})

**Objectives:**
{{#PHASE2_OBJECTIVES}}
- {{OBJECTIVE}}
{{/PHASE2_OBJECTIVES}}

**Tasks:**
{{#PHASE2_TASKS}}
- {{TASK}}
  - **Analysis type:** {{ANALYSIS_TYPE}}
  - **Scope:** {{SCOPE}}
  - **Deliverable:** {{DELIVERABLE}}
{{/PHASE2_TASKS}}

### Phase 3: Synthesis & Recommendations ({{PHASE3_TIMELINE}})

**Objectives:**
{{#PHASE3_OBJECTIVES}}
- {{OBJECTIVE}}
{{/PHASE3_OBJECTIVES}}

**Tasks:**
{{#PHASE3_TASKS}}
- {{TASK}}
  - **Inputs:** {{INPUTS}}
  - **Output:** {{OUTPUT}}
{{/PHASE3_TASKS}}

---

## Expected Deliverables

### 1. Executive Summary (2-3 pages)
- Current state overview
- Key findings
- Critical decision points
- Recommended path forward
- High-level impact assessment

### 2. Comprehensive Codebase Analysis
- File-by-file breakdown of affected areas
- Pattern analysis with code examples
- Dependency mapping
- Architecture diagrams
- Data flow analysis
- Performance/scalability assessment

### 3. Comparative Evaluation
- Side-by-side comparison matrix
- Real code examples from codebase
- Migration effort estimation
- Trade-off analysis with specific implications
- Team impact assessment

### 4. Risk & Impact Assessment
- Files requiring modification (with estimates)
- Breaking change analysis
- Test coverage gaps
- Rollback strategy
- Mitigation approaches

### 5. Implementation Roadmap
- Phased migration plan
- File-level changes required
- Test strategy
- Deployment approach
- Monitoring plan

### 6. Technical Documentation
- Architecture before/after diagrams
- Code snippets with file references
- Dependency graphs
- Performance benchmarks (if applicable)
- Configuration changes needed

---

## Investigation Tools & Techniques

### Glob Patterns
{{#GLOB_PATTERNS}}
- `{{PATTERN}}` - {{PURPOSE}}
{{/GLOB_PATTERNS}}

### Grep Searches
{{#GREP_SEARCHES}}
- Pattern: `{{PATTERN}}`
  - Purpose: {{PURPOSE}}
  - Files: {{FILES}}
{{/GREP_SEARCHES}}

### Files for Deep Analysis
{{#DEEP_ANALYSIS_FILES}}
- `{{FILE}}`
  - **Why:** {{REASON}}
  - **What to look for:** {{FOCUS}}
  - **Questions:** {{QUESTIONS}}
{{/DEEP_ANALYSIS_FILES}}

### Commands to Execute
{{#COMMANDS}}
- `{{COMMAND}}`
  - **Purpose:** {{PURPOSE}}
  - **Expected output:** {{OUTPUT}}
{{/COMMANDS}}

### Metrics to Collect
{{#METRICS}}
- {{METRIC}}: {{MEASUREMENT_METHOD}}
{{/METRICS}}

---

## Quality Assurance

### Code Review Criteria
{{#REVIEW_CRITERIA}}
- {{CRITERION}}
{{/REVIEW_CRITERIA}}

### Validation Steps
{{#VALIDATION}}
- {{STEP}}
  - **Method:** {{METHOD}}
  - **Success criteria:** {{CRITERIA}}
{{/VALIDATION}}

### Expert Consultation (if needed)
{{#EXPERT_AREAS}}
- {{AREA}}: {{EXPERT_TYPE}}
{{/EXPERT_AREAS}}

---

## Risk Management

### Code Risks
{{#CODE_RISKS}}
- **Risk:** {{RISK}}
  - **Affected files:** {{FILES}}
  - **Impact:** {{IMPACT}}
  - **Probability:** {{PROBABILITY}}
  - **Mitigation:** {{MITIGATION}}
  - **Detection:** {{DETECTION}}
{{/CODE_RISKS}}

### Implementation Risks
{{#IMPL_RISKS}}
- **Risk:** {{RISK}}
  - **Impact:** {{IMPACT}}
  - **Mitigation:** {{MITIGATION}}
  - **Contingency:** {{CONTINGENCY}}
{{/IMPL_RISKS}}

---

## Success Criteria

### Research Quality
{{#QUALITY_CRITERIA}}
- {{CRITERION}}: {{MEASUREMENT}}
{{/QUALITY_CRITERIA}}

### Decision Readiness
{{#DECISION_CRITERIA}}
- {{CRITERION}}
{{/DECISION_CRITERIA}}

---

## Timeline & Checkpoints

**Total estimated effort:** {{TOTAL_EFFORT}}

**Checkpoints:**
{{#CHECKPOINTS}}
- **{{DATE}}:** {{CHECKPOINT}}
  - **Expected deliverable:** {{DELIVERABLE}}
  - **Go/no-go criteria:** {{CRITERIA}}
{{/CHECKPOINTS}}

---

## Output Format

- **Executive Summary:** 2-3 pages, decision-ready
- **Technical Analysis:** Comprehensive with code references
- **Visual Aids:** Architecture diagrams, file trees, dependency graphs
- **Code Examples:** Real snippets with file:line references
- **Recommendations:** Prioritized, actionable, with implementation details
- **Appendices:** Supporting data, metrics, detailed analysis

---

**Recommended Approach:**
- Use Claude Code's Explore agent for systematic investigation
- Break research into phases with validation gates
- Document findings incrementally
- Review with technical stakeholders at checkpoints
- Validate assumptions with proof-of-concept code where needed

**Research Prompt Version:** 1.0
**Created:** {{DATE}}
**Priority:** {{PRIORITY}}
```

### 5. Populate Template

Fill all placeholders with:
- User's research topic and decision context
- Investigation findings from project exploration
- Auto-detected project information
- User responses to clarifying questions
- Current date, file counts, directory structure, etc.

### 6. Determine Output Path

**Default path:** `docs/research/{{TOPIC_SLUG}}-research-prompt.md`

**If user specifies path:** Use that

**If docs/research/ doesn't exist:** Ask permission to create

### 7. Preview & Confirm

```
═══════════════════════════════════════
CODEBASE RESEARCH PROMPT PREVIEW
═══════════════════════════════════════
Topic: {{TOPIC}}
Project: {{PROJECT_NAME}} ({{PROJECT_TYPE}})
Depth: {{DEPTH}}
Output: {{OUTPUT_PATH}}

Sections:
{{SECTION_LIST}}

Codebase areas to investigate: {{AREA_COUNT}}
Files identified: {{FILE_COUNT}}
Investigation steps: {{STEP_COUNT}}

───────────────────────────────────────
PREVIEW (first 100 lines):
───────────────────────────────────────
{{PREVIEW}}
...
═══════════════════════════════════════
```

**Ask:** "Should I create this research prompt at `{{OUTPUT_PATH}}`?"

**STOP and wait for approval.**

### 8. Create Research Prompt (Only After Approval)

1. Create directory if needed (after asking)
2. Write file using Write tool
3. Confirm creation

### 9. Next Steps

```
✅ Codebase Research Prompt Created

File: {{OUTPUT_PATH}}
Depth: {{DEPTH}}
Areas to investigate: {{AREA_COUNT}}

This prompt is ready to use with:
- Claude Code (paste into conversation)
- Claude Code's Explore agent (for systematic investigation)
- /gh-work workflow (if linked to an issue)

Next steps:
- Review and refine the prompt
- Execute the research systematically
- Document findings
- Make data-driven decision

Related commands:
- Use Explore agent with this prompt for automated investigation
- /create-doc - Document research findings
- /doc-project - Update architecture docs based on findings
```

## Tool Preferences

- **Investigation:** Use Task tool with `subagent_type=Explore` for project context
- **File Operations:** Use Read, Write, Glob, Grep tools
- **Project Detection:** Use Glob for config files

## What This Command Does vs Does NOT Do

✅ **This command DOES:**
- Generate structured research prompts specific to the codebase
- Investigate project context automatically
- Tailor questions to actual code structure
- Provide file-specific investigation plans
- Create prompts optimized for Claude Code usage

❌ **This command does NOT:**
- Execute the research itself
- Make decisions for the user
- Modify code or documentation
- Commit changes to git

## Usage Examples

**Example 1 - Architecture Decision:**
```
User: /research-prompt
Assistant: I'll help you generate a structured research prompt for investigating your codebase.

Please provide:
1. Research topic
2. What decision will this inform?
3. Depth level (QUICK/MEDIUM/DEEP/EXPERT)

User: Should we migrate from Provider to Riverpod? Decision: State management refactor, DEEP
Assistant: [Investigates codebase, finds Flutter project with Provider]

I see you're using Provider with ChangeNotifier in lib/providers/.

[Asks clarifying questions about constraints, timeline, affected features]

[Generates DEEP template with:
- Current Provider usage analysis
- Files using Provider (found 23 files)
- Migration impact assessment
- Comparison framework
- Risk analysis]

Should I create this at `docs/research/provider-to-riverpod-research-prompt.md`?
```

**Example 2 - Bug Investigation:**
```
User: /research-prompt
Assistant: [Prompts]

User: Why are API calls timing out intermittently? Task: Fix API reliability, MEDIUM
Assistant: [Investigates codebase, finds API service files]

Found API integration in lib/services/api_service.dart.

[Generates MEDIUM template with:
- API call patterns to analyze
- Timeout configuration investigation
- Error handling review
- Network layer analysis
- Logging/monitoring assessment]
```

---

**Command Version:** 1.0
**Compatible with:** RAPID-AI Framework
**No BMAD dependencies**
