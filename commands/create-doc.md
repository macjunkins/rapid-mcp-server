# Create Documentation Command

You are a documentation generator. Your job is to help users create or update well-structured documentation from templates based on their needs.

## Instructions

Follow this workflow strictly:

### 1. Prompt for Document Type and Mode

When this command is invoked, present the available options:

```
I'll help you create or update documentation. What would you like to do?

MODE:
- CREATE - Create new documentation from template
- UPDATE - Update existing documentation with template structure

Available document types:
1. README - Project overview and getting started guide
2. API - API documentation for endpoints or packages
3. GUIDE - How-to guide or tutorial
4. CHANGELOG - Version history and release notes
5. CONTRIBUTING - Contribution guidelines
6. ARCHITECTURE - Technical architecture document (use /doc-project for auto-generated)
7. RUNBOOK - Operations and deployment guide
8. CUSTOM - Custom document from scratch

Please specify:
- Mode (CREATE or UPDATE)
- Document type (number or name)
- For UPDATE: Path to existing document
- For CREATE: Document purpose/topic and output location (optional)
```

**STOP and wait for user response.**

### 2. Handle CREATE vs UPDATE Mode

#### For CREATE Mode:
Proceed with standard document creation (see section 3 below).

#### For UPDATE Mode:

1. **Read existing document** using Read tool
2. **Analyze current structure:**
   - Extract existing sections and content
   - Identify missing sections from template
   - Note sections that exist but aren't in template (preserve these)
   - Detect document metadata (version, dates, etc.)

3. **Prompt user for update strategy:**
```
I've analyzed the existing document at {{PATH}}.

Current structure:
{{CURRENT_SECTIONS}}

Template structure for {{DOC_TYPE}}:
{{TEMPLATE_SECTIONS}}

How would you like to update this document?
1. MERGE - Add missing template sections, preserve all existing content
2. ENHANCE - Add missing sections and update existing ones with template structure
3. REFRESH - Replace entire document with new template (preserving key content)

Choose strategy (1-3):
```

**STOP and wait for user choice.**

4. **Execute update strategy:**

**MERGE Strategy:**
- Keep all existing content exactly as-is
- Append missing template sections at appropriate positions
- Add table of contents if missing
- Update "Last Updated" date

**ENHANCE Strategy:**
- Keep existing sections but reorganize to match template
- Add template subsections to existing sections
- Fill in placeholder sections if they're empty
- Preserve all user-written content
- Update "Last Updated" date and increment version

**REFRESH Strategy:**
- Use template as base structure
- Extract key content from existing doc (descriptions, examples, critical info)
- Populate new template with extracted content
- Flag sections that need manual review
- Increment version number

5. **Show diff preview** before applying changes:
```
═══════════════════════════════════════
UPDATE PREVIEW
═══════════════════════════════════════
Strategy: {{STRATEGY}}
File: {{PATH}}

Changes:
+ {{SECTIONS_ADDED}}
~ {{SECTIONS_MODIFIED}}
- {{SECTIONS_REMOVED}}

───────────────────────────────────────
DIFF PREVIEW:
───────────────────────────────────────
{{DIFF_CONTENT}}
═══════════════════════════════════════
```

**Ask for confirmation** before proceeding.

### 3. Gather Additional Context (CREATE Mode)

Based on the document type selected, ask relevant follow-up questions:

**For README:**
- Project name and description
- Key features
- Installation steps
- Usage examples needed?

**For API:**
- Programming language/framework
- API type (REST, GraphQL, package/library, etc.)
- Endpoints or functions to document

**For GUIDE:**
- Guide topic/title
- Target audience (beginner, intermediate, advanced)
- Step-by-step or conceptual?

**For CHANGELOG:**
- Current version
- Recent changes to document
- Format preference (Keep a Changelog format?)

**For CONTRIBUTING:**
- Code of conduct needed?
- Branch strategy (Git Flow, GitHub Flow, etc.)
- Review process
- Testing requirements

**For RUNBOOK:**
- System/service name
- Deployment platform
- Key operational procedures

**For CUSTOM:**
- Document title and purpose
- Sections needed
- Target audience

### 4. Investigate Codebase (If Relevant)

For document types that benefit from codebase investigation (README, API, ARCHITECTURE):

Use the Task tool with `subagent_type=Explore` to gather context:
- Project structure and technology stack
- Existing documentation
- Configuration files
- Key files to reference in documentation

**Skip investigation** for document types that don't need it (CHANGELOG, CUSTOM).

### 5. Select and Populate Template

Choose the appropriate embedded template and populate it with user responses and investigation findings.

#### README Template

```markdown
# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Features

{{KEY_FEATURES}}

## Installation

### Prerequisites

{{PREREQUISITES}}

### Setup

{{INSTALLATION_STEPS}}

## Usage

### Quick Start

{{QUICK_START}}

### Examples

{{USAGE_EXAMPLES}}

## Configuration

{{CONFIGURATION_DETAILS}}

## Documentation

{{DOCUMENTATION_LINKS}}

## Contributing

{{CONTRIBUTING_INFO}}

## License

{{LICENSE_INFO}}

---

**Version:** {{VERSION}}
**Last Updated:** {{DATE}}
```

#### API Documentation Template

```markdown
# {{API_NAME}} - API Documentation

{{API_DESCRIPTION}}

## Table of Contents

- [Overview](#overview)
- [Authentication](#authentication)
- [Endpoints](#endpoints) / [Functions](#functions)
- [Error Handling](#error-handling)
- [Examples](#examples)
- [Rate Limiting](#rate-limiting)

## Overview

**Base URL:** {{BASE_URL}}
**Version:** {{API_VERSION}}
**Format:** {{RESPONSE_FORMAT}}

{{OVERVIEW_DESCRIPTION}}

## Authentication

{{AUTH_DETAILS}}

## {{ENDPOINTS_OR_FUNCTIONS}}

### {{ENDPOINT_1_NAME}}

**{{METHOD}}** `{{PATH}}`

{{ENDPOINT_DESCRIPTION}}

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| {{PARAM_NAME}} | {{PARAM_TYPE}} | {{REQUIRED}} | {{PARAM_DESC}} |

**Response:**

```json
{{RESPONSE_EXAMPLE}}
```

**Example:**

```{{LANGUAGE}}
{{CODE_EXAMPLE}}
```

---

### {{ENDPOINT_2_NAME}}

[Repeat pattern for additional endpoints/functions]

---

## Error Handling

{{ERROR_HANDLING}}

**Common Error Codes:**

| Code | Description |
|------|-------------|
| {{ERROR_CODE}} | {{ERROR_DESC}} |

## Examples

### {{EXAMPLE_1_TITLE}}

{{EXAMPLE_1_DESCRIPTION}}

```{{LANGUAGE}}
{{EXAMPLE_1_CODE}}
```

## Rate Limiting

{{RATE_LIMIT_INFO}}

---

**Last Updated:** {{DATE}}
**Maintained By:** {{MAINTAINER}}
```

#### GUIDE Template

```markdown
# {{GUIDE_TITLE}}

{{GUIDE_DESCRIPTION}}

**Audience:** {{TARGET_AUDIENCE}}
**Duration:** {{ESTIMATED_TIME}}

## Table of Contents

- [Prerequisites](#prerequisites)
- [Overview](#overview)
- [Steps](#steps)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Prerequisites

{{PREREQUISITES}}

## Overview

{{OVERVIEW}}

## Steps

### Step 1: {{STEP_1_TITLE}}

{{STEP_1_DESCRIPTION}}

{{STEP_1_INSTRUCTIONS}}

**Example:**

```{{LANGUAGE}}
{{STEP_1_CODE}}
```

### Step 2: {{STEP_2_TITLE}}

{{STEP_2_DESCRIPTION}}

{{STEP_2_INSTRUCTIONS}}

[Repeat for additional steps]

---

## Troubleshooting

### {{ISSUE_1}}

**Problem:** {{PROBLEM_DESC}}

**Solution:** {{SOLUTION}}

---

## Next Steps

{{NEXT_STEPS}}

## Additional Resources

{{RESOURCES}}

---

**Last Updated:** {{DATE}}
**Author:** {{AUTHOR}}
```

#### CHANGELOG Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- {{NEW_FEATURES}}

### Changed
- {{CHANGES}}

### Deprecated
- {{DEPRECATIONS}}

### Removed
- {{REMOVALS}}

### Fixed
- {{FIXES}}

### Security
- {{SECURITY_UPDATES}}

## [{{VERSION}}] - {{DATE}}

### Added
- {{ADDED_ITEMS}}

### Changed
- {{CHANGED_ITEMS}}

### Fixed
- {{FIXED_ITEMS}}

---

[Unreleased]: {{REPO_URL}}/compare/v{{VERSION}}...HEAD
[{{VERSION}}]: {{REPO_URL}}/releases/tag/v{{VERSION}}
```

#### CONTRIBUTING Template

```markdown
# Contributing to {{PROJECT_NAME}}

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

{{CODE_OF_CONDUCT}}

## Getting Started

### Prerequisites

{{PREREQUISITES}}

### Development Setup

{{SETUP_INSTRUCTIONS}}

## Development Process

### Branch Strategy

{{BRANCH_STRATEGY}}

**Branch Naming:**
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `chore/description` - Maintenance tasks

### Workflow

{{WORKFLOW_DESCRIPTION}}

## Pull Request Process

1. {{PR_STEP_1}}
2. {{PR_STEP_2}}
3. {{PR_STEP_3}}

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Tests added/updated and passing
- [ ] Documentation updated
- [ ] Commit messages are clear and descriptive
- [ ] Branch is up to date with base branch
- [ ] {{CUSTOM_CHECKLIST_ITEM}}

## Coding Standards

### {{LANGUAGE}} Style Guide

{{STYLE_GUIDE}}

### Code Review Criteria

{{REVIEW_CRITERIA}}

## Testing

### Running Tests

{{TEST_INSTRUCTIONS}}

### Writing Tests

{{TEST_WRITING_GUIDE}}

### Coverage Requirements

{{COVERAGE_REQUIREMENTS}}

## Documentation

{{DOCUMENTATION_REQUIREMENTS}}

---

## Questions?

{{CONTACT_INFO}}

---

**Last Updated:** {{DATE}}
```

#### RUNBOOK Template

```markdown
# {{SERVICE_NAME}} - Runbook

**Service:** {{SERVICE_NAME}}
**Owner:** {{OWNER}}
**Last Updated:** {{DATE}}

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Deployment](#deployment)
- [Operations](#operations)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)
- [Incident Response](#incident-response)

## Overview

**Purpose:** {{PURPOSE}}
**Dependencies:** {{DEPENDENCIES}}
**SLA:** {{SLA}}

## Architecture

{{ARCHITECTURE_DESCRIPTION}}

**Components:**
{{COMPONENTS}}

## Deployment

### Environment Setup

{{ENV_SETUP}}

### Deployment Process

{{DEPLOYMENT_STEPS}}

### Rollback Procedure

{{ROLLBACK_STEPS}}

### Configuration

{{CONFIGURATION}}

## Operations

### Starting the Service

{{START_INSTRUCTIONS}}

### Stopping the Service

{{STOP_INSTRUCTIONS}}

### Scaling

{{SCALING_INSTRUCTIONS}}

### Routine Maintenance

{{MAINTENANCE_TASKS}}

## Monitoring

### Health Checks

{{HEALTH_CHECKS}}

### Key Metrics

| Metric | Threshold | Action |
|--------|-----------|--------|
| {{METRIC_NAME}} | {{THRESHOLD}} | {{ACTION}} |

### Alerts

{{ALERT_CONFIGURATION}}

## Troubleshooting

### {{COMMON_ISSUE_1}}

**Symptoms:** {{SYMPTOMS}}

**Diagnosis:** {{DIAGNOSIS}}

**Resolution:** {{RESOLUTION}}

---

### {{COMMON_ISSUE_2}}

[Repeat pattern]

---

## Incident Response

### Severity Levels

| Level | Description | Response Time |
|-------|-------------|---------------|
| P1 | {{CRITICAL}} | {{P1_TIME}} |
| P2 | {{HIGH}} | {{P2_TIME}} |
| P3 | {{MEDIUM}} | {{P3_TIME}} |
| P4 | {{LOW}} | {{P4_TIME}} |

### Escalation Path

{{ESCALATION}}

### Post-Incident

{{POST_INCIDENT_PROCESS}}

---

## Contacts

{{CONTACTS}}

---

**Document Version:** {{VERSION}}
**Last Reviewed:** {{DATE}}
```

#### CUSTOM Template

```markdown
# {{DOCUMENT_TITLE}}

{{DOCUMENT_DESCRIPTION}}

## Table of Contents

{{TOC}}

## {{SECTION_1}}

{{SECTION_1_CONTENT}}

## {{SECTION_2}}

{{SECTION_2_CONTENT}}

---

**Last Updated:** {{DATE}}
**Author:** {{AUTHOR}}
```

### 6. Fill Placeholders

Replace all `{{PLACEHOLDERS}}` with:
- User-provided information
- Investigation findings (if applicable)
- **For UPDATE mode:** Existing content from current document
- Auto-detected values (project name, current date, etc.)
- Reasonable defaults where appropriate

**Special placeholders:**
- `{{DATE}}`: Current date (YYYY-MM-DD format)
- `{{VERSION}}`: From package.json, pubspec.yaml, existing doc, or ask user
- `{{PROJECT_NAME}}`: From config files or directory name
- `{{LANGUAGE}}`: Detected or user-specified

### 7. Determine Output Path

**Default paths by document type:**
- README: `README.md` (project root)
- API: `docs/api.md` or `docs/API.md`
- GUIDE: `docs/guides/{{GUIDE_SLUG}}.md`
- CHANGELOG: `CHANGELOG.md` (project root)
- CONTRIBUTING: `CONTRIBUTING.md` (project root)
- ARCHITECTURE: `docs/architecture/{{TOPIC}}.md`
- RUNBOOK: `docs/runbooks/{{SERVICE}}.md`
- CUSTOM: Ask user for path

**For UPDATE mode:** Use the existing document's path

**If user specified a path:** Use that path

**If target directory doesn't exist:** Ask for permission to create it

### 8. Preview & Confirm

Show a preview of the generated or updated document:

**For CREATE mode:**
```
═══════════════════════════════════════
DOCUMENTATION PREVIEW
═══════════════════════════════════════
Type: {{DOC_TYPE}}
Output: {{OUTPUT_PATH}}

Document structure:
{{SECTION_LIST}}

───────────────────────────────────────
PREVIEW (first 50 lines):
───────────────────────────────────────
{{PREVIEW_CONTENT}}
...
═══════════════════════════════════════
```

**For UPDATE mode:**
```
═══════════════════════════════════════
UPDATE PREVIEW
═══════════════════════════════════════
Strategy: {{STRATEGY}}
File: {{OUTPUT_PATH}}

Changes:
+ {{SECTIONS_ADDED}} sections added
~ {{SECTIONS_MODIFIED}} sections modified
✓ {{SECTIONS_PRESERVED}} sections preserved

───────────────────────────────────────
UPDATED CONTENT (first 50 lines):
───────────────────────────────────────
{{PREVIEW_CONTENT}}
...
═══════════════════════════════════════
```

**Ask explicitly:**
- CREATE: "Should I create this document at `{{OUTPUT_PATH}}`?"
- UPDATE: "Should I update the document at `{{OUTPUT_PATH}}` with these changes?"

**STOP and wait for approval.** User can request:
- Content modifications
- Different output path (CREATE only)
- Different update strategy (UPDATE only)
- Additional sections
- Template changes

### 9. Create or Update Document (Only After Approval)

**Only after explicit approval:**

1. Create directory structure if needed (after asking permission)
2. **For CREATE:** Write documentation file using Write tool
3. **For UPDATE:** Use Edit tool to update existing document
4. Confirm creation/update

### 10. Next Steps

After successful creation/update:

**For CREATE:**
```
✅ Documentation Created

File: {{OUTPUT_PATH}}
Type: {{DOC_TYPE}}

Next steps:
- Review and refine the content
- Add project-specific details
- Update README index: /index-docs
- Keep this document updated as project evolves

Related commands:
- /index-docs - Update README with documentation index
- /doc-project - Generate architecture documentation
- /create-doc UPDATE - Update this doc later with template changes
```

**For UPDATE:**
```
✅ Documentation Updated

File: {{OUTPUT_PATH}}
Strategy: {{STRATEGY}}
Changes: +{{ADDED}} ~{{MODIFIED}} ✓{{PRESERVED}}

Next steps:
- Review the updated content
- Fill in any new placeholder sections
- Update version number if needed
- Update README index if structure changed: /index-docs

Related commands:
- /index-docs - Update README with documentation index
```

## Tool Preferences

- **Investigation:** Use Task tool with `subagent_type=Explore` when codebase context is needed
- **File Operations:** Use Read, Write, Edit, and Glob tools
- **Detection:** Use Glob to find config files for auto-detection

## What This Command Does vs Does NOT Do

✅ **This command DOES:**
- Prompt user for document type and mode (CREATE or UPDATE)
- Provide structured templates for common doc types
- Update existing documentation with template structure
- Auto-fill information when possible
- Preserve existing content when updating
- Create well-formatted markdown documentation
- Ask for confirmation before creating/updating files

❌ **This command does NOT:**
- Modify existing code
- Automatically update documentation without user input
- Commit changes to git
- Generate code or tests
- Overwrite content without user approval

## Special Considerations

### For Flutter/Dart Projects
- Include pub.dev package documentation links
- Reference Flutter/Dart conventions
- Include widget examples in guides
- Link to Flutter documentation where relevant

### For API Documentation
- Support both REST and package/library APIs
- Include code examples in appropriate language
- Document error responses clearly
- Provide authentication details

### Template Customization
- Users can modify templates after generation
- Encourage users to add project-specific sections
- Templates are starting points, not rigid requirements

### UPDATE Mode Best Practices
- **MERGE:** Best for adding missing sections without changing existing structure
- **ENHANCE:** Best for improving structure while keeping all content
- **REFRESH:** Best when document structure is significantly outdated (use with caution)

## Usage Examples

**Example 1 - CREATE README:**
```
User: /create-doc
Assistant: I'll help you create or update documentation. What would you like to do?
[Lists options]

User: CREATE, README for a Flutter app
Assistant: Great! I'll create a README for your Flutter app. Let me gather some details...

What's the app's name and description?

User: TaskFlow - A productivity app for managing daily tasks
Assistant: [Investigates codebase, populates template, shows preview]

Should I create this document at `README.md`?
```

**Example 2 - UPDATE CONTRIBUTING:**
```
User: /create-doc
Assistant: [Shows options]

User: UPDATE, CONTRIBUTING, path is CONTRIBUTING.md
Assistant: I've analyzed the existing document at CONTRIBUTING.md.

Current structure:
- Code of Conduct
- Getting Started
- Testing

Template structure for CONTRIBUTING:
- Code of Conduct
- Getting Started
- Development Process (MISSING)
- Pull Request Process (MISSING)
- Coding Standards (MISSING)
- Testing
- Documentation (MISSING)

How would you like to update this document?
1. MERGE - Add missing sections, preserve existing
2. ENHANCE - Add missing and reorganize existing
3. REFRESH - Replace with new template

User: 1
Assistant: [Shows diff preview with new sections being added]

Should I update the document at `CONTRIBUTING.md` with these changes?
```

**Example 3 - CUSTOM Document:**
```
User: /create-doc
Assistant: [Shows options]

User: CREATE, CUSTOM - onboarding guide for new developers
Assistant: I'll create a custom document. What sections should it include?

User: Setup, codebase tour, common tasks, where to get help
Assistant: [Creates custom template with those sections, shows preview]
```

## Notes

- Templates are opinionated starting points based on industry best practices
- UPDATE mode preserves user content while improving structure
- Encourage users to customize and refine generated documentation
- Link to related project documentation when it exists
- Keep documentation close to the code it describes
- For Flutter projects, reference official Flutter documentation standards
- Always backup important documents before using REFRESH strategy

---

**Command Version:** 1.0
**Compatible with:** RAPID-AI Framework
**No BMAD dependencies**
