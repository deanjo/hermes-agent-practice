---
status: current
applies_when: "在最新 Hermes 基线上分别实现 T21、Product Confirmation 和 T5v 开源边界"
not_for: "继续维护 Feishu wsfix；把三个任务写入同一仓库；未经测试部署 H1/H3"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T4 提取核心修复与插件

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
- 空 follow-up 不复用工具调用前的旧 assistant 内容。
- session JSON 不得进入流式消费者、最终返回或最后持久化 assistant 消息。
- 生产修改最多两个文件；向 `NousResearch/hermes-agent` 提独立 PR。

## Product 契约

- 保留现有五个工具行为和持久化状态机。
- 使用 `pre_gateway_dispatch` 从 `event.source.user_id_alt` 获取真实 staffId，并通过公开上下文取得 gateway。
- DingTalk `@` 与 `errcode != 0` 检查归 Kit adapter。
- 禁止迁入 `gateway/run.py`、`gateway/session_context.py` 私有环境变量桥接；Hermes 核心 diff 必须为零。

## T5v 契约

- 普通与结构化文本限制为 `8192 bytes / 200 lines`，图片等多模态内容保持原样。
- 支持跨工具包装的同根因归并；普通重复失败优先使用 Hermes 原生 guardrail 配置。
- 缺凭据、401/403 等首次停止先尝试公开 middleware/hook。
- 只有测试证明公开接口不能表达 halt，才另建仅修改 `agent/tool_guardrails.py` 的核心分支与 PR。

## 验收

- A11-A13 PASS。
- 每路一次独立合并 review；Critical、Important 为零。
- 不运行真实 DingTalk/Feishu 消息，不部署远程实例。
