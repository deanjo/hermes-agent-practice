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

## Sharding Decision（T1 初始分片快照）

下列计数只记录立项时为什么采用多文件，不代表当前未关闭项数量；当前状态以“执行阶段”和验收矩阵为准。

```text
Sharding Decision: multi-file
Counts: baseline_facts=23 | acceptance_rows=16 | subagent_gates=3 | modules=7 | tools=0 | prompts=0 | schemas=2 | test_layers=4 | open_findings=4 | review_rounds=0 | est_lines≈150
Trigger hit: baseline_facts>=10, acceptance_rows>=8, modules>=3, new/old authority conflict
Reason: 任务跨工作区、三个代码项目、上游 PR、文档治理和最终删除；旧文档又存在互相冲突的当前状态，单文件会让执行 Agent 误读。
Entry document: docs/workspace-migration_20260714/00_ROADMAP.md
Shard documents: 01 baseline and decisions; 02 acceptance matrix; 03 review gate; 04 source/release/upgrade policy; tasks/T1-T5 plus T4R
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
7. 我们的 Hermes 核心修复只在执行时最新官方基线上的 `deanjo/hermes-agent` 开发，形成可审阅提交并向 `NousResearch/hermes-agent` 提 PR；运行容器和旧补丁目录不作为源码权威。
8. DingTalk 源码只在 `deanjo/hermes-dingtalk-kit` 开发并固定提交或 tag，再由标准安装器进入镜像；禁止先改 H1 再补仓库。
9. 官方升级时先在最新官方代码上重跑同一回归测试：官方已等价修复就删除本地补丁，仍失败才保留最小差异；旧整文件不得覆盖新版本。
10. T4 只做到 `SOURCE_COMPLETE / RELEASE_READY`；远程构建、部署与重启属于 T4R，必须获得单独 H1 部署授权。

## Multi-agent 执行策略

并行只用于写集相互隔离、能够独立验收的工作；共享 Git 状态、归档删除和最终权威文档由主 Agent 串行控制。

| 阶段 | 执行方式 | 并行边界 |
|---|---|---|
| T2 | 主 Agent 归档；移除 worktree 前由 1 个 subagent 只读复核 | subagent 不写文件、不删除、不派生 Agent |
| T3 | 主 Agent 串行 clone、配置 remote、建仓和迁入 dirty 内容 | subagent 只可核对 upstream、remote、清单和哈希 |
| T4 | 主 Agent + 3 个 worker 并行 | T21、Product、T5v 各写一个独立仓库；T5v 不并行修改 Hermes 核心 |
| T4R | 主 Agent 串行 | 固定四路源码 SHA、构建候选、受控发布与回滚；没有 H1 部署授权时保持 BLOCKED |
| T5 | 最多 3 个 subagent 分区只读盘点，主 Agent统一裁决和迁移 | subagent 只交付分类、证据和阻塞点，不批量删除 |

统一约束：最多 4 个并发槽位；worker 不派生子 Agent；任务上下文只包含 Roadmap、当前 task 和必要路径；输出只保留结论、文件、验证与阻塞点；每项最多一轮独立 review。

## 执行阶段

| 顺序 | 任务 | 当前状态 |
|---|---|---|
| T1 | [工作区与文档规则](tasks/T1_workspace_and_repo_layout.md) | `PASS / USER_ACCEPTED_20260714` |
| T2 | [退役 Feishu wsfix](tasks/T2_retire_feishu_wsfix.md) | `PASS` |
| T3 | [建立干净源码与项目仓库](tasks/T3_refresh_upstream_and_migrate_projects.md) | `PASS / REVIEW_CLEARED_20260714` |
| T4 | [T21、Product、T5v 实现与开源](tasks/T4_extract_core_and_plugins.md) | `PASS / SOURCE_COMPLETE / RELEASE_READY_SCOPED / REVIEW_CLEARED_20260715` |
| T4R | [固定版本并受控发布到 H1](tasks/T4R_release_to_h1.md) | `BLOCKED / REQUIRES_DEPLOY_AUTHORIZATION_AND_INSTALL_MODE` |
| T5 | [旧 docs 治理与最终清仓](tasks/T5_govern_docs_and_cleanup_legacy.md) | `NOT_STARTED` |

## 文档加载顺序

1. 本 Roadmap。
2. [01_BASELINE_AND_DECISIONS.md](01_BASELINE_AND_DECISIONS.md) 中与当前任务相关的事实。
3. 涉及源码、发布或升级时读取 [04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md](04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md)。
4. 当前唯一 task 文件。
5. [02_ACCEPTANCE_MATRIX.md](02_ACCEPTANCE_MATRIX.md) 的对应验收行。
6. 完成前读取 [03_REVIEW_AND_COMPLETION_GATE.md](03_REVIEW_AND_COMPLETION_GATE.md)。

## 停止条件

- 迁移前后 dirty 文件或未跟踪文件的清单、内容哈希不一致。
- 新 Hermes 的 `HEAD` 不等于执行当刻 `upstream/main`，或 remote 角色配置错误。
- 开始编码前没有冻结执行时 upstream 完整 SHA、fork 完整 SHA和复现结果。
- Product Confirmation 仍需修改 Hermes 核心，或 T21 生产文件超过两个。
- T5v 在未证明插件接口不足前扩大核心补丁。
- Kit 安装需要整文件覆盖 `gateway/run.py`、`gateway/session.py` 或 `gateway/session_context.py`，或需要修改允许清单外核心文件。
- 准备把本地测试写成“已部署”，却没有单独 H1 部署授权和 T4R 运行证据。
- 独立 review 仍有 Critical 或 Important 未清零。
- 旧资产仍标为 `defer`，却准备删除旧目录。
- H1/H3 镜像、启动时间或关键文件发生本任务未触发的变化。

## 当前结论

T3 的 `226e8de` 快照已通过 A08-A10 和 [R2](reviews/R2_t3_repository_migration_verification.md) 独立复核，但它不是永久 live 基线。T4 已在执行时官方 `569b912d7d0931c7256e9f5fb326609e9deda377` 上收口：T21 fork `fca44fd00b5c0575469c51e96ec5fa731d5c7222`、Kit `0e37e209cc6c1df8b96dd28f80adb7c00e09bc11`、T5v 通用 core `dd45532f563e72adcf0f605ff11ea441187232fc`、Guardrails `14c28d4444273232c8753314ff928927fce651c3`，四个 PR 均已创建；A11-A13、A15 经 [R3](reviews/R3_t4_source_release_verification.md) 复核为 `PASS`。

Product/mention 只在 `--plugins-only` 路径达到 `RELEASE_READY_PRODUCT_ONLY`；默认 legacy compat 因 `run.reply_sentinel_constant` 和 `session.path_sensitive_validation` 两个旧锚点不匹配，保持 `ADAPT_REQUIRED`，不能写成整套 Kit 已可发布。T4 也没有把源码部署到 H1/H3。

收口只读检查发现 H1 在 `2026-07-15T08:53:57.916638417Z`、H3 在 `2026-07-15T09:11:33.186856916Z` 被外部显式 restart。Docker 事件、data 文件修改时间和旧目录 vision 修复记录共同归因为 T4 外的图片识别数据层调整；容器 ID、镜像 ID、Created 时间均未变，H1 `/opt/hermes/` 无差异，H3 只有 4 个 `__pycache__/*.pyc`。结论为 `RUNTIME_CHANGE_ATTRIBUTED_EXTERNAL`，不是 T4/T4R 部署；具体调用人因 Docker 事件不记录客户端身份而仍为 `UNKNOWN`。T4R 继续因缺少 H1 部署授权和安装模式选择而 `BLOCKED`，T5 尚未开始。
