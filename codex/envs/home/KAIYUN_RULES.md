# Kaiyun 项目规则

本文档归档 `/home/hetao/workspace/kaiyun-oa` 的项目级与模块级工作规则，适用于 home 环境中的 Kaiyun 项目。

## 项目与服务器

- Kaiyun 项目位于 `/home/hetao/workspace/kaiyun-oa`。
- 通过 SSH 连接服务器时，项目路径为 `/root/docker/server/kaiyun`。
- `prod` 表示生产环境，`test` 表示测试环境。
- 未经用户明确要求，不部署、发布、重建或重启远程/在线环境。

## 技能与规则归属

- 通用工作区技能放在项目根目录 `skills/` 下。
- 前端专属技能放在 `kaiyun-fe/skills/` 下。
- 后端或前后端共用技能应放在项目根目录，不要混入前端技能目录。
- 技能目录按技能类型划分，不混放无关技能。

## 考勤业务约束

- 考勤打卡的前提是员工已绑定手机号。
- 不支持未绑定手机号的人员登录或打卡。
- 打卡流程不设计“非绑定手机号打卡理由”“非绑定手机号异常分类”或相关审批处理。

## Java 集合工具

- 后端处理 `List`、`Collection`、`Set`、`Map` 时，优先复用 `com.base.common.utils.ListUtils`、`MapUtils`、`SetUtils`。
- 集合判空优先使用 `ListUtils.isEmpty/isNotEmpty`；Map 判空优先使用 `MapUtils.isEmpty/isNotEmpty`。
- 集合映射、转 Map、分组和计数优先使用现有工具方法，避免重复编写 stream 或判空逻辑。
- 保留现有工具对 null 过滤、重复 key 和映射结果的行为；只有通用工具无法表达时才直接使用 stream。
