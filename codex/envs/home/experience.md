# home 环境经验总结

本文档记录只适用于 home 环境的路径、项目、配置、账号、机器状态和本机工作流经验。

## 经验归属规则

- 只和 home 环境相关的经验写入本文件。
- 所有环境都适用的经验写入 `codex/general/experience.md`。
- 不确定归属时，先询问用户，不要随意写入通用经验。
- 经验总结不得包含 Bearer、账号密码、API Key、测试环境长期凭据、个人敏感信息或运行日志。

## 2026-07-09 home Git 快捷别名同步

- 场景：home 环境需要从规则仓库同步 Git 快捷别名。
- 做法：`git/git-fast-options` 是 shell alias 文件，不是 Git config；应在 `/home/hetao/.zshrc` 中 source 仓库文件。
- 注意：保留本机额外 alias 时，不删除 `.zshrc` 原有定义；source 仓库文件可补齐并覆盖同名 Git alias。
- 约定：`gc` 保留给 `git commit`，切换分支使用 `gco`，避免和 Codex 的 `gc` 提交快捷语义冲突。


## 2026-07-10 home Windows 安装 WezTerm

- 场景：在 home 的 Windows 主机安装 WezTerm。
- 做法：使用 winget install --id wez.wezterm -e，并通过 wezterm.exe --version 验证。
- 注意：PowerShell 的 codex.ps1 可能受执行策略阻断，验证 Codex CLI 时可使用 codex.cmd。

## 2026-07-10 home Windows WezTerm 迁移到 D 盘

- 场景：将 winget 安装在 `C:\Program Files\WezTerm` 的 WezTerm 迁移到 D 盘。
- 做法：先用 `winget uninstall --id wez.wezterm --exact --silent` 卸载，再用 `winget install --id wez.wezterm --exact --location D:\WezTerm --silent` 重装；验证开始菜单快捷方式和 `wezterm.exe --version`。
- 注意：重装到自定义目录后需检查用户 `Path`；若缺少 `D:\WezTerm`，追加后再验证 `wezterm.exe` 命令解析。

## 2026-07-13 home Windows WezTerm 默认进入 WSL

- 场景：在 Windows 上打开 WezTerm 时默认进入 WSL Debian12。
- 做法：在 `C:\Users\29900\.wezterm.lua` 的 `return config` 前设置 `config.default_domain = 'WSL:Debian12'`，并用 `wezterm.exe show-keys --lua` 验证配置可加载。
- 注意：配置只影响后续新建的窗口或标签页；现有 PowerShell 标签页不会自动切换。

## 2026-07-10 home D 盘空间清理

- 场景：为系统映像备份释放 D 盘空间，用户确认不再需要虚拟机、下载的安装包/压缩包及系统 ISO。
- 做法：删除前统计目标目录大小并确认无虚拟机进程；只清理 `D:\documents\Virtual Machines` 内容、`D:\download` 中安装包/压缩包和 `D:\操作系统` 中 ISO，不直接删除 WSL 虚拟磁盘、游戏或其他个人文档。
- 注意：虚拟机磁盘和快照文件不可在未确认用途或虚拟机仍运行时直接删除；实际释放空间可能小于文件逻辑大小，因为虚拟磁盘可能是稀疏文件。

## 2026-07-13 home Windows 系统映像备份目标

- 场景：使用 `wbadmin` 为 Windows 创建可还原的系统映像。
- 做法：先运行 `wbadmin start backup -backupTarget:<目标盘> -include:C: -allCritical -quiet` 检查关键卷；备份目标不能是命令列出的关键卷。
- 注意：本机 D 盘被 Windows 识别为关键卷；清除遗留的 `pagefile.sys` 和 `swapfile.sys`、确认启动项/恢复环境/VSS 均不在 D 盘、以及将旧 `D:\Windows` 目录改名均不能改变该判定。应使用外接 NTFS 磁盘或网络共享。

## 2026-07-13 home Windows C 盘恢复备份

- 场景：D 盘无法作为 `-allCritical` 系统映像目标，但需要在本机保留 C 盘可恢复备份。
- 做法：在 D 盘创建并挂载 NTFS VHDX 作为临时备份卷，再执行 `wbadmin start backup -backupTarget:E: -include:C: -quiet`，并以 `wbadmin get versions -backupTarget:E:` 验证。
- 注意：该备份可完整恢复 C 盘、用户数据和应用，但不包含 EFI/恢复分区，不能替代外接盘上的完整裸机映像；重启或进入 WinRE 后需先用 DiskPart 挂载 `D:\WindowsSystemImageBackup.vhdx` 再恢复。

## 2026-07-13 home D 盘软件清理

- 场景：用户确认删除 D 盘中功能重复的软件。
- 做法：先检查目标进程并退出运行中的应用；有卸载器的应用优先运行卸载器，再删除残留目录；便携软件可删除其已确认目录。
- 注意：旧软件残留可能需要管理员权限和所有权处理；在提升的 Windows PowerShell 中运行含中文路径的脚本时，应避免依赖无 BOM UTF-8 的硬编码路径。

## 2026-07-13 home Windows Codex CLI 迁移到 D 盘

- 场景：将 npm 全局安装的 Codex CLI 与用户配置从 C 盘迁移到 `D:\AI工具\Codex`。
- 做法：用 `npm install -g @openai/codex@<当前版本> --prefix D:\AI工具\Codex\npm` 安装同版本 CLI，复制 `.codex` 到目标目录，设置用户 `CODEX_HOME` 并将新的 npm 前缀置于用户 `Path` 首位后验证。
- 注意：正在运行的 Codex 会话仍使用旧配置；应在新终端验证后再删除 C 盘原安装与 `.codex`，迁移时不得输出认证文件内容。

## 2026-07-10 home Windows 与 WSL 规则路径

- 场景：Codex 在 Windows PowerShell 中运行，但 `CODEX_WORK_ENV=home` 的规则仓库位于 WSL。
- 做法：通过 `wsl.exe` 读取和维护 `/home/hetao/workspace/dev-config-notes/codex/`；Windows 工具需要文件路径时使用对应的 `\\wsl.localhost\Debian12\...` UNC 路径。
- 注意：Windows 侧不存在 `/home/...` 映射并不表示规则文件缺失，不能因此改读 `~/.codex/codex/` 副本。

## 2026-07-13 home WSL 安装 lazygit

- 场景：home 的 WSL Debian 环境安装 `lazygit`，但 `sudo` 需要密码且不适合阻塞安装。
- 做法：从 GitHub latest release 下载 `linux_x86_64` tarball，使用 `checksums.txt` 校验后安装到 `/home/hetao/.local/bin/lazygit`。
- 注意：`~/.local/bin` 已在 PATH 中；安装后用 `command -v lazygit` 和 `lazygit --version` 验证。

## 2026-07-13 home Windows WezTerm 配置优化

- 场景：优化 `C:\Users\29900\.wezterm.lua` 时需要保留已验证的默认 WSL 和 tmux 风格快捷键。
- 做法：保留 `config.default_domain = 'WSL:Debian12'`，补充窗口尺寸、标签栏、标题格式、自定义配色、滚动、复制粘贴、全屏、重载配置和 launcher 快捷键。
- 注意：修改后用 `wezterm.exe show-keys --lua` 验证配置可加载；不要依赖本机未安装的额外字体或外部主题文件。

## 2026-07-13 home Windows WezTerm workspace 恢复

- 场景：按仓库 `wezterm/` 配置给 home 的 Windows WezTerm 增加 workspace 保存/恢复能力。
- 做法：home 保留 `config.default_domain = 'WSL:Debian12'`，不要照搬 ghy/Linux 的 `default_prog = { '/bin/zsh', '-l' }`；增加 `Alt+t` 重命名 tab、`Alt+s` 保存 workspace、`Alt+r` 恢复 workspace。
- 注意：`resurrect.wezterm` 插件网络安装失败时，应使用条件加载检测 `plugins/resurrect.wezterm/plugin/resurrect/workspace_state.lua`，保证插件缺失时 WezTerm 仍可启动，并用 `wezterm.exe show-keys --lua` 验证。

## 2026-07-13 home Windows WezTerm 自定义标题显示

- 场景：`Alt+t` 设置 tab 标题后，窗口标题和 tab 显示仍使用 pane 标题。
- 做法：`format-tab-title` 和 `format-window-title` 优先读取 `tab.tab_title`，为空时回退到 `tab.active_pane.title`。
- 注意：`tab:set_title()` 设置的是 tab 标题，不应只读取 active pane 标题；修改后用 `wezterm.exe show-keys --lua` 验证配置可加载。

