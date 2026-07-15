# Hermes Agent Practice

Hermes Agent Practice 用于公开沉淀 Hermes 的部署实践、上游补丁决策、DingTalk 集成经验和可复核的事故记录。

## 当前入口

| 文档 | 作用 |
|---|---|
| [CONTRIBUTING_DOCS.md](CONTRIBUTING_DOCS.md) | 新建、修改、迁移文档时必须遵守的规范 |
| [docs/README.md](docs/README.md) | 文档导航与加载规则 |
| [Workspace Migration Roadmap](docs/workspace-migration_20260714/00_ROADMAP.md) | 本次工作区治理的唯一当前路线图 |

## 当前状态

`T4_GOAL_ACTIVE / BASELINE_REFRESH`：T1-T3 与 A01-A10 已完成。2026-07-15 16:37 CST，官方 Hermes `569b912` 比 fork `226e8de` 领先 157 个提交；当前先同步 fork，再并行实现 T21、Product Confirmation 和 T5v。T4 不部署或重启 H1/H3。

## 非目标

- 不复制 Hermes 或 OpenClaw 全量源码到本项目。
- 不把远程 `.env`、凭据、session 内容或运行目录当成开源文档资产。
- 不用本地文档替代远程运行状态检查。
