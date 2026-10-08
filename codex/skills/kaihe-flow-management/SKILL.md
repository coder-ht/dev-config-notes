---
name: kaihe-flow-management
description: Safely manage Kaihe AI Center Flows through the /flows API and UI: list, inspect, create, update, import, run, and delete workflows; inspect component schemas and Playground sessions. Use when the user mentions /flows, AI Flow, 工作流管理, 流程编排, Langflow, Playground, or asks to create, update, execute, or delete a Kaihe workflow.
---

# Kaihe Flow Management

Manage Kaihe AI Center workflows through the business-side AI Center API. Resolve the current deployment URL and use only current-session credentials; never place Authorization, Cookie, Token, API Key, or other runtime credentials in this Skill, source, logs, commits, or replies.

Read [references/kaihe-flow-api.md](references/kaihe-flow-api.md) before calling an API.

## Execution context

This is a business-side Skill. If the user does not specify an execution environment, use `KAIHE_BIZ_TOKEN`, `KAIHE_BIZ_TENANT`, and `KAIHE_BIZ_TERMINAL` from the current shell. The token must be non-empty. A user-supplied environment or credential overrides only the corresponding default; never substitute `KAIHE_ADMIN_*` values.

## Core workflow

1. Classify the request: list, inspect, create, update, import, run, manage Playground sessions, or delete.
2. Resolve the target Flow by ID or an exactly unique name. For a name, list flows first; do not update or delete an ambiguous match.
3. Before graph changes, read the complete Flow and query the needed component schemas. Preserve graph nodes, edges, and configuration not explicitly changed.
4. For create or update, state the resolved Flow, graph impact, and execution impact before writing. A natural-language description alone is insufficient to safely generate a complex graph; obtain the required node `cubeType`, ports, links, and config or let the user complete the canvas first.
5. For execution, distinguish direct run from Playground: Playground messages require a `sessionId`; direct run may use an optional session ID.
6. After every write, independently read back the Flow or session. After execution, inspect the non-stream result or read the persisted Playground messages.

## Flow graph rules

- A graph update is a complete replacement unless the API documents a patch. Read before update and send the full intended graph.
- Use `GET /components` and `GET /components/schema?cubeType=...` before adding a component. Do not invent component type names, port IDs, or config fields.
- Graph payloads use `schemaVersion: 1`. Reject a malformed or incomplete graph rather than overwriting an existing Flow with a guessed graph.
- Keep Flow IDs as opaque strings. Do not assume a display name is stable or unique.

## Safety rules

- Deletion is destructive: read the exact Flow, confirm the resolved ID and impact with the user, then delete and verify it is gone.
- Importing from Langflow changes the target Flow graph. Read the target Flow and confirm the import source before invoking it.
- `stream: false` is the preferred diagnostic mode because it returns a complete JSON result. For SSE, parse events and use Playground history to independently verify the persisted final reply.

## Completion report

Report Flow ID, name, operation, graph/read-back result, and execution/session result. Clearly state configuration or runtime behavior that could not be verified.
