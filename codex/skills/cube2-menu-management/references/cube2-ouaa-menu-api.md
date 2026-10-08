# Cube2 OUAA 菜单接口参考

## 管理端边界与默认值

OUAA 菜单管理属于管理端操作。用户端菜单、角色可见性和业务页面不应直接复用管理端的菜单配置。

测试环境非凭据默认值：

- 管理端地址：`http://192.168.0.243:30101/api/ouaa`
- 未指定环境时，`tenant` 和 `terminal` 从 `KAIHE_ADMIN_TENANT`、`KAIHE_ADMIN_TERMINAL` 读取（默认分别为 `0`、`kh-admin-web`）。
- 菜单终端 ID：`1528568123400142850`

应用 ID、父菜单、菜单路径、编码和排序不是固定默认值，必须为每次请求从当前应用与菜单树重新解析。

未指定环境时使用 `KAIHE_ADMIN_TOKEN`；该变量为空时停止并要求凭据。禁止将 Authorization、Cookie、Token、密码或其他凭据写入本 Skill、引用资料、源码、日志、Git 提交或回复。

## 接口

| 操作 | 方法与路径 | 用途 |
|---|---|---|
| 查询菜单树 | `GET /menus` | 使用 `terminalId`、`applicationId`，可选 `keyword`、`enabled` |
| 查询详情 | `GET /menu/{id}` | 写入前读取菜单详情 |
| 新增 | `POST /menu` | 返回新增菜单 ID |
| 修改 | `PUT /menu/{id}` | 修改当前菜单字段 |
| 删除 | `DELETE /menu/{id}` | 软删除当前菜单 |

这些接口需要管理员权限。调用前检查 HTTP 状态和业务响应，写入后必须通过查询接口独立回读。

## 新增 payload

```json
{
  "terminalId": 1528568123400142850,
  "applicationId": "从当前应用解析",
  "parentId": null,
  "code": "按当前应用规则生成的唯一编码",
  "name": "用户指定的菜单名称",
  "icon": "",
  "path": "由路由和当前菜单路径规范解析",
  "sort": "同级菜单最大排序值加 1",
  "remark": "页面用途说明",
  "enabled": true
}
```

新增接口必填：`terminalId`、`applicationId`、`code`、`name`。

## 修改 payload 与限制

修改接口接受 `categoryId`、`code`、`name`、`icon`、`path`、`sort`、`remark`、`enabled`。

- `code` 与 `name` 必填。
- 未传 `sort` 会被服务端置为 `0`，因此必须传入当前或目标排序值。
- 不能通过该接口修改 `terminalId`、`applicationId`、`parentId`；需要迁移菜单时先停止并确认新的方案。

## 删除限制

删除接口执行软删除。调用前查询目标菜单、子菜单与角色授权；调用后仅能确认菜单不再被正常查询返回，不能假定角色关系或权限缓存已自动清理。
