# Codex 规则路由

本文件是当前机器 Codex 的全局入口规则，只负责环境识别和规则加载。具体规则与经验统一维护在 `dev-config-notes` 仓库的 `codex/` 目录中；不同环境只切换仓库根路径：

- `CODEX_WORK_ENV=ghy`：仓库根路径为 `/home/ghy/work/dev-config-notes`
- `CODEX_WORK_ENV=home-windows`：规则仓库位于 WSL 的 `/home/hetao/workspace/dev-config-notes`，Windows 侧通过 `wsl.exe` 访问
- `CODEX_WORK_ENV=home-wsl`：仓库根路径为 `/home/hetao/workspace/dev-config-notes`

项目级规则与经验：

- 先确定任务实际操作的目标仓库：用户明确指定的仓库、绝对路径或可唯一定位的项目优先；用户未指定时，才以当前工作目录所在仓库作为目标。
- 目标仓库位于下列项目根目录或其子目录时，按路由读取对应项目的补充资料；项目根目录下的 `CODING_STANDARDS.md` 是代码编写的必读、必守规范：
  - `/home/ghy/work/cube2-upgrade` 或 `/home/hetao/workspace/cube2-upgrade` → `codex/projects/cube2/`
  - `/home/ghy/work/ghcloud` 或 `/home/hetao/workspace/ghcloud` → `codex/projects/ghcloud/`
  - `/home/ghy/work/kaihe` 或 `/home/hetao/workspace/kaihe` → `codex/projects/kaihe/`
  - `/home/ghy/work/kaiyun-oa` 或 `/home/hetao/workspace/kaiyun-oa` → `codex/projects/kaiyun-oa/`
  - `/home/ghy/work/baseline` 或 `/home/hetao/workspace/baseline` → `codex/projects/baseline/`
- 项目匹配按完整项目根路径判断，不根据当前子目录名称猜测项目。明确目标与当前工作目录不同时，不因启动目录而加载无关项目规则。
- 跨仓库任务按每个实际操作目标分别匹配并加载项目补充资料；未匹配的目标不加载项目级文件。任务执行中新增操作目标时，先完成对应路由再操作。
- 项目级文件适用于 `ghy`、`home-windows` 和 `home-wsl` 三个环境，不改变 `CODEX_WORK_ENV` 的环境选择逻辑。

## 项目编码规范文件

- 各项目根目录统一使用 `CODING_STANDARDS.md` 作为项目编码规范文件；不同项目分别维护各自根目录下的该文件。
- 编写、修改或重构项目代码前，必须先读取并遵守实际目标项目根目录下的 `CODING_STANDARDS.md`，跨仓库任务按每个实际操作目标分别读取并遵守对应文件。
- 目标项目缺少该文件、文件无法读取或规范内容不明确时，必须先报告并暂停该项目的代码编写，不得用其他项目的规范文件替代。

## 规则同步要求

- 仓库内 `codex/AGENTS.md` 发生新增、修改或合并后，必须在同一任务内及时同步到当前环境对应的 Codex 应用目录下的 `AGENTS.md`；`CODEX_WORK_ENV=ghy` 时对应文件为 `/home/ghy/.codex/AGENTS.md`，其他环境按其本机 Codex 应用目录确定。
- 同步前必须读取并比较应用目录中的现有文件；发现本机存在未同步修改时，不得静默覆盖，应先保留并处理差异。
- 同步后必须使用 `cmp -s`、`diff` 或等价方式验证仓库文件与应用目录文件完全一致；无法同步或验证时，必须明确报告，不能宣称任务已完成。

## 任务开始前

每次执行用户任务前，必须先读取当前系统环境变量 `CODEX_WORK_ENV`，然后按以下顺序加载规则与经验：

1. 若 `CODEX_WORK_ENV` 为空、缺失或不是已支持的环境值，必须停止执行具体任务，先提示用户配置环境变量。
2. 只有确认 `CODEX_WORK_ENV` 有效后，才能确定当前环境的 `dev-config-notes` 仓库根路径。
3. 读取通用规则：`<当前环境 dev-config-notes 仓库>/codex/general/rules.md`
4. 若存在通用经验文件，则使用任务关键词检索并只读取命中条目及必要上下文：`<当前环境 dev-config-notes 仓库>/codex/general/experience.md`；文件不存在时跳过，不阻塞任务。
5. 根据 `CODEX_WORK_ENV` 读取对应环境文件：
   - `CODEX_WORK_ENV=ghy`：若存在则读取 `<当前环境 dev-config-notes 仓库>/codex/envs/ghy/rules.md`，并按任务关键词检索同目录的 `experience.md`
   - `CODEX_WORK_ENV=home-windows`：若存在则读取 `<当前环境 dev-config-notes 仓库>/codex/envs/home-windows/rules.md`，并按任务关键词检索同目录的 `experience.md`
   - `CODEX_WORK_ENV=home-wsl`：若存在则读取 `<当前环境 dev-config-notes 仓库>/codex/envs/home-wsl/rules.md`，并按任务关键词检索同目录的 `experience.md`
6. 按上述目标仓库优先级确定一个或多个实际操作目标；同目录的 `rules.md`、`experience.md` 仅在存在时读取，缺失时跳过且不使用其他项目文件替代；编写、修改或重构项目代码时，必须读取并遵守实际目标项目根目录下的 `CODING_STANDARDS.md`。

配置示例：`export CODEX_WORK_ENV=ghy`、`export CODEX_WORK_ENV=home-windows` 或 `export CODEX_WORK_ENV=home-wsl`。
<!-- codebase-memory-mcp:start -->
# Codebase Memory

## Codebase Knowledge Graph (codebase-memory-mcp)

This project uses codebase-memory-mcp to maintain a knowledge graph of the codebase.
ALWAYS prefer MCP graph tools over grep/glob/file-search for code discovery.

### Priority Order
1. `search_graph` — find functions, classes, routes, variables by pattern
2. `trace_path` — trace who calls a function or what it calls
3. `get_code_snippet` — read specific function/class source code
4. `check_index_coverage` — validate candidate paths and missed ranges before claims
5. `query_graph` — run Cypher queries for complex patterns
6. `get_architecture` — high-level project summary

### Evidence tiers
- **Scout (Tier 1):** quick positive lookup with few calls and targeted source checks. Mark it provisional; do not make negative or exhaustive claims.
- **Verify (Tier 2, default):** task-directed graph evidence, relevant trace directions, exact snippets for material claims, and relevant pagination.
- **Auditor (Tier 3):** bounded-scope full verification with current generation, complete relevant pagination, both call directions and broader relationships when material, and every limitation disclosed.
- After candidate paths are known in any tier, call `check_index_coverage` once with every evidence path. Add relevant scopes for negative or exhaustive claims. A clean result means no recorded gap, not proof of completeness. For partial, skipped, excluded, stale, pending, or unknown coverage, read/grep the reported ranges or scope before relying on graph results.

### When to fall back to grep/glob
- Searching for string literals, error messages, config values
- Searching non-code files (Dockerfiles, shell scripts, configs)
- When MCP tools return insufficient results

### Examples
- Find a handler: `search_graph(name_pattern=".*OrderHandler.*")`
- Who calls it: `trace_path(function_name="OrderHandler", direction="inbound")`
- Read source: `get_code_snippet(qualified_name="pkg/orders.OrderHandler")`

### Session resets and subagents
- At session start or after compaction, confirm the nearest graph project and generation with `list_projects` or `index_status`, then choose Scout, Verify, or Auditor.
- Before spawning a subagent, query the graph and coverage in the parent. Pass the tier, project, generation/freshness, bounded scope, queries and pagination state, qualified symbols, paths, call-chain findings, coverage evidence with ranges/reasons, source fallback already performed, and unresolved questions in the delegated task context.
- Do not assume subagents inherit MCP access or the parent conversation. If a child lacks MCP tools, it must not call or claim MCP access. It should use the supplied evidence and read/grep exact source, especially every reported missed-coverage range.
<!-- codebase-memory-mcp:end -->
