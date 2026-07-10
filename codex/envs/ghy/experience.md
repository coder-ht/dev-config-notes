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

## 2026-07-09 emergency-management-migrate 预案生成页面边距

- 场景：`/home/ghy/work/ghcloud/legacy/emergency-management-migrate` 的 `planGenerate` 页面在主应用内出现顶部和左侧内容区空白。
- 做法：先查路由与子应用根布局；该路由直连 `src/views/planGenerate/index.vue`，主要页面外侧空白来自本页 `.plan-generate-page` 的内边距，不是共享 `g-layout`。
- 注意：只去除页面根容器外侧 padding，保留面板内部 padding 和 grid gap，避免破坏表单、预览卡片的内部层次。

## 2026-07-09 emergency-management-migrate 预案生成返回白屏

- 场景：`planGenerate` 页面返回按钮在 qiankun 主应用内点击后白屏。
- 做法：不要用 `window.history.length` 判断后执行 `router.back()`；浏览器历史可能落到主应用或未匹配地址，固定 `router.push("/planDocument/list")` 更稳。
- 注意：保存成功跳转本来就是固定回列表，可保持一致。

## 2026-07-09 Cube2 测试环境管理端菜单禁用

- 场景：需要通过接口禁用测试环境管理端菜单，例如“预案生成”菜单。
- 做法：测试环境管理端访问地址是 `http://192.168.0.243:30101`；登录页前端通过 `/api/ouaa/public/auth/login/code/generate` 获取验证码，通过 `/gw-bff/auth/token` 登录，Header 需要 `x-oauth-client: inner_terminal`，登录后用 `tenant: 0`、`terminal: kh-admin-web` 调 `/api/ouaa/menu/{id}`。
- 注意：菜单更新接口要求完整保留 `code/name/icon/path/sort/remark/categoryId` 等字段，只修改 `enabled`；不要写入账号密码、Bearer token 或验证码图片。

## 2026-07-10 baseline 前端版本升级最小流程

- 场景：升级 `/home/ghy/work/baseline/component/fe.yaml` 中某个前端应用的部署版本。
- 做法：升级哪些应用必须由用户明确指定；AI 读取这些应用当前分支 `package.json` 中的实际版本，并逐一与 baseline 对应版本比较。版本一致时不修改 baseline、不提交、不推送；版本不一致时，以用户指定应用自身的实际版本为准更新 baseline。需要更新时先在 baseline 仓库执行 `git pull --ff-only`，再按 `package` 名称上下文精确修改对应 `version`，最后检查目标差异、`git diff --check` 和 YAML 解析结果。
- 注意：AI 不得根据应用与 baseline 的版本差异自行增加、删除或调整升级应用范围，也不得自行推断其他目标版本。只要求升级 baseline 时，不顺带修改或提交应用仓库；不要按裸版本号替换，避免误改其他同版本组件。执行期间若分支或文件状态发生变化，先重新读取状态再继续。

## 2026-07-10 Kitty 输入光标闪烁

- 场景：ghy 本机 Kitty 终端打字时光标持续闪烁，用户配置未覆盖系统默认闪烁行为。
- 做法：在 `/home/ghy/.config/kitty/kitty.conf` 设置 `cursor_blink_interval 0`，用 Kitty 自带的 `load_config` 解析结果确认值为 `0.0`，再向现有 Kitty 进程发送配置重载。
- 注意：先区分光标闪烁与整个窗口渲染闪屏；只有后者才继续排查 Wayland、显卡驱动或显示后端。

## 2026-07-10 隐患治理根因分析已关闭测试造数

- 场景：需要在 Cube2 测试环境为隐患治理根因分析增加“已关闭”列表数据。
- 做法：`CLOSED` 不是落库状态，而是已有 `hazard_repeated_rectification` 案件在查询窗口内同一风险对象与分类的已闭环隐患少于 3 条时实时派生；造数应使用新组合，并同步新增历史 `hazard_record`、案件和证据快照。
- 注意：历史闭环时间应早于前端最大查询窗口，写入后核对 30/90/180 天计数、案件与证据数量；测试库工具禁用物理删除时，回滚使用本次唯一 ID 做逻辑删除。接口验证仍需当前有效 Bearer，不能从历史记录中提取或持久化凭据。

## 2026-07-10 隐患治理根因分析正式库安全补录

- 场景：正式库需要补录隐患治理根因分析“已关闭”展示数据。
- 做法：业务展示文本可以贴近真实运维场景，但审计字段必须保留补录痕迹；验收展示名使用岗位类名称，例如“隐患验收岗”，不要伪造真实人员姓名。
- 注意：正式库执行中断后先按本次唯一 ID 复核 `hazard_record`、案件表、证据表数量，再补齐缺失表；验收必须覆盖数量、关联完整性、验收人字段和 30/90/180 天派生关闭状态。

## 2026-07-10 ghy Codex 新增 MCP 生效边界

- 场景：在 `~/.codex/config.toml` 追加新的 MCP server 后，需要立刻使用该 MCP 工具继续任务。
- 做法：先用 `codex mcp list` 确认配置已被 Codex CLI 识别；若当前对话的工具发现仍找不到新工具，需要重启 Codex 会话后再继续调用。
- 注意：涉及数据库密码、Bearer、API Key 的 MCP 配置只写入本机 `~/.codex/config.toml`，不要写入仓库规则、经验或任务日志。

## 2026-07-10 ghy MySQL MCP 默认库配置

- 场景：MySQL MCP 能启动并执行显式库名 SQL，但 `get_database_info` 报 `No database selected`。
- 做法：检查对应 MCP 的 `MYSQL_DATABASE` 是否为空；需要使用库信息类工具时，在 `~/.codex/config.toml` 的对应 server env 中配置默认数据库，再用 `tomllib` 和 `codex mcp list` 验证。
- 注意：只记录工具行为和配置边界，不把数据库主机、账号、密码或完整日志写入经验文件；修改后当前会话仍可能需要重启才加载新默认库。
