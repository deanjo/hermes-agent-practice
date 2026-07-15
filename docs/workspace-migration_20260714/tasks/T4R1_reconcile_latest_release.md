---
status: current
applies_when: "T4 源码已在 main 快照收口，但 H1 发布必须改以最新稳定官方 Release 为底座"
not_for: "直接切换或重启 H1；发送真实 DingTalk/Feishu 消息；把旧镜像文件当源码"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T4R1 最新稳定 Release 对账与回移

## 当前状态

`PASS / RELEASE_RECONCILED_20260715`。H1 运行底座已固定为最新稳定 Release，全部运行差异已回到 fork 提交；Product 固定使用 `--plugins-only`。本任务只完成对账、实现和候选验收，最终远程写由 [T4R](T4R_release_to_h1.md) 串行执行。

## 已冻结双基线

| 用途 | 冻结值 | 证据 |
|---|---|---|
| H1 运行底座 | `v2026.7.7.2^{}` = `9de9c25f620ff7f1ce0fd5457d596052d5159596` | GitHub latest Release 为 `draft=false / prerelease=false`；`git ls-remote` 的 tag 解引用结果一致 |
| 官方 PR 复核 | `upstream/main=9df5f879b4a5925c0f8f947e7e16ed8e845932c3` | 2026-07-15 `git fetch upstream main` 后本地与 `git ls-remote` 一致 |
| 原 T4 源码快照 | `569b912d7d0931c7256e9f5fb326609e9deda377` | [R3](../reviews/R3_t4_source_release_verification.md)；比 Release 多 685 个提交 |

任何候选切换前都要重新查询 latest Release；若不再是 `v2026.7.7.2`，停止并在新 Release 上重跑本任务，不能沿用“当时最新”的称呼。

## 实际对账结果

| 能力 | Release 运行线 | 当前 main 贡献线 | 双线结论 |
|---|---|---|---|
| T21 session search | `10ae3059a`，最终随 `62b304750762c69e7d4e611c5f2ec3ff296f58e6` 发布 | PR [#64892](https://github.com/NousResearch/hermes-agent/pull/64892) `fca44fd00b5c0575469c51e96ec5fa731d5c7222`；在 `9df5f879...` 无冲突，`15/15` | `LOCAL_REQUIRED / LOCAL_REQUIRED` |
| T5v 通用 halt | `3e96156ca`、`5eb5fdd0a` | PR [#64895](https://github.com/NousResearch/hermes-agent/pull/64895) `dd45532f563e72adcf0f605ff11ea441187232fc`；在 `9df5f879...` 无冲突，`27/27` | `LOCAL_REQUIRED / LOCAL_REQUIRED` |
| changed-only skill refresh | `9a2b21df4` | PR [#64971](https://github.com/NousResearch/hermes-agent/pull/64971) `ded7e6e2f0a8c950bc617205db1f81f63ebad875`；`78/78` | `LOCAL_REQUIRED / LOCAL_REQUIRED` |
| HANDOFF-GUARD + quotefix | `18f969caa`、`6d6c9c3d6` | PR [#64972](https://github.com/NousResearch/hermes-agent/pull/64972) `355366e938e44159ea5053d50f818a288fa31e96`；`47/47` | `LOCAL_REQUIRED / LOCAL_REQUIRED` |
| toolgate | `e36d50ab0` | PR [#64973](https://github.com/NousResearch/hermes-agent/pull/64973) `63f6c0444e83de0473dbe59eb8ba77f1420bda00`；`508/508` 目标测试通过 | `LOCAL_REQUIRED / LOCAL_REQUIRED` |
| delegate profile SOUL | `62b304750` | PR [#64975](https://github.com/NousResearch/hermes-agent/pull/64975) `c592e3d398f69de8d167d8881911f5b7c689b076`；`261/261` | `LOCAL_REQUIRED / LOCAL_REQUIRED` |

删除条件统一且只有一个：未来稳定 Release 在不带对应 fork 提交时通过同一回归测试，下一次升级才删除该回移；不能因为 main 已合并或 PR 已打开就提前从当前 H1 移除。

## 固定源码与候选证据

| 项目 | 完整固定值 | 验证 |
|---|---|---|
| Hermes 运行 fork | `62b304750762c69e7d4e611c5f2ec3ff296f58e6` | 从 Release SHA 建分支；12 份生产文件；重点回归 `103/103`、导入冒烟 `IMPORT_SMOKE_OK`；独立 review `CLEARED` |
| DingTalk Kit | `735e943fe8d9d58ca007677a56dbad35a3e8d329`；Git archive SHA256=`402facd79cb5f983527e69a4de0800faf89a467e82cec945a86dbd7714413be8` | PR [#1](https://github.com/deanjo/hermes-dingtalk-kit/pull/1)；`105/105`；候选 verifier `35/35`；二次安装无变化；gateway 三核心文件摘要不变 |
| Runtime Guardrails | `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba`；Git archive SHA256=`f8efda3032d254fcf1b95a1ef5c02106e983ca8e85bbdf28468f5d601602d77c` | PR [#1](https://github.com/deanjo/hermes-agent-runtime-guardrails/pull/1)；`48/48`；临时目录 install/verify/install 的 changed_count=`1/0/0` |

Release 组合回归曾得到 `577 passed / 15 failed`；15 项均为跨测试文件的 cwd 缓存顺序问题，对应两组单独运行分别为 `16/16`、`32/32`，所以没有把组合结果写成“全绿”。独立 reviewer 另跑 7 个重点文件 `103/103` 并给出 `CLEARED`。

## 目标

1. 从 Release tag 新建 fork 发布分支，所有 H1 核心差异都形成提交、测试和回滚清单；禁止把容器文件或旧 build context 整文件复制回来。
2. T21、T5v 以及 quotefix、toolgate、delegate、HANDOFF-GUARD 等旧能力，在 Release 与 main 上分别判定 `UPSTREAM_EQUIVALENT / LOCAL_REQUIRED / SPLIT_REQUIRED / ADAPT_REQUIRED`。
3. Release 需要而 main 已等价解决的能力只做带删除条件的运行回移；main 仍缺失的能力继续维护官方 PR。
4. Product/mention 只从 Kit 固定提交运行 `--plugins-only`；本任务不启用默认 legacy compat patcher，不覆盖 gateway 三核心文件。

## 并行边界

- 三个 subagent 可并行做只读对账：Release/提交图、旧四类补丁、H1 数据清理预检。
- 代码实现必须使用互相隔离的 worktree；两个任务若修改同一 Hermes 文件，主 Agent 串行整合。
- Kit、Guardrails 可与 Hermes 发布分支并行测试；H1 清理、快照、构建、切换和重启只由主 Agent 串行执行。

## 验收

1. Release tag、Release SHA、当前 main SHA、运行 fork SHA、PR fork SHA、Kit SHA、Guardrails SHA全部固定为完整值。
2. 每个旧补丁和 T4/T5v 缺口都有 Release/main 双结论、复现测试、变更文件与删除条件。
3. Release 发布分支工作树干净；候选镜像只从该提交构建；没有运行容器独有的未提交核心修改。
4. T21、Kit、T5v、Guardrails 的目标回归与安装幂等全部通过，再把控制权交给 T4R。

上述四项均已满足；三个目标工作树干净并已推送，T4R 接收的完整 SHA 与本节一致。

## 停止条件

- latest Release 在切换前变化，或 tag 解引用 SHA 与冻结值不一致。
- 任何能力只能靠旧整文件覆盖、无法写成 fork 最小提交，或对应回归测试无法在 Release 上运行。
- Product `--plugins-only` 要修改 Kit 自有插件目录之外的文件。
- H1 image、StartedAt、RestartCount、关键哈希或 data 在本任务外发生未归因变化。
