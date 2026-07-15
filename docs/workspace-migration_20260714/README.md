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

`T3_PASS / T4_GOAL_ACTIVE / BASELINE_REFRESH`。A01-A10 已通过；T3 的仓库与迁移证据仍有效。T4 因官方 Hermes 从 `226e8de` 前进到 `569b912`，先刷新 fork 和复现，再实现 T21、Product Confirmation 与 T5v；A11-A13、A15 尚未通过。T4R 仍因没有单独 H1 部署授权而 BLOCKED。
