---
status: current
applies_when: "从 hermes-agent-practice 查找当前执行计划、运维知识、集成经验、上游补丁或历史事故"
not_for: "直接判断远程 H1/H3 当前状态；把导航摘要当成部署配置；查阅 Hermes/OpenClaw 全量源码"
current_authority: router-current
supersedes: []
superseded_by: []
---

# 文档导航

本文件只负责导航。文档中的运行状态都是带时间的证据快照，不会随远程实例自动更新。

## 当前入口

| 入口 | 状态 | 作用 |
|---|---|---|
| [workspace-migration_20260714/README.md](workspace-migration_20260714/README.md) | current | 本次工作区治理的导航入口 |
| [workspace-migration_20260714/00_ROADMAP.md](workspace-migration_20260714/00_ROADMAP.md) | current | 目标、顺序、停止条件和阶段状态 |
| [../CONTRIBUTING_DOCS.md](../CONTRIBUTING_DOCS.md) | current | 文档目录、frontmatter 和迁移规范 |

## 加载顺序

1. 先读最近的 `README.md`，只发现候选文档。
2. 再读候选文件的 frontmatter，先处理 `superseded_by`，再判断 `status`、`not_for` 和 `applies_when`。
3. 只有匹配当前任务的 `*-current` 文档能主导执行。
4. `archive`、`superseded` 默认不加载正文；需要历史证据时只读相关章节。
5. 判断远程行为时重新运行对应实例的只读检查，不引用本地文档作 live 证明。

## 计划中的分类

`operations/`、`integrations/`、`upstream/`、`incidents/`、`projects/` 和 `archive/` 将在相关旧资产实际迁入时创建；第一阶段不创建空目录。
