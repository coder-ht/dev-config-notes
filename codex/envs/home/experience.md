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
