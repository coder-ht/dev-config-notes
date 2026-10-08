---
name: cube2-menu-management
description: Safely query, add, update, delete, and authorize Cube2 OUAA management-side menus. Use when a user asks to manage a Cube2 application menu, such as "给xx应用增加xx菜单", menu lookup, path or sort changes, role visibility, or menu removal. Resolve the application and current menu tree before every write, and use only the current-session administrator credentials.
---

# Cube2 Menu Management

Manage OUAA menus only as a management-side operation. Do not treat management-side menu data as user-side menu or role configuration.

Read [references/cube2-ouaa-menu-api.md](references/cube2-ouaa-menu-api.md) before calling an API. It contains the fixed non-sensitive test defaults, endpoint contracts, payloads, and credential boundary.

## Execution context

This is a management-side Skill. If the user does not specify an execution environment, use `KAIHE_ADMIN_TOKEN`, `KAIHE_ADMIN_TENANT`, and `KAIHE_ADMIN_TERMINAL` from the current shell. The token must be non-empty. A user-supplied environment or credential overrides only the corresponding default; never substitute `KAIHE_BIZ_*` values.

## Core workflow

1. Classify the request as query, add, update, delete, or role authorization.
2. Resolve the target application from the user-provided name, its frontend package, router, and existing menu tree. Determine `applicationId` from current data; never reuse an ID from another application or an old task.
3. Query the existing menu tree with the resolved `terminalId` and `applicationId`. Record matching names, codes, paths, parents, sorts, enabled state, and children before any write.
4. For a write, state the resolved target, payload, and impact in the progress update. Use the current-session administrator credential only; never write a token or cookie to a Skill, rule, source file, log, commit, or response.
5. Perform the requested API call.
6. Independently query the menu tree or detail endpoint and verify the persisted ID, application, parent, code, name, path, sort, and enabled state.

If the application, route, target menu, or requested scope is ambiguous, stop before writing and ask for the missing direction.

## Add a menu

Use this when the user says “给 <应用> 增加 <菜单>”.

- Locate the page in the frontend router. Derive the menu path from the router and the current application's existing menu-path convention; do not assume the raw router path is the final menu path.
- Confirm no existing menu uses the same code, name, or path in the target application.
- Use the user-specified parent when present. Otherwise, default to a top-level menu (`parentId: null`).
- Generate a unique code following the target application's current convention.
- Default to `enabled: true`, an empty icon, no automatic role authorization, and `sort = max(same-level sort) + 1`. Use a different sort only when the user requests a location or an adjacent menu establishes an unambiguous placement.
- Include a concise remark describing the page purpose.

## Update a menu

- Read the current menu before updating.
- Send a complete update payload. The update endpoint requires `code` and `name`; omitting `sort` resets it to `0`.
- Do not attempt to change terminal, application, or parent through the update endpoint. Explain the limitation and obtain a separate approved migration path if such a move is needed.
- Preserve fields outside the user's requested change unless the user explicitly asks to replace them.

## Delete a menu

- Treat deletion as destructive. Read the exact menu, its children, and relevant role relationships first; present the affected menu ID and scope before calling delete.
- Require the user's explicit deletion request for the resolved menu ID or an unambiguous unique menu.
- Verify that the menu is no longer returned after deletion. The current service performs a soft delete; do not claim that role mappings or cached permissions were automatically removed unless separately verified.

## Role authorization

Adding a menu does not automatically make it visible to ordinary users. Query the target role and its menu relationships, obtain explicit role scope, apply the role-menu change through the appropriate OUAA interface, then read back the assignment.

## Completion report

Report the target environment, operation, menu ID, resolved application, parent, code, path, sort, enabled state, and independent read-back result. State any UI-cache or role-authorization verification not performed.
