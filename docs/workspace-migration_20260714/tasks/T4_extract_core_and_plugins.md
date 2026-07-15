---
status: current
applies_when: "在最新 Hermes 基线上分别实现 T21、Product Confirmation 和 T5v 开源边界"
not_for: "继续维护 Feishu wsfix；把三个任务写入同一仓库；未经测试部署 H1/H3"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T4 提取核心修复与插件

## 当前状态

`PASS / SOURCE_COMPLETE / RELEASE_READY_SCOPED / REVIEW_CLEARED_20260715`。执行时官方、本地 main 与 fork main 均固定为 `569b912d7d0931c7256e9f5fb326609e9deda377`；四个源码提交、四个 PR、测试、安装/回滚材料和三路独立 review 已由 [R3](../reviews/R3_t4_source_release_verification.md) 收口。这里的 `PASS` 只覆盖源码和限定发布材料，不表示 H1 已部署。

## 共同前置门禁

1. 再查一次 `upstream/main` 并冻结完整 SHA；如果冻结后又变化，重新检查而不是继续使用旧结果。
2. 只允许 `--ff-only`（仅快进）更新干净 `sources/hermes-agent/main` 和 fork；祖先关系不成立就停止。
3. 从固定干净提交创建三个隔离 worktree（工作树）。Kit 两个现有根目录各有 `1 modified + 16 untracked`，manifest `c7ee88ba...fc22eb6`，禁止原地切分支、stash 或清理。
4. 在最新官方基线上分别重跑 T21、Product 接口和 T5v 能力检查；每个旧补丁先给出 `UPSTREAM_EQUIVALENT / LOCAL_REQUIRED / SPLIT_REQUIRED / ADAPT_REQUIRED`。
5. 全程遵守 [源码、发布与官方升级原则](../04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md)；T4 不构建、部署或重启 H1/H3。

## 执行编排

最多使用主 Agent 加三个 worker；每个 worker 只写一个仓库，不派生子 Agent：

| Worker | 仓库 | 写集 |
|---|---|---|
| T21 | `sources/hermes-agent` | `agent/conversation_loop.py`、`agent/turn_finalizer.py`、对应测试 |
| Product | `projects/hermes-dingtalk-kit` | Product 插件、DingTalk adapter、测试和文档 |
| T5v | `projects/hermes-agent-runtime-guardrails` | 独立插件、配置、测试和 README |
| T5v core（主 Agent 串行） | `sources/hermes-agent` | `agent/tool_guardrails.py`、`run_agent.py`、对应测试 |

worker 只加载本 Roadmap、当前 task、对应仓库规则和必要代码路径，不接收整段会话；输出只包含结论、改动文件、测试和阻塞点。T5v 的失败测试已证明公开 hook 只能提出 halt、官方 core 不消费；该项在 T21 完成后交回主 Agent，以独立 fork 分支串行实现，没有与 T21 同时写 Hermes。

## T21 契约

- 先在执行时 upstream 复现 session_search 原始 JSON 进入用户回复的路径。
- 分支必须直接基于冻结的 upstream SHA，所有自有改动提交到 `deanjo/hermes-agent` fork；不得从 H1 镜像或旧 quotefix 整文件复制。
- 空 follow-up 不复用工具调用前的旧 assistant 内容。
- session JSON 不得进入流式消费者、最终返回或最后持久化 assistant 消息。
- 生产修改最多两个文件；使用 Hermes 仓库规定的 `scripts/run_tests.sh`；向 `NousResearch/hermes-agent` 提独立 PR 并记录 URL。

## Product 契约

- 保留现有五个工具行为和持久化状态机。
- 使用 `pre_gateway_dispatch` 从 `event.source.user_id_alt` 获取真实 staffId，并通过公开上下文取得 gateway。
- DingTalk `@` 与 `errcode != 0` 检查归 Kit adapter。
- 以 `feat/dingtalk-admin-private-send@f4e7816` 的干净隔离 worktree 为开发起点；`feat/dingtalk-mention-meta@8b9f185` 只作行为和测试来源。
- 可精选 `ad1ccea`、`8b9f185` 及 `37e0147` 中 adapter 的 `at_user_ids / errcode` 改动；禁止整体合并 `37e0147` 的 `gateway/run.py`、`gateway/session.py`、`gateway/session_context.py` 快照。
- 禁止迁入私有环境变量桥接；Product/mention 增量的 Hermes core diff 必须为零。Kit 既有 legacy compat 要在安装报告中单独列出并逐项给升级结论，不能混成 Product 修改，也不能为过门禁擅自删除。最终源码先提交并推送 Kit GitHub。
- 最终 Product/mention 只用 `--plugins-only` 在完整 Hermes `569b912` 上发布验证：verifier `35/35`、二次安装无变化、`core_manifest.changed_paths=[]`。默认 legacy compat 的 `run.reply_sentinel_constant`、`session.path_sensitive_validation` 为 `ADAPT_REQUIRED`，虽然故障注入已证明原子回滚有效，适配前仍禁止发布。

## T5v 契约

- 普通与结构化文本限制为 `8192 bytes / 200 lines`，图片等多模态内容保持原样。
- 支持跨工具包装的同根因归并；普通重复失败优先使用 Hermes 原生 guardrail 配置。
- 缺凭据、401/403 等首次停止先尝试公开 middleware/hook。
- mentionguard 镜像的 HANDOFF-GUARD 只作行为参考；不得从运行镜像复制 `base.py` 到项目。
- 只有测试证明公开接口不能表达 halt，才串行另建最多修改 `agent/tool_guardrails.py`、`run_agent.py` 的通用 fork 分支与官方 PR：前者消费 `hermes.tool_guardrail.request/v1`，后者只区分“首次不可重试阻塞”与“重复失败”的真实话术；两处均不得识别插件专名。没有证明时 Hermes core diff 必须为零。

## 实现结果

| 路径 | 固定提交与 PR | 关键验证 | 发布结论 |
|---|---|---|---|
| T21 | `fca44fd00b5c0575469c51e96ec5fa731d5c7222`；官方 [PR #64892](https://github.com/NousResearch/hermes-agent/pull/64892) | 边界测试 `15/15`；两份生产文件；独立 review Critical=0、Important=0 | `SOURCE_COMPLETE / RELEASE_READY` |
| Product/mention | Kit `0e37e209cc6c1df8b96dd28f80adb7c00e09bc11`；Kit [PR #1](https://github.com/deanjo/hermes-dingtalk-kit/pull/1) | `105 passed + 14 subtests`；`--plugins-only` verifier `35/35`；Product/mention core diff=0 | `SOURCE_COMPLETE / RELEASE_READY_PRODUCT_ONLY` |
| T5v | Guardrails `14c28d4444273232c8753314ff928927fce651c3`、[PR #1](https://github.com/deanjo/hermes-agent-runtime-guardrails/pull/1)；core `dd45532f563e72adcf0f605ff11ea441187232fc`、官方 [PR #64895](https://github.com/NousResearch/hermes-agent/pull/64895) | 插件 `45/45`；core `27/27`；安装/卸载/回滚幂等；两份 core 生产文件无插件专名 | `SOURCE_COMPLETE / RELEASE_READY` |

## 验收

- A11-A13 与 A15 已由 R3 判为 `PASS`；A16 在 R3 时点仍为 `BLOCKED`，后续状态以 [验收矩阵](../02_ACCEPTANCE_MATRIX.md) 和 [R4](../reviews/R4_t4r_h1_release_verification.md) 为准。
- 每路一次独立合并 review；Critical、Important 为零。
- 三路均达到 `SOURCE_COMPLETE`；T21/T5v 达到 `RELEASE_READY`，Product 的范围严格限定为 `RELEASE_READY_PRODUCT_ONLY`。
- 不运行真实 DingTalk/Feishu 消息，不构建、不部署、不重启远程实例；后续只由 [T4R](T4R_release_to_h1.md) 在单独授权后执行。
