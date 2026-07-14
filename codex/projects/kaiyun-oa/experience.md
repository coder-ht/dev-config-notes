# Kaiyun OA 项目经验总结

## 2026-07-14 测试环境部署与版本自动升级

- 场景：测试环境前后端共用服务器部署脚本，且 `test` 分支由 GitHub Actions 自动升级模块版本。
- 做法：版本任务只在 `test` 分支对比 `github.event.before` 与当前提交；检测到 `kaiyun-fe/` 时执行 `npm version patch --no-git-tag-version --prefix kaiyun-fe`，检测到 `kaiyun-be/` 时递增 Maven 版本，然后自动提交并推送，部署任务使用该版本提交的 SHA。
- 注意：服务器部署脚本的 `git reset --hard "$TARGET_SHA"` 只改变服务器本地工作副本，不会回退 GitHub 远端分支；如果版本提交生成后分支又回到旧 SHA，应检查其他推送或分支审计记录。

## 2026-07-14 测试环境部署前置检查与健康校验

- 场景：测试环境前后端共用服务器部署脚本时，前端部署不应依赖预先存在的后端 JAR。
- 做法：将 JDK/Maven/后端 Dockerfile 检查收敛到后端部署阶段；为 Nginx 容器增加健康检查，并在部署脚本中等待健康状态；测试 API 代理地址与 staging 配置保持一致。
- 注意：真实服务器发布仍需单独验证容器启动和接口可用性。

## 2026-07-14 流程执行记录权限校验

- 场景：新增执行记录提示“当前用户不属于该流程的执行对象”。
- 做法：从 Controller 进入 `ProcessExecutionServiceImpl.createRecord`，依次校验申请存在、审批状态为 `FINISHED`、启用业务执行，再比较流程定义快照的执行对象部门 ID 与当前登录用户部门 ID。
- 注意：当前只支持部门执行对象，精确匹配部门 ID，不自动包含子部门；查询执行记录的管理员、申请人等可见性规则不等于新增记录的执行权限。

## 2026-06-13 kaiyun-be VS Code/Maven 启动排查

- 场景：`kaiyun-be/application` 启动失败或 VS Code Java classpath 缺少内部模块。
- 做法：先检查 `.vscode/launch.json`、`.vscode/settings.json`、本地 Maven 仓库和全局 settings；将调试工作目录对齐到 `kaiyun-be`，使用可读的工作区 Maven settings，并一次性安装缺失的内部模块后执行 `application compile -DskipTests` 验证。
- 注意：缺少内部 JAR 和不可读的系统 Maven settings 往往是启动根因；`ENOSPC` 文件监听告警可能同时出现，但不一定是 Java classpath 根因。

## 2026-06-15 隐患治理需求文档分析

- 场景：分析 Kaiyun OA 的隐患治理应用需求文档。
- 做法：优先提炼文档定位、10 步业务闭环、7 个模块、关键规则和 AI 边界，而不是逐节复述。
- 注意：AI 是辅助能力，不替代人工审批、整改确认和验收结论；具体规则以当前仓库中的文档版本为准。
