# YAML Command Schema Documentation

**Last Updated:** 2025-10-31
**Status:** MVP - 3 commands converted

This document defines the YAML schema structure for RAPID command definitions used by the MCP server.

---

## Overview

Commands are defined in YAML format with structured metadata, parameter validation, and Handlebars-templated prompts. This enables:
- **Type-safe parameter validation** (never trust AI input)
- **Dynamic prompt generation** with parameter substitution
- **Structured metadata** for OS integration and tooling
- **Self-documenting command definitions**

**Current State:**
- ✅ 3 MVP commands converted: `sanity-check.yaml`, `gh-work.yaml`, `create-issue.yaml`
- 📋 22 commands remain in `.md` format (to be converted in Phase 3)

---

## Schema Structure

```yaml
name: string              # Command identifier (kebab-case)
version: string           # Semantic version (e.g., "1.0.0")
description: string       # Brief description for AI clients
category: string          # Command category (see categories below)

parameters:               # Array of parameter definitions
  - name: string          # Parameter name (snake_case)
    type: string          # string | integer | number | boolean | array | object
    required: boolean     # Is this parameter required?
    description: string   # Help text for AI clients
    default: any          # Optional default value
    validation:           # Optional validation rules
      pattern: string     # Regex pattern (for strings)
      min: number         # Minimum value/length
      max: number         # Maximum value/length
      max_length: number  # Maximum string length

examples:                 # Usage examples for AI context
  - description: string   # What this example demonstrates
    args: object          # Parameter values for this example

prompt: |                 # Multi-line prompt with Handlebars {{placeholders}}
  Workflow instructions...
  Use {{parameter_name}} for substitution
  Use {{#if parameter}}...{{/if}} for conditional blocks
  Use {{#unless parameter}}...{{/unless}} for negation

metadata:                 # System integration metadata
  os_integration:
    requires_git: boolean           # Needs git repository context?
    requires_gh_cli: boolean        # Needs GitHub CLI (`gh`)?
    system_permissions: array       # Future: permissions needed
```

---

## Command Categories

| Category | Description | Examples |
|----------|-------------|----------|
| `github` | GitHub operations (issues, PRs, milestones) | gh-work, create-issue, create-pr |
| `documentation` | Documentation generation and management | doc-project, create-doc, shard-doc |
| `workflow` | Meta-workflows and process management | sanity-check, brainstorm, correct-course |
| `qa` | Quality assurance and testing | qa-gate, test-design, qa-apply-fixes |
| `utility` | General utilities | research-prompt, gen-prompt, trace-requirements |

---

## Parameter Types & Validation

### Type System

| Type | Description | Validation Options |
|------|-------------|--------------------|
| `string` | Text value | pattern, min, max, max_length |
| `integer` | Whole number | min, max |
| `number` | Decimal number | min, max |
| `boolean` | true/false | none (use `default: false` for flags) |
| `array` | List of values | min, max (for length) |
| `object` | Key-value map | (future - not used in MVP) |

### Validation Rules

**String Validation:**
```yaml
- name: repo
  type: string
  validation:
    pattern: "^[\\w-]+/[\\w-]+$"  # Regex for owner/repo format
    max_length: 100                # Maximum 100 characters
```

**Integer Validation:**
```yaml
- name: issue_number
  type: integer
  validation:
    min: 1          # Minimum value
    max: 999999     # Maximum value (prevents overflow/abuse)
```

**Boolean Flags (no validation needed):**
```yaml
- name: strict
  type: boolean
  required: false
  default: false
```

### Common Validation Patterns

**GitHub Repository:**
```yaml
validation:
  pattern: "^[\\w-]+/[\\w-]+$"  # owner/repo format
  max_length: 100
```

**Issue/PR Number:**
```yaml
validation:
  min: 1
  max: 999999  # GitHub's practical limit
```

**Branch Name:**
```yaml
validation:
  pattern: "^[\\w/_-]+$"  # Alphanumeric + / _ - only
  max_length: 255
```

**Milestone Name:**
```yaml
validation:
  max_length: 200
```

---

## Handlebars Templating

Commands use **Handlebars** syntax for dynamic prompt generation:

### Basic Substitution
```handlebars
Use `gh issue view {{issue_number}} --json title,body`
```

### Conditional Blocks
```handlebars
{{#if repo}}
- Use `gh issue view {{issue_number}} -R {{repo}} --json ...`
{{else}}
- Use `gh issue view {{issue_number}} --json ...`
{{/if}}
```

### Negation
```handlebars
{{#unless scope}}
Use conversation context to determine scope.
{{/unless}}
```

### Boolean Flags
```handlebars
{{#if strict}}
**Strict mode enabled** - Stop immediately if ANY drift detected.
{{/if}}
```

---

## MVP Command Examples

### Example 1: No Parameters (create-issue.yaml)

```yaml
name: create-issue
version: "1.0.0"
description: "Create a well-documented GitHub issue with codebase investigation"
category: github

parameters: []  # No parameters - prompts user interactively

examples:
  - description: "Create a new issue with interactive prompts"
    args: {}

prompt: |
  You are creating a new GitHub issue ONLY...

  ### 1. Acknowledge and Prompt for Input
  When this command is invoked, respond with:
  "I'll help you create a GitHub issue..."

  [Full workflow without any parameter substitution]

metadata:
  os_integration:
    requires_git: true
    requires_gh_cli: true
    system_permissions: []
```

### Example 2: Simple Parameters (gh-work.yaml)

```yaml
name: gh-work
version: "1.0.0"
description: "Work on GitHub issue using investigate → plan → execute workflow"
category: github

parameters:
  - name: issue_number
    type: integer
    required: true
    description: "GitHub issue number to work on"
    validation:
      min: 1
      max: 999999

  - name: repo
    type: string
    required: false
    description: "Repository in owner/repo format (auto-detected from git context)"
    validation:
      pattern: "^[\\w-]+/[\\w-]+$"
      max_length: 100

examples:
  - description: "Work on issue #6 in current repository"
    args:
      issue_number: 6

  - description: "Work on issue in specific repository"
    args:
      issue_number: 42
      repo: "owner/repo"

prompt: |
  ### 1. Investigate
  {{#if repo}}
  - Use `gh issue view {{issue_number}} -R {{repo}} --json title,body...`
  {{else}}
  - Use `gh issue view {{issue_number}} --json title,body...`
  {{/if}}

  [Rest of workflow with parameter substitution]

metadata:
  os_integration:
    requires_git: true
    requires_gh_cli: true
    system_permissions: []
```

### Example 3: Boolean Flags (sanity-check.yaml)

```yaml
name: sanity-check
version: "1.0.0"
description: "Mid-brainstorm sanity check to ensure alignment with original intent"
category: workflow

parameters:
  - name: strict
    type: boolean
    required: false
    description: "Stop on any drift detection (strict mode)"
    default: false

  - name: reset
    type: boolean
    required: false
    description: "Automatically apply correction without asking"
    default: false

  - name: scope
    type: string
    required: false
    description: "Custom scope to anchor validation"
    validation:
      max_length: 200

examples:
  - description: "Basic sanity check"
    args: {}

  - description: "Strict mode - stop on any drift"
    args:
      strict: true

  - description: "Auto-reset with custom scope"
    args:
      reset: true
      scope: "MVP medication tracking only"

prompt: |
  ## Configuration
  - Strict mode: {{strict}}
  - Auto-reset: {{reset}}
  {{#if scope}}- Custom scope: {{scope}}{{/if}}

  {{#if reset}}
  **Auto-reset enabled** - Apply correction automatically.
  {{else}}
  Stop and ask user: Proceed with correction? (Yes/No)
  {{/if}}

  {{#if strict}}
  **Strict mode enabled** - Stop immediately if ANY drift detected.
  {{/if}}

metadata:
  os_integration:
    requires_git: false
    requires_gh_cli: false
    system_permissions: []
```

---

## Parameter Extraction from Markdown

When converting from `.md` to `.yaml`, follow these rules:

### Positional Arguments ({{arg1}}, {{arg2}})

**Markdown:**
```markdown
Use `gh issue view {{arg1}} --json title,body`
```

**YAML conversion:**
```yaml
parameters:
  - name: issue_number  # Infer semantic name from context
    type: integer       # Infer type: issue number = integer
    required: true      # arg1 is typically required
    validation:
      min: 1
      max: 999999
```

**Updated prompt:**
```handlebars
Use `gh issue view {{issue_number}} --json title,body`
```

### Named Parameters ({{NAMED_PARAM}})

**Markdown:**
```markdown
Anchor validation to: {{CUSTOM_SCOPE}}
```

**YAML conversion:**
```yaml
parameters:
  - name: scope  # Convert CUSTOM_SCOPE → scope (snake_case)
    type: string
    required: false  # Named params often optional
    validation:
      max_length: 200
```

**Updated prompt:**
```handlebars
{{#if scope}}
Anchor validation to: {{scope}}
{{/if}}
```

### Flag Parameters (--flag, --option)

**Markdown:**
```markdown
/sanity-check [--strict] [--reset]
```

**YAML conversion:**
```yaml
parameters:
  - name: strict
    type: boolean
    required: false
    default: false

  - name: reset
    type: boolean
    required: false
    default: false
```

---

## Validation Philosophy: Never Trust AI Input

All parameters must be validated to prevent:
- **Type confusion** - AI sends string when integer expected
- **Injection attacks** - Shell metacharacters in repo names
- **Resource abuse** - Unbounded arrays, huge strings
- **Hallucinated values** - Invalid issue numbers, non-existent repos

### Defense Strategies

1. **Type validation** - Enforce integer/string/boolean
2. **Range limits** - Min/max for numbers, max_length for strings
3. **Pattern matching** - Regex for structured data (repo names, branches)
4. **Required vs optional** - Explicit nullability
5. **Sanitization** - Escape shell metacharacters when executing commands

**Example attack vector prevented:**
```yaml
# Without validation:
repo: "owner/repo; rm -rf /"  # Shell injection!

# With validation:
validation:
  pattern: "^[\\w-]+/[\\w-]+$"  # Blocks shell metacharacters
```

---

## Implementation Checklist

When converting a command from `.md` to `.yaml`:

- [ ] Identify all `{{arg1}}`, `{{arg2}}`, `{{NAMED_PARAM}}` placeholders
- [ ] Infer semantic parameter names (issue_number, repo, etc.)
- [ ] Determine types from context (issue = integer, repo = string)
- [ ] Define validation rules (min/max, pattern, max_length)
- [ ] Decide required vs optional (arg1 usually required)
- [ ] Add default values for boolean flags
- [ ] Convert prompt to Handlebars syntax
- [ ] Add conditional blocks for optional parameters ({{#if}})
- [ ] Set metadata flags (requires_git, requires_gh_cli)
- [ ] Create 2-3 usage examples
- [ ] Validate YAML syntax (`python3 -c "import yaml; yaml.safe_load(open('file.yaml'))"`)
- [ ] Keep original `.md` file (do not delete)

---

## Future Enhancements (Post-MVP)

- **JSON Schema validation** - Formal schema for YAML files
- **PCRE pattern matching** - Full regex support (currently custom validators)
- **Parameter dependencies** - "If A is set, B is required"
- **Array/object validation** - Complex nested structures
- **Command composition** - Commands that call other commands
- **Hot reload** - Update YAML files without restarting MCP server
- **Localization** - Multi-language prompt support

---

## References

- **MCP Protocol:** https://modelcontextprotocol.io
- **Handlebars Syntax:** https://handlebarsjs.com/guide/
- **YAML 1.2 Spec:** https://yaml.org/spec/1.2/spec.html
- **Project PRD:** `/docs/prd.md`
- **[Issue #7](https://github.com/owner/repo/issues/7):** Convert 3 MVP commands from .md to YAML format