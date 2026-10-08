# Kaihe AI Flow API Reference

All paths are relative to the business-side AI Center gateway: `/api/ai-center`. If the user does not specify an environment, use `KAIHE_BIZ_TOKEN`, `KAIHE_BIZ_TENANT`, and `KAIHE_BIZ_TERMINAL`; do not record their values.

## Flow management

| Operation | Method and path | Notes |
|---|---|---|
| List flows | `GET /flow/console/studio/` | Use to resolve a name and detect ambiguity. |
| Create flow | `POST /flow/console/studio/` | Body: `name`, optional `description`, and `editorFlowJson`. |
| Get flow | `GET /flow/console/studio/{id}` | Returns detail and graph. |
| Update flow | `PUT /flow/console/studio/{id}` | Send name, description, and complete `editorFlowJson`. |
| Delete flow | `DELETE /flow/console/studio/{id}` | Confirm exact target before use. |
| Import Langflow | `POST /flow/console/studio/{id}/import` | Import payload is defined by the current service schema. |
| List components | `GET /flow/console/studio/components` | Use before composing a graph. |
| Component schema | Read the component catalog and its returned schema before composing nodes. |

## Execution and Playground

| Operation | Method and path | Notes |
|---|---|---|
| Direct run | `POST /flow/console/studio/{id}/run` | Optional `sessionId`; synchronize graph before execution. |
| Debug/compile preview | `POST /flow/console/studio/{id}/debug` | Use for graph diagnostics. |
| Validate graph | `POST /flow/console/studio/{id}/validate` | Inspect issues before a run. |

Use `stream: false` for a complete JSON response. Streamed execution uses `text/event-stream`; there is no separate asynchronous job/progress query endpoint.

## Error handling

| HTTP | Meaning |
|---|---|
| 400 | Missing parameter, ambiguous name, or invalid graph. |
| 404 | Flow or session is absent in the current context. |
| 422 | Graph validation failed. |
| 502 | Langflow synchronization or execution failed. |
| 503 | Flow execution backend or component directory unavailable. |
