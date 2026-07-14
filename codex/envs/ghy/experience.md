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

## 2026-07-09 ghy 本机规则备份范围

- 场景：用户要求把当前本机 Codex 规则备份到 `dev-config-notes` 仓库。
- 做法：`/home/ghy/.codex/AGENTS.md` 备份到 `codex/AGENTS.md`；ghy 机器专属的规则、经验和说明类 Markdown 备份到 `codex/envs/ghy/`。
- 注意：按用户要求决定备份范围；本机配置修改无法随仓库 git 提交时，需要单独说明。

## 2026-07-09 ghy zsh Git 别名同步

- 场景：用户要求把 zsh Git 别名同步规则写入规则。
- 做法：ghy 本机 `.zshrc` 是 `/home/ghy/.zshrc`，仓库备份文件是 `git/git-fast-options`；同步时优先让 `.zshrc` source 仓库文件，备份时先比较两边差异再更新仓库 alias。
- 注意：当前 `.zshrc` 中 Git alias 比 `git/git-fast-options` 更多，后续真实同步/备份时需要先对齐差异，再用 `zsh -ic 'alias gfp gpp gp gpu gst'` 验证关键别名。

## 2026-07-10 baseline 前端版本升级最小流程

- 场景：升级 `/home/ghy/work/baseline/component/fe.yaml` 中某个前端应用的部署版本。
- 做法：升级哪些应用必须由用户明确指定；AI 读取这些应用当前分支 `package.json` 中的实际版本，并逐一与 baseline 对应版本比较。版本一致时不修改 baseline、不提交、不推送；版本不一致时，以用户指定应用自身的实际版本为准更新 baseline。需要更新时先在 baseline 仓库执行 `git pull --ff-only`，再按 `package` 名称上下文精确修改对应 `version`，最后检查目标差异、`git diff --check` 和 YAML 解析结果。
- 注意：AI 不得根据应用与 baseline 的版本差异自行增加、删除或调整升级应用范围，也不得自行推断其他目标版本。只要求升级 baseline 时，不顺带修改或提交应用仓库；不要按裸版本号替换，避免误改其他同版本组件。执行期间若分支或文件状态发生变化，先重新读取状态再继续。

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

## 2026-07-10 ghy WezTerm tmux 风格快捷键

- 场景：ghy 本机希望 WezTerm 的常用窗格和标签页快捷键贴近当前 tmux 日常操作。
- 做法：新建或维护 `/home/ghy/.wezterm.lua`，只追加 `Alt` 风格键位，不配置 `Ctrl-b` leader，避免影响终端内继续使用 tmux。
- 注意：当前 tmux 日常键位来自 `/home/ghy/.tmux.conf.local` 的 `M-h/j/k/l/o`、`M-H/J/K/L`、`M--`、`M-\`、`M-c/n/p/Tab`、`M-z/x/v`；修改后用 `wezterm --config-file /home/ghy/.wezterm.lua show-keys --lua` 验证解析和最终键位。
- 补充：窗口标题改名快捷键使用 `Alt+Shift+R`，通过 `PromptInputLine` 获取输入并调用 `window:mux_window():set_title(line)`；避免使用容易和终端程序冲突的 `Alt+r`。

## 2026-07-13 ghy WezTerm 仅承载 tmux

- 场景：用户不希望 WezTerm 单独维护一套快捷键，避免与 tmux 的 root `Alt` 映射冲突。
- 做法：在 `/home/ghy/.wezterm.lua` 清空 WezTerm 自定义键位并禁用默认键位，仅设置 `default_prog` 自动 `tmux new-session -A -s main`；窗格、窗口、会话和复制模式快捷键统一交给 tmux。
- 注意：用 `wezterm --config-file /home/ghy/.wezterm.lua show-keys --lua` 确认主 `keys` 表为空，再用 `tmux show-options` 和 `tmux list-keys -T root` 回归 tmux 的前缀与 root 映射。

## 2026-07-13 ghy 改用 WezTerm 直接承载 zsh

- 场景：用户放弃 tmux，改为直接使用 WezTerm 管理窗格和标签页。
- 做法：在 `/home/ghy/.wezterm.lua` 将 `default_prog` 改为 `/bin/zsh -l`，恢复 WezTerm 的 Alt 窗格、分屏、缩放、复制模式和标签页快捷键；不修改 tmux 配置。
- 注意：用 `wezterm --config-file /home/ghy/.wezterm.lua show-keys --lua` 验证配置解析和关键映射。

## 2026-07-10 ghy WezTerm CapsLock 快捷键入口

- 场景：ghy 本机要把 WezTerm 原 Alt 风格快捷键改为 CapsLock 触发。
- 做法：不要把 `ALT` 直接替换成不存在的 CapsLock 修饰符；在 `/home/ghy/.wezterm.lua` 中把 `CapsLock` 绑定到一次性 `ActivateKeyTable`，再在自定义 key table 中复用原来的窗格、分屏、标签页动作。
- 注意：用 `wezterm --config-file /home/ghy/.wezterm.lua show-keys --lua` 验证，确认 `CapsLock` 入口和自定义 key table 都被当前 WezTerm 版本解析。

## 2026-07-10 ghy GNOME Wayland 禁用 CapsLock 锁定

- 场景：ghy 本机在 GNOME Wayland 下需要禁用 CapsLock 切换大小写。
- 做法：使用 `gsettings set org.gnome.desktop.input-sources xkb-options "['caps:none']"`，再用 `gsettings get org.gnome.desktop.input-sources xkb-options` 验证。
- 注意：`caps:none` 会禁用 CapsLock 键本身；如果还要让应用收到 CapsLock 作为快捷键入口，需要另行做键盘重映射而不是直接禁用。

## 2026-07-10 ghy CapsLock 作为 WezTerm 入口且不锁定大小写

- 场景：ghy 本机既要避免 CapsLock 切换大小写，又要让 WezTerm 继续把它当快捷键入口。
- 做法：GNOME Wayland 使用 `gsettings set org.gnome.desktop.input-sources xkb-options "['caps:menu']"` 把 CapsLock 映射为 Menu/Application 键；WezTerm 中绑定 `key = 'Applications'` 到一次性 `ActivateKeyTable`。
- 注意：WezTerm 配置里 `key = 'Menu'` 在当前版本未进入 `show-keys` 有效结果；应使用 `Applications`，并用 `wezterm --config-file /home/ghy/.wezterm.lua show-keys --lua` 验证。

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
