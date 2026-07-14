---
status: current
applies_when: "执行 OpenClaw/Hermes 新工作区创建、源码分离、插件开源、文档治理和旧目录清仓"
not_for: "直接开发 OpenClaw 功能；未经任务分片执行远程部署；把旧目录立即整体删除"
current_authority: roadmap-current
supersedes:
  - "旧 openclaw-harmes 顶层把 OpenClaw、Hermes 源码、worktree、文档和临时产物混放的目录语义"
superseded_by: []
---

# OpenClaw / Hermes 工作区迁移 Roadmap

## Sharding Decision

```text
Sharding Decision: multi-file
Counts: baseline_facts=16 | acceptance_rows=14 | subagent_gates=2 | modules=5 | tools=0 | prompts=0 | schemas=1 | test_layers=3 | open_findings=0 | review_rounds=0 | est_lines≈90
Trigger hit: baseline_facts>=10, acceptance_rows>=8, modules>=3, new/old authority conflict
Reason: 任务跨工作区、三个代码项目、上游 PR、文档治理和最终删除；旧文档又存在互相冲突的当前状态，单文件会让执行 Agent 误读。
Entry document: docs/workspace-migration_20260714/00_ROADMAP.md
Shard documents: 01 baseline and decisions; 02 acceptance matrix; 03 review gate; tasks/T1-T5
```

## 目标

新建 `/Users/cicada/SourceCode/openclaw-hermes-workspace`，让 OpenClaw 源码、Hermes fork、DingTalk 集成、通用运行时插件和实战知识各自拥有清晰职责与独立 Git 历史。

## 为什么改

- 旧顶层不是 Git 仓库，却混放两个上游源码、四个 Hermes worktree、596 个 docs 文件、缓存和临时文件，无法作为可公开项目直接维护。
- 旧 Hermes `main` 相对旧 `origin/main` 为 `ahead 25, behind 13980`，且有 26 个修改文件和 19 个未跟踪路径，不能代表最新版干净源码。
- docs 中同时存在 current、historical、archive、pass、done 等二十余种状态，后续 Agent 无法稳定判断权威来源。

## 不可变决策

1. 顶层工作区不建 Git；所有源码和项目各自独立。
2. 新 Hermes 源码从个人 fork 全新 clone，官方仓库只作为 `upstream`。
3. Feishu wsfix 退役；Product Confirmation 核心修改目标为零；T21 保留最小核心 PR；T5v 优先独立插件。
4. 旧目录只按资产逐项迁移；没有迁移结论和验收证据不得整体删除。
5. 本轮不重启、不重建、不重新部署 H1/H3，也不发送真实平台消息。
6. 每个阶段只加载当前 task 和必要证据，不全量阅读 335 份 Markdown。

## Multi-agent 执行策略

并行只用于写集相互隔离、能够独立验收的工作；共享 Git 状态、归档删除和最终权威文档由主 Agent 串行控制。

| 阶段 | 执行方式 | 并行边界 |
|---|---|---|
| T2 | 主 Agent 归档；移除 worktree 前由 1 个 subagent 只读复核 | subagent 不写文件、不删除、不派生 Agent |
| T3 | 主 Agent 串行 clone、配置 remote、建仓和迁入 dirty 内容 | subagent 只可核对 upstream、remote、清单和哈希 |
| T4 | 主 Agent + 3 个 worker 并行 | T21、Product、T5v 各写一个独立仓库；T5v 不并行修改 Hermes 核心 |
| T5 | 最多 3 个 subagent 分区只读盘点，主 Agent统一裁决和迁移 | subagent 只交付分类、证据和阻塞点，不批量删除 |

统一约束：最多 4 个并发槽位；worker 不派生子 Agent；任务上下文只包含 Roadmap、当前 task 和必要路径；输出只保留结论、文件、验证与阻塞点；每项最多一轮独立 review。

## 执行阶段

| 顺序 | 任务 | 当前状态 |
|---|---|---|
| T1 | [工作区与文档规则](tasks/T1_workspace_and_repo_layout.md) | `PASS / USER_ACCEPTED_20260714` |
| T2 | [退役 Feishu wsfix](tasks/T2_retire_feishu_wsfix.md) | `PASS` |
| T3 | [建立干净源码与项目仓库](tasks/T3_refresh_upstream_and_migrate_projects.md) | `PASS / REVIEW_CLEARED_20260714` |
| T4 | [T21、Product、T5v 实现与开源](tasks/T4_extract_core_and_plugins.md) | `NOT_STARTED` |
| T5 | [旧 docs 治理与最终清仓](tasks/T5_govern_docs_and_cleanup_legacy.md) | `NOT_STARTED` |

## 文档加载顺序

1. 本 Roadmap。
2. [01_BASELINE_AND_DECISIONS.md](01_BASELINE_AND_DECISIONS.md) 中与当前任务相关的事实。
3. 当前唯一 task 文件。
4. [02_ACCEPTANCE_MATRIX.md](02_ACCEPTANCE_MATRIX.md) 的对应验收行。
5. 完成前读取 [03_REVIEW_AND_COMPLETION_GATE.md](03_REVIEW_AND_COMPLETION_GATE.md)。

## 停止条件

- 迁移前后 dirty 文件或未跟踪文件的清单、内容哈希不一致。
- 新 Hermes 的 `HEAD` 不等于执行当刻 `upstream/main`，或 remote 角色配置错误。
- Product Confirmation 仍需修改 Hermes 核心，或 T21 生产文件超过两个。
- T5v 在未证明插件接口不足前扩大核心补丁。
- 独立 review 仍有 Critical 或 Important 未清零。
- 旧资产仍标为 `defer`，却准备删除旧目录。
- H1/H3 镜像、启动时间或关键文件发生本任务未触发的变化。

## 当前结论

用户已于 2026-07-14 确认第一阶段。T2 已通过 A07；T3 已通过 A08-A10 和独立复核，结果记录在 [R2](reviews/R2_t3_repository_migration_verification.md)。T3 期间 H1 被另一项已有账本的 quotefix 部署更新；暂停核对后已用当前 RCA、补丁账本、远端 compose 时间和 Docker 生命周期事件闭环归因，本任务没有执行远程写操作。T4-T5 尚未开始。
