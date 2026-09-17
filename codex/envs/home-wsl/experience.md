# home-wsl 环境经验总结

本文档记录 Debian12 WSL 专属的路径、配置和工作流经验。敏感凭据不写入经验。

## 经验归属

- 按任务的实际执行入口归类：由 WSL shell 或 WSL Codex 发起的任务写入本文件，即使过程中调用 Windows Chrome、PowerShell 或访问 Windows 盘符。
- 从 Windows PowerShell 或 Windows Codex 发起的任务归入 `codex/envs/home-windows/experience.md`；不依赖执行入口的方法才考虑通用经验。

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

## WSL 动态获取 Windows 代理地址

- 场景：Windows 活动网卡 IP 会随网络切换而变化，WSL 中的 shell、npm、Git 和 APT 不能长期写死代理地址。
- 做法：通过 Windows `ROUTE.EXE PRINT 0.0.0.0` 的活动默认路由提取接口 IP，由统一的只读辅助脚本输出代理 URL；shell 导出标准代理变量和 `npm_config_*` 变量，npm、Git 清除静态代理项；APT 使用 `Acquire::http::Proxy-Auto-Detect` 和 `Acquire::https::Proxy-Auto-Detect` 在请求时调用同一脚本。
- 注意：辅助脚本获取失败时输出 `DIRECT`，避免生成无效 URL；除普通用户验证外，还要用 `_apt` 用户执行脚本并检查 `apt-config dump`，确认 Windows 互操作和 APT 配置均可用。代理程序仍需监听对应端口并允许 WSL 访问，地址解析成功不代表端口可达。

## WSL 安装 Windows Wireshark

- 场景：从 WSL 为 Windows 桌面安装 Wireshark；先明确抓包目标是 Windows 还是 WSL。
- 做法：可调用 Windows winget；下载停滞时可从 Wireshark 官网下载安装包，校验 winget 清单中的 SHA256 和 Windows Authenticode 签名后安装，避免同时运行多个安装器。
- 注意：Wireshark 静默安装不包含 Npcap 安装，缺少驱动时需另行打开官方 Npcap 安装向导。完成后用 Windows 侧 `tshark --version`、`dumpcap -D` 和 Npcap 服务状态验证版本、驱动加载及网卡识别，不能仅凭安装器退出码判断可抓包。
