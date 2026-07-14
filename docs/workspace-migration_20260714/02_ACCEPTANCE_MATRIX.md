---
status: current
applies_when: "判断工作区迁移各阶段是否可以收口、进入下一阶段或删除旧目录"
not_for: "用单元测试替代远程运行证明；没有证据时把项目写成完成；扩大具体 task 的范围"
current_authority: acceptance-current
supersedes: []
superseded_by: []
---

# 验收矩阵

状态只使用 `PASS / FAIL / BLOCKED / INSUFFICIENT_EVIDENCE / NOT_APPLICABLE`。没有命令、文件、测试或 GitHub 证据的项目不得写 `PASS`。

| ID | 验收项 | PASS 证据 | 当前状态 |
|---|---|---|---|
| A01 | 新顶层存在且不是 Git 仓库 | 目标目录存在；向上查找不命中该目录的 `.git` | `PASS` |
| A02 | OpenClaw 与 Hermes 一级目录分开 | 两个一级目录及 README 均存在 | `PASS` |
| A03 | Practice 第一阶段固定文档齐全 | Roadmap、baseline、matrix、gate、T1-T5 均存在 | `PASS` |
| A04 | 每个已创建 docs 目录有唯一 README | 目录枚举与 README 枚举一一对应 | `PASS` |
| A05 | 所有 `docs/**/*.md` frontmatter 合规 | 六个必填字段齐全，无状态/权威冲突 | `PASS` |
| A06 | 第一阶段没有提前 clone 或建 Git | `sources/` 无源码仓库；Practice 与父目录均无 `.git` | `PASS` |
| A07 | Feishu patch 已归档且可恢复 | 桌面归档 `working-tree.patch` SHA256 `2c304955...dd08`；`git apply --check` PASS；恢复内容 7/7 一致；[R1](reviews/R1_t2_archive_verification.md) `CLEARED`；原路径已移除 | `PASS` |
| A08 | Hermes fork 为执行时最新干净基线 | `origin=deanjo`、`upstream=NousResearch`；本地与两个实时远端 main 均为 `226e8de827a6...`；状态干净；[R2](reviews/R2_t3_repository_migration_verification.md) `CLEARED` | `PASS` |
| A09 | OpenClaw 官方源码已独立 clone | `origin=https://github.com/openclaw/openclaw.git`；main 在 `202dea59bdf5...` 上状态干净；远端后续前进不改变独立官方 clone 的验收语义；[R2](reviews/R2_t3_repository_migration_verification.md) `CLEARED` | `PASS` |
| A10 | DingTalk Kit 本地未提交资产完整迁入 | 新旧均为 `f4e781651df7...`、`1 modified + 16 untracked`；内容 `17/17 PASS`；双方 manifest SHA256 均为 `c7ee88ba...fc22eb6`；旧目录保留 | `PASS` |
| A11 | Product Confirmation 不改 Hermes 核心 | Kit 测试通过；Hermes core diff 为零 | `INSUFFICIENT_EVIDENCE` |
| A12 | T21 最小修复可向上游提交 | 三类回归通过；仅两份生产文件；官方 PR URL | `INSUFFICIENT_EVIDENCE` |
| A13 | T5v 插件职责完整 | 输出预算、多模态、失败归并、首次停止与兼容测试通过 | `INSUFFICIENT_EVIDENCE` |
| A14 | 旧目录可整体删除 | 所有资产有五分类结论，无 `defer`，独立最终验收 PASS | `INSUFFICIENT_EVIDENCE` |

## 一票否决

- A07、A10 任一内容校验失败，禁止移除对应旧资产。
- A08 不满足时，禁止在新 Hermes 上实现或提交 PR。
- A11 出现非零核心 diff，必须回到 Product hook 设计，不得以“先兼容”为由通过。
- A12 超过两个生产文件，必须重新证明必要性。
- A14 仍有 `defer` 或无最终验收记录，禁止删除旧顶层。
