# ghy 环境经验总结

本文档记录只适用于 ghy 环境的路径、项目、配置、账号、机器状态和本机工作流经验。

## 经验归属规则

- 只和 ghy 环境相关的经验写入本文件。
- 所有环境都适用的经验写入 `codex/general/experience.md`。
- 不确定归属时，先询问用户，不要随意写入通用经验。

## 2026-07-09 ghy 全局规则维护

- ghy 当前本机 Codex 全局生效文件是 `/home/ghy/.codex/AGENTS.md`。
- ghy 当前规则仓库是 `/home/ghy/work/dev-config-notes`。
- ghy 环境规则文件是 `codex/envs/ghy/rules.md`，通用规则文件是 `codex/general/rules.md`。
- `/home/ghy/.codex` 不是 `dev-config-notes` 仓库的一部分，本机配置修改无法随仓库 git 提交。

## 2026-07-09 ghy 本机规则同步

- 场景：用户要求在 ghy 机器同步或备份当前 Codex 规则。
- 做法：检查 `/home/ghy/work/dev-config-notes` 的本地改动与远端最新规则，以远端为基线合并本机有效改动；完成后让 `/home/ghy/.codex/AGENTS.md` 与仓库入口一致，并提交、推送本次 `codex/` 变更。
- 注意：`~/.codex/codex/` 旧镜像不参与同步；两边冲突时不得整体覆盖，应保留差异并请求用户判断。

## 2026-07-09 Git log 时间显示

- 场景：`git log` 显示时间与本机时区不一致。
- 判断与做法：先核对系统时间、`TZ`、`git config --show-origin --get-all log.date` 和 `git log --date=iso-local`；确认只是显示格式时，可在目标仓库设置 `git config --local log.date iso-local`。
- 边界与验证：该设置只修改仓库 `.git/config` 的显示方式，不改写历史提交；用普通 `git log` 验证本地时区显示。

## 2026-07-09 GNOME Terminal 背景能力边界

- 场景：需要为 GNOME Terminal 设置图片背景或恢复终端颜色。
- 判断与做法：GNOME Terminal 当前 schema 不支持窗口背景图，桌面壁纸会被最大化终端遮挡；图片背景需求改用支持该能力的终端。颜色异常时优先恢复当前 profile 的 `use-theme-colors=true`。
- 边界与验证：桌面背景通过 GNOME `gsettings` 管理，与终端窗口背景不同；修改后分别检查桌面显示和终端 profile，不把两者混为一项能力。

## 2026-07-09 ghy zsh Git 别名同步

- 场景：用户要求把 zsh Git 别名同步规则写入规则。
- 做法：ghy 本机 `/home/ghy/.zshrc` 只通过 `source /home/ghy/work/dev-config-notes/git/git-fast-options` 加载 Git 别名，仓库文件是别名的唯一维护位置。
- 验证：检查 source 入口后，用非交互式 zsh 加载全部关键别名；`gc` 必须解析为 `git commit`，`gco` 必须解析为 `git checkout`。

## 2026-07-10 Kitty 输入光标闪烁

- 场景：ghy 本机 Kitty 终端打字时光标持续闪烁，用户配置未覆盖系统默认闪烁行为。
- 做法：在 `/home/ghy/.config/kitty/kitty.conf` 设置 `cursor_blink_interval 0`，用 Kitty 自带的 `load_config` 解析结果确认值为 `0.0`，再向现有 Kitty 进程发送配置重载。
- 注意：先区分光标闪烁与整个窗口渲染闪屏；只有后者才继续排查 Wayland、显卡驱动或显示后端。

## 2026-07-10 ghy 用户级 WezTerm 安装

- 场景：在 ghy Debian 12 安装 WezTerm 时，当前 Codex 会话无法完成交互式 `sudo` 密码输入。
- 做法：从 WezTerm apt 仓库索引下载稳定版 `.deb`，校验 SHA256 后用 `dpkg-deb -x` 解包到 `/home/ghy/.local/opt/wezterm`，再将 `wezterm/wezterm-gui/wezterm-mux-server` 链接到 `/home/ghy/.local/bin`。
- 注意：桌面入口写入 `/home/ghy/.local/share/applications/org.wezfurlong.wezterm.desktop`，`Exec/TryExec` 使用绝对路径；系统级 apt 源安装仍需要用户在真实终端提供 sudo 密码。

## 2026-07-13 ghy 用户级 Warp 安装

- 场景：在 ghy Debian 12 安装 Warp Terminal 时，优先避免交互式 `sudo` 和系统级 apt 源修改。
- 做法：用临时 apt 配置读取 `https://releases.warp.dev/linux/deb stable main`，下载 `warp-terminal` 的 `.deb`，校验 Packages 中的 SHA256 后用 `dpkg-deb -x` 解包到 `/home/ghy/.local/opt/warp-terminal-debroot`，再将 `/home/ghy/.local/bin/warp-terminal` 链接到包内 `warp` 可执行文件。
- 注意：Warp 当前共享可执行文件的 `--version` 可能显示 `Oz v...`，可用 `dump-debug-info` 验证真实 Warp 版本、Wayland 和 GPU 信息；桌面入口写入 `/home/ghy/.local/share/applications/dev.warp.Warp.desktop`，`Exec` 使用绝对路径。

## 2026-07-27 ghy WezTerm 当前终端方案

- 场景：维护 ghy 当前 WezTerm、tmux 和 CapsLock 的生效关系。
- 当前方案：`/home/ghy/.wezterm.lua` 直接启动 `/bin/zsh -l`，由 WezTerm 的 `Alt` 快捷键管理窗格和标签页，并使用本地 resurrect 脚本定期保存、启动恢复 workspace。
- 边界：WezTerm 不自动进入 tmux；`/home/ghy/.tmux.conf.local` 仅供独立启动 tmux 时使用，两套 `Alt` 快捷键不能视为同时生效。WezTerm 当前没有 CapsLock key table，GNOME 当前也没有 CapsLock 的 XKB 重映射。
- 已废弃方案：WezTerm 自动附着 tmux、CapsLock 触发 WezTerm key table、`caps:none` 和 `caps:menu` 均不是当前配置；只有用户明确要求回滚时才从 Git 历史恢复。
- 验证：用 `wezterm --config-file /home/ghy/.wezterm.lua show-keys --lua` 检查配置与快捷键，并用 `gsettings get org.gnome.desktop.input-sources xkb-options` 核对 CapsLock 映射。

## 2026-07-10 ghy Fcitx5 Tab 被输入法吞掉

- 场景：ghy 本机中文输入法激活时，应用无法收到 Tab。
- 做法：检查 `/home/ghy/.config/fcitx5/config` 和 `/home/ghy/.config/fcitx5/conf/pinyin.conf`，移除候选词快捷键中的 `0=Tab` 与 `0=Shift+Tab`，再后台重启 `fcitx5 -r`。
- 注意：直接前台执行 `fcitx5 -r` 会占住终端；先停掉前台进程、修正配置，再用 `setsid fcitx5 -r >/tmp/fcitx5-restart.log 2>&1 &` 启动并检查配置是否被写回。

## 2026-07-13 ghy Fcitx5 Super+Space 切换

- 场景：ghy 本机 GNOME Wayland 下 `Super+Space` 无法切换 Fcitx5 中英文，GNOME 自身输入源快捷键占用该组合且只有一个 `cn` 输入源。
- 做法：清空 `org.gnome.desktop.wm.keybindings` 的 `switch-input-source` 与 `switch-input-source-backward`，把 `/home/ghy/.config/fcitx5/config` 中 `Super+space` 放到 `Hotkey/TriggerKeys`，并从 group enumerate 快捷键中移除。
- 注意：重启后用 `fcitx5-remote -t` 做往返验证；若 `fcitx5 -r` 只退出未拉起，直接后台启动 `setsid fcitx5 >/tmp/fcitx5-start.log 2>&1 &`。

## 2026-07-13 ghy GNOME SVG 壁纸

- 场景：ghy 本机 GNOME 桌面需要设置自定义速查表壁纸，系统没有 `convert` 或 `rsvg-convert`。
- 做法：可直接生成 SVG 到 `/home/ghy/Pictures/wallpapers/`，再用 `gsettings set org.gnome.desktop.background picture-uri 'file://...'` 和 `picture-uri-dark` 设置亮色/暗色壁纸。
- 注意：双屏横向当前可按 `xdpyinfo` 的 `3840x1080` 生成宽幅 SVG，并设置 `picture-options 'zoom'` 后用 `gsettings get` 验证；若壁纸视觉过大，优先缩小 SVG 内部内容区和字号、增加外侧留白，不必改 GNOME 路径。

## 2026-07-10 ghy Codex 新增 MCP 生效边界

- 场景：在 `~/.codex/config.toml` 追加新的 MCP server 后，需要立刻使用该 MCP 工具继续任务。
- 做法：先用 `codex mcp list` 确认配置已被 Codex CLI 识别；若当前对话的工具发现仍找不到新工具，需要重启 Codex 会话后再继续调用。
- 注意：涉及数据库密码、Bearer、API Key 的 MCP 配置只写入本机 `~/.codex/config.toml`，不要写入仓库规则、经验或任务日志。

## 2026-07-10 ghy MySQL MCP 默认库配置

- 场景：MySQL MCP 能启动并执行显式库名 SQL，但 `get_database_info` 报 `No database selected`。
- 做法：检查对应 MCP 的 `MYSQL_DATABASE` 是否为空；需要使用库信息类工具时，在 `~/.codex/config.toml` 的对应 server env 中配置默认数据库，再用 `tomllib` 和 `codex mcp list` 验证。
- 注意：只记录工具行为和配置边界，不把数据库主机、账号、密码或完整日志写入经验文件；修改后当前会话仍可能需要重启才加载新默认库。

## 2026-07-18 ghy DM MCP 只读配置

- 场景：本机通过 `dm-mcp-server` 配置 DM 数据库只读 MCP。
- 做法：使用独立 Python 虚拟环境运行 MCP，设置 `DAMENG_READ_ONLY=true` 和 Schema 白名单；Linux 环境将该虚拟环境内的 `dmssl` 目录加入 `LD_LIBRARY_PATH`。需要全库只读时，从 `ALL_USERS` 枚举当前 Schema 并完整写入 `DAMENG_ALLOWED_SCHEMAS`。
- 注意：当前服务不支持用 `*` 表示全库，白名单留空也只允许默认 Schema；新增 Schema 后需重新枚举，配置修改后需重启 Codex/MCP。未配置加密库路径时可能报 `-70089 加密模块加载失败`；补齐后若返回 `-2501 用户名或密码错误`，说明已到达数据库，应核对账号、密码或端口对应实例，不要继续猜测凭据。

## 2026-07-21 ghy Codex 终端卡死恢复

- 场景：Codex CLI 界面卡死，对应进程持续高 CPU/高写入，且同一会话重复启动多组 MCP 子进程。
- 做法：先按 TTY 核对 Codex PID、会话 ID 和子进程树，只向异常 Codex 发送 `SIGTERM`；主进程退出后继续清理该会话遗留的 MCP 进程，再对原 TTY 执行 `stty sane`。
- 注意：不要按名称全局 `pkill codex` 或终止包含登录 shell 的整个进程组；验证时确认原 TTY 只剩 shell，且 `icanon`、`echo` 和 `isig` 已恢复。
