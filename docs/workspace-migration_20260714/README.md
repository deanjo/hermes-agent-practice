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

`T3_PASS / T4_PASS / SOURCE_COMPLETE / RELEASE_READY_SCOPED`。A01-A13、A15 已通过；四个固定提交、四个 PR、测试和独立复核见 [R3](reviews/R3_t4_source_release_verification.md)。Product 的发布范围只包含 `--plugins-only`；默认 legacy compat 仍需适配。T4R 因没有单独 H1 部署授权和安装模式选择而 `BLOCKED`；T5 未开始，A14、A16 未通过。
