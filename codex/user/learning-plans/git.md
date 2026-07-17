# Git 学习计划

## 当前状态

- 计划版本：v1（华贵铂金）
- 当前评分：44 分
- 当前段位：华贵铂金
- 计划范围：只覆盖华贵铂金阶段
- 计划状态：进行中
- 学习目标：未设定
- 每周可投入时间：未设定
- 当前优先级：撤销操作、远程跟踪、忽略规则和分支状态
- 来源评分档案：[`technical-levels.md`](../technical-levels.md)
- 学习经验记录：[`learning-experiences/git.md`](../learning-experiences/git.md)

## 核心学习范围

- 工作区、暂存区、提交和 `HEAD`
- `git add`、`commit`、`restore`、`reset`
- 分支、快进合并、冲突解决
- merge 与 rebase 的历史和协作风险
- 远程跟踪分支与 `git push -u`
- stash 保存、恢复与删除
- `.gitignore` 与已跟踪文件
- detached HEAD 与安全建分支

## 待加强

- 准确区分 `reset --soft`、`--mixed`、`--hard` 对暂存区和工作区的影响。
- 理解 `-u` 设置的是上游跟踪分支，而不是仅指定远程仓库。
- 理解 `.gitignore` 不会自动取消已跟踪文件。
- 掌握 detached HEAD 的风险和 `switch -c`/`checkout -b`。

## 验证练习

- 预测 add、修改、commit 后三个区域的内容。
- 分析不同 reset 模式的结果。
- 阅读冲突标记并说明完成合并的步骤。
- 判断远程、stash、ignore 和分支状态命令的结果。

## 完成条件

- 区域与撤销：两道变式题正确。
- 分支与合并：能解释快进、冲突、merge/rebase 风险。
- 远程与忽略：正确解释 upstream、stash 和 tracked 文件规则。
- 状态恢复：能识别 detached HEAD 并说出安全处理方式。

