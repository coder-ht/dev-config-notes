# home-wsl 工作规则

本文件适用于 Debian12 WSL 中的 Codex 会话，环境变量值为 `CODEX_WORK_ENV=home-wsl`。

- 规则仓库根路径为 `/home/hetao/workspace/dev-config-notes`，直接读取该仓库的 `codex/` 文件。
- WSL shell 中持久化设置 `CODEX_WORK_ENV=home-wsl`；当前用户 shell 配置为 `/home/hetao/.zshrc`。
- 环境归属按任务的实际执行入口判断：从 WSL shell 或 WSL Codex 发起的任务归入 `home-wsl`，即使任务会调用 Windows 程序或写入 Windows 文件系统；从 Windows PowerShell 或 Windows Codex 发起的任务归入 `home-windows`。
- 只有不依赖执行入口、可在多个环境直接复用的规则，才归入通用规则或项目规则。
