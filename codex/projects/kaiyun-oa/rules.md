# Kaiyun OA 项目规则

本文件适用于 `/home/ghy/work/kaiyun-oa` 和 `/home/hetao/workspace/kaiyun-oa`，由 `ghy`、`home` 两个 Codex 环境共同加载。

## 项目结构

- 前端目录：`kaiyun-fe`
- 后端目录：`kaiyun-be`
- 测试部署配置：`deploy/test`
- 后端是 Maven 多模块项目，Spring Boot 启动模块为 `kaiyun-be/application`，主类为 `com.base.Application`。

## 技能与目录归属

- 通用工作区技能放在项目根目录 `skills/` 下；前端专属技能放在 `kaiyun-fe/skills/` 下。
- 适用于前后端的技能放在项目根目录，不放入前端专属目录。
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

## 服务器与部署边界

- 通过 SSH 连接服务器时，项目路径为 `/root/docker/server/kaiyun`。
- `test` 表示测试环境，`prod` 表示正式环境。
- 默认不得部署、发布、重建或重启远程环境；只有用户明确要求时才执行。
- 测试服务器部署脚本中的 `git reset --hard` 用于将服务器工作副本对齐到指定发布 SHA；不能把它等同于回退远端 Git 分支。

## 开发与排查

- 前端变更按 `kaiyun-fe` 范围检查；后端变更按 `kaiyun-be` 模块和 Maven 依赖链检查。
- 排查 Java 启动或 VS Code 调试问题时，先检查 `.vscode/launch.json`、`.vscode/settings.json`、Maven 全局 settings 和本地 Maven 仓库，再判断是否为业务代码问题。
- `application` 启动前需要确保依赖的内部模块已经安装到本地 Maven 仓库；优先使用项目工作区可读的 Maven settings。
- 不自动运行完整构建；用户未明确要求时优先做静态检查或针对性验证。

## 业务校验边界

- 流程执行记录接口为 `POST /approves/executions/{applicationId}/records`。
- 新增执行记录必须基于申请关联的流程定义快照校验，不使用当前最新流程定义替代历史快照。
- 当前执行对象类型只支持部门，要求流程启用执行、申请审批已完成，且流程快照的 `executionTargetId` 必须等于当前登录用户的 `SecurityUtils.getDeptId()`。
- 当前只做部门 ID 精确匹配，不隐式包含子部门；管理员不能绕过新增执行记录的执行对象校验。
