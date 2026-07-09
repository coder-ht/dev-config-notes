# ghy 环境经验总结

本文档记录只适用于 ghy 环境的路径、项目、配置、账号、机器状态和本机工作流经验。

## 经验归属规则

- 只和 ghy 环境相关的经验写入本文件。
- 所有环境都适用的经验写入 `codex/general/experience.md`。
- 不确定归属时，先询问用户，不要随意写入通用经验。
- 经验总结不得包含 Bearer、账号密码、API Key、测试环境长期凭据、个人敏感信息或运行日志。

## 2026-07-09 ghy 全局规则维护

- ghy 当前本机 Codex 全局生效文件是 `/home/ghy/.codex/AGENTS.md`。
- ghy 当前规则仓库是 `/home/ghy/work/dev-config-notes`。
- ghy 环境规则文件是 `codex/envs/ghy/rules.md`，通用规则文件是 `codex/general/rules.md`。
- `/home/ghy/.codex` 不是 `dev-config-notes` 仓库的一部分，本机配置修改无法随仓库 git 提交。

## 2026-07-09 ghy 本机规则备份范围

- 场景：用户要求把当前本机 Codex 规则备份到 `dev-config-notes` 仓库。
- 做法：`/home/ghy/.codex/AGENTS.md` 备份到 `codex/AGENTS.md`；ghy 机器专属的规则、经验和说明类 Markdown 备份到 `codex/envs/ghy/`。
- 注意：只备份 Markdown 规则资料；排除 `auth.json`、`config.toml`、sqlite、日志、history、缓存、shell 快照等运行态文件，并把请求头写成 `<Authorization>` 占位符。
