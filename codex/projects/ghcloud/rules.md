# ghcloud 项目规则

本文件适用于 `/home/ghy/work/ghcloud` 和 `/home/hetao/workspace/ghcloud`。

## 规则入口

- `.agents/` 是 ghcloud 规则权威来源；先读取仓库地图、Skill 索引、标准索引和命令发现文档。
- 先检查目标应用的 `package.json` 和实际 scripts，不根据目录名猜命令。
- `prod` 按当前标准结构开发；`legacy` 只做最小必要修改，不顺手现代化或重构。

## 服务与前端

- 服务契约按 `interfaces -> gateway -> client` 检查；修改接口契约时必须核对三层调用链。
- 页面、路由、状态、依赖、构建和验证按对应 Skill 路由处理。
- 依赖、workspace、catalog 和 lockfile 变更要单独检查。
- 完成前必须取得新鲜验证证据，不能仅凭代码修改宣称完成。

## Git 与发布

- 先检查工作区、目标包版本、实际变更范围和 package scripts，再执行 Git 操作。
- legacy 项目保持最小变更；不要把无关 lockfile、环境配置或生成文件混入业务提交。
- 发布、推送、部署和依赖安装必须由用户明确授权。
