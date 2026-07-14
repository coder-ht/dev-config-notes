# home-wsl 环境经验总结

本文档记录 Debian12 WSL 专属的路径、配置和工作流经验。敏感凭据不写入经验。

## WSL Git 快捷别名

- 场景：WSL 需要同步 Git 快捷别名。
- 做法：`git/git-fast-options` 是 shell alias 文件，应在 `/home/hetao/.zshrc` 中 source；`gc` 保留给 `git commit`，切换分支使用 `gco`。
- 注意：保留本机额外 alias，不删除 `.zshrc` 原有定义。

## WSL 安装 lazygit

- 场景：WSL Debian 安装 lazygit。
- 做法：下载 Linux x86_64 release，校验 `checksums.txt` 后安装到 `/home/hetao/.local/bin/lazygit`。
- 注意：安装后用 `command -v lazygit` 和 `lazygit --version` 验证。
