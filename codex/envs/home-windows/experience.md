# home-windows 环境经验总结

本文档记录 Windows 主机专属的路径、配置、安装和工作流经验。敏感凭据不写入经验。

## Windows 规则仓库路径

- 场景：Windows PowerShell 使用 home 规则。
- 做法：`CODEX_WORK_ENV=home-windows`，通过 `wsl.exe` 读取 WSL 中的 `/home/hetao/workspace/dev-config-notes/codex/`。
- 注意：Windows 侧不存在 `/home/...` 映射不表示规则缺失，不能改读本机 `~/.codex/codex/` 副本。

## Windows WezTerm

- WezTerm、Codex CLI、D 盘清理、系统映像备份和 WezTerm workspace/标题/配色等既有经验均属于 Windows 主机；修改后按对应经验使用 `wezterm.exe show-keys --lua` 或 Windows 工具验证。
- WezTerm 默认域为 `WSL:Debian12`，不要把 Linux 的 `default_prog` 配置照搬到 Windows。
