---
status: current
applies_when: "T2 通过后建立 OpenClaw/Hermes 干净源码仓库，并迁入 DingTalk Kit 本地差异"
not_for: "实现 T21/Product/T5v；覆盖旧工作树；部署远程实例"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T3 建立干净源码与项目仓库

## 目标

建立可追踪上游的干净源码，并在不丢失本地未提交内容的前提下把 DingTalk Kit 放入新工作区。

## 实施

1. clone `deanjo/hermes-agent` 到 `hermes-workspace/sources/hermes-agent`。
2. 配置 `upstream=https://github.com/NousResearch/hermes-agent.git`，fetch 后仅允许 fast-forward 到执行时 `upstream/main`，再同步 fork main。
3. clone `openclaw/openclaw` 到 `openclaw-workspace/sources/openclaw`。
4. clone `deanjo/hermes-dingtalk-kit` 的当前分支到 `projects/hermes-dingtalk-kit`。
5. 将旧 Kit 的 tracked diff 和全部未跟踪文件迁入；用文件清单与 SHA256 对比新旧内容。
6. 创建公开 MIT 仓库 `deanjo/hermes-agent-practice` 与 `deanjo/hermes-agent-runtime-guardrails`，但不提前声明代码实现完成。

## 执行方式

主 Agent 串行执行全部 Git 与 GitHub 写操作。subagent 只能并行核对执行时 upstream SHA、OpenClaw remote、DingTalk Kit dirty 清单和迁移前后哈希，不得同时 clone 到目标路径或修改 remote。

## 验收与停止

- A08-A10 PASS。
- 新 Hermes 必须工作区干净，且 origin/upstream 角色正确。
- DingTalk Kit 任一内容哈希不一致时保留旧目录并停止。
- 不对旧 dirty Hermes main 执行 reset、checkout 或清理。

## 当前状态

`PASS / REVIEW_CLEARED_20260714`：

- Hermes 位于 `hermes-workspace/sources/hermes-agent`，`origin=deanjo/hermes-agent`、`upstream=NousResearch/hermes-agent`；本地与两个实时远端 main 均为 `226e8de827a669e8ffa7035b27d70c19e44b1208`，工作树干净。
- OpenClaw 位于 `openclaw-workspace/sources/openclaw`，`origin=openclaw/openclaw`；主 Agent 于 `16:05:16 +08` 从官方 fetch 并 fast-forward 到 `202dea59bdf5d0bf3bb1b50424ee8a68af9efae8`，工作树干净。官方 main 随后继续前进，这是 A09 之外的实时变化，不要求冻结上游。
- DingTalk Kit 新旧仓库均在 `feat/dingtalk-admin-private-send`、HEAD `f4e781651df7606b4f7a7a8a43d49616775bc43e`；双方均为 `1 modified + 16 untracked`，逐文件比较 `17/17 PASS`，manifest SHA256 均为 `c7ee88bac561904f7a4e87aecee5c67c531a176e448ea3fd91b27b476fc22eb6`。旧目录未删除。
- [hermes-agent-practice](https://github.com/deanjo/hermes-agent-practice) 与 [hermes-agent-runtime-guardrails](https://github.com/deanjo/hermes-agent-runtime-guardrails) 均为 `PUBLIC / main / MIT`；Runtime README 明确标记 `SCAFFOLD_ONLY`，没有提前声明 T5v 已实现。
- H1 在 T3 期间由外部已记录任务更新为 `pc-quotefix-20260714`。本任务先暂停，再以当前事故 RCA、补丁账本、远端 compose 修改时间与 Docker 事件完成归因；H3 镜像和启动时间不变。本任务没有部署、重启或修改 H1/H3。
- 独立验收记录：[R2_t3_repository_migration_verification.md](../reviews/R2_t3_repository_migration_verification.md)，结论 `CLEARED`，Critical=0、Important=0、Minor=0。
