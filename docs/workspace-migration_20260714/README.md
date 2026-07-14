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
3. [tasks/README.md](tasks/README.md)：只选择当前阶段的任务文件。
4. [02_ACCEPTANCE_MATRIX.md](02_ACCEPTANCE_MATRIX.md)：逐项判断阶段是否完成。
5. [03_REVIEW_AND_COMPLETION_GATE.md](03_REVIEW_AND_COMPLETION_GATE.md)：审阅与最终收口规则。
6. [reviews/README.md](reviews/README.md)：独立复核记录导航。

## 当前阶段

`T3_GOAL_ACTIVE`。A01-A07 已通过；当前只执行 T3 的仓库基线、clone、dirty 内容迁移和公开建仓，禁止提前进入 T4。
