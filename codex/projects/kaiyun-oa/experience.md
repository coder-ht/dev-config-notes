# Kaiyun OA 项目经验总结

## 2026-07-15 Eclipse Classpath 元数据清理

- 场景：IDE 自动生成的各 Maven 模块 `.classpath` 已被 Git 跟踪，普通忽略规则无法让其自动退出版本控制。
- 做法：删除全部已跟踪 `.classpath` 并暂存删除记录；确认仓库根 `.gitignore` 已包含 `.classpath`，防止 IDE 再生成后重新进入 Git。
- 注意：只清理目标元数据，不连带删除 `.settings`、`.project` 等其他 IDE 配置；用文件系统搜索和 Git 状态分别验证实际删除与版本控制状态。

## 2026-07-15 后台请求边界日志

- 场景：统一记录 Controller、Service 每个节点会让后台日志量过大，常规接口观测只需要请求边界。
- 做法：由请求过滤器记录 HTTP 请求开始、结束、状态码和耗时，保留 `traceId`、用户及租户 MDC；不使用切面打印 Controller、Service 中间节点。
- 注意：请求异常出口仍按级别记录，业务关键节点、定时任务汇总和异常堆栈继续保留，不能因精简接口日志而全部关闭。

## 2026-07-15 生产数据库每日全量同步到本机

- 场景：需要每日将正式 MySQL 数据同步到本机，同时避免电脑关机导致生产备份缺失或失败覆盖本地可用库。
- 做法：如果目标只是防服务器或云盘损坏，优先启用 ECS 自动磁盘快照；需要逻辑级数据库备份或本地调试时，再由生产服务器导出正式库、压缩加密并由本机通过 SSH 拉取、校验和恢复。
- 注意：磁盘快照最省维护且能覆盖数据库和对象文件，但属于磁盘级恢复；需要防数据库逻辑损坏、误操作或账号/地域级故障时，应叠加数据库导出、跨地域复制或 OSS 异地备份。使用 `mysqldump --databases` 的文件会包含原库的 `CREATE DATABASE` 和 `USE`，恢复到新库时只过滤这两类语句并指定目标库，不能全局替换库名以免修改业务数据。

## 2026-07-13 测试环境服务器构建部署

- 场景：Kaiyun 测试环境改为服务器本机打包 JAR 和构建 Docker 镜像。
- 做法：服务器项目位于 `/root/docker/server/kaiyun/repo/test`；构建前从部署脚本和项目配置核对当前 JDK、Maven 与 Compose 要求，镜像使用可追溯的模块版本或提交标识，部署日志采用受控保留策略。
- 注意：固定容器名切换 Compose project 时，必须在镜像构建成功后移除旧容器再启动；部署前后检查磁盘空间，但不把某次剩余空间、工具版本或日志数量写成长期经验。经验中不记录服务器凭据。

## 2026-07-14 测试环境部署与版本自动升级

- 场景：测试环境前后端共用服务器部署脚本，且 `test` 分支由 GitHub Actions 自动升级模块版本。
- 做法：版本任务只在 `test` 分支对比 `github.event.before` 与当前提交；检测到 `kaiyun-fe/` 时执行 `npm version patch --no-git-tag-version --prefix kaiyun-fe`，检测到 `kaiyun-be/` 时递增 Maven 版本，然后自动提交并推送，部署任务使用该版本提交的 SHA。
- 注意：默认 `GITHUB_TOKEN` 推送的版本提交不会递归触发新的 push workflow，因此当前运行必须直接部署版本提交 SHA；服务器部署脚本的 `git reset --hard "$TARGET_SHA"` 只改变服务器本地工作副本，不会回退 GitHub 远端分支。仅补 workflow 注释时，应解析 YAML 并逐行比较修改前后的非注释内容，不能因“只改注释”跳过行为不变验证。

## 2026-07-14 测试环境部署前置检查与健康校验

- 场景：测试环境前后端共用服务器部署脚本时，前端部署不应依赖预先存在的后端 JAR。
- 做法：将 JDK/Maven/后端 Dockerfile 检查收敛到后端部署阶段；为 Nginx 容器增加健康检查，并在部署脚本中等待健康状态；测试 API 代理地址与 staging 配置保持一致。
- 注意：真实服务器发布仍需单独验证容器启动和接口可用性。

## 2026-07-14 正式环境改为服务器构建部署

- 场景：正式环境参考测试环境，改为服务器拉取指定 `main` SHA、本机构建前后端并通过 Compose 发布。
- 做法：正式仓库使用 `/root/docker/server/kaiyun/repo/prod`；部署脚本可在空目录初始化 `origin`，并强制用目标 SHA 覆盖 Actions 预上传的临时脚本；正式镜像使用“模块版本-SHA”标签，日志采用有上限的轮换保留策略。
- 注意：服务器首次 `npm ci` 可能超过 SSH Action 默认超时，需根据当前构建耗时为 `command_timeout` 留出余量；Actions 超时后远端进程可能继续持有部署锁，重新触发前先检查部署进程和锁占用。

## 2026-07-14 前端服务器构建依赖缓存

- 场景：前端服务器部署的主要耗时来自依赖未变化时仍重复执行 `npm ci`。
- 做法：按锁文件真实依赖、Node ABI、平台和架构生成环境级指纹，忽略自动版本提交只改变的根版本字段；指纹不变且 `node_modules` 完整时跳过 `npm ci`。
- 注意：首次部署、真实依赖变化或运行环境变化仍需完整安装；`scp-action` 会保留 source 路径层级，上传部署脚本时 target 应指向仓库根目录，避免产生重复的 `deploy/test/deploy/test`。

## 2026-07-14 前后端合并部署与耗时观测

- 场景：同一次提交同时影响前后端时，两个 Actions 部署 job 会被服务器部署锁串行化，造成重复源码同步、日志相互清理且不便统计整体耗时。
- 做法：准备阶段将目标归一成 `frontend`、`backend`、`all` 或 `none`；`all` 先完成两端产物和两个新镜像构建，全部成功后再统一停止当前容器、启动新容器并检查两端健康状态。
- 注意：旧服务必须持续运行到所有新镜像构建成功；切换旧 Compose 容器前校验项目和服务标签，完成后独立验证容器健康、后端端口、前端首页和代理链路。

## 2026-07-14 同一浏览器多账号登录隔离

- 场景：同源页面将认证 Token 放在 Cookie 或 `localStorage` 时，所有标签页共享登录态，无法同时登录多个账号。
- 做法：认证工具统一只从 `sessionStorage` 读写 Token，使各标签页拥有独立会话；若明确不兼容旧登录态，初始化时直接清理旧 Cookie 和 `localStorage` Token。
- 注意：页面刷新会保留当前标签页会话，关闭标签页后会话失效；由已有页面复制或打开的新标签页可能获得浏览器复制的初始 `sessionStorage`，但后续登录和退出互不覆盖。

## 2026-07-14 流程执行记录权限校验

- 场景：新增执行记录提示“当前用户不属于该流程的执行对象”。
- 做法：从 Controller 进入 `ProcessExecutionServiceImpl.createRecord`，依次校验申请存在、审批状态为 `FINISHED`、启用业务执行，再比较流程定义快照的执行对象部门 ID 与当前登录用户部门 ID。
- 注意：当前只支持部门执行对象，精确匹配部门 ID，不自动包含子部门；查询执行记录的管理员、申请人等可见性规则不等于新增记录的执行权限。

## 2026-06-13 kaiyun-be VS Code/Maven 启动排查

- 场景：`kaiyun-be/application` 启动失败或 VS Code Java classpath 缺少内部模块。
- 做法：先检查 `.vscode/launch.json`、`.vscode/settings.json`、本地 Maven 仓库和全局 settings；将调试工作目录对齐到 `kaiyun-be`，使用可读的工作区 Maven settings，并一次性安装缺失的内部模块后执行 `application compile -DskipTests` 验证。
- 注意：缺少内部 JAR 和不可读的系统 Maven settings 往往是启动根因；`ENOSPC` 文件监听告警可能同时出现，但不一定是 Java classpath 根因。

## 2026-07-23 Kaiyun AI 模块接入 LangChain4j

- 场景：在 `kaiyun-be` Maven 多模块项目中接入 DeepSeek API 进行 LangChain4j 学习和测试。
- 做法：新增 `ai` 模块，使用 `langchain4j-open-ai` 连接 DeepSeek 的 OpenAI 兼容接口；应用配置默认关闭，通过 `AI_DEEPSEEK_ENABLED` 和 `DEEPSEEK_API_KEY` 环境变量启用，模型和连接参数也使用环境变量覆盖；需要由 AI 直接调用业务 Service 时，在 `ai/pom.xml` 显式依赖对应业务模块，保持依赖方向为业务模块 → AI 使用方，避免反向依赖。
- 注意：定向编译需同时指定仓库内 Maven settings 作为 global/user settings，避免系统 `/usr/share/maven/conf/settings.xml` 权限问题；应用全量定向编译若被既有 `process` 模块实体目标类不一致阻断，应区分既有构建问题与 AI 模块自身编译结果。

## 2026-06-15 隐患治理需求文档分析

- 场景：分析 Kaiyun OA 的隐患治理应用需求文档。
- 做法：优先提炼文档定位、10 步业务闭环、7 个模块、关键规则和 AI 边界，而不是逐节复述。
- 注意：AI 是辅助能力，不替代人工审批、整改确认和验收结论；具体规则以当前仓库中的文档版本为准。

## 2026-07-14 登录 Token 调试定位

- 场景：需要以指定用户身份调用正式接口调试，但验证码登录不便重复执行。
- 做法：从 Redis 的 `login_tokens:*` 缓存项中按缓存值里的用户信息定位会话，再取对应 token 调用接口。
- 注意：不得记录密码、完整 token 或 Redis 脱敏以外的认证信息；Redis key 按 token 组织，不能直接用用户名拼出 key；若 JWT 已能解析但 Redis 查询返回空对象，401 根因是登录缓存缺失、过期、注销或环境/数据库不一致，应重新登录并核对当前应用连接的 Redis。

## 2026-07-14 临时文件孤儿检查

- 场景：核对正式 MinIO 临时对象是否存在数据库未登记文件。
- 做法：将 MinIO `temporary/` 对象名与 `t_file_temporary.temporary_object_name` 截取第一个下划线前的前缀后比对，避免中文文件名编码差异；同时按 `expire_time` 和 `handled` 统计过期未处理记录。
- 注意：`handled` 是字符串枚举，查询时使用 `NOT_HANDLE`，不要用 `handled=0` 的隐式数值转换；只读核对阶段不执行对象或数据库删除。

## 2026-07-15 过期临时文件清理边界

- 场景：定时清理已过期且未处理的临时文件，不能复用会删除持久化对象的通用文件删除入口。
- 做法：通过状态抢占隔离持久化与清理；新模型只删除 MinIO 临时对象和 `t_file_temporary` 记录，同时兼容清理历史持久化占位记录；任务在应用启动完成后执行一次，并按北京时间每天零点执行。
- 注意：历史持久化记录的对象名非空时跳过并标记异常，避免产生持久化对象孤儿；普通清理异常需释放 `CLEANING` 并恢复 `NOT_HANDLE`，以便下次幂等重试。进程内需防止启动触发与定时触发重叠，多实例仍依赖数据库状态抢占。

## 2026-07-15 临时与持久化文件元数据分离

- 场景：临时上传不应提前占用持久化表，只有真实完成对象复制和业务绑定后才产生持久化元数据。
- 做法：上传只写 `t_file_temporary`；持久化请求必须携带场景，从临时记录生成并新增 `t_file_persistence`，对历史空占位记录保留更新兼容和幂等判断。
- 注意：上线迁移只删除对象名为空的历史占位记录，不触碰已有持久化对象；查询采用持久化优先、临时兜底，文件 ID 和接口响应保持不变。

## 2026-07-15 文件服务关键节点日志

- 场景：文件上传、持久化、删除和定时清理需要能从日志快速判断执行结果，又不能产生逐步骤日志噪声。
- 做法：业务入口记录开始或完成，批量任务汇总匹配、成功、跳过、失败数量和耗时；关键分支记录文件 ID、业务 ID、场景或引用数，异常保留堆栈。
- 注意：不逐条记录批量成功项，不输出 Token、URL、对象完整路径或原始文件名；对象存储失败日志与业务失败日志应避免重复描述同一层细节。

## 2026-07-15 接口注释对接说明

- 场景：流程执行记录接口注释需要提供给 Apifox 和前端对接。
- 做法：接口注释同时说明用途、权限范围、请求字段必填性、格式、枚举值、响应字段含义、排序规则和空值行为；通过 MCP 同步时先读取现有接口定义，再按方法和路径最小范围更新。
- 注意：更新 Apifox 请求体时必须保留原 `requestBody.jsonSchema.$ref`；只写 `requestBody.parameters` 会覆盖 Schema 引用，导致文档只显示 `object`、字段消失。字段说明应写入接口实际引用的 OpenAPI Schema，同步后重新读取接口并核对 Schema 引用、字段列表、必填项、描述及同批次其他接口，不能仅依据 MCP 的成功响应判断完成。

## 2026-07-23 LangChain4j ChatResponse 接口返回

- 场景：Spring 接口将 LangChain4j 的 `ChatResponse` 直接放入 `Result.data` 时，Jackson 报 `No serializer found`。
- 做法：对外返回文本时使用 `chatResponse.aiMessage().text()`，接口泛型声明为 `Result<String>`；只有确实需要响应元数据时，才自行定义可序列化 DTO。
- 注意：不要通过关闭 `SerializationFeature.FAIL_ON_EMPTY_BEANS` 掩盖类型设计问题；`ChatResponse` 的内容和 token 等元数据应按 API 需要显式映射。

## 2026-07-23 LangChain4j 流式接口

- 场景：在当前 Spring MVC 项目中增加 LangChain4j 流式聊天接口。
- 做法：使用 `OpenAiStreamingChatModel` 创建 `StreamingChatModel` Bean，控制器通过 `SseEmitter` 转发 `onPartialResponse` 分片，并在完成或异常回调中结束连接。
- 注意：接口返回类型使用 `text/event-stream`，不要把 `ChatResponse` 直接作为普通 JSON 返回；Spring MVC 可直接使用 `SseEmitter`，无需仅为该接口引入 WebFlux。

## 2026-07-23 LangChain4j AI Services 依赖

- 场景：当前 AI 模块只引入 `langchain4j-open-ai` 时，无法使用 `AiServices`、`@SystemMessage` 和 `@UserMessage`。
- 做法：在保留厂商适配依赖的同时，补充同版本的 `dev.langchain4j:langchain4j` 主依赖；厂商依赖负责模型客户端，高层主依赖负责 AI Services 等能力。
- 注意：示例接口中的注解必须使用 `dev.langchain4j.service` 包，`@SystemMe` 等拼写错误会被误判为依赖缺失。

## 2026-07-23 AI 模块依赖边界调整

- 场景：AI 模块不应通过 Maven 直接依赖所有业务模块，避免依赖扩散和模块边界变宽。
- 做法：`dev.langchain4j:langchain4j` 和 `dev.langchain4j:langchain4j-open-ai` 都由 `ai` 模块直接持有，不下沉到 `common`，也不让所有业务模块传递依赖 AI 库；`common` 只保留通用业务基础依赖。
- 注意：AI Tool 需要哪个业务能力时，再按实际使用场景在 `ai` 中显式增加对应业务模块依赖；执行任务时重新核对当前 POM，不把某次模块图或依赖版本写成长期事实。
