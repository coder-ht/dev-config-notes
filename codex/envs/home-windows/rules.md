# home-windows 工作规则

本文件适用于 Windows 主机上的 Codex 会话，环境变量值为 `CODEX_WORK_ENV=home-windows`。

- 规则仓库位于 WSL 的 `/home/hetao/workspace/dev-config-notes`；Windows 侧通过 `wsl.exe` 读取和维护，不改用 `~/.codex/codex/` 副本作为规则源。
- Windows 工具需要访问仓库文件时，使用 `\\wsl.localhost\\Debian12\\home\\hetao\\workspace\\dev-config-notes\\codex\\` 对应的 WSL UNC 路径。
- Windows 主机安装应用时，默认安装到 D 盘；用户指定位置、安装器不支持自定义目录或系统组件必须安装在系统盘时除外。
- WezTerm 默认使用 WSL Debian12；Windows 配置变更后用 `wezterm.exe show-keys --lua` 验证。
