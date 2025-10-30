# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Status

**Current Phase:** Planning & Design (no implementation yet)

**Last Updated:** 2025-10-29

This repository contains:
- **25 RAPID command definitions** (`commands/*.md`) - ~8,765 lines of workflow playbooks
- **1 YAML prototype** (`commands/sanity-check.yaml`) - Demonstrates YAML conversion feasibility
- **Comprehensive PRD v1.1** (`prd.md`) - Revised technical specification with reality checks
- **No code yet** - Implementation has not started

**Critical:** Do not attempt to run build/test commands. There is no `src/` directory, no build system yet.

**Recent Updates (2025-10-29):**
- Clarified ZigJR provides JSON-RPC foundation only (MCP layer must be built)
- Added shell injection prevention strategy
- Converted performance claims to targets (unverified)
- Identified template engine requirement from YAML prototype
- Revised timeline to 8-12 weeks (from 6-8)

---

## Architecture Overview

### Planned System (see prd.md for details)

**Target Implementation:** Model Context Protocol (MCP) server written in **Zig** (not Node.js)

**Reality Check:** This is pioneering work - no mature Zig MCP server implementations exist as reference. ZigJR provides JSON-RPC 2.0 foundation only; MCP protocol layer must be built from scratch.

**Core Components (to be implemented in this repo):**
```
rapid-mcp-server/                # This repository
├── src/
│   ├── main.zig                 # MCP JSON-RPC stdio event loop
│   ├── mcp.zig                  # Protocol handlers (initialize, tools/list, tools/call)
│   ├── command.zig              # YAML command loader & registry (HashMap)
│   ├── validator.zig            # Parameter validation (never trust AI input)
│   ├── github.zig               # GitHub CLI wrapper (std.process)
│   └── http_bridge.zig          # Optional HTTP server (Phase 4)
├── build.zig                    # Zig build configuration
├── build.zig.zon               # Package dependencies
├── commands/                    # YAML command definitions (source of truth)
│   ├── sanity-check.yaml       # Convert from .md
│   ├── gh-work.yaml
│   └── ... (23 more)
├── docs/
│   └── commands/               # Human-readable markdown (generated or archived .md files)
├── test/
│   ├── unit/
│   └── integration/
├── prd.md                      # Already exists
└── README.md                   # Already exists
```

**Why Zig?**
- Performance target: < 50ms startup vs Node.js ~200ms (unverified)
- Minimal dependencies: static binary with zig-yaml
- Foundation for RapidOS "AI-first" operating system
- Strategic positioning as early adopter (pioneering territory)

**Key Dependencies (planned):**
- ZigJR (JSON-RPC 2.0 foundation - MCP layer built on top)
- zig-yaml (YAML parsing - work-in-progress library)
- http.zig (optional HTTP bridge - truly optional for MVP)
- Template engine (likely needed for complex commands - contradicts "zero deps" goal)

---

## Command Structure (Current `.md` Format)

Commands live in `commands/*.md` with this pattern:

**Parameter Substitution:**
- `{{arg1}}`, `{{arg2}}`, etc. - positional arguments
- `{{NAMED_PARAM}}` - named parameters in prompts

**Example:** `gh-work.md`
```markdown
# GitHub Issue Workflow Command

You are working on a GitHub issue using investigate → plan → execute workflow.

## Instructions
### 1. Investigate
- Use `gh issue view {{arg1}} --json title,body,labels,milestone,state,number,assignees`
- Present clear summary...

### 2. Analyze
- Review issue body, identify tasks...
```

**Future YAML Format (prd.md Section: "YAML Command Schema"):**
Commands will be converted to YAML with:
- Strict parameter validation (type, range, pattern)
- Metadata for RapidOS integration
- Examples for AI context

---

## Command Categories (25 Total)

**GitHub Operations (11 commands):**
- `sanity-check` - Project health check (no GitHub calls)
- `gh-work` - Work on issue (investigate → plan → execute)
- `gh-finish`, `gh-update-issue`, `gh-review-issue`, `gh-validate-issue`
- `gh-next-issue`, `create-issue`, `gh-create-milestone`
- `create-pr`, `review-pr`

**Documentation (3):** `doc-project`, `create-doc`, `shard-doc`

**Workflow/Analysis (8):** `brainstorm`, `elicit`, `test-design`, `qa-gate`, `qa-apply-fixes`, `nfr-assess`, `risk-assess`, `correct-course`

**Utilities (3):** `research-prompt`, `gen-prompt`, `trace-requirements`

---

## Development Workflow (When Implementation Begins)

### Phase 1: Foundation (1-2 weeks)
1. Initialize Zig project in this repository
2. Set up `build.zig` with ZigJR + zig-yaml dependencies
3. Convert 3 MVP commands to YAML: `sanity-check`, `gh-work`, `create-issue`
4. Implement core MCP protocol handlers
5. Build parameter validation system
6. GitHub CLI integration (`gh` command wrapper)

### Phase 2: MVP Implementation (1 week)
- Command loader (scan `commands/`, parse YAML, build registry)
- Implement 3 MVP command handlers
- End-to-end test with Claude Code client

### Phases 3-5: See prd.md
- Phase 3: Port all 25 commands (2-3 weeks)
- Phase 4: HTTP bridge for non-MCP clients (1 week)
- Phase 5: RapidOS integration prep (1 week)

**Total estimated timeline:** 8-12 weeks (revised from 6-8)

**Timeline adjustment:** Accounts for building MCP layer from scratch, YAML conversion complexity discovered in prototype, and Zig ecosystem learning curve.

---

## Key Principles

### Never Trust AI Input
**Philosophy:** All parameters from AI clients must be rigorously validated.

**Why?**
- AI clients can hallucate values
- Prevent injection attacks (shell metacharacters in repo names)
- Type safety (string vs integer confusion)
- Resource protection (unbounded arrays, huge strings)

**Validation rules (see prd.md "Parameter Validation System"):**
- Type validation (string, integer, number, boolean, array, object)
- Range limits (min/max)
- Pattern matching (custom validators for MVP, PCRE bindings later)
- Required vs optional parameters

### GitHub CLI Integration
**All GitHub operations use `gh` CLI, NOT MCP GitHub tools.**

**Why?**
- 80-85% fewer tokens than MCP tools
- Automatically infers repository from git context
- Consistent JSON output format

**Pattern:**
```zig
const result = try std.process.Child.exec(.{
    .allocator = allocator,
    .argv = &[_][]const u8{"gh", "issue", "view", "42", "--json", "title,body"},
});
const parsed = try std.json.parseFromSlice(std.json.Value, allocator, result.stdout, .{});
```

---

## MCP Protocol Implementation

**Required JSON-RPC methods:**
1. `initialize` - Handshake and capability negotiation
2. `notifications/initialized` - Acknowledge initialization complete
3. `tools/list` - List all available commands
4. `tools/call` - Execute a command with validation

**Transport:** stdio (JSON-RPC over stdin/stdout)

**Response format for `tools/call`:**
```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "[Full prompt with workflow instructions and substituted parameters]"
      }
    ]
  }
}
```

See prd.md "MCP Protocol Implementation" for complete request/response examples.

---

## Performance Targets

**Note:** Aspirational targets, not verified benchmarks.

- Startup time: Target < 50ms (cold start) - *unverified until benchmarking*
- Command latency: Target < 100ms (YAML load + validation) - *depends on zig-yaml performance*
- GitHub CLI overhead: ~500ms+ (network dependent) - *will dominate total latency*
- Memory footprint: Target < 10MB (resident) - *unverified*
- Binary size: Target < 5MB (static binary) - *depends on final dependencies*

---

## When Working in This Repository

### Before Implementation Starts
- Read `prd.md` for complete technical specification
- Reference `commands/*.md` for existing workflow definitions
- Understand YAML conversion requirements (prd.md "YAML Command Schema")

### During Implementation
- Follow phased approach (Phase 1 → 2 → 3 → 4 → 5)
- Test each command end-to-end with Claude Code before moving on
- Validate all parameters rigorously (never skip validation)
- Use `gh` CLI for all GitHub operations
- Keep binary size and startup time within targets

### Testing Strategy
- Unit tests: command loader, validator, GitHub CLI wrapper, MCP handlers
- Integration tests: end-to-end command execution with real GitHub API
- Performance tests: startup time, command latency, memory profiling
- Compatibility tests: Claude Code, Copilot, Codex CLI, VS Code tasks

---

## External References

- **MCP Protocol:** https://modelcontextprotocol.io
- **ZigJR (JSON-RPC 2.0 only):** https://github.com/williamw520/zigjr
- **zig-yaml:** https://github.com/kubkon/zig-yaml
- **GitHub CLI docs:** https://cli.github.com/manual/
- **Related Projects (not pure Zig MCP references):**
  - lsp-mcp-server (LSP↔MCP bridge): https://github.com/nzrsky/lsp-mcp-server
  - zig-mcp (88.6% TypeScript): https://github.com/zig-wasm/zig-mcp
