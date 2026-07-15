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
Shard documents: 01 baseline and decisions; 02 acceptance matrix; 03 review gate; 04 source/release/upgrade policy; tasks/T1-T5 plus T4R1/T4R
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
5. T1-T4 不重启、不重建、不重新部署 H1/H3；T4R 只有在单独授权、候选验收和回滚材料齐全后才可操作 H1，H3 与真实平台消息始终不在本任务范围。2026-07-15 用户已授权本次 H1 候选通过后的切换与所需重启。
6. 每个阶段只加载当前 task 和必要证据，不全量阅读 335 份 Markdown。
7. H1 运行底座使用执行时最新稳定官方 Release 的精确 tag/commit；官方 PR 在复核当刻 `upstream/main` 上前向实现。两条线都只能在 `deanjo/hermes-agent` 形成可审阅提交；运行容器和旧补丁目录不作为源码权威。
8. DingTalk 源码只在 `deanjo/hermes-dingtalk-kit` 开发并固定提交或 tag，再由标准安装器进入镜像；禁止先改 H1 再补仓库。
9. 官方升级时在最新稳定 Release 与当前 main 分别重跑同一回归测试：Release 已等价修复就删除 H1 回移，main 已等价修复就不再维护对应 PR；仍失败的线才保留最小差异，旧整文件不得覆盖新版本。
10. T4 只做到 `SOURCE_COMPLETE / RELEASE_READY`；远程构建、部署与重启属于 T4R，必须获得单独 H1 部署授权。

## Multi-agent 执行策略

并行只用于写集相互隔离、能够独立验收的工作；共享 Git 状态、归档删除和最终权威文档由主 Agent 串行控制。

| 阶段 | 执行方式 | 并行边界 |
|---|---|---|
| T2 | 主 Agent 归档；移除 worktree 前由 1 个 subagent 只读复核 | subagent 不写文件、不删除、不派生 Agent |
| T3 | 主 Agent 串行 clone、配置 remote、建仓和迁入 dirty 内容 | subagent 只可核对 upstream、remote、清单和哈希 |
| T4 | 主 Agent + 3 个 worker 并行 | T21、Product、T5v 各写一个独立仓库；T5v 不并行修改 Hermes 核心 |
| T4R1 | 主 Agent + 3 个只读/隔离 worker | 并行核验 Release、旧补丁和数据清理；同一 Hermes 文件由主 Agent 串行整合 |
| T4R | 主 Agent 串行 | 固定双基线与各路源码 SHA、构建候选、受控发布、清理和回滚；远程写不与 worker 并行 |
| T5 | 最多 3 个 subagent 分区只读盘点，主 Agent统一裁决和迁移 | subagent 只交付分类、证据和阻塞点，不批量删除 |

统一约束：最多 4 个并发槽位；worker 不派生子 Agent；任务上下文只包含 Roadmap、当前 task 和必要路径；输出只保留结论、文件、验证与阻塞点；每项最多一轮独立 review。

## 执行阶段

| 顺序 | 任务 | 当前状态 |
|---|---|---|
| T1 | [工作区与文档规则](tasks/T1_workspace_and_repo_layout.md) | `PASS / USER_ACCEPTED_20260714` |
| T2 | [退役 Feishu wsfix](tasks/T2_retire_feishu_wsfix.md) | `PASS` |
| T3 | [建立干净源码与项目仓库](tasks/T3_refresh_upstream_and_migrate_projects.md) | `PASS / REVIEW_CLEARED_20260714` |
| T4 | [T21、Product、T5v 实现与开源](tasks/T4_extract_core_and_plugins.md) | `PASS / SOURCE_COMPLETE / RELEASE_READY_SCOPED / REVIEW_CLEARED_20260715` |
| T4R1 | [最新稳定 Release 对账与回移](tasks/T4R1_reconcile_latest_release.md) | `PASS / RELEASE_RECONCILED_20260715` |
| T4R | [固定版本并受控发布到 H1](tasks/T4R_release_to_h1.md) | `PASS / RUNTIME_DEPLOYED_H1_20260715` |
| T5 | [旧 docs 治理与最终清仓](tasks/T5_govern_docs_and_cleanup_legacy.md) | `IN_PROGRESS / PRE_DELETE_REVIEW` |

## 文档加载顺序

1. 本 Roadmap。
2. [01_BASELINE_AND_DECISIONS.md](01_BASELINE_AND_DECISIONS.md) 中与当前任务相关的事实。
3. 涉及源码、发布或升级时读取 [04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md](04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md)。
4. 当前唯一 task 文件。
5. [02_ACCEPTANCE_MATRIX.md](02_ACCEPTANCE_MATRIX.md) 的对应验收行。
6. 完成前读取 [03_REVIEW_AND_COMPLETION_GATE.md](03_REVIEW_AND_COMPLETION_GATE.md)。

## 停止条件

- 迁移前后 dirty 文件或未跟踪文件的清单、内容哈希不一致。
- H1 运行分支不从执行时最新稳定官方 Release 的解引用 SHA创建，或官方 PR 分支没有复核当前 `upstream/main`，或 remote 角色配置错误。
- 开始编码前没有分别冻结 `release_tag / release_sha / upstream_main_sha / runtime_fork_sha / pr_fork_sha` 和复现结果。
- Product Confirmation 仍需修改 Hermes 核心，或 T21 生产文件超过两个。
- T5v 在未证明插件接口不足前扩大核心补丁。
- Kit 安装需要整文件覆盖 `gateway/run.py`、`gateway/session.py` 或 `gateway/session_context.py`，或需要修改允许清单外核心文件。
- 准备把本地测试写成“已部署”，却没有 T4R 的镜像 digest、StartedAt、RestartCount、安装验证和回滚证据。
- 独立 review 仍有 Critical 或 Important 未清零。
- 旧资产仍标为 `defer`，却准备删除旧目录。
- H1/H3 镜像、启动时间或关键文件发生本任务未触发的变化。

## 当前结论

T3 的 `226e8de` 快照已通过 A08-A10 和 [R2](reviews/R2_t3_repository_migration_verification.md) 独立复核，但它不是永久 live 基线。T4 已在执行时官方 `569b912d7d0931c7256e9f5fb326609e9deda377` 上收口：T21 fork `fca44fd00b5c0575469c51e96ec5fa731d5c7222`、Kit `0e37e209cc6c1df8b96dd28f80adb7c00e09bc11`、T5v 通用 core `dd45532f563e72adcf0f605ff11ea441187232fc`、Guardrails `14c28d4444273232c8753314ff928927fce651c3`，形成四条初始 PR 线；A11-A13、A15 经 [R3](reviews/R3_t4_source_release_verification.md) 复核为 `PASS`。T4R1 前向对账后，当前共有官方 6 个、Kit 1 个、Guardrails 1 个 PR。

Product/mention 只在 `--plugins-only` 路径达到 `RELEASE_READY_PRODUCT_ONLY`；默认 legacy compat 因 `run.reply_sentinel_constant` 和 `session.path_sensitive_validation` 两个旧锚点不匹配，保持 `ADAPT_REQUIRED`，不能写成整套 Kit 已可发布。T4 也没有把源码部署到 H1/H3。

收口只读检查发现 H1 在 `2026-07-15T08:53:57.916638417Z`、H3 在 `2026-07-15T09:11:33.186856916Z` 被外部显式 restart。Docker 事件、data 文件修改时间和旧目录 vision 修复记录共同归因为 T4 外的图片识别数据层调整；容器 ID、镜像 ID、Created 时间均未变，H1 `/opt/hermes/` 无差异，H3 只有 4 个 `__pycache__/*.pyc`。结论为 `RUNTIME_CHANGE_ATTRIBUTED_EXTERNAL`，不是 T4/T4R 部署；具体调用人因 Docker 事件不记录客户端身份而仍为 `UNKNOWN`。

2026-07-15 T4R1 已完成双线对账：运行线固定 `v2026.7.7.2^{}`=`9de9c25f620ff7f1ce0fd5457d596052d5159596` 和 fork `62b304750762c69e7d4e611c5f2ec3ff296f58e6`；官方贡献线固定 `upstream/main=9df5f879b4a5925c0f8f947e7e16ed8e845932c3`。较早的 PR #64892、#64895 在该 main 上无冲突重放并通过 `42/42` 合并回归；其余四个官方 PR 直接从该 main 创建。Kit 固定 `735e943fe8d9d58ca007677a56dbad35a3e8d329`，Guardrails 固定 `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba`。

T4R 已把 H1 发布为 Hermes `0.18.2`：目标镜像摘要 `sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d`，`StartedAt=2026-07-15T13:11:21.295530766Z`、`RestartCount=0`，本地端口 `8651/9131` 均连通，启动错误计数为 `0`。发布前 data 与 dbstore 备份位于 `/Users/cicada/hermes-docker/hermes-1/backups/t4r-20260715210716`，旧镜像仍保留用于回滚；没有部署 H3、没有发送真实平台消息。A16 已 `PASS`。

T5 已完成删除前资产治理：旧 docs `603 = migrate 13 + archive 567 + discard 23`，旧 Hermes dirty `56 = migrate 20 + archive 36`，旧顶层真实为 `19` 项；私有运行资产固定在本地提交 `2d5e155f4c393d3e9389ba2a1cd7066dac5b00b5`。当前无 `defer`，但独立最终复核和旧根实际删除尚未完成，因此 A14 仍未通过。
