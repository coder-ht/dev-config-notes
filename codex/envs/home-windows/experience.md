# home-windows 环境经验总结

本文档记录 Windows 主机专属的路径、配置、安装和工作流经验。敏感凭据不写入经验。

## 经验归属

- 按任务的实际执行入口归类：从 Windows PowerShell 或 Windows Codex 发起的任务写入本文件，即使过程中调用 `wsl.exe` 或访问 WSL 文件。
- 从 WSL shell 或 WSL Codex 发起的任务归入 `codex/envs/home-wsl/experience.md`；不依赖执行入口的方法才考虑通用经验。

## Windows 规则仓库路径

- 场景：Windows PowerShell 使用 home 规则。
- 做法：`CODEX_WORK_ENV=home-windows`，通过 `wsl.exe` 读取 WSL 中的 `/home/hetao/workspace/dev-config-notes/codex/`。
- 注意：Windows 侧不存在 `/home/...` 映射不表示规则缺失，不能改读本机 `~/.codex/codex/` 副本。

## Windows WezTerm 安装与基础配置

- 场景：在 Windows 安装或维护 WezTerm，并默认进入 WSL Debian12。
- 做法：使用 `winget install --id wez.wezterm --exact` 安装；安装器支持且用户未指定其他位置时可用 `--location D:\WezTerm`。在 `$env:USERPROFILE\.wezterm.lua` 设置 `config.default_domain = 'WSL:Debian12'`。
- 注意：不要写死 Windows 用户名，也不要照搬 Linux 的 `default_prog`；修改后用 `wezterm.exe --version` 和 `wezterm.exe show-keys --lua` 验证版本、路径与配置解析。

## Windows WezTerm workspace 与标题

- 场景：Windows WezTerm 需要保存、恢复 workspace，或让自定义 tab 标题同步显示到窗口标题。
- 做法：保留 `default_domain = 'WSL:Debian12'`；workspace 插件使用条件加载，插件缺失时仍应能启动。标题格式优先读取 `tab.tab_title`，为空时回退到 active pane 标题。
- 注意：网络安装插件失败时不得留下无法启动的强制加载配置；用 `wezterm.exe show-keys --lua` 验证最终配置。

## Windows D 盘清理

- 场景：用户明确要求释放 D 盘空间或卸载重复软件。
- 做法：先统计用户指定目标的空间占用并检查相关进程；有卸载器的软件优先正常卸载，便携软件只删除用户确认的目录。
- 注意：删除虚拟机磁盘、快照、安装包、系统镜像或个人文件前必须获得明确授权；不得根据旧记录推断当前目录仍可删除，也不得扩大到用户未指定的路径。

## Windows 系统映像备份

- 场景：使用 `wbadmin` 创建可还原的 Windows 系统映像。
- 做法：先检查当前磁盘、卷、已有备份和目标空间，再根据实际关键卷选择外接 NTFS 磁盘或网络共享；执行备份后用 `wbadmin get versions -backupTarget:<目标>` 验证。
- 注意：备份目标不能是本次备份包含的关键卷；`wbadmin start backup` 会实际写入大量数据，必须获得用户明确授权后才能执行。不要把某个盘符曾经被判定为关键卷的瞬时状态当成长期规则。

## Windows Codex CLI 迁移

- 场景：将 Windows 的 npm 全局 Codex CLI 和用户配置迁移到 D 盘。
- 做法：先读取当前 `codex.cmd --version`，使用 `npm install -g @openai/codex@<当前版本> --prefix <D盘目标目录>` 安装同版本，复制 `.codex` 后设置用户级 `CODEX_HOME` 和 `Path`。
- 注意：不得输出认证文件内容；在新终端验证命令解析、版本与配置目录后，只有用户明确授权才能删除旧安装或旧配置。

## Windows Codex 免确认与全权限配置

- 场景：用户明确要求 Windows 上后续 Codex 会话无需逐条确认且不受沙箱限制。
- 做法：只有获得该项明确授权后，才能在 `$env:USERPROFILE\.codex\config.toml` 设置 `approval_policy = "never"` 与 `sandbox_mode = "danger-full-access"`，并用 `codex.cmd --strict-config --version` 校验。
- 注意：该组合允许自动执行未受沙箱保护的命令，不能根据普通安装、规则同步或“直接执行”等指令推断授权；变更前必须说明风险和影响范围。
