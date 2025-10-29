# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Status

**Current Phase:** Planning & Design (no implementation yet)

This repository contains:
- **25 RAPID command definitions** (`commands/*.md`) - ~8,700 lines of workflow playbooks
- **Comprehensive PRD** (`prd.md`) - Full technical specification for Zig implementation
- **No code yet** - Implementation has not started

**Critical:** Do not attempt to run build/test commands. There is no `src/` directory, no build system yet.

---

## Architecture Overview

### Planned System (see prd.md for details)

**Target Implementation:** Model Context Protocol (MCP) server written in **Zig** (not Node.js)

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
- Performance: < 50ms startup vs Node.js ~200ms
- Zero dependencies: single static binary
- Foundation for RapidOS "AI-first" operating system
- Strategic positioning as early adopter

**Key Dependencies (planned):**
- ZigJR (JSON-RPC 2.0 + MCP protocol)
- zig-yaml (YAML parsing for command definitions)
- http.zig (optional HTTP bridge for non-MCP clients)

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

**Total estimated timeline:** 6-8 weeks

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

- Startup time: < 50ms (cold start)
- Command latency: < 100ms (YAML load + validation)
- GitHub CLI overhead: < 500ms (network dependent)
- Memory footprint: < 10MB (resident)
- Binary size: < 5MB (static binary)

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
- **ZigJR (JSON-RPC + MCP):** https://github.com/williamw520/zigjr
- **zig-yaml:** https://github.com/kubkon/zig-yaml
- **GitHub CLI docs:** https://cli.github.com/manual/
- **Related Zig MCP servers:**
  - lsp-mcp-server: https://github.com/nzrsky/lsp-mcp-server
  - zig-mcp: https://github.com/zig-wasm/zig-mcp
