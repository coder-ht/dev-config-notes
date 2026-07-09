# ghy 工作经验总结

本文档记录 Codex 在本机为 ghy 执行任务后的可复用经验。后续执行任务前先读取本文档，查找是否有相似任务的参考总结；任务完成后再回看本文档，若已有相似经验则判断是否需要优化，若没有则追加一条简明总结。

## 2026-07-09 全局规则维护：经验总结机制

- 场景：用户要求新增长期遵守的 Codex 全局规则。
- 做法：优先修改 `/home/ghy/.codex/AGENTS.md`，这是本机 Codex 全局协作和编码规则的权威文件。
- 注意：`/home/ghy/.codex` 当前不是 git 仓库，修改全局配置文件后不能用仓库 git 暂存；交付说明里要明确未暂存原因。
- 复用：以后遇到“把规则写入全局规则”“必须遵守”“加强约束”等请求，先完整读取 `GHY_WORK_EXPERIENCE.md` 和 `AGENTS.md`，在计划里说明命中的经验，再做最小范围修改，最后复查行号和内容。
- 经验文件约束：任务前读取经验文件时，要在计划中明确“命中的经验/无相似经验”；任务后回看经验文件时，要先判断更新已有条目还是追加新条目，并在最终回复说明处理结果。
- 规则迁移：若用户要求把 Codex 全局规则放入 `dev-config-notes` 以便新机器复用，应拆成 `codex/ghy-work-rules.md` 与 `codex/general-coding-rules.md`：前者放 ghy 本机路径和专项入口，后者放通用协作/编码规则；仓库文件不得包含 Bearer、账号密码、API Key、测试环境长期凭据或运行日志。
- 冗余清理：优化 `/home/ghy/.codex/AGENTS.md` 时，应合并通用规则与 Cube2 特化规则的重复项，保留简洁的当前生效规则，并把敏感接口调试凭据改为“使用用户当次提供的 Header 或本机私有配置”。
- 环境路由：当前更推荐让 `/home/ghy/.codex/AGENTS.md` 只做环境路由，任务开始前读取 `CODEX_WORK_ENV`，始终加载 `/home/ghy/work/dev-config-notes/codex/general/rules.md` 和 `codex/general/experience.md`，再按环境加载 `codex/envs/<env>/rules.md` 与 `codex/envs/<env>/experience.md`。
- 经验归属：新增经验前必须判断归属，所有环境通用的经验写入 `codex/general/experience.md`，只和某个环境的路径、项目、配置、账号、机器状态相关的经验写入对应 `codex/envs/<env>/experience.md`；不确定归属时先询问用户。

## 2026-07-09 工作经验查询

- 场景：用户询问当前有哪些 ghy 工作经验。
- 做法：直接读取 `/home/ghy/.codex/GHY_WORK_EXPERIENCE.md`，按条目标题和要点汇总，不需要展开无关全局规则。
- 注意：查询类任务完成后也要回看该文件；若只是同类查询且经验已覆盖，不再重复追加。

## 2026-07-09 Git log 时间显示不对

- 场景：用户反馈当前仓库 `git log` 时间不对，实际是提交对象记录为 `+0000`，而本机时区为 `+0800 CST`。
- 做法：先用 `date '+%Y-%m-%d %H:%M:%S %z %Z'`、`printenv TZ`、`git config --show-origin --get-all log.date`、`git log --date=iso-local` 区分系统时区、Git 显示配置和提交对象时间。
- 处理：若只是显示格式问题，在当前仓库执行 `git config --local log.date iso-local`，普通 `git log` 会显示本地时区时间，不改写历史提交。
- 注意：该配置写入仓库 `.git/config`，不会出现在工作区 diff，也不需要 git 暂存。

## 2026-07-09 GNOME Terminal 背景风格调整

- 场景：用户要求把终端背景替换为 Linux 常用命令操作背景。
- 做法：先检测实际终端进程和 GNOME Terminal profile；当前 GNOME Terminal schema 没有背景图和透明度键，不能直接给终端窗口设置图片背景。
- 处理：生成 SVG 命令速查背景图到 `/home/ghy/图片/linux-common-commands-terminal-background.svg`，通过 `gsettings` 设置为 GNOME 桌面明暗背景；同时把当前 GNOME Terminal profile 的 `use-theme-colors` 设为 `false`，背景色设为 `#07110b`，前景色设为 `#d8ffe4`。
- 二次调整：若用户反馈终端内看不到背景，要明确这是 GNOME Terminal 最大化窗口遮住桌面壁纸且不支持终端图片背景导致；可继续优化桌面 SVG 内容，例如增加更多命令分类、中文说明、安全提醒，并重新设置明暗桌面背景。
- 显示修复：若桌面只显示纯色、看不到 SVG 命令内容，优先改为生成真实 PNG `/home/ghy/图片/linux-common-commands-terminal-background.png`，用 `gsettings set org.gnome.desktop.background picture-uri` 和 `picture-uri-dark` 指向 PNG，并设置 `picture-options 'zoom'`；生成 PNG 时用 Noto CJK 绘制中文、JetBrains Mono 绘制 ASCII 命令，避免中文方块和 SVG 渲染兼容问题。
- 颜色恢复：若用户反馈终端颜色显示不正常，只恢复当前 GNOME Terminal profile 的 `use-theme-colors=true`，让终端重新跟随系统主题；不需要改桌面背景 PNG。此时 `background-color`/`foreground-color` 旧值可能仍保留，但因 `use-theme-colors=true` 不再生效。
- 注意：这类 GNOME Terminal 配置写入 dconf/gsettings，不会出现在仓库 diff；若用户需要真正的终端窗口图片背景，应改用支持背景图的终端，例如 Kitty、WezTerm、Tilix。
