# ghy 工作规则

本文件记录和 ghy 本机工作目录、项目入口、专项资料位置强绑定的规则。迁移到新机器时，需要按实际目录调整路径。

## zsh Git 别名同步

- ghy 本机 zsh 生效配置是 `/home/ghy/.zshrc`，规则仓库中的 Git 别名备份文件是 `/home/ghy/work/dev-config-notes/git/git-fast-options`。
- `/home/ghy/.zshrc` 必须通过 `source /home/ghy/work/dev-config-notes/git/git-fast-options` 加载 Git 别名，不在 `.zshrc` 内重复维护手写 Git alias；本机非 Git alias 保持独立。
- 同步或备份 Git 别名时直接维护仓库文件，完成后先确认 `.zshrc` 的 source 入口存在，再执行 `zsh -ic 'alias gfp gpp gp gpuo gpu gbr gb gbd gbvv gs gsp gr gst gc gco gcb gcp gcm gl'` 验证完整关键别名。
- `gc` 固定表示 `git commit`，`gco` 固定表示 `git checkout`；验证结果与该语义不一致时视为同步失败，不得继续使用错误别名。
