# ghcloud 项目规则

本文件适用于 `/home/ghy/work/ghcloud` 和 `/home/hetao/workspace/ghcloud`。

## 权威入口与路由

- 开始 ghcloud 任务时只先读取仓库根 `.agents/README.md`，再根据当前任务从它指向的仓库地图、Skill 索引、标准和命令发现文档中按需选择；不固定全文读取四份或更多文档。
- 当前代码、`package.json`、TypeScript 与构建配置是最高优先级事实；命中具体目录后继续读取最近层级的 `AGENTS.md`、目标 Skill 和实际 scripts。
- 仓库根 `AGENTS.md` 等工具入口只负责分流，项目知识以 `.agents/` 为权威来源，不在本文件复制业务、编码或命令规则。

## 个人补充与环境边界

- `prod` 按当前标准结构处理；`legacy` 遵循最近层级规则并保持最小必要改动，不顺手现代化。
- 命令、测试和构建必须从目标包当前 scripts 或 `.agents` 对应 Skill 发现，不根据目录名猜测。
- 需要环境地址、认证或部署信息时只读取当前环境资料并核对实时状态，不跨环境复用；发布、部署、推送和依赖安装仍需用户明确授权。
