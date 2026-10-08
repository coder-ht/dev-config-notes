# Cube2 Tenant Dictionary API Reference

## Management-page boundary

`/tenantDict` manages tenant data dictionaries. The management frontend calls the dictionary service under `/api/dictionary` and sends the selected tenant through the `tenant` header.

Use `KAIHE_ADMIN_TOKEN` and `KAIHE_ADMIN_TERMINAL` for management authentication. The `tenant` header selects the tenant that owns the data dictionary; for a business Flow configuration, default it to `KAIHE_BIZ_TENANT`. The host, Bearer token, Cookie, and selected tenant are time-sensitive; do not record their values here.

## Read APIs

| Operation | Method and path | Required context |
|---|---|---|
| List dictionary items | `GET /getDictionaryItemAll` | Management authentication |
| Get an item by code | `GET /getDictionaryItemByCode/{code}` | Management authentication |
| Page tenant data dictionaries | `GET /getDataDictionaryByItemPage` | `tenant` header, `itemCode`, paging fields |
| Read item values | `GET /getDataDictionaryByItem` | `tenant` header, `itemCode`; optionally `code` |
| Read one value | `GET /getDataDictionaryByItemAndCode` | `tenant` header, `itemCode`, `code` |

## Write APIs

| Operation | Method and path | Required context |
|---|---|---|
| Add dictionary item | `POST /addDictionaryItem` | Management authentication |
| Add tenant data dictionary | `POST /addDataDictionary` | `tenant` header, complete payload |
| Update tenant data dictionary | `PUT /updateDataDictionary` | `tenant` header, complete payload including `id` |

## Payloads

Add dictionary item:

```json
{
  "code": "UPPERCASE_ITEM_CODE",
  "remarks": "说明，长度满足管理端校验",
  "changeNotice": "可选"
}
```

Add tenant data dictionary:

```json
{
  "itemCode": "EXISTING_ITEM_CODE",
  "name": "配置名称",
  "code": "UNIQUE_DATA_CODE",
  "variable": "{\"configKey\":\"value\"}",
  "remarks": "配置用途说明",
  "version": "可选"
}
```

Update tenant data dictionary:

```json
{
  "id": "current-read-back-id",
  "itemCode": "EXISTING_ITEM_CODE",
  "name": "保留或更新后的名称",
  "code": "保留或更新后的编码",
  "variable": "{\"configKey\":\"updated-value\"}",
  "remarks": "保留或更新后的说明",
  "version": "保留当前值"
}
```

The native data-dictionary create API fills enable status and default version when omitted. Do not assume an update preserves omitted fields; send the complete record after reading it.
