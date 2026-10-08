# Codex 工作环境路由

每次执行用户任务前，先读取系统环境变量 `CODEX_WORK_ENV`。值为空、缺失或不在下列范围内时，停止具体任务并提示用户配置。

- `ghy`：规则仓库为 `/home/ghy/work/dev-config-notes`，工作环境目录为 `codex/envs/ghy/`。
- `home-windows`：规则仓库位于 WSL 的 `/home/hetao/workspace/dev-config-notes`，Windows 侧通过 `wsl.exe` 访问，工作环境目录为 `codex/envs/home-windows/`。
- `home-wsl`：规则仓库为 `/home/hetao/workspace/dev-config-notes`，工作环境目录为 `codex/envs/home-wsl/`。

确定环境后，完整读取该目录的 `AGENTS.md` 并按其中规则继续。文件缺失或无法完整读取时停止具体任务并报告，不使用其他环境的文件代替。
