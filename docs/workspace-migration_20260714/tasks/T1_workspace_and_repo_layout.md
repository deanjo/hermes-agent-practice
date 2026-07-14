---
status: current
applies_when: "执行或验收新工作区骨架、Practice 文档规则和第一阶段固定文档"
not_for: "clone 源码；创建 Git/GitHub 仓库；迁移旧资产；修改远程 H1/H3"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T1 工作区与文档规则

## 目标

只建立新工作区骨架和可供后续 Agent 直接执行的权威文档，不提前做任何源码或旧资产迁移。

## 写集

- `/Users/cicada/SourceCode/openclaw-hermes-workspace/README.md`
- `openclaw-workspace/` 的导航 README
- `hermes-workspace/` 的导航 README
- `projects/hermes-agent-practice/` 的 README、文档规范和迁移 Roadmap 分片

## 禁止

- 不执行 `git init`、`git clone`、`gh repo create`。
- 不删除或移动 `/Users/cicada/SourceCode/openclaw-harmes` 中的文件。
- 不修改 `/Users/cicada/SourceCode/hermes-dingtalk-kit`。
- 不对 H1/H3 做写操作、重启或真实消息验收。

## 验收

- A01-A06 全部 PASS。
- 新建的每个 docs 子目录都有唯一 `README.md`。
- frontmatter 六字段齐全，`current` 文档的 `superseded_by` 为空。
- `sources/` 只含 README，不含源码 clone。

## 当前状态

`PASS / USER_ACCEPTED_20260714`：A01-A06 已通过本地结构、frontmatter、链接和未修改旧环境检查，用户已确认进入 T2。
