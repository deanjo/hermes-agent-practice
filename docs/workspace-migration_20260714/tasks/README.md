---
status: current
applies_when: "为 workspace migration 选择当前唯一可执行任务分片"
not_for: "同时启动全部任务；替代 Roadmap 决定执行顺序；把未开始任务写成完成"
current_authority: router-current
supersedes: []
superseded_by: []
---

# Tasks 导航

任务必须按顺序执行；当前只加载一个任务文件。

| 顺序 | 任务 | 状态 |
|---|---|---|
| T1 | [Workspace and repo layout](T1_workspace_and_repo_layout.md) | `PASS / USER_ACCEPTED_20260714` |
| T2 | [Retire Feishu wsfix](T2_retire_feishu_wsfix.md) | `PASS` |
| T3 | [Refresh upstream and migrate projects](T3_refresh_upstream_and_migrate_projects.md) | `PASS / REVIEW_CLEARED_20260714` |
| T4 | [Extract core and plugins](T4_extract_core_and_plugins.md) | `GOAL_ACTIVE / BASELINE_REFRESH` |
| T4R | [Release fixed versions to H1](T4R_release_to_h1.md) | `BLOCKED / REQUIRES_EXPLICIT_DEPLOY_AUTHORIZATION` |
| T5 | [Govern docs and clean legacy](T5_govern_docs_and_cleanup_legacy.md) | `NOT_STARTED` |

进入下一任务前，先在验收矩阵中完成上一任务对应行。
