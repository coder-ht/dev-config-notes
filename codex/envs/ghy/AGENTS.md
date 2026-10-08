# ghy 工作环境

本文件适用于 `CODEX_WORK_ENV=ghy`，是此环境唯一的规则与经验入口。规则仓库根路径为 `/home/ghy/work/dev-config-notes`，项目工作区根路径为 `/home/ghy/work`。

## 规则加载

- 每次任务先完整读取规则仓库的 `codex/general/rules.md`，再按任务关键词检索 `codex/general/experience.md` 中的相关条目；经验文件不存在时跳过。
- 按通用规则确定实际目标仓库，并读取对应项目规则目录中存在的 `rules.md` 和相关经验。项目代码操作前必须完整读取对应的 `CODING_STANDARDS.md`，完成后按其要求复核。
- 本文件以下记录与 ghy 本机目录、配置强绑定的规则；迁移到其他机器时按实际路径调整。

## zsh Git 别名同步

- ghy 本机 zsh 生效配置是 `/home/ghy/.zshrc`，规则仓库中的 Git 别名备份文件是 `/home/ghy/work/dev-config-notes/git/git-fast-options`。
- `/home/ghy/.zshrc` 必须通过 `source /home/ghy/work/dev-config-notes/git/git-fast-options` 加载 Git 别名，不在 `.zshrc` 内重复维护手写 Git alias；本机非 Git alias 保持独立。
- 同步或备份 Git 别名时直接维护仓库文件，完成后先确认 `.zshrc` 的 source 入口存在，再执行 `zsh -ic 'alias gfp gpp gp gpuo gpu gbr gb gbd gbvv gs gsp gr gst gc gco gcb gcp gcm gl'` 验证完整关键别名。
- `gc` 固定表示 `git commit`，`gco` 固定表示 `git checkout`；验证结果与该语义不一致时视为同步失败，不得继续使用错误别名。
