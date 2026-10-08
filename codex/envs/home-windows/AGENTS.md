# home-windows 工作环境

本文件适用于 Windows 主机上的 Codex 会话，环境变量值为 `CODEX_WORK_ENV=home-windows`。规则仓库位于 WSL 的 `/home/hetao/workspace/dev-config-notes`，项目工作区根路径为 `/home/hetao/workspace`。

## 规则加载

- 每次任务通过 `wsl.exe` 完整读取规则仓库的 `codex/general/rules.md`，再按任务关键词检索 `codex/general/experience.md` 中的相关条目；经验文件不存在时跳过。
- 按通用规则确定实际目标仓库，并读取对应项目规则目录中存在的 `rules.md` 和相关经验。项目代码操作前必须完整读取对应的 `CODING_STANDARDS.md`，完成后按其要求复核。
- WSL UNC 路径与对应的 `/home/hetao/workspace` 路径视为同一项目位置。

## 环境规则

- 规则仓库位于 WSL 的 `/home/hetao/workspace/dev-config-notes`；Windows 侧通过 `wsl.exe` 读取和维护，不改用 `~/.codex/codex/` 副本作为规则源。
- Windows 工具需要访问仓库文件时，使用 `\\wsl.localhost\\Debian12\\home\\hetao\\workspace\\dev-config-notes\\codex\\` 对应的 WSL UNC 路径。
- Windows 主机安装应用时，默认安装到 D 盘；用户指定位置、安装器不支持自定义目录或系统组件必须安装在系统盘时除外。
- WezTerm 默认使用 WSL Debian12；Windows 配置变更后用 `wezterm.exe show-keys --lua` 验证。

## 环境经验

以下经验仅适用于 Windows 主机。敏感凭据不写入经验。

### 经验归属

- 按任务实际执行入口归类：从 Windows PowerShell 或 Windows Codex 发起的任务写入本文件，即使过程中调用 `wsl.exe` 或访问 WSL 文件。
- 从 WSL shell 或 WSL Codex 发起的任务归入 `codex/envs/home-wsl/AGENTS.md`；不依赖执行入口的方法才考虑通用经验。

### Windows 规则仓库路径

- 场景：Windows PowerShell 使用 home 规则。
- 做法：设置 `CODEX_WORK_ENV=home-windows`，通过 `wsl.exe` 读取 WSL 中的 `/home/hetao/workspace/dev-config-notes/codex/`。
- 注意：Windows 侧不存在 `/home/...` 映射不表示规则缺失，不能改读本机 `~/.codex/codex/` 副本。

### Windows WezTerm 安装与基础配置

- 场景：在 Windows 安装或维护 WezTerm，并默认进入 WSL Debian12。
- 做法：使用 `winget install --id wez.wezterm --exact` 安装；安装器支持且用户未指定其他位置时可用 `--location D:\WezTerm`。在 `$env:USERPROFILE\.wezterm.lua` 设置 `config.default_domain = 'WSL:Debian12'`。
- 注意：不要写死 Windows 用户名，也不要照搬 Linux 的 `default_prog`；修改后用 `wezterm.exe --version` 和 `wezterm.exe show-keys --lua` 验证版本、路径与配置解析。

### Windows WezTerm workspace 与标题

- 场景：Windows WezTerm 需要保存、恢复 workspace，或让自定义 tab 标题同步显示到窗口标题。
- 做法：保留 `default_domain = 'WSL:Debian12'`；workspace 插件使用条件加载，插件缺失时仍应能启动。标题格式优先读取 `tab.tab_title`，为空时回退到 active pane 标题。
- 注意：网络安装插件失败时不得留下无法启动的强制加载配置；用 `wezterm.exe show-keys --lua` 验证最终配置。

### Windows D 盘清理

- 场景：用户明确要求释放 D 盘空间或卸载重复软件。
- 做法：先统计用户指定目标的空间占用并检查相关进程；有卸载器的软件优先正常卸载，便携软件只删除用户确认的目录。
- 注意：删除虚拟机磁盘、快照、安装包、系统镜像或个人文件前必须获得明确授权；不得根据旧记录推断当前目录仍可删除，也不得扩大到用户未指定的路径。

### Windows 系统映像备份

- 场景：使用 `wbadmin` 创建可还原的 Windows 系统映像。
- 做法：先检查当前磁盘、卷、已有备份和目标空间，再根据实际关键卷选择外接 NTFS 磁盘或网络共享；执行备份后用 `wbadmin get versions -backupTarget:<目标>` 验证。
- 注意：备份目标不能是本次备份包含的关键卷；`wbadmin start backup` 会实际写入大量数据，必须获得用户明确授权后才能执行。不要把某个盘符曾经被判定为关键卷的瞬时状态当成长期规则。

### Windows Codex CLI 迁移

- 场景：将 Windows 的 npm 全局 Codex CLI 和用户配置迁移到 D 盘。
- 做法：先读取当前 `codex.cmd --version`，使用 `npm install -g @openai/codex@<当前版本> --prefix <D盘目标目录>` 安装同版本，复制 `.codex` 后设置用户级 `CODEX_HOME` 和 `Path`。
- 注意：不得输出认证文件内容；在新终端验证命令解析、版本与配置目录后，只有用户明确授权才能删除旧安装或旧配置。自定义 npm 前缀下，通用的 `npm install -g` 会写入当前默认前缀，更新前应核对 `npm config get prefix` 与 `Get-Command codex -All`；目标 Codex 正在运行时 Windows 可能因可执行文件被锁定而返回 `EBUSY`，应退出相关进程后更新，并在验证目标版本可启动后再删除旧副本。

### Windows Codex 免确认与全权限配置

- 场景：用户明确要求 Windows 上后续 Codex 会话无需逐条确认且不受沙箱限制。
- 做法：只有获得该项明确授权后，才能在 `$env:USERPROFILE\.codex\config.toml` 设置 `approval_policy = "never"` 与 `sandbox_mode = "danger-full-access"`，并用 `codex.cmd --strict-config --version` 校验。
- 注意：该组合允许自动执行未受沙箱保护的命令，不能根据普通安装、规则同步或“直接执行”等指令推断授权；变更前必须说明风险和影响范围。

### Windows Microsoft Store 应用在商店服务禁用时的安装

- 场景：通过 `winget` 的 `msstore` 源安装应用时返回 `0x80070422`，且 `InstallService` 或 `wuauserv` 处于禁用状态。
- 做法：先核对 Microsoft Store 与 Desktop App Installer 包完整；若应用官网提供微软签名的 Store Installer，可验证数字签名后启动该安装器完成交互安装，再通过 `Get-AppxPackage` 和 `Get-StartApps` 回读包状态与开始菜单入口。
- 注意：不要仅凭安装器退出码判断成功，也不要未经授权永久改变系统服务启动策略；若官方安装器仍失败，再取得管理员授权后调整服务策略。

### WSL mirrored 模式下清理应用代理

- 场景：Windows 保留系统代理，但要求 WSL 应用不再使用 HTTP/SOCKS 代理。
- 做法：同时检查 Windows `.wslconfig` 的 `autoProxy`、WSL Shell 启动文件、APT 自动检测脚本、包管理器、Git、Docker/systemd 和 IDE 自动代理设置；先备份，再移除实际启用代理的配置。设置 `autoProxy=false` 后需重启 WSL，并在默认进程和新 Shell 中验证代理环境变量及工具有效配置。
- 注意：mirrored 网络模式不等于应用流量已由 Windows 代理接管；旧进程仍保留原环境，存在编辑器或终端时先确认已保存再重启。不要删除系统 SSH 的 Unix socket/vsock 转发、注释示例、反向代理业务配置或历史备份。HTTP 401 仅证明接口网络可达，不代表认证和模型请求成功。
