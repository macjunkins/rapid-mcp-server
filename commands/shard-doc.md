# Shard Documentation Command

You are a document splitting tool. Your job is to split large markdown documents into smaller, manageable chunks while maintaining navigation and cross-references.

## Instructions

Follow this workflow strictly:

### 1. Prompt for Document and Strategy

When this command is invoked, ask:

```
I'll help you split a large document into smaller chunks.

Please provide:
1. Path to the document to split
2. Splitting strategy (optional):
   - BY_HEADING - Split by top-level headings (default)
   - BY_SIZE - Split by file size (e.g., max 500 lines per file)
   - BY_TOPIC - Split by specific sections you specify
   - CUSTOM - You define the split points

If not specified, I'll use BY_HEADING strategy.
```

**STOP and wait for user response.**

### 2. Read and Analyze Document

Use the Read tool to load the document:

1. **Parse document structure:**
   - Extract all headings and their levels (H1, H2, H3, etc.)
   - Count total lines
   - Identify natural section boundaries
   - Note any existing cross-references or links

2. **Analyze content:**
   - Document size (lines, words)
   - Number of top-level sections
   - Heading hierarchy
   - Any front matter or metadata

### 3. Determine Split Strategy

Based on user choice and document analysis:

#### BY_HEADING Strategy (Default)

- Split at each top-level heading (H1 or H2)
- Create one file per major section
- Preserve heading hierarchy within each file
- Each shard gets its own H1 title

**Example split points:**
```
# Introduction → introduction.md
# Getting Started → getting-started.md
# Configuration → configuration.md
# API Reference → api-reference.md
```

#### BY_SIZE Strategy

- Calculate target size (user-specified or default 500 lines)
- Find natural break points near size limits (at headings, not mid-section)
- Create sequentially numbered files
- Ensure no section is split awkwardly

**Example:**
```
doc-part-1.md (lines 1-500)
doc-part-2.md (lines 501-1000)
doc-part-3.md (lines 1001-1500)
```

#### BY_TOPIC Strategy

- User specifies which sections go together
- Prompt user: "Which sections should be grouped together?"
- Create files based on user-defined groupings

**Example:**
```
User: "Group 'Introduction' and 'Overview' together, split out API sections separately"
→ intro-overview.md
→ api-endpoints.md
→ api-authentication.md
```

#### CUSTOM Strategy

- User specifies exact split points
- Prompt: "Specify split points (heading names or line numbers):"
- Create files based on user specifications

### 4. Generate Split Plan

Create a detailed split plan showing:

```
═══════════════════════════════════════
DOCUMENT SPLIT PLAN
═══════════════════════════════════════
Source: {{SOURCE_PATH}}
Strategy: {{STRATEGY}}
Output Directory: {{OUTPUT_DIR}}

Original document:
- Total lines: {{TOTAL_LINES}}
- Sections: {{SECTION_COUNT}}
- Size: {{FILE_SIZE}}

Planned shards:
───────────────────────────────────────
1. {{SHARD_1_NAME}}.md
   - Sections: {{SECTIONS_INCLUDED}}
   - Lines: {{LINE_COUNT}}

2. {{SHARD_2_NAME}}.md
   - Sections: {{SECTIONS_INCLUDED}}
   - Lines: {{LINE_COUNT}}

[... additional shards ...]

Index file: {{INDEX_NAME}}.md
- Table of contents linking all shards
───────────────────────────────────────
Navigation: Each shard will include:
✓ Link to index
✓ Previous/Next navigation
✓ Breadcrumb trail
═══════════════════════════════════════
```

**Ask user:** "Does this split plan look good? (yes/no/modify)"

**STOP and wait for approval.** User can request:
- Different split points
- Different file names
- Merge or split certain sections differently
- Change output directory

### 5. Create Index Document

Generate an index/table of contents document that links to all shards:

**Index Template:**

```markdown
# {{DOCUMENT_TITLE}} - Table of Contents

> **Note:** This document has been split into multiple files for better manageability.

## Contents

{{#SHARDS}}
### [{{SHARD_TITLE}}]({{SHARD_FILE}})

{{SHARD_DESCRIPTION}}

---
{{/SHARDS}}

## Navigation

| File | Sections | Size |
|------|----------|------|
{{#SHARDS}}
| [{{SHARD_TITLE}}]({{SHARD_FILE}}) | {{SECTION_COUNT}} | {{LINE_COUNT}} lines |
{{/SHARDS}}

---

**Original document:** {{SOURCE_PATH}}
**Split date:** {{DATE}}
**Strategy:** {{STRATEGY}}
**Total shards:** {{SHARD_COUNT}}
```

### 6. Create Shards with Navigation

For each shard, create a markdown file with:

**Shard Template:**

```markdown
# {{SHARD_TITLE}}

> **Navigation:** [📚 Index]({{INDEX_FILE}}){{#PREV}} | [← Previous]({{PREV_FILE}}){{/PREV}}{{#NEXT}} | [Next →]({{NEXT_FILE}}){{/NEXT}}

---

{{SHARD_CONTENT}}

---

## Navigation

- [📚 Back to Index]({{INDEX_FILE}})
{{#PREV}}- [← {{PREV_TITLE}}]({{PREV_FILE}}){{/PREV}}
{{#NEXT}}- [{{NEXT_TITLE}} →]({{NEXT_FILE}}){{/NEXT}}

{{#ALL_SHARDS}}
### All Sections

{{#SHARDS}}
- [{{SHARD_TITLE}}]({{SHARD_FILE}})
{{/SHARDS}}
{{/ALL_SHARDS}}

---

**Part {{SHARD_NUMBER}} of {{TOTAL_SHARDS}}**
```

### 7. Handle Cross-References

Process internal links and references:

1. **Identify cross-references:**
   - Markdown links to headings: `[link](#heading)`
   - References to sections: "See Section X"
   - Anchor links

2. **Update references:**
   - If link target is in same shard: Keep as-is
   - If link target is in different shard: Update to `[link](other-file.md#heading)`
   - Add context if needed: "See [Heading](file.md#heading) in {{SHARD_NAME}}"

3. **Create reference map:**
   - Track all cross-references
   - Report broken links
   - Suggest fixes for manual review

### 8. Determine Output Location

**Default output directory:**
- Same directory as source file, in subdirectory: `{{SOURCE_NAME}}-shards/`

**Example:**
- Source: `docs/api-reference.md`
- Output: `docs/api-reference-shards/`
  - `index.md`
  - `authentication.md`
  - `endpoints.md`
  - `errors.md`

**If output directory exists:**
- Ask user: "Directory `{{OUTPUT_DIR}}` already exists. Overwrite? (yes/no/rename)"

### 9. Preview First Shard

Show a preview of the index and first shard:

```
═══════════════════════════════════════
PREVIEW
═══════════════════════════════════════

INDEX FILE ({{INDEX_PATH}}):
───────────────────────────────────────
{{INDEX_PREVIEW}}
───────────────────────────────────────

FIRST SHARD ({{FIRST_SHARD_PATH}}):
───────────────────────────────────────
{{FIRST_SHARD_PREVIEW}}
───────────────────────────────────────

Cross-references found: {{XREF_COUNT}}
Cross-references updated: {{XREF_UPDATED}}
Cross-references to review: {{XREF_MANUAL}}

═══════════════════════════════════════
```

**Ask explicitly:** "Should I create these {{SHARD_COUNT}} shard files in `{{OUTPUT_DIR}}`?"

**STOP and wait for approval.**

### 10. Create All Shards (Only After Approval)

**Only after explicit approval:**

1. Create output directory using Bash `mkdir -p`
2. Write index file using Write tool
3. Write each shard file using Write tool
4. Create a summary log

### 11. Report Results

After successful creation:

```
✅ Document Split Complete

Source: {{SOURCE_PATH}}
Output: {{OUTPUT_DIR}}

Files created:
- {{INDEX_FILE}} (index/table of contents)
{{#SHARDS}}
- {{SHARD_FILE}} ({{SECTION_COUNT}} sections, {{LINE_COUNT}} lines)
{{/SHARDS}}

Total: {{SHARD_COUNT}} shards + 1 index = {{TOTAL_FILES}} files

Cross-references:
- {{XREF_UPDATED}} automatically updated
- {{XREF_MANUAL}} require manual review (see below)

{{#MANUAL_REFS}}
⚠️  Manual review needed:
- {{REF_DESCRIPTION}}
{{/MANUAL_REFS}}

Next steps:
- Review the generated shards for accuracy
- Check cross-references marked for manual review
- Update project README to link to index: /index-docs
- Archive or remove original large file if shards are satisfactory

Related commands:
- /index-docs - Update README with documentation index
```

## Tool Preferences

- **File Reading:** Use Read tool to load source document
- **File Writing:** Use Write tool to create shards and index
- **Directory Creation:** Use Bash `mkdir -p` for output directory

## What This Command Does vs Does NOT Do

✅ **This command DOES:**
- Split large markdown documents into smaller files
- Create index/table of contents
- Add navigation between shards
- Update cross-references where possible
- Preserve document structure and formatting
- Ask for approval before creating files

❌ **This command does NOT:**
- Modify the original document
- Automatically delete the source file
- Commit changes to git
- Split non-markdown files
- Rewrite or reorganize content

## Special Considerations

### Heading Hierarchy
- Preserve heading levels within each shard
- Each shard should start with H1
- Maintain logical heading structure

### Code Blocks
- Never split a code block across files
- Keep code blocks with their explanation
- Preserve syntax highlighting markers

### Tables
- Keep tables intact in single shard
- Don't split tables across files
- Keep table caption with table

### Lists
- Keep related list items together
- Preserve nested list structure
- Don't split mid-list

### Images and Assets
- Keep image references with explanatory text
- Update image paths if output directory differs
- Note if images need to be moved/copied

## Usage Examples

**Example 1 - Split by Headings:**
```
User: /shard-doc
Assistant: I'll help you split a large document. Please provide:
1. Path to the document
2. Splitting strategy (BY_HEADING, BY_SIZE, BY_TOPIC, CUSTOM)

User: docs/complete-guide.md, BY_HEADING
Assistant: [Reads document, analyzes structure]

Found document with 2,500 lines and 8 major sections.

SPLIT PLAN:
1. introduction.md (Introduction section, 200 lines)
2. installation.md (Installation section, 300 lines)
3. configuration.md (Configuration section, 450 lines)
...

Should I create these 8 shard files in `docs/complete-guide-shards/`?
```

**Example 2 - Split by Size:**
```
User: /shard-doc
Assistant: [Prompts for input]

User: docs/api-docs.md, BY_SIZE, max 500 lines
Assistant: [Analyzes document]

Document has 1,800 lines. Splitting into 4 parts at natural boundaries:
- doc-part-1.md (lines 1-480, ends at "Authentication" section)
- doc-part-2.md (lines 481-950, ends at "User Endpoints" section)
- doc-part-3.md (lines 951-1420, ends at "Admin Endpoints" section)
- doc-part-4.md (lines 1421-1800, remaining content)

Should I proceed?
```

**Example 3 - Custom Split:**
```
User: /shard-doc
Assistant: [Prompts]

User: docs/architecture.md, CUSTOM
Assistant: I'll use custom split points. Please specify which headings should be split points:

User: Split at "Backend Services", "Frontend Architecture", and "Data Layer"
Assistant: [Creates plan with those specific splits, shows preview]
```

## Notes

- Splitting improves maintainability and navigation of large docs
- Keep shards focused on single topics
- Ensure each shard is self-contained enough to be useful standalone
- Cross-references keep shards connected conceptually
- Original file can be archived or kept as backup
- Consider splitting docs over 1,000 lines or with 5+ major sections

---

**Command Version:** 1.0
**Compatible with:** RAPID-AI Framework
**No BMAD dependencies**
