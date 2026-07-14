# Cube2 项目规则

本文件适用于 `/home/ghy/work/cube2-upgrade` 和 `/home/hetao/workspace/cube2-upgrade`。

## 任务入口

- 处理 Cube2 任务时，先读取当前环境规则仓库 `codex/envs/<env>/CUBE2_APPS_GUIDE.md`；接口调试再读取 `AI_INTERFACE_CALL_CASES.md`，结构化输出问题再读取 `AI_MISTAKES.md`。
- 先根据业务词、接口路径、网关前缀、表名或 Controller 定位应用目录。
- 命中具体应用后，继续读取该应用的 `SKILL.md`、`AGENTS.md` 或应用规则。
- 基础能力优先复用 `base`、`platform` 和已有 client，不重复建设数据源或服务封装。
- Controller、Service 按业务边界拆分；业务异常使用项目统一异常体系，有限值域使用枚举或常量。

## 数据与接口

- 禁止在循环中执行数据库或 client 调用，优先批量查询、批量写入或一次性调用。
- 接口调试时区分网关路径、Controller 路径、响应包装层和业务结果字段。
- 字典配置遵循“先查、再增改、写入后回查”。
- 需要测试造数时保留唯一 ID、核对关联完整性并设计可回滚方案。
- 不使用历史 Bearer、Cookie、验证码或其他运行态凭据。

## 验证边界

- 不自动执行完整 `bazel build`；优先静态检查或目标性验证。
- 处理数据库批量操作、接口调用和正式环境数据时，先确认影响范围和回滚方式。
- 当前环境的接口调用案例、AI 结构化输出和 Cube2 应用路由手册仍按环境路由加载，项目规则只定义可复用边界。
