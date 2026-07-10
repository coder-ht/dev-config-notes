# AI 接口调用案例步骤

本文档记录 AI 在本机调试接口时可复用的调用步骤。后续凡是需要由 AI 调用业务接口、AI Flow、工作流接口、字典接口、模拟上报接口或其他平台接口，必须先查本文档；如果本文档没有对应接口或场景，完成本次调用后必须把可复用步骤补充到本文档。

## 使用规则

1. 调接口前先确认调用环境、Host、路径前缀、鉴权 Header、租户 Header、请求方法、请求体、响应包装层和业务结果字段。
2. 优先复用用户提供的 Apifox/curl 请求头；没有时再按全局规则选择默认测试环境请求头。
3. 按用户要求记录接口地址、请求头、鉴权信息、token 信息和可复用调用步骤。
4. 调试或编写 AI 调用接口、AI Flow 客户端、AI 回调/MQ 消费、AI 结果解析代码前，必须保留一份脱敏真实响应样例，并明确响应包装层路径和业务结果字段路径；未命中明确业务字段时不得把整段 JSON、对象 `toString()` 或原文写入业务字段或 `parsed_content`，应置空并按解析失败处理。
5. AI Flow、工作流、网关代理、消息总线这类可能有多层包装的返回，必须优先按明确路径提取业务内容，例如 `outputs.message.message`、`outputs.message.text`、`artifacts.message`、`results.message.text`、`results.message.data.text`、`message.data.text`；只有节点本身明确包含业务字段时，才可以把该节点序列化为业务 JSON。
6. 新增案例必须包含：
   - 场景和适用范围
   - 接口路径和方法
   - 必要请求头
   - 请求体关键字段
   - 成功响应判断
   - 常见失败和排查点
   - 如果是 AI/工作流接口，必须写明响应包装层路径和业务结果字段路径
7. 如果只是一次性业务数据，不要写入本文档；只沉淀后续可以复用的接口调用步骤。

## Cube2 测试环境通用调用

适用范围：Cube2 后台测试环境接口。

- Host: `http://192.168.0.243:40201`
- 路径格式: `/api/{应用网关前缀去掉首尾斜杠}/{接口路径}`
- 网关前缀来源: 应用 `server/BUILD.bazel` 的 `server_info.gw_prefix`
- 必要请求头:

```text
Authorization: <Authorization>
tenant: <tenant>
terminal: bimops-manage-web
```

调用前检查：

1. 先定位应用目录和 Controller 根路径。
2. 确认本地/测试环境路径差异。本地通常不带 `/api/{gwPrefix}`，测试环境必须带。
3. 优先使用用户给出的 curl/Apifox Header；不要无故重新登录。
4. 响应异常时先记录 HTTP 状态、业务 code/message、接口路径、tenant 和请求头使用情况。

## Cube2 后台应用接口归纳

适用范围：根据业务词、接口路径、网关前缀、Controller 或表名判断 Cube2 后台接口属于哪个应用。

归纳规则：

1. 测试环境接口统一先看 `/api/{prefix}`，`prefix` 对应应用 `server/BUILD.bazel` 的 `server_info.gw_prefix` 去掉首尾斜杠。
2. 定位到应用后，再查该应用 `server/src/**/controller` 下的 Controller 根路径和方法路径。
3. 命中有 `SKILL.md` 的应用时，必须先读取应用规则，再调试或修改接口。
4. 如果接口职责属于用户、组织、设备、告警、文件、消息、字典等基础能力，优先路由到 base 或 platform，不要强行归到业务 app。
5. 归纳不确定时，使用 `rg "@RequestMapping|@GetMapping|@PostMapping|@PutMapping|@DeleteMapping"` 在候选应用 Controller 下确认。

基础/平台能力优先路由：

| 接口职责 | 优先模块 |
| --- | --- |
| 登录、租户、组织、用户、角色、权限 | `packages/base/ouaa` |
| 设备档案、设备属性、实时数据、历史数据、设备关联 | `packages/base/device-center` |
| 告警事件、告警规则、告警统计 | `packages/base/alarm` |
| 文件上传、附件、下载 | `packages/base/file` |
| 消息、待办、通知、工作台 | `packages/base/message`、`packages/base/work-center` |
| 字典、配置、通用工具、异常、DB、Redis、RocketMQ、安全基础能力 | `packages/platform` |
| 客户定制或项目定制接口 | `packages/customization` |

业务应用接口归纳：

| 应用 | 测试环境前缀 | 后台路径 | 主要接口职责 |
| --- | --- | --- | --- |
| 资产/物业 | `/api/property` | `packages/apps/asset` | 资产、物业、仓库、耗材、盘点 |
| 考勤 | `/api/attendance` | `packages/apps/attendance` | 考勤记录、排班、考勤统计 |
| 广播 | `/api/broadcast` | `packages/apps/broadcast` | 广播设备、广播任务、播发记录 |
| 冷库安全 | `/api/cold-storage` | `packages/apps/cold-storage` | 冷库档案、主设备、监控看板、制冷能效、泄漏、健康度、统计分析 |
| 会议 | `/api/conference` | `packages/apps/conference` | 会议室、会议预约、会议记录 |
| 内容管理 | `/api/management` | `packages/apps/content` | 内容、栏目、发布管理 |
| 日常任务 | `/api/daily-task` | `packages/apps/daily-task` | 日常任务、任务执行、任务统计 |
| 调度 | `/api/dispatch` | `packages/apps/dispatch` | 调度任务、调度记录、调度资源 |
| 门禁 | `/api/door` | `packages/apps/door` | 门禁设备、通行记录、门禁权限 |
| 应急 | `/api/emergency` | `packages/apps/emergency` | 应急预案、应急事件、应急资源 |
| 能源 | `/api/energymanagement` | `packages/apps/energy` | 能耗数据、能耗分析、能源统计 |
| 隐患治理 | `/api/hazard-governance` | `packages/apps/hazard-governance` | 隐患排查、整改、复查、闭环统计 |
| 身份识别 | `/api/identity` | `packages/apps/identity` | 身份识别、识别记录、人员核验 |
| 智慧粮仓 | `/api/intelligent-grain` | `packages/apps/intelligent-grain` | 粮仓业务、粮情监测、粮仓统计 |
| 图书/资料 | `/api/library-management` | `packages/apps/library` | 图书资料、借阅、归还 |
| 联动 | `/api/linkage` | `packages/apps/linkage` | 联动规则、联动执行、联动记录 |
| 零散作业 | `/api/loose-works` | `packages/apps/loose-works` | 零散作业申请、审批、作业记录 |
| 维保 | `/api/maintain` | `packages/apps/maintain` | 维保计划、工单、巡检维修 |
| 肉菜交易 | `/api/meattrade` | `packages/apps/meat-trade` | 肉菜交易、摊位交易、交易统计 |
| 指标 | `/api/metric` | `packages/apps/metric` | 指标定义、指标数据、指标统计 |
| 公文 | `/api/official` | `packages/apps/official` | 公文流转、收发文、审批 |
| 一卡通 | `/api/onecard` | `packages/apps/onecard` | 一卡通账户、消费、充值、记录 |
| 园区 | `/api/park` | `packages/apps/park` | 园区基础信息、楼宇、空间 |
| 停车 | `/api/park-management` | `packages/apps/parking` | 停车场、车辆、停车记录 |
| 巡更/巡检 | 需按实际 `BUILD.bazel` 确认 | `packages/apps/patrol` | 巡更点、巡更路线、巡更记录 |
| 人员 | `/api/personnel` | `packages/apps/personnel` | 人员档案、人员分组、人员统计 |
| 预付费 | `/api/prepaid` | `packages/apps/prepaid` | 预付费账户、充值、扣费 |
| 产品市场 | `/api/product-market` | `packages/apps/product-market` | 产品、市场、商品配置 |
| 风险源 | 需按实际 `BUILD.bazel` 确认 | `packages/apps/risk-source` | 风险源、风险评分、风险管控 |
| 安全信用 | `/api/safety-credit` | `packages/apps/safety-credit` | 安全信用、信用评分、信用记录 |
| 安全教育 | `/api/safety-education` | `packages/apps/safety-edu` | 培训课程、考试、学习记录 |
| 安全管理 | `/api/safety-management` | `packages/apps/safety-management` | 安全制度、安全检查、安全管理事项 |
| 安全人员 | `/api/safety-personnel` | `packages/apps/safety-personnel` | 安全人员、证书、人员资质 |
| 安防管理 | `/api/securitymanagement` | `packages/apps/security-management` | 安防事件、安防资源、安防统计 |
| 智慧卡 | 需按实际 `BUILD.bazel` 确认 | `packages/apps/smart-card` | 智慧卡、卡片记录、卡片业务 |
| 摊位 | `/api/stall` | `packages/apps/stall` | 摊位档案、摊位经营、摊位统计 |
| 供应商 | `/api/supplier` | `packages/apps/supplier` | 供应商档案、供应商评价、合作记录 |
| 标签 | `/api/tag` | `packages/apps/tag` | 标签定义、对象标签、标签分组 |
| 交通检测 | `/api/traffic-detection` | `packages/apps/traffic-detection` | 交通检测、车辆检测、检测记录 |
| 访客 | `/api/visitor-management` | `packages/apps/visitor` | 访客预约、访客通行、访客记录 |
| 可视化中心 | `/api/visualization` | `packages/apps/visualization-center` | 可视化大屏、组件、展示数据 |
| 作业许可 | `/api/work-permit` | `packages/apps/work-permit` | 作业票、许可审批、作业过程 |
| 工作报告 | `/api/report` | `packages/apps/work-report` | 工作报告、日报周报、报告统计 |

常用确认命令：

```bash
rg "gw_prefix" packages/apps/<app>/server/BUILD.bazel
rg "@(RequestMapping|GetMapping|PostMapping|PutMapping|DeleteMapping|PatchMapping)" packages/apps/<app>/server/src
rg "<业务关键词|路径片段|表名|Controller名>" packages/apps/<app>
```

## Cube2 本地环境通用调用

适用范围：本机启动的 Cube2 应用接口。

1. 从应用 `server/resources/application.yaml` 读取 `server.port` 默认端口。
2. 使用 `http://localhost:{port}/{Controller路径}` 调用。
3. 如果本地服务挂了网关前缀或上下文路径，以实际启动日志为准。
4. 本地调试仍需携带业务需要的 `tenant`、`terminal`、`Authorization`。

## 租户数据字典查询

适用范围：读取租户字典，例如冷库监控配置、AI 工作流配置。

接口：

```http
GET /api/dictionary/getDataDictionaryByItemAndCode?itemCode=<itemCode>&code=<code>
```

必要请求头：Cube2 测试环境通用 Header。

步骤：

1. 明确 `itemCode`、`code`、目标 `tenant`。
2. 调用查询接口。
3. 返回对象为空时表示当前租户未配置。
4. `variable` 如果是 JSON 字符串，先解析为业务 JSON 再使用。
5. 回答或修改前说明当前租户、字典编码和 variable 解析结果。

常见失败：

- 401/403：检查 Authorization、tenant、terminal。
- 返回为空：不要跨租户复用结果，应按当前 tenant 新增。
- `variable` 解析失败：保留原字符串摘要，说明不是合法 JSON。

## 租户数据字典新增

适用范围：当前租户缺少某个租户字典时新增。

接口：

```http
POST /api/dictionary/addDataDictionary
```

请求体关键字段：

```json
{
  "name": "<字典名称>",
  "code": "<字典编码>",
  "itemCode": "<字典项编码>",
  "variable": "{\"key\":\"value\"}",
  "remarks": "<备注>"
}
```

步骤：

1. 必须先查 `getDataDictionaryByItemAndCode`，确认当前租户不存在。
2. 如果 `variable` 是对象或数组，先构造合法 JSON，再序列化为字符串写入。
3. 新增成功后必须回查确认 `id`、`itemCode`、`code`、`variable`。

## 租户数据字典更新

适用范围：当前租户已有字典，需要调整 variable、name 或 remarks。

接口：

```http
PUT /api/dictionary/updateDataDictionary
```

步骤：

1. 先查询当前字典对象。
2. 基于查询结果更新，保留原有 `id`、`version`、`itemCode`、`code` 等必要字段。
3. `variable` 必须是字符串；业务 JSON 需要 JSON.stringify 后写入。
4. 更新成功后回查，确认目标字段已生效。

常见失败：

- 丢失 `id` 或 `version`：可能更新失败或覆盖异常。
- 把 `variable` 写成嵌套对象：接口契约错误，应改为字符串。

## 系统字典查询

适用范围：XXL-JOB 租户范围等系统字典。

典型 Java client:

```text
SysDictionaryClient.getSysDictionaryByCodeAndItemCode(itemCode, code)
```

调用或排查步骤：

1. 明确 `itemCode` 和 `code`。
2. 检查 `variable` 是否为空。
3. 如果存租户列表，确认分隔符和租户 ID 可解析。
4. 如果存 JSON 配置，先解析并校验必要字段。

冷库当前约定：

- 健康分预测和制冷能效 AI 分析复用 `JOB_PARAM_ITEM_CODE / coldStorageMainDeviceHealthPredictionJob`。
- 不要为冷库能效 AI 分析新增独立 job 租户字典。

## AI Flow 调用与结果解析

适用范围：通过平台 AI Flow 或工作流执行接口获取 AI 结果。

调用前必须确认：

1. `flowId` 来源，不能使用占位符或无关工作流。
2. 输入 JSON 结构和必填业务字段。
3. AI Flow 返回的外部包装层路径。
4. 业务结果字段路径。

已知响应包装层示例：

```text
outputs.message.message
outputs.message.text
artifacts.message
results.message.text
results.message.data.text
message.data.text
```

解析规则：

1. 只有节点本身明确包含业务字段，才能作为业务 JSON 解析。
2. 不要把外层数组、外层对象、整段 JSON、对象 `toString()` 当业务结果。
3. 解析失败时记录结构类型、输出长度、关键字段是否存在，不记录完整大报文。
4. 调试时保留一份脱敏真实响应样例，用来区分是工作流输出问题、客户端剥壳问题还是业务字段解析问题。

## 冷库 AI 工作流字典

适用范围：冷库应用健康预测、制冷能效分析等 AI Flow 配置。

租户字典：

```text
itemCode: BUSINESS_AI_FLOW
code: COLD_STORAGE_AI_FLOW
```

`variable` 示例：

```json
{
  "healthPredictionFlowId": "<健康预测工作流ID>",
  "refrigerationEnergyAnalysisFlowId": "<制冷能效AI分析工作流ID>"
}
```

规则：

1. 冷库应用的工作流配置按应用收敛到一个租户字典。
2. 不要为单个业务场景新增独立 AI Flow 字典。
3. 不要把 flowId 写入 COP、监控指标等业务配置字典。
4. 更新时保留已有 flowId，只替换本次目标字段。

## 冷库物联模拟属性上报

适用范围：通过物联模拟接口上报冷库设备属性。

接口：

```http
POST http://192.168.0.243:19992/iot-runtime/mock/property/report
```

必要请求头：

```text
Authorization: <Authorization>
Content-Type: application/json
```

请求体：

```json
[
  {
    "tenantId": "<tenant>",
    "deviceId": "<deviceId>",
    "propCode": "<propCode>",
    "propValue": "<propValue>",
    "ts": 0
  }
]
```

注意：

1. 枚举属性必须按规则 operand 类型上报。
2. 冷库库门状态 `door_status` 开启值是字符串 `"1"`，不要用数字 `1`。
3. 如果规则有 `delayTime`，是否触发告警取决于规则引擎真实持续满足时间，不能只靠把 `ts` 往前调来快进。
4. 上报后通过冷库告警记录或通用告警记录接口按设备、事件类型和时间范围回查。

## 新接口案例补录模板

新增案例时复制以下模板：

```markdown
## <接口/场景名称>

适用范围：

接口：

\`\`\`http
<METHOD> <PATH>
\`\`\`

必要请求头：

请求体关键字段：

调用步骤：

成功响应判断：

响应包装层路径：

业务结果字段路径：

常见失败和排查：

安全注意：
```

## 隐患治理根因分析屡改屡犯详情

适用范围：调试隐患治理根因分析详情页、AI 根因分析报告展示、AI 报告状态和历史包装 JSON 解包问题。

接口：

```http
GET http://192.168.0.243:40201/api/hazard-governance/root-cause-analysis/repeated-rectifications/{id}
```

必要请求头：

```text
Authorization: <Authorization>
tenant: 58197260
terminal: bimops-manage-web
```

请求参数关键字段：

```text
pageNumber=<页码>
pageSize=<每页数量>
status=ACTIVE
days=30
```

调用步骤：

1. 默认使用测试环境 `http://192.168.0.243:40201`。
2. 按应用网关前缀 `/api/hazard-governance` 拼接接口路径。
3. 使用当前可用测试环境请求头调用。
4. 若接口返回 401，先确认用户是否提供了最新 Apifox/curl 请求头；不要把过期 token 当作业务失败。
5. 若需要核对历史 AI 报告存储形态，可只读查询测试库 `cube-srv-gen-hazard-governance` 的 `hazard_repeated_rectification` 和 `hazard_ai_analysis_record`。

成功响应判断：

```text
code 为成功码，data.id 等于请求 id，data.aiRootCauseReportRecordId 非空时可继续判断 AI 报告状态。
```

响应包装层路径：

```text
data
```

业务结果字段路径：

```text
data.aiRootCauseReport
data.aiRootCauseReportStatus
data.aiRootCauseReportFailureReason
data.aiRootCauseReportTime
data.records
data.rootCauseDistributions
```

AI/历史报告包装字段：

```text
aiAnalysisReport
ai_analysis_report
rootCauseReport
root_cause_report
analysisReport
analysis_report
report
richText
rich_text
html
content
```

常见失败和排查：

1. `401 Failed to validate the token` 或 `401 Not Authenticated`：测试环境 token 失效或未带有效请求头，需要用户提供最新 Apifox/curl 请求头。
2. `aiRootCauseReport` 返回 `{"aiAnalysisReport":"<section>..."}`：历史数据已把 AI 包装 JSON 写入业务字段，详情返回需要按明确报告字段解包。
3. `parsed_content` 存整段 JSON：AI 结果解析没有命中明确业务字段却使用了 `root.toString()` 或原文兜底，应改为解析失败，不能写整段 JSON。
4. `aiRootCauseReportStatus=RECOGNIZING`：异步 MQ 仍在处理，前端应展示生成中状态。
5. `aiRootCauseReportStatus=FAILED`：查看 `aiRootCauseReportFailureReason` 和 `hazard_ai_analysis_record.failure_reason`。

安全注意：

按用户要求记录请求和响应样例，优先保留复用排查所需字段。

## 隐患治理 AI 隐患识别工作流

适用场景：

调试或修改隐患治理 AI 隐患识别工作流提示词、DSL、校验和发布流程。

关联配置：

```text
应用：hazard-governance
业务字典：item_code=BUSINESS_AI_FLOW，code=HAZARD_GOVERNANCE_AI_FLOW
字典变量字段：variable.hazardImageRecognition
当前测试环境工作流 ID：856854472981217280
```

接口路径：

```http
GET  http://192.168.0.243:40201/api/ai-center/flow/console/studio/{flowId}
PUT  http://192.168.0.243:40201/api/ai-center/flow/console/studio/{flowId}
POST http://192.168.0.243:40201/api/ai-center/flow/console/studio/{flowId}/validate
POST http://192.168.0.243:40201/api/ai-center/flow/console/studio/{flowId}/publish
```

必要请求头：

```text
Authorization: <Authorization>
tenant: 58197260
terminal: bimops-manage-web
Content-Type: application/json
```

调用步骤：

1. 先通过业务字典确认 `hazardImageRecognition` 的 flowId，避免写死旧流程。
2. `GET /api/ai-center/flow/console/studio/{flowId}` 获取完整工作流详情。
3. 只修改必要节点字段，例如 `editorFlowJson.nodes[].data.config.systemMessage`；保留原有节点、边和 metadata。
4. `PUT /api/ai-center/flow/console/studio/{flowId}` 保存，body 至少包含 `name`、`description`、`enabled`、`remark`、`editorFlowJson`。
5. 保存后必须调用 `POST /validate`。只有 `ok=true` 且 `issues` 为空时才继续发布。
6. 发布前必须确认最新 DSL 已保存；发布 body 使用 `{}` 或带 `releaseNote` 的 JSON。
7. 发布后再次 `GET` 回查，确认目标字段已生效。

响应包装层路径：

```text
无额外业务包装，响应体直接是 FlowDetailItem / FlowValidateResult / FlowPublishResult。
```

关键业务字段路径：

```text
editorFlowJson.nodes[].componentKey
editorFlowJson.nodes[].data.config.modelId
editorFlowJson.nodes[].data.config.selectedModelLabel
editorFlowJson.nodes[].data.config.systemMessage
ok
issues
releaseId
releaseVersion
```

常见失败和排查：

1. `PUT` 返回 500 且无明确业务错误：先确认测试 token 是否完整、未手工复制损坏，再重试。
2. `/validate` 返回 `FLOW_MULTIMODAL_INPUT_IGNORED` warning：当前语言模型不具备视觉输入能力，图片不会传入模型；不要绕过 `issues` 非空直接发布。
3. 修改隐患识别输出字段时，提示词和后端解析契约必须同步，例如 `hazards[].hazardDescription`。
4. 按用户要求记录日志或案例文件中的请求信息、DSL 和样例输入。
