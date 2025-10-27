# RAPID-MCP-Server

Unified Model Context Protocol (MCP) server for RAPID-style AI workflows.  
Implements a single command surface usable from **Claude CLI**, **Codex CLI**, **VS Code tasks**, or **GitHub Copilot** via a local bridge.

---

## Overview

This server exposes standardized RAPID commands (sanity check, fetch issue, create PR, etc.) through the MCP protocol.  
Each AI client calls the same commands, ensuring consistent behavior across tools.

### Architecture

```
Claude CLI ----\
Codex CLI ------>  MCP Server  ---> gh CLI + local FS
VS Code --------/
```

---

## Features

- JSON-RPC compliant MCP server (Node.js)
- Connects to `gh` CLI for GitHub operations
- Modular command structure (`src/commands/*`)
- Optional HTTP bridge for non-MCP clients
- Works with existing slash commands (`/rapid.fetch_issue` etc.)

---

## Prerequisites

- Node.js ≥ 18
- GitHub CLI (`gh`) authenticated locally
- npm or pnpm

---

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/rapid-mcp-server.git
cd rapid-mcp-server
npm install
```

---

## Run the MCP server

```bash
node src/index.js
```

This starts a local MCP JSON-RPC server on `localhost:8080`.

> ⚠️ The `src/` entry points are still being scaffolded. Until they land, treat this repository as design documentation plus command specs.

---

## Optional: HTTP Bridge

To support clients that cannot speak MCP directly (Codex CLI, VS Code, Copilot), run the bridge:

```bash
node src/httpBridge.js
```

It exposes a simple REST endpoint:

```
POST http://localhost:5001/run
{
  "command": "rapid.fetch_issue",
  "args": { "issueNumber": "42" }
}
```

---

## Example Usage

### Claude CLI
```bash
/rapid.fetch_issue issueNumber:42
```

### Codex CLI
```bash
codex run "mcp-run rapid.fetch_issue '{\"issueNumber\":\"42\"}'"
```

or, inside an interactive Codex session:
```bash
run rapid.fetch_issue '{\"issueNumber\":\"42\"}'
```

### GitHub Copilot (VS Code Task)
Add to `.vscode/tasks.json`:

```json
{
  "label": "Run RAPID Fetch Issue",
  "type": "shell",
  "command": "mcp-run rapid.fetch_issue '{\"issueNumber\":\"42\"}'"
}
```

Trigger with `Ctrl+Shift+P → Run Task`.

---

## Directory Layout

```
src/
  index.js             # Core MCP server
  httpBridge.js        # Optional HTTP bridge
  commands/
    sanityCheck.js
    fetchIssue.js
    createPR.js
```

---

## Example Command Module

`src/commands/fetchIssue.js`

```js
import { execa } from "execa";

export async function fetchIssue({ issueNumber }) {
  const { stdout } = await execa("gh", [
    "issue", "view", issueNumber,
    "--json", "title,body,comments"
  ]);
  return JSON.parse(stdout);
}
```

---

## Add New Commands

1. Create a new file in `src/commands/`.
2. Export a function:  
   ```js
   export async function myCommand(args) { ... }
   ```
3. Register it in `src/index.js` under `server.on('callCommand', ...)`.
4. Add its schema to the `capabilities` list.

---

## Security Notes

- Server runs on localhost only.
- Validate all inputs before executing shell commands.
- Do not expose to public networks.

---

## Future Plans

- Zod-based schema validation  
- Logging and trace correlation for AI observability  
- GitHub GraphQL API integration  
- Containerized deployment

---

## Roadmap & Milestones

- **Milestone 1 — Scaffold the Runtime (2025-10-27 → 2025-11-08)**  
  Standing up the TypeScript project, MCP transport skeleton, and HTTP bridge stubs. Deliver `src/index.ts` with handshake logging, environment-driven config, and a shared command loader that can dispatch no-op handlers.
- **Milestone 2 — Core Command Parity (2025-11-11 → 2025-12-02)**  
  Implement `rapid.sanity_check`, `rapid.fetch_issue`, and `rapid.create_pr` handlers with GitHub CLI integration, argument validation, and structured error envelopes. Provide end-to-end smoke scripts for Claude CLI, Codex CLI, and the HTTP bridge.
- **Milestone 3 — Workflow Automation (2025-12-05 → 2026-01-09)**  
  Port the remaining RAPID command playbooks into executable modules, add prompt scaffolding helpers, and introduce persistence helpers for docs artifacts. Ensure VS Code tasks and Copilot bridge can drive the same flows.
- **Milestone 4 — Production Hardening (2026-01-13 → 2026-02-07)**  
  Add telemetry, opt-in auth on the HTTP bridge, replay-safe logging, and regression tests. Package Docker image, document deployment, and tag v1.0.0 for general use.

### Core User Stories

- As a RAPID workflow facilitator, I want to trigger `rapid.sanity_check` from Claude CLI so I can keep teams aligned without leaving the chat.
- As an engineering lead, I want Codex CLI to execute `rapid.fetch_issue` and summarize GitHub data so I can triage work directly from the terminal.
- As a contributor using VS Code, I want the MCP bridge to expose `rapid.create_pr` as a task so I can open standardized pull requests without memorizing the `gh` flags.
- As a documentation steward, I want RAPID commands to persist artifacts to `docs/` so our brainstorms, risk assessments, and QA plans remain auditable.
- As a platform maintainer, I want observability hooks and configuration via environment variables so I can monitor and tune the server in staging and production.

---

## License

MIT
