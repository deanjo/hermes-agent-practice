# Hermes Agent Practice

Hermes Agent Practice 用于公开沉淀 Hermes 的部署实践、上游补丁决策、DingTalk 集成经验和可复核的事故记录。

## 当前入口

| 文档 | 作用 |
|---|---|
| [CONTRIBUTING_DOCS.md](CONTRIBUTING_DOCS.md) | 新建、修改、迁移文档时必须遵守的规范 |
| [docs/README.md](docs/README.md) | 文档导航与加载规则 |
| [Workspace Migration Roadmap](docs/workspace-migration_20260714/00_ROADMAP.md) | 本次工作区治理的唯一当前路线图 |

## 当前状态

`T1-T5_PASS / RUNTIME_DEPLOYED_H1_20260715 / REVIEW_CLEARED_20260715`：A01-A16 全部通过。H1 已运行 Hermes `0.18.2` 镜像 `sha256:b67a60b...188d`；官方 6 个 PR、Kit 1 个 PR、Guardrails 1 个 PR 当前均为 OPEN。T5 已完成 `603` 个旧 docs、`56` 个旧 Hermes dirty 文件和顶层 `19` 项的逐项清单与双副本归档；旧目录已删除，独立复核见 [R5](docs/workspace-migration_20260714/reviews/R5_t5_legacy_cleanup_verification.md)。

## 非目标

- 不复制 Hermes 或 OpenClaw 全量源码到本项目。
- 不把远程 `.env`、凭据、session 内容或运行目录当成开源文档资产。
- 不用本地文档替代远程运行状态检查。
