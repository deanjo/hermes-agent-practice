---
status: current
applies_when: "核对 T3 的 A08-A10、两个公开仓库和远程只读边界是否足以收口"
not_for: "证明 T21、Product Confirmation 或 T5v 已实现；授权删除旧 DingTalk Kit 或旧顶层；冻结持续更新的 OpenClaw 上游"
current_authority: acceptance-current
supersedes: []
superseded_by: []
gate: repository-migration-verification
round: 1
reviewer: t3_final_verifier
documentation_reviewer: t3_docs_final_audit
rollup: CLEARED
---

# R2 T3 仓库迁移独立复核

## Input Packet

- 任务：[T3_refresh_upstream_and_migrate_projects.md](../tasks/T3_refresh_upstream_and_migrate_projects.md)
- 验收行：[A08-A10](../02_ACCEPTANCE_MATRIX.md)
- Hermes：`/Users/cicada/SourceCode/openclaw-hermes-workspace/hermes-workspace/sources/hermes-agent`
- OpenClaw：`/Users/cicada/SourceCode/openclaw-hermes-workspace/openclaw-workspace/sources/openclaw`
- DingTalk Kit 新旧路径：`/Users/cicada/SourceCode/openclaw-hermes-workspace/hermes-workspace/projects/hermes-dingtalk-kit`、`/Users/cicada/SourceCode/hermes-dingtalk-kit`
- 公开项目：[Practice](https://github.com/deanjo/hermes-agent-practice)、[Runtime Guardrails](https://github.com/deanjo/hermes-agent-runtime-guardrails)

## Findings

```text
Critical=0
Important=0
Minor=0
Roll-up=CLEARED
```

补充文档审计同为 `CLEARED`：扫描 `15` 份 Markdown、`4` 个 docs 目录，frontmatter、README 数量、相对链接和 `git diff --check` 错误均为 `0`。

## A08 Hermes

- `origin=https://github.com/deanjo/hermes-agent.git`
- `upstream=https://github.com/NousResearch/hermes-agent.git`
- HEAD、本地 main、origin/main、upstream/main 与两个实时远端 main：`226e8de827a669e8ffa7035b27d70c19e44b1208`
- 工作树：clean

## A09 OpenClaw

- `origin=https://github.com/openclaw/openclaw.git`
- 分支：`main`
- 主 Agent 于 `2026-07-14 16:05:16 +08` 从官方 fetch 并 fast-forward 到 `202dea59bdf5d0bf3bb1b50424ee8a68af9efae8`
- 工作树：clean
- 复核期间官方 main 继续前进。A09 的权威条件是官方 origin 与干净独立 clone，不要求本地持续追平一个正在变化的远端。

## A10 DingTalk Kit

- 新旧分支：`feat/dingtalk-admin-private-send`
- 新旧 HEAD：`f4e781651df7606b4f7a7a8a43d49616775bc43e`
- 新旧状态：`1 modified + 16 untracked`
- 路径集合：一致
- 内容比较：`17/17 PASS`
- manifest 算法：每行 `SHA256  相对路径`，按路径排序并保留末尾换行
- 新旧 manifest SHA256：`c7ee88bac561904f7a4e87aecee5c67c531a176e448ea3fd91b27b476fc22eb6`
- 旧目录：保留，未删除

## 公开仓库

| 仓库 | 复核时本地与远端提交 | GitHub 状态 |
|---|---|---|
| `deanjo/hermes-agent-practice` | `2c5f0eec6a58d25239aec373348865ad07994c4d` | `PUBLIC / main / MIT` |
| `deanjo/hermes-agent-runtime-guardrails` | `461a171379bad488a577289c7dbf6560b3f40951` | `PUBLIC / main / MIT` |

Runtime Guardrails 只有 README、LICENSE 与 `.gitignore`，README 标记 `SCAFFOLD_ONLY`；这不是 T5v 实现完成的证据。

## 远程只读边界

T2 结束基线中的 H1 为 `pc-b8200e4ba-20260714`，启动时间 `2026-07-14T04:04:57.139661091Z`。T3 复核时 H1 为 `pc-quotefix-20260714`，启动时间 `2026-07-14T07:24:06.232398379Z`，因此首次检查按 Roadmap 暂停。

后续只读证据形成同一条部署链：

1. `/Users/cicada/SourceCode/openclaw-harmes/docs/hermes1-agong-dev-loop_20260707/reports/incident_design_hallucination_rca_20260714.md:12` 明确记录 quotefix 当日已部署。
2. `/Users/cicada/SourceCode/openclaw-harmes/docs/hermes-image-patches-knowledge/README.md:72` 记录相同镜像、build context 与回滚项。
3. 远端 `compose.yml` 修改时间为 `2026-07-14T15:24:04+0800`，image 行指向同一 quotefix 镜像。
4. Docker 生命周期事件连续显示旧 pc 镜像容器 `die/destroy`、新 quotefix 镜像容器 `start`；当前容器的 image 与 StartedAt 精确对应。

这证明 H1 变化来自 T3 之外的已记录部署；不证明 Docker 事件可以识别具体操作人。T3 没有执行远程部署、重启或文件修改。H3 仍为 `...t11-20260707210056`，启动时间仍为 `2026-07-08T09:10:16.506671846Z`。

## Verdict

`CLEARED`。A08-A10 和两个公开仓库满足 T3 contract；远程变化已按停止条件暂停并完成外部归因。旧 DingTalk Kit 与旧顶层继续保留，T4 未开始。
