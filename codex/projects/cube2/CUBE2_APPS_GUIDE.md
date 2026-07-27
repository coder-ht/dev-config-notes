# Cube2 代码归属路由

本文档只提供动态定位方法和易混淆边界，不保存应用目录、网关前缀或 Skill 清单的跨仓库快照。每次以当前 Cube2 checkout 为准。

## 定位顺序

1. 根据用户给出的路径、业务词、接口路径、表名、Java 包名或 Controller 名称在当前 checkout 搜索，先确认目标真实存在。
2. 查询 `.agents/skills/cube2-repo/references/module-skill-index.md`；命中登记模块后读取最近层级的 `SKILL.md`，索引未覆盖时从目标目录向上查找。
3. 应用目录和应用级 Skill 通过当前磁盘发现，不在本文维护固定清单：
   - `rg --files packages/apps -g 'BUILD.bazel'`
   - `rg --files packages/apps | rg '(^|/)SKILL\.md$'`
4. 网关前缀、数据库和服务标识从目标模块当前 `BUILD.bazel` 的 `server_info` 验证：
   - `rg -n 'gw_prefix|database|server_id' packages/<target> -g 'BUILD.bazel'`
5. 接口边界继续查 Controller 或 `src/interfaces`，业务实现继续查对应 Service、Mapper、模型和资源文件；不要根据其他应用的旧结构推断。

## 易混淆边界

| 能力 | 优先定位 | 边界 |
| --- | --- | --- |
| 登录、租户、组织、用户、角色、权限 | `packages/base/ouaa` | 先复用认证授权中心能力。 |
| 设备档案、属性、实时或历史数据、设备关联 | `packages/base/device-center` | 应用展示设备数据时先查已有 client。 |
| 告警事件、规则和统计 | `packages/base/alarm` | 不在应用内重复建设公共告警数据源。 |
| 文件、附件和文件元数据 | `packages/base/file` | 先确认已有文件服务契约。 |
| 消息、通知、待办和工作中心 | `packages/base/message`、`packages/base/todo`、`packages/base/work-center` | 按当前模块 Skill 和 client 进一步分流。 |
| 数据字典 | `packages/base/dictionary` | 字典是基础领域服务，不属于 `packages/platform`。 |
| 通用技术能力 | `packages/platform` | 数据库、Redis、RocketMQ、安全和通用 Web 等横切能力在此分流。 |
| 业务事件持久化与再投递 | `packages/base/event` | 注意区别于 `packages/platform/event` 的事件基础能力。 |
| 网关、制品和部署聚合 | `packages/deploy` | 开发任务不要因应用改动主动扩展到部署聚合。 |
| 客户专属逻辑 | `packages/customization` | 先确认是否为定制需求，避免误改通用应用。 |

## 验证要求

- URL 出现 `/api/{prefix}` 时，分别核对外层网关路径、目标模块 `gw_prefix` 和 Controller 映射，不把历史前缀当成当前事实。
- 表名或库名能定位时，结合 `server_info.database`、`datasource_package`、初始化脚本和 Mapper 交叉确认。
- 同名能力出现在多个模块时，以当前前端请求、Controller、表模型和模块 Skill 共同判断，不只按中文名称归属。
- 应用或模块不在当前 checkout 时停止引用该旧路径；不要为了匹配历史规则创建不存在的目录。
