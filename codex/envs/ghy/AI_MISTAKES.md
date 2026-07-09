# AI 失误记录

本文档记录 Codex 在本机工作中出现过的典型失误，供处理相关高风险任务或复盘问题时查阅。

## 2026-07-04 冷库 AI Flow 输出包装结构误判

### 背景

在 `packages/apps/cold-storage` 中实现冷库主设备健康预测定时任务时，AI Flow 返回的结果外层是 Flow 运行包装结构：

```text
[
  {
    "inputs": {...},
    "outputs": {
      "message": {
        "message": "{\"predictions\":[...]}"
      }
    },
    "artifacts": {
      "message": "{\"predictions\":[...]}"
    }
  }
]
```

真正的业务预测结果在 `outputs.message.message` 或 `artifacts.message` 中，而不是整个返回对象本身。

### 失误

客户端提取 AI Flow 输出时，遇到数组或对象直接返回了整个节点的 JSON 字符串，导致后续解析器收到的是：

```text
[{"inputs":...,"outputs":...}]
```

而不是：

```text
{"predictions":[...]}
```

因此 `ColdStoreAiPredictionOutputParser` 将外层数组当作预测数组处理，发现数组元素没有 `storeId` 和 `mainDeviceId`，最终日志表现为：

```text
AI 输出单项缺少目标字段: hasStoreId=false, hasMainDeviceId=false
AI 输出解析完成: structure=array, itemCount=1, resultCount=0
```

### 根因

- 没有先确认外部服务返回的真实契约层级。
- 把“传输包装结构”和“业务结果结构”混为一谈。
- 对对象/数组做了过宽泛的兜底 `toString()`，掩盖了错误提取路径。

### 修复原则

- 解析外部系统响应时，必须先识别响应包装层和业务数据层。
- 不要把任意对象或数组直接当作业务结果返回。
- 对 AI Flow、工作流、网关代理、消息总线这类可能有多层包装的返回，优先按明确路径提取，例如：

```text
outputs.message.message
outputs.message.text
artifacts.message
results.message.text
results.message.data.text
message.data.text
```

- 只有节点本身明确包含业务字段，例如 `predictions`，才可以把该节点序列化为业务 JSON。
- 日志应记录结构类型、输出长度、解析结果数量和关键字段是否存在，不记录完整大报文。

### 后续防范

处理任何外部 API、AI Flow、gRPC、消息或前端传来的复杂 JSON 时，必须：

1. 先保留或查看一份真实响应样例。
2. 明确写出“包装层路径”和“业务数据路径”。
3. 再编写解析代码。
4. 解析失败时日志要能说明当前解析到了哪一层。

## 2026-07-07 冷库能效 AI 定时任务配置漏项

### 背景

在 `packages/apps/cold-storage` 中新增冷库制冷能效 AI 分析定时任务后，直接让用户执行 XXL-JOB。

该任务依赖两类租户字典。最新约定是复用已有冷库任务租户字典，并按应用维护一个 AI 工作流配置字典：

```text
JOB_PARAM_ITEM_CODE / coldStorageMainDeviceHealthPredictionJob
BUSINESS_AI_FLOW / COLD_STORAGE_AI_FLOW
```

前者提供健康分预测和制冷能效 AI 分析定时任务共用的租户列表，后者在同一个冷库应用级配置变量中同时维护多个工作流 ID，例如：

```json
{
  "healthPredictionFlowId": "<健康预测工作流ID>",
  "refrigerationEnergyAnalysisFlowId": "<制冷能效AI分析工作流ID>"
}
```

### 失误

完成代码实现后，只说明“需要后续配置字典”，但没有主动通过测试环境接口完成或核对配置，导致用户执行任务时出现：

```text
冷库制冷能效 AI 分析 job 租户未配置: itemCode=JOB_PARAM_ITEM_CODE, code=coldStorageRefrigerationEnergyAiAnalysisJob
冷库制冷能效 AI 分析 job 结束: 未配置有效租户
```

同时，AI Flow 工作流编排配置也没有在任务交付时核对；即使 job 租户配置补齐，如果 `BUSINESS_AI_FLOW / COLD_STORAGE_AI_FLOW` 缺少有效 `refrigerationEnergyAnalysisFlowId`，任务仍无法真正调用能效 AI 工作流。

后续又补建了独立的 `JOB_PARAM_ITEM_CODE / coldStorageRefrigerationEnergyAiAnalysisJob` 和 `BUSINESS_AI_FLOW / COLD_STORAGE_REFRIGERATION_ENERGY_ANALYSIS`，并一度把能效工作流 ID 写入 `COLD_STORAGE_MONITOR_CONFIG / COLD_STORAGE_REFRIGERATION_ENERGY.aiFlowId`。这不符合冷库模块最新配置口径：能复用健康分任务租户字典时不要新增能效任务租户字典；工作流配置是一个应用一个租户字典，冷库的健康预测和能效分析 flowId 都应归入 `BUSINESS_AI_FLOW / COLD_STORAGE_AI_FLOW`。

### 根因

- 把“代码实现完成”误当成“可运行交付完成”。
- 对定时任务的运行前置配置没有形成交付检查清单。
- 对 AI Flow 类任务没有同时检查“任务租户字典”和“工作流编排字典”两条配置链路。

### 修复原则

实现依赖字典、定时任务参数、工作流 ID、外部服务配置的后台功能时，交付前必须完成或明确阻塞以下检查：

1. 定时任务租户字典是否存在，`variable` 是否包含目标租户。
2. 冷库应用 AI 工作流租户字典是否存在，`variable.refrigerationEnergyAnalysisFlowId` 是否非空。
3. 若需自动配置字典，必须按接口规则先查后增或更，写入后回查确认。
4. 若找不到真实 `flowId`，不得写占位符或复用无关工作流，必须明确报告阻塞。
5. 最终交付说明要区分代码已完成、字典已配置、工作流实例缺失、运行验证是否完成。
6. 冷库制冷能效 AI 分析必须复用 `JOB_PARAM_ITEM_CODE / coldStorageMainDeviceHealthPredictionJob` 作为租户范围，复用 `BUSINESS_AI_FLOW / COLD_STORAGE_AI_FLOW` 承载应用级工作流配置，不要再新增独立的能效 job 租户字典、独立业务 Flow 字典，也不要把工作流 ID 混入能效 COP 业务配置字典。
