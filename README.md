# RAPID-MCP-Server

**Status:** 📋 Planning Phase - PRD Complete, Implementation Pending

Unified Model Context Protocol (MCP) server for RAPID-style AI workflows.
Exposes 25 standardized RAPID commands to **any MCP-compatible AI client** (Claude Code, GitHub Copilot, Codex CLI, VS Code, etc.).

---

## Current State

This repository contains:
- ✅ **25 RAPID command definitions** (`commands/*.md`) - Complete workflow playbooks
- ✅ **Comprehensive PRD** (`prd.md`) - Full technical specification for Zig implementation
- ✅ **Contributor guidelines** (`AGENTS.md`) - Repository expectations for agents and maintainers
- ⏳ **No implementation yet** - Code coming soon

**Next up:** Begin Phase 1 implementation (Zig project setup + 3 MVP commands)

---

## Architecture Decision: Zig, Not Node.js

**Why Zig?**
- ⚡ Blazing fast startup (< 50ms vs Node.js ~200ms)
- 📦 Zero dependencies - single static binary
- 🛡️ Memory safety without GC overhead
- 🔧 Easy C interop for system tools (gh CLI, git)
- 🚀 Foundation for RapidOS "AI-first" operating system

**Strategic rationale:** Position RapidOS as an innovative, performance-focused platform by embracing emerging technologies early.

See `prd.md` for full technical justification.

---

## What This Will Be

Once implemented, this MCP server will:

1. **Load 25 RAPID commands** from YAML files (converted from current `.md` files)
2. **Validate all parameters rigorously** (never trust AI input)
3. **Execute workflows via GitHub CLI** (`gh`) for GitHub operations
4. **Return structured prompts** to AI clients with full context
5. **Optional HTTP bridge** for non-MCP clients (VS Code tasks, etc.)

### Planned Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   AI Clients                            │
│  Claude Code │ Copilot │ Codex │ VS Code │ Other MCP    │
└──────────────┬──────────┬───────┬──────────┬────────────┘
               │          │       │          │
               └──────────┴───────┴──────────┘
                          │ MCP Protocol (JSON-RPC/stdio)
               ┌──────────▼────────────────────┐
               │  Rapid MCP Server (Zig)       │
               │  - YAML Command Loader        │
               │  - Parameter Validator        │
               │  - GitHub CLI Wrapper         │
               │  - Prompt Template Engine     │
               └──────────┬────────────────────┘
                          │
               ┌──────────▼────────────────────┐
               │  External Tools                │
               │  - gh CLI (GitHub ops)         │
               │  - git (repo context)          │
               │  - filesystem (docs)           │
               └────────────────────────────────┘
```

---

## Command Inventory (25 Total)

All commands currently defined in `commands/*.md`:

**GitHub Operations (11)**
- sanity-check, gh-work, gh-finish, gh-update-issue, gh-review-issue
- gh-validate-issue, gh-next-issue, create-issue, gh-create-milestone
- create-pr, review-pr

**Documentation (3)**
- doc-project, create-doc, shard-doc

**Workflow/Analysis (8)**
- brainstorm, elicit, test-design, qa-gate, qa-apply-fixes
- nfr-assess, risk-assess, correct-course

**Utilities (3)**
- research-prompt, gen-prompt, trace-requirements

---

## Implementation Phases

See `prd.md` for full details. Summary:

1. **Phase 1 (1-2 weeks):** Foundation - Zig setup, 3 MVP commands (sanity-check, gh-work, create-issue)
2. **Phase 2 (1 week):** End-to-end testing with Claude Code
3. **Phase 3 (2-3 weeks):** Port all 25 commands, comprehensive testing
4. **Phase 4 (1 week):** Optional HTTP bridge for non-MCP clients
5. **Phase 5 (1 week):** RapidOS integration prep, cross-platform binaries

**Estimated timeline:** 6-8 weeks total

---

## Prerequisites (Future)

When implemented, you'll need:
- Zig 0.14.0+ (or latest stable)
- GitHub CLI (`gh`) authenticated locally
- git (for repository context)

---

## Example Usage (Future)

Once implemented, you'll be able to:

### Claude Code CLI
```bash
# Work on a GitHub issue with full investigate → plan → execute workflow
/gh-work issue_number:42
```

### Generic MCP Client
```json
{
  "method": "tools/call",
  "params": {
    "name": "gh-work",
    "arguments": { "issue_number": 42 }
  }
}
```

### VS Code Task (via HTTP bridge)
```json
{
  "label": "Work on Issue #42",
  "type": "shell",
  "command": "curl -X POST http://localhost:5001/run -d '{\"command\":\"gh-work\",\"args\":{\"issue_number\":42}}'"
}
```

---

## Why This Matters

**Problem:** RAPID workflow commands currently only work with Claude Code (defined in `.claude/commands/*.md`). Other AI tools can't access them.

**Solution:** MCP server exposes all commands to any MCP-compatible client. Write once, use everywhere.

**Bonus:** High-performance Zig implementation becomes core component of RapidOS, demonstrating technical leadership in AI-native systems.

---

## Technology Stack (Planned)

**Core:**
- Zig 0.14.0+ (build system + runtime)

**Dependencies:**
- [ZigJR](https://github.com/williamw520/zigjr) - JSON-RPC 2.0 + MCP protocol
- [zig-yaml](https://github.com/kubkon/zig-yaml) - YAML parsing for command definitions
- [http.zig](https://github.com/karlseguin/http.zig) - Optional HTTP bridge (Phase 4)

**External Tools:**
- GitHub CLI (`gh`) - All GitHub operations
- git - Repository context detection

---

## Performance Targets

- Startup: < 50ms (cold start)
- Command latency: < 100ms (YAML load + validation)
- Memory: < 10MB (resident)
- Binary size: < 5MB (static)

---

## Next Steps

1. ✅ PRD complete (see `prd.md`)
2. ⏳ Initialize Zig project in this repository
3. ⏳ Set up `build.zig` with ZigJR + zig-yaml dependencies
4. ⏳ Convert 3 MVP commands to YAML schema
5. ⏳ Implement core MCP protocol handlers
6. ⏳ End-to-end test with Claude Code

---

## Related Projects

- [lsp-mcp-server](https://github.com/nzrsky/lsp-mcp-server) - Zig MCP implementation example
- [zig-mcp](https://github.com/zig-wasm/zig-mcp) - Zig docs MCP server
- [MCP Specification](https://modelcontextprotocol.io) - Official protocol docs

---

## License

MIT
