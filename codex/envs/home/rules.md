# home 工作规则

本文件记录 home 环境的项目路径、专项资料入口和本机工作规则。

当前尚未配置 home 环境专属规则。使用 `CODEX_WORK_ENV=home` 时，应先读取通用规则和通用经验；若任务需要 home 专属路径或配置，先向用户确认后再补充本文件。

## Windows 与 WSL 兼容

- home 环境同时覆盖 Windows 主机与其 WSL 发行版；规则源始终是 WSL 中的 `/home/hetao/workspace/dev-config-notes/codex/`。
- 当 Codex 在 Windows PowerShell 中运行时，应通过 `wsl.exe` 读取或操作上述 Linux 路径；Windows 文件系统中找不到 `/home/...` 对应路径不表示规则缺失。
- 需要从 Windows 工具访问该规则仓库文件时，可使用 WSL UNC 路径 `\\wsl.localhost\Debian12\home\hetao\workspace\dev-config-notes\codex\`；不得改用 `~/.codex/codex/` 副本作为规则来源。

## Windows 应用安装位置

- 在 Windows 主机安装应用时，默认将应用安装到 D 盘；用户指定安装位置、应用安装器不支持自定义目录或系统组件必须安装在系统盘时除外。
- 执行前应在计划中说明目标目录；安装后验证实际安装目录、命令行入口和必要的快捷方式或配置。
