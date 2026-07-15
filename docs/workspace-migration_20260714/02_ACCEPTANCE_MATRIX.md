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
| A08 | T3 在验收时使用最新干净 Hermes 基线 | T3 验收时 `origin=deanjo`、`upstream=NousResearch`，本地与两个当时远端 main 均为 `226e8de827a6...`；[R2](reviews/R2_t3_repository_migration_verification.md) `CLEARED`；该 PASS 是历史快照，不替代 T4 重新冻结 | `PASS` |
| A09 | OpenClaw 官方源码已独立 clone | `origin=https://github.com/openclaw/openclaw.git`；main 在 `202dea59bdf5...` 上状态干净；远端后续前进不改变独立官方 clone 的验收语义；[R2](reviews/R2_t3_repository_migration_verification.md) `CLEARED` | `PASS` |
| A10 | DingTalk Kit 本地未提交资产完整迁入 | 新旧均为 `f4e781651df7...`、`1 modified + 16 untracked`；内容 `17/17 PASS`；双方 manifest SHA256 均为 `c7ee88ba...fc22eb6`；旧目录保留 | `PASS` |
| A11 | Product Confirmation 归 Kit 且不新增 Hermes 核心修改 | Kit `0e37e209cc6c...`、PR #1；`105 passed + 14 subtests`；完整 Hermes 上 `--plugins-only` verifier `35/35` 且二次安装无变化；Product/mention core diff=0；默认 legacy compat 两个锚点单列 `ADAPT_REQUIRED` 并验证回滚；[R3](reviews/R3_t4_source_release_verification.md) `CLEARED` | `PASS` |
| A12 | T21 在 T4 冻结的 main 快照上保持最小并可向上游提交 | upstream `569b912d7d09...`；fork `fca44fd00b5c...`；仅两份生产文件；边界回归 `15/15`；官方 PR #64892；[R3](reviews/R3_t4_source_release_verification.md) `CLEARED`；这是源码历史验收，不代表已适配稳定 Release | `PASS` |
| A13 | T5v 插件职责完整 | Guardrails `14c28d444427...`、`45/45`；通用 core `dd45532f563e...`、`27/27`；失败测试证明首次 halt 需要最多两份通用生产文件且代码无插件专名；安装/卸载/回滚幂等；PR #1 与官方 PR #64895；[R3](reviews/R3_t4_source_release_verification.md) `CLEARED` | `PASS` |
| A14 | 旧目录可整体删除 | 三张清单为 docs `603`、dirty `56`、顶层 `19`，无 `defer`；双副本与恢复测试通过；A15/A16 PASS；[R5](reviews/R5_t5_legacy_cleanup_verification.md) `CLEARED`；旧路径已不存在并释放 `2,076,904 KiB` | `PASS` |
| A15 | T4 三路源码和限定发布材料可追溯 | 四路源码完整 SHA、T4R1 后八个当前 PR（官方 6 + Kit 1 + Guardrails 1）、安装清单、兼容清单、回滚与独立 review 齐全；T21/T5v 达 `RELEASE_READY`，Product 达 `RELEASE_READY_PRODUCT_ONLY`；默认 Kit legacy compat 明确排除 | `PASS` |
| A16 | 最新稳定 Release 的固定版本已受控发布到 H1 | Release `v2026.7.7.2@9de9c25f620ff7f1ce0fd5457d596052d5159596`、runtime `62b304750762c69e7d4e611c5f2ec3ff296f58e6`、Kit `735e943fe8d9d58ca007677a56dbad35a3e8d329`、Guardrails `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba`；官方/目标镜像完整摘要见 [T4R](tasks/T4R_release_to_h1.md)；H1 `0.18.2`、StartedAt=`2026-07-15T13:11:21.295530766Z`、RestartCount=`0`、端口 `2/2`、Kit `35/35`、Guardrails verify/import、启动错误 `0`、data/dbstore 快照与旧镜像回滚均通过；[R4](reviews/R4_t4r_h1_release_verification.md) `CLEARED` | `PASS` |

## 一票否决

- A07、A10 任一内容校验失败，禁止移除对应旧资产。
- T4R 运行分支不是从执行时 latest Release 的解引用 SHA创建，或官方 PR 线没有复核当前 `upstream/main`，禁止实现或发布；不能拿 A08/A12 的历史 PASS 代替。
- A11 的 Product/mention 增量出现非零核心 diff，必须回到公开 hook 设计；Kit 既有 legacy compat 不能混入 Product 增量，需按 04 契约单独判定。
- A12 超过两个生产文件，必须重新证明必要性。
- A13 只有在最新版失败测试证明插件不能自行首次 halt 后才能修改 core；最多 `agent/tool_guardrails.py`、`run_agent.py` 两份通用生产文件，不得写插件专名或扩大成平台耦合。
- A15 缺任一源码 SHA、安装清单或回滚证据，不得把 T4 写成 `RELEASE_READY`；默认 Kit 安装仍命中两个缺失锚点时，只能写 `RELEASE_READY_PRODUCT_ONLY`。
- A16 只有 T4R1、候选、快照和运行证据全部齐全才可保持 `PASS`；任一证据回退时不得用本地测试替代。
- A14 仍有 `defer`、A15 未 PASS、A16 未处理或无最终验收记录，禁止删除旧顶层。
