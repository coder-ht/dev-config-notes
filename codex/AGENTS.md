# Codex 规则路由

本文件是当前机器 Codex 的全局入口规则，只负责环境识别和规则加载。具体规则与经验维护在 `/home/ghy/work/dev-config-notes/codex/`。

## 任务开始前

每次执行用户任务前，必须先读取当前系统环境变量 `CODEX_WORK_ENV`，然后按以下顺序加载规则与经验：

1. 若 `CODEX_WORK_ENV` 为空、缺失或不是已支持的环境值，必须停止执行具体任务，先提示用户配置环境变量。
2. 只有确认 `CODEX_WORK_ENV` 有效后，才能继续读取通用规则：`/home/ghy/work/dev-config-notes/codex/general/rules.md`
3. 读取通用经验：`/home/ghy/work/dev-config-notes/codex/general/experience.md`
4. 根据 `CODEX_WORK_ENV` 读取对应环境文件：
   - `CODEX_WORK_ENV=ghy`：读取 `/home/ghy/work/dev-config-notes/codex/envs/ghy/rules.md` 与 `/home/ghy/work/dev-config-notes/codex/envs/ghy/experience.md`
   - `CODEX_WORK_ENV=home`：读取 `/home/ghy/work/dev-config-notes/codex/envs/home/rules.md` 与 `/home/ghy/work/dev-config-notes/codex/envs/home/experience.md`

配置示例：`export CODEX_WORK_ENV=ghy` 或 `export CODEX_WORK_ENV=home`。

## 经验总结归属

任务完成后写入经验总结时，必须先判断经验归属：

- 所有环境都适用的经验，写入 `/home/ghy/work/dev-config-notes/codex/general/experience.md`。
- 只和 `ghy` 的路径、项目、配置、账号、机器状态相关的经验，写入 `/home/ghy/work/dev-config-notes/codex/envs/ghy/experience.md`。
- 只和 `home` 的路径、项目、配置、账号、机器状态相关的经验，写入 `/home/ghy/work/dev-config-notes/codex/envs/home/experience.md`。
- 不确定归属时，先询问用户，不要随意写入通用经验。

不要把 Bearer、账号密码、API Key、测试环境长期凭据、个人敏感信息或运行日志写入任何仓库内规则/经验文件。
