# Codex 规则路由

本文件是当前机器 Codex 的全局入口规则，只负责环境识别和规则加载。具体规则与经验统一维护在 `dev-config-notes` 仓库的 `codex/` 目录中；不同环境只切换仓库根路径：

- `CODEX_WORK_ENV=ghy`：仓库根路径为 `/home/ghy/work/dev-config-notes`
- `CODEX_WORK_ENV=home-windows`：规则仓库位于 WSL 的 `/home/hetao/workspace/dev-config-notes`，Windows 侧通过 `wsl.exe` 访问
- `CODEX_WORK_ENV=home-wsl`：仓库根路径为 `/home/hetao/workspace/dev-config-notes`

项目级规则与经验：

- 先确定任务实际操作的目标仓库：用户明确指定的仓库、绝对路径或可唯一定位的项目优先；用户未指定时，才以当前工作目录所在仓库作为目标。
- 目标仓库位于下列项目根目录或其子目录时，读取对应项目的规则和经验：
  - `/home/ghy/work/cube2-upgrade` 或 `/home/hetao/workspace/cube2-upgrade` → `codex/projects/cube2/`
  - `/home/ghy/work/ghcloud` 或 `/home/hetao/workspace/ghcloud` → `codex/projects/ghcloud/`
  - `/home/ghy/work/kaihe` 或 `/home/hetao/workspace/kaihe` → `codex/projects/kaihe/`
  - `/home/ghy/work/kaiyun-oa` 或 `/home/hetao/workspace/kaiyun-oa` → `codex/projects/kaiyun-oa/`
  - `/home/ghy/work/baseline` 或 `/home/hetao/workspace/baseline` → `codex/projects/baseline/`
- 项目匹配按完整项目根路径判断，不根据当前子目录名称猜测项目。明确目标与当前工作目录不同时，不因启动目录而加载无关项目规则。
- 跨仓库任务按每个实际操作目标分别匹配并加载项目规则；未匹配的目标不加载项目级文件。任务执行中新增操作目标时，先完成对应路由再操作。
- 项目级文件适用于 `ghy`、`home-windows` 和 `home-wsl` 三个环境，不改变 `CODEX_WORK_ENV` 的环境选择逻辑。

## 任务开始前

每次执行用户任务前，必须先读取当前系统环境变量 `CODEX_WORK_ENV`，然后按以下顺序加载规则与经验：

1. 若 `CODEX_WORK_ENV` 为空、缺失或不是已支持的环境值，必须停止执行具体任务，先提示用户配置环境变量。
2. 只有确认 `CODEX_WORK_ENV` 有效后，才能确定当前环境的 `dev-config-notes` 仓库根路径。
3. 读取通用规则：`<当前环境 dev-config-notes 仓库>/codex/general/rules.md`
4. 使用任务关键词检索通用经验，只读取命中条目及必要上下文：`<当前环境 dev-config-notes 仓库>/codex/general/experience.md`
5. 根据 `CODEX_WORK_ENV` 读取对应环境文件：
   - `CODEX_WORK_ENV=ghy`：读取 `<当前环境 dev-config-notes 仓库>/codex/envs/ghy/rules.md`，并按任务关键词检索同目录的 `experience.md`
   - `CODEX_WORK_ENV=home-windows`：读取 `<当前环境 dev-config-notes 仓库>/codex/envs/home-windows/rules.md`，并按任务关键词检索同目录的 `experience.md`
   - `CODEX_WORK_ENV=home-wsl`：读取 `<当前环境 dev-config-notes 仓库>/codex/envs/home-wsl/rules.md`，并按任务关键词检索同目录的 `experience.md`
6. 按上述目标仓库优先级确定一个或多个实际操作目标；对每个命中映射的项目读取 `codex/projects/<project>/rules.md`，并按任务关键词检索同目录的 `experience.md`。

配置示例：`export CODEX_WORK_ENV=ghy`、`export CODEX_WORK_ENV=home-windows` 或 `export CODEX_WORK_ENV=home-wsl`。
