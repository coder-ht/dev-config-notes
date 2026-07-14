# home-wsl 工作规则

本文件适用于 Debian12 WSL 中的 Codex 会话，环境变量值为 `CODEX_WORK_ENV=home-wsl`。

- 规则仓库根路径为 `/home/hetao/workspace/dev-config-notes`，直接读取该仓库的 `codex/` 文件。
- WSL shell 中持久化设置 `CODEX_WORK_ENV=home-wsl`；当前用户 shell 配置为 `/home/hetao/.zshrc`。
- Windows 主机专属路径、安装和配置不归入本环境；跨 Windows/WSL 的规则放入通用规则或项目规则。
