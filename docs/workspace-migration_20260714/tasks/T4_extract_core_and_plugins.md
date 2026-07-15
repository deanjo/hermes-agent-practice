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

`GOAL_ACTIVE / IMPLEMENTATION_ACTIVE`。主 Agent 已验证 `226e8de → 569b912d7d0931c7256e9f5fb326609e9deda377` 为纯快进，并把本地与 fork main 同步到该执行时官方 SHA；三个隔离 worktree 已建立，worker 只在各自固定写集内实现。

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

worker 只加载本 Roadmap、当前 task、对应仓库规则和必要代码路径，不接收整段会话；输出只包含结论、改动文件、测试和阻塞点。T5v 如果证明必须修改 Hermes 核心，则停止并交回主 Agent，待 T21 分支完成后串行处理。

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
- 禁止迁入私有环境变量桥接；在固定官方 Hermes 树运行标准安装后，Hermes core diff 必须为零；最终源码先提交并推送 Kit GitHub。

## T5v 契约

- 普通与结构化文本限制为 `8192 bytes / 200 lines`，图片等多模态内容保持原样。
- 支持跨工具包装的同根因归并；普通重复失败优先使用 Hermes 原生 guardrail 配置。
- 缺凭据、401/403 等首次停止先尝试公开 middleware/hook。
- mentionguard 镜像的 HANDOFF-GUARD 只作行为参考；不得从运行镜像复制 `base.py` 到项目。
- 只有测试证明公开接口不能表达 halt，才串行另建仅修改 `agent/tool_guardrails.py` 的 fork 分支与官方 PR；没有证明时 Hermes core diff 必须为零。

## 验收

- A11-A13 与 A15 PASS。
- 每路一次独立合并 review；Critical、Important 为零。
- 三路至少达到 `SOURCE_COMPLETE`，并在固定 SHA、安装/卸载/回滚和离线验证齐全后达到 `RELEASE_READY`。
- 不运行真实 DingTalk/Feishu 消息，不构建、不部署、不重启远程实例；后续只由 [T4R](T4R_release_to_h1.md) 在单独授权后执行。
