# Cube2 项目规则

本文件适用于 `/home/ghy/work/cube2-upgrade` 和 `/home/hetao/workspace/cube2-upgrade`。

## 权威入口

- Cube2 仓库结构、Bazel 约定、分层边界和模块 Skill 路由以仓库内 `.agents/skills/cube2-repo/SKILL.md` 为准。
- 涉及具体模块时，先查 `.agents/skills/cube2-repo/references/module-skill-index.md`，再读取当前 checkout 中命中的最近层级 `SKILL.md`、`AGENTS.md` 和实际代码、`BUILD.bazel`；索引与磁盘冲突时以当前 checkout 为准并报告漂移。
- 提交说明按仓库内 `cube2-commit` Skill 处理，不在本文件复制提交规范。

## 辅助路由

- 需要定位应用、接口、数据或代码归属时，按需读取本项目目录下的 `CUBE2_APPS_GUIDE.md`；该手册只提供定位方法和易混淆边界，不保存应用目录、网关前缀或 Skill 的完整快照。
- 接口调试时，按接口路径或业务关键词检索 `codex/envs/<当前环境>/AI_INTERFACE_CALL_CASES.md`；仅在文件存在时读取命中章节，不全文加载。
- AI 或外部系统响应出现结构化输出、包装层或解析问题时，按现象检索本项目 `experience.md` 中的对应经验。
- 环境地址、租户、终端和运行态凭据只从当前环境资料及用户当前会话获取，不跨环境套用，也不复用历史 Bearer、Cookie 或验证码。

## 个人执行边界

- 不自动执行完整 `bazel build`；优先使用源码检查、模块级验证和仓库现有验证工具。用户明确要求构建时，再按目标范围执行。
- 项目业务与编码规则以仓库内 Skill、最近层级规则和当前实现为准；本文件不维护重复副本。
