# Hermes Agent Practice

Hermes Agent Practice 用于公开沉淀 Hermes 的部署实践、上游补丁决策、DingTalk 集成经验和可复核的事故记录。

## 当前入口

| 文档 | 作用 |
|---|---|
| [CONTRIBUTING_DOCS.md](CONTRIBUTING_DOCS.md) | 新建、修改、迁移文档时必须遵守的规范 |
| [docs/README.md](docs/README.md) | 文档导航与加载规则 |
| [Workspace Migration Roadmap](docs/workspace-migration_20260714/00_ROADMAP.md) | 本次工作区治理的唯一当前路线图 |

## 当前状态

`T4_PASS / SOURCE_COMPLETE / RELEASE_READY_SCOPED`：A01-A13、A15 已通过；Hermes 本地、fork main 与执行时官方均为 `569b912d7d09...`。T21、Product Confirmation、T5v 已形成四个固定提交和四个 PR；Product 只在 `--plugins-only` 路径达到发布就绪，默认 legacy compat 仍为 `ADAPT_REQUIRED`。T4R 因没有 H1 部署授权和安装模式选择而 `BLOCKED`；A14、A16 未通过，旧目录继续保留。

## 非目标

- 不复制 Hermes 或 OpenClaw 全量源码到本项目。
- 不把远程 `.env`、凭据、session 内容或运行目录当成开源文档资产。
- 不用本地文档替代远程运行状态检查。
