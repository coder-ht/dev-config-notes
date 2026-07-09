# Cube2 应用路由手册

本文档用于帮助 AI 处理 Cube2 后台问题时快速判断应该读取哪个应用、哪个目录和哪些入口文件。适用仓库：`/home/ghy/work/cube2-upgrade`。

## 使用规则

1. 处理任何 Cube2 后台任务时，先读本文档。
2. 先根据业务词、接口路径、网关前缀、表名前缀、Controller 名称判断应用目录。
3. 命中具体应用后，优先读取该应用根目录的 `SKILL.md`。当前已有专项说明的应用：
   - `packages/apps/cold-storage/SKILL.md`
   - `packages/apps/hazard-governance/SKILL.md`
   - `packages/apps/safety-credit/SKILL.md`
   - `packages/apps/safety-personnel/SKILL.md`
4. 没有专项 `SKILL.md` 时，先看：
   - `packages/apps/{app}/server/BUILD.bazel`：确认 `gw_prefix`、`database`、`server_id`。
   - `packages/apps/{app}/server/src/**/controller` 或 `server/src/interfaces`：确认接口边界。
   - `packages/apps/{app}/server/src/**/service`、`mapper`、`po`：确认业务逻辑和表模型。
   - `packages/apps/{app}/server/resources/application.yaml`、`resources/db`、`server/init`：确认配置和 DDL。
5. 不要仅凭应用名跨模块改代码。涉及设备、告警、文件、用户、消息、字典、权限等通用能力时，优先查 `packages/base` 或 `packages/platform` 的现有 client/服务。
6. 如果任务是客户定制能力，先查 `packages/customization`，不要误改通用 `packages/apps`。
7. 默认不要执行 `bazel build`。除非用户明确要求或确认，优先用源码检查、`rg`、`git diff --check`、局部静态验证。

## 非 apps 路由

| 问题类型 | 优先读取目录 | 说明 |
| --- | --- | --- |
| 登录、租户、组织、用户、角色、权限 | `packages/base/ouaa` | 不要在业务应用中复制用户/权限数据源。 |
| 设备档案、设备属性、实时/历史数据、设备关联 | `packages/base/device-center` | 业务应用展示设备数据时优先复用 device-center client。 |
| 告警事件、告警规则、告警统计 | `packages/base/alarm` | 业务应用不要自行重复设计告警事件数据源。 |
| 文件上传、附件展示、下载、文件元数据 | `packages/base/file` | 业务表通常只存 fileId，展示信息走 file 服务。 |
| 消息、待办、通知 | `packages/base/message`、`packages/base/work-center` | 先查已有 SDK/client 和场景配置。 |
| 字典、配置、通用工具、异常、数据库、RocketMQ、Redis、安全框架 | `packages/platform` | 横切基础能力优先放这里或复用这里。 |
| 网关、server-one、发布聚合 | `packages/deploy` | 开发阶段通常不要主动改，除非任务明确涉及部署聚合。 |
| 客户项目定制 | `packages/customization` | 如长沙县/项目专属逻辑，先确认是否是定制目录。 |

## packages/apps 应用路由表

| 应用 | 路径 | 网关前缀 | 适用后台问题 | 关键入口 |
| --- | --- | --- | --- | --- |
| asset | `packages/apps/asset` | `/property/` | 资产/物业、仓库、耗材、资产流程、耗材库存和盘点。 | `server/src/common/controller`、`server/src/consumable/controller`、`server/src/property/controller` |
| attendance | `packages/apps/attendance` | `/attendance/` | 考勤管理、出勤记录、考勤统计、考勤规则。 | `server/src`、`server/tests` |
| broadcast | `packages/apps/broadcast` | `/broadcast/` | 广播子系统、播放规则、广播统计、广播适配。 | `server/src/rule/controller`、`server/src/statistics/controller`、`adapter` |
| cold-storage | `packages/apps/cold-storage` | `/cold-storage/` | 冷库安全、冷库档案、冷库监控、制冷机房、泄漏应急、冷库统计。 | `SKILL.md`、`server/src/coldstorage/controller` |
| conference | `packages/apps/conference` | `/conference/` | 会议室、会议预约、会议审批、会议物资、会议设备、会议统计。 | `server/src/controller` |
| content | `packages/apps/content` | `/management/` | 内容管理、管理端内容/元数据/proto 相关能力。 | `server/src`、`proto`、`metadata` |
| daily-task | `packages/apps/daily-task` | `/daily-task/` | 日常任务、巡检任务、计划、记录、任务配置、任务统计。 | `server/src/configuration/controller`、`plan/controller`、`record/controller`、`task/controller`、`statistics/controller` |
| dispatch | `packages/apps/dispatch` | `/dispatch/` | 调度中心、调度设备、设备分组、调度平台、设备状态。 | `server/src/controller` |
| door | `packages/apps/door` | `/door/` | 门禁、门禁卡、门禁事件、门禁设备、门禁监控、可视化。 | `server/src/controller`、`adapter`、`client` |
| emergency | `packages/apps/emergency` | `/emergency/` | 应急管理、应急设施、物资出入库、应急知识、预案、疏散路线、平面图资源。 | `server/src/controller`、`server/src/evacuation/controller`、`server/src/planemap/controller`、`server/src/resource/controller` |
| energy | `packages/apps/energy` | `/energymanagement/` | 能源管理、能耗、计量设备、负荷预测、能源日报、能源告警规则。 | `server/src/controller` |
| hazard-governance | `packages/apps/hazard-governance` | `/hazard-governance/` | 隐患治理、隐患上报、确认、整改、审批、验收、根因分析、AI 识别/建议。 | `SKILL.md`、`server/src/interfaces` |
| identity | `packages/apps/identity` | `/identity/` | 身份识别、身份相关业务和 DCM 扩展。 | `server/src`、`server/src-dcm`、`client` |
| intelligent-grain | `packages/apps/intelligent-grain` | `/intelligent-grain/` | 智慧粮仓/粮食相关业务。 | `server/src/interfaces/IntelligentGrainController.java` |
| library | `packages/apps/library` | `/library-management/` | 图书/资料借阅、整理入库等库房管理。 | `server/src/server/controller` |
| linkage | `packages/apps/linkage` | `/linkage/` | 联动规则、事件联动、联动元数据。 | `server/src/linkage/controller`、`metadata` |
| loose-works | `packages/apps/loose-works` | `/loose-works/` | 零星工程、项目申请、合同、进度、整改、反馈、验收/检查。 | `server/src/controller` |
| maintain | `packages/apps/maintain` | `/maintain/` | 运维维护、巡检、无人机、电子巡更、旧版隐患/安全分析等历史维护能力。 | `server/src/common/controller`、`drone/controller`、`inspectionv2/controller`、`electron/controller` |
| meat-trade | `packages/apps/meat-trade` | `/meattrade/` | 肉类交易、屠宰场、订单、结算、猪肉排单、抽检、钱包账户。 | `server/src/base/controller`、`order/controller`、`pork/controller`、`wallet/controller` |
| metric | `packages/apps/metric` | `/metric/` | 指标、规则库、指标配置。 | `server/src/rule/controller` |
| official | `packages/apps/official` | `/official/` | 公文/政务、用印、流程统计、重点工作。 | `server/src/interfaces` |
| onecard | `packages/apps/onecard` | `/onecard/` | 一卡通、账户、消费记录、余额/次数变更、适配。 | `server/src/consumption/controller`、`adapter` |
| park | `packages/apps/park` | `/park/` | 园区、企业、房间/租赁、企业诉求、访谈、园区统计。 | `server/src/interfaces` |
| parking | `packages/apps/parking` | `/park-management/` | 停车管理、停车子系统、停车适配和 client。 | `server/src`、`adapter`、`client` |
| patrol | `packages/apps/patrol` | 无 server_info | 巡更/巡检适配类能力。 | `adapter/server` |
| personnel | `packages/apps/personnel` | `/personnel/` | 人事/人员管理、员工、员工类型、用户中心。 | `server/src/interfaces` |
| prepaid | `packages/apps/prepaid` | `/prepaid/` | 预付费水电、表计、充值、采集记录、水电日用量。 | `server/src/server/controller` |
| product-market | `packages/apps/product-market` | `/product-market/` | 农贸/商品市场、摊位、入场量、商品分类、定价计划、价格预警。 | `server/src/common/controller`、`pricing/controller` |
| risk-source | `packages/apps/risk-source` | 无 server_info | 风险源、风险评分 SDK/client。 | `risk-score`、`client` |
| safety-credit | `packages/apps/safety-credit` | `/safety-credit/` | 安全信用、商户档案、评分、行为、自查、排名、权益规则。 | `SKILL.md`、`server/src/interfaces` |
| safety-edu | `packages/apps/safety-edu` | `/safety-education/` | 安全教育、培训学习、教育元数据。 | `server/src`、`client`、`metadata` |
| safety-management | `packages/apps/safety-management` | `/safety-management/` | 安全管理、消防/用气安全、告警配置/记录、月报、指标、通知。 | `server/src/controller`、`metric/controller`、`monthlyreport/controller`、`notify/controller` |
| safety-personnel | `packages/apps/safety-personnel` | `/safety-personnel/` | 安全人员库、安委会、证书、重点人员、安全履历、安全履职。 | `SKILL.md`、`server/src/keypersonnel/controller`、`server/src/duty` |
| security-management | `packages/apps/security-management` | `/securitymanagement/` | 安防/后勤综合子系统，含照明、锅炉、冷水、消防、电气、环境、熏蒸、物流、医气、会议、客流、周界、污水、三维、交通灯、仓库安全等。 | `server/src/*/controller`、`adapter`、`client`、`metadata` |
| smart-card | `packages/apps/smart-card` | 无 server_info | 智慧卡/卡片可视化。 | `server/src/controller` |
| stall | `packages/apps/stall` | `/stall/` | 摊位管理。 | `server/src/controller` |
| supplier | `packages/apps/supplier` | `/supplier/` | 供应商管理。 | `server/src/supplier/controller` |
| tag | `packages/apps/tag` | `/tag/` | 标签、业务标签关联。 | `server/src/tag/controller` |
| traffic-detection | `packages/apps/traffic-detection` | `/traffic-detection/` | 交通检测。 | `server/src` |
| visitor | `packages/apps/visitor` | `/visitor-management/` | 访客预约、邀请、黑名单、访客区域、通行状态变更。 | `server/src/server/controller` |
| visualization-center | `packages/apps/visualization-center` | `/visualization/` | 可视化中心、模型管理、场景、视角、漫游路线、画布配置。 | `server/src/controller` |
| work-permit | `packages/apps/work-permit` | `/work-permit/` | 作业票、作业许可类型配置。 | `server/src/controller` |
| work-report | `packages/apps/work-report` | `/report/` | 工作上报、报告类型、工作计划、计划类型。 | `server/src/controller` |

## 快速判断提示

- URL 以 `/api/{prefix}` 形式出现时，去掉 `/api` 后用网关前缀匹配上表。
- 表名或库名能定位时，先看 `server/BUILD.bazel` 的 `database` 和 `datasource_package`，再看 `server/init` 或 `resources/db`。
- Controller 名能定位时，优先用 `rg -n "class XxxController" packages/apps packages/base packages/customization`。
- 包名含 `srv.gen.xxx` 多数是生成/业务应用；包名含 `base` 或 `platform` 时，不要强行归到 apps。
- 旧隐患、巡检、运维问题通常在 `maintain`；新隐患治理走 `hazard-governance`。
- 冷库、隐患治理、安全信用、安全人员已有专项规则，进入代码前必须先读对应 `SKILL.md`。
