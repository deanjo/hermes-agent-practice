---
status: current
applies_when: "进入 2026-07-14 OpenClaw/Hermes 工作区迁移任务并选择应读取的计划分片"
not_for: "替代具体 task 的写集和测试；直接执行远程部署；作为旧 docs 全量内容索引"
current_authority: router-current
supersedes: []
superseded_by: []
---

# Workspace Migration 导航

## 必读顺序

1. [00_ROADMAP.md](00_ROADMAP.md)：目标、不可变决策、阶段顺序和停止条件。
2. [01_BASELINE_AND_DECISIONS.md](01_BASELINE_AND_DECISIONS.md)：已核验事实、未知项与最终边界。
3. [04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md](04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md)：源码权威、发布状态和官方升级取舍。
4. [tasks/README.md](tasks/README.md)：只选择当前阶段的任务文件。
5. [02_ACCEPTANCE_MATRIX.md](02_ACCEPTANCE_MATRIX.md)：逐项判断阶段是否完成。
6. [03_REVIEW_AND_COMPLETION_GATE.md](03_REVIEW_AND_COMPLETION_GATE.md)：审阅与最终收口规则。
7. [reviews/README.md](reviews/README.md)：独立复核记录导航。

## 当前阶段

`T3_PASS / T4_PASS / T4R1_PASS / T4R_PASS / RUNTIME_DEPLOYED_H1_20260715 / T5_PRE_DELETE_REVIEW`。H1 已从最新稳定 Release `v2026.7.7.2`（`9de9c25f620ff7f1ce0fd5457d596052d5159596`）受控发布为运行提交 `62b304750762c69e7d4e611c5f2ec3ff296f58e6`，当前镜像摘要为 `sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d`，`StartedAt=2026-07-15T13:11:21.295530766Z`、`RestartCount=0`。A01-A13、A15-A16 已通过；T5 分类与归档已收口，独立删除前复核尚未完成，所以 A14 仍为 `INSUFFICIENT_EVIDENCE`，旧目录继续保留。源码历史复核见 [R3](reviews/R3_t4_source_release_verification.md)，Release 对账与生产证据见 [T4R1](tasks/T4R1_reconcile_latest_release.md) 和 [T4R](tasks/T4R_release_to_h1.md)。
