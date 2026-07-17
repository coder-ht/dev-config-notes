# home-wsl 环境经验总结

本文档记录 Debian12 WSL 专属的路径、配置和工作流经验。敏感凭据不写入经验。

## 2026-07-16 WSL 生成 PDF 到 Windows D 盘桌面

- 场景：WSL 中生成中文学习资料 PDF，并交付到 Windows 的 D 盘桌面。
- 做法：使用 Windows Chrome 无界面打印，将 HTML 临时复制到 `/mnt/d/desktop`，通过 `D:\\desktop\\文件名.pdf` 输出 PDF；生成后删除桌面临时 HTML，并按技术分类移动到 `D:\\desktop\\学习资料\\<技术分类>\\`，只保留 PDF。
- 注意：Chrome Windows 进程不能直接使用 `/mnt/d/...` 作为输出路径；必须传 Windows 路径，生成后回读文件大小和哈希确认结果存在。

## WSL Git 快捷别名

- 场景：WSL 需要同步 Git 快捷别名。
- 做法：`git/git-fast-options` 是 shell alias 文件，应在 `/home/hetao/.zshrc` 中 source；`gc` 保留给 `git commit`，切换分支使用 `gco`。
- 注意：保留本机额外 alias，不删除 `.zshrc` 原有定义。

## WSL 安装 lazygit

- 场景：WSL Debian 安装 lazygit。
- 做法：下载 Linux x86_64 release，校验 `checksums.txt` 后安装到 `/home/hetao/.local/bin/lazygit`。
- 注意：安装后用 `command -v lazygit` 和 `lazygit --version` 验证。
