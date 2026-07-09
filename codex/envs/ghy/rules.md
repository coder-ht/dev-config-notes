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
- 接口调试凭据、Bearer、账号密码、API Key 不应写入本仓库规则文件；需要时使用本机私有配置或用户当次提供的请求头。
