# ghcloud 项目经验总结

## 前端与服务契约

- 场景：Vue、qiankun、Pinia、路由、BFF 或 SDK 问题。
- 做法：先按 Skill 路由，连同共享接口类型、Gateway、Client 和前端调用一起核对。
- 注意：legacy 项目不能反推为新项目规范；具体 package scripts、应用路径和技术栈必须以当前仓库为准。

## 构建与依赖

- 场景：构建、启动或推送前检查失败。
- 做法：先查 package scripts、workspace 依赖、catalog、lockfile 和 Node/Bun 环境，再决定修代码还是修环境。
- 注意：watcher、Node/Bun 版本、lockfile 和 workspace 协议问题通常属于环境或依赖边界，不要直接归因于业务代码。

## Git 与验证

- 场景：前端 Git 提交、回退或发布。
- 做法：使用路径限定的暂存和提交，区分业务文件、环境配置和 lockfile；完成后核对缓存区差异和实际验证结果。
- 注意：不要根据其他仓库的分支、发布脚本或历史失败经验直接推断当前应用行为。

## 页面与 legacy 路由

- 场景：legacy 的 qiankun 页面出现布局空白或返回白屏。
- 做法：先查真实路由和子应用根布局；页面外侧空白只调整页面根容器，保留面板内部层次。固定业务返回地址时直接使用目标路由，不用浏览器历史长度猜测返回位置。
- 注意：legacy 经验只用于对应 legacy 页面，不能反推 prod 应用规范。
