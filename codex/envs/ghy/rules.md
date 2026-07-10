# ghy 工作规则

本文件记录和 ghy 本机工作目录、项目入口、专项资料位置强绑定的规则。迁移到新机器时，需要按实际目录调整路径。

## 常用项目路径

- 前端项目路径：`/home/ghy/work/ghcloud`
- 产品工作路径：`/home/ghy/work/kaihe`
- Cube2 后端项目路径：`/home/ghy/work/cube2-upgrade`

## Cube2 工作入口

- 处理 `/home/ghy/work/cube2-upgrade` 中的 Cube2 后台任务时，先读取 `/home/ghy/.codex/CUBE2_APPS_GUIDE.md`。
- 根据业务词、接口路径、网关前缀、表名或 Controller 名判断应进入的应用目录。
- 命中有 `SKILL.md` 的应用后，继续读取该应用规则。

## 接口调试入口

- 调试任何平台接口、Cube2 后台接口、AI 调用接口、AI Flow、工作流接口、字典接口或模拟上报接口前，先读取 `/home/ghy/.codex/AI_INTERFACE_CALL_CASES.md`。
- 严格复用其中的调用步骤、Header 规则、请求体规则、响应包装层路径和业务结果字段路径。
- 接口调试时按用户要求记录地址、请求头、鉴权信息和可复用调用步骤。

## zsh Git 别名同步

- ghy 本机 zsh 生效配置是 `/home/ghy/.zshrc`，规则仓库中的 Git 别名备份文件是 `/home/ghy/work/dev-config-notes/git/git-fast-options`。
- 备份本机 zsh Git 别名到仓库时，必须先比较 `/home/ghy/.zshrc` 中的 Git alias 区块和 `git/git-fast-options`，只把可迁移的 Git alias 写入仓库文件。
- 同步仓库 Git 别名到本机时，优先让 `/home/ghy/.zshrc` 通过 `source /home/ghy/work/dev-config-notes/git/git-fast-options` 加载仓库文件，避免在 `.zshrc` 与仓库文件中长期维护两份重复 alias。
- 若因启动顺序、兼容性或临时排查必须保留 `.zshrc` 内手写 Git alias，需要在执行后说明原因，并明确仓库文件与 `.zshrc` 是否仍存在差异。
- 同步或备份后必须验证别名是否生效，优先使用 `zsh -ic 'alias gfp gpp gp gpu gst'` 或等价命令检查关键别名。
- `git/git-fast-options` 用于记录可复用 Git alias。
