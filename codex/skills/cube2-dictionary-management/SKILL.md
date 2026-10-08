---
name: cube2-dictionary-management
description: Safely query, add, and update Cube2 tenant data dictionaries and dictionary items. Use when a user asks to manage a Cube2 tenant dictionary, data dictionary, dictionary item, AI Flow dictionary configuration, or /tenantDict configuration. Resolve the tenant and existing record before every write, and verify the persisted configuration by independent read-back.
---

# Cube2 Dictionary Management

Manage dictionary configuration through the management-side `/tenantDict` workflow. Read [references/cube2-tenant-dictionary-api.md](references/cube2-tenant-dictionary-api.md) before any API call.

## Execution context

This is a management-side Skill. If the user does not specify an execution environment, use `KAIHE_ADMIN_TOKEN` and `KAIHE_ADMIN_TERMINAL` for management authentication. The token must be non-empty. The `tenant` header identifies the tenant that owns the dictionary data: resolve it from the request; for AI Flow configuration associated with a business Flow, default to `KAIHE_BIZ_TENANT`, not the management tenant. A user-supplied target tenant overrides that default.

## Core workflow

1. Classify the request: query, add, or update a dictionary item or tenant data dictionary.
2. Resolve the tenant that owns the requested dictionary data. Do not confuse it with the management authentication tenant, and do not reuse a tenant header or credential from a prior task.
3. Read the dictionary item and existing data dictionary before a write. For data dictionaries, resolve by `itemCode` and `code`; do not create a duplicate because a similarly named record exists.
4. Before writing, report the resolved tenant, `itemCode`, `code`, proposed `name`, `variable`, and the impact. Never place Authorization, Cookie, Token, password, or Flow secret in a Skill, source file, log, commit, or response.
5. Create only the requested dictionary item or data dictionary. Preserve `name`, `code`, `remarks`, `version`, and unrelated `variable` fields on update.
6. Independently read back the record with the same tenant context and verify its ID, item code, code, enabled status, and variable content.

If the tenant, item code, code, payload meaning, or target record is ambiguous, stop before writing and request direction.

## Data dictionary rules

- `itemCode` identifies the dictionary item; `code` identifies a value under that item.
- `variable` is application configuration. When it is JSON, validate it as JSON before sending and preserve its fields unless the user requests replacement.
- Use `addDataDictionary` only after confirming the `(itemCode, code)` pair is absent.
- Use `updateDataDictionary` only with the ID returned by a current query. Send the complete update payload; the server requires `id`, `name`, and `code`.
- For AI Flow configuration, confirm the expected JSON key from the consuming code before editing. A Flow ID is runtime configuration, not source code.

## Dictionary item rules

- Create an item only when it is absent. Existing items can be shared by multiple applications; do not rename or delete one merely to add a data dictionary value.
- Item codes must be uppercase letters and underscores. The management service requires code and remarks to meet its length constraints.

## Completion report

Report the target tenant, operation, item code, data code, record ID, and independent read-back result. State whether a browser refresh or configuration cache propagation was not verified.
