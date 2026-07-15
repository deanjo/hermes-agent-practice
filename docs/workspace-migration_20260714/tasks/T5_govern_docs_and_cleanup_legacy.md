---
status: current
applies_when: "代码边界验收后迁移旧 docs、清理旧顶层杂项并决定是否删除旧目录"
not_for: "在未读元信息时全量加载旧 Markdown；把缓存当知识资产；绕过 defer 直接删除"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T5 Docs 治理与旧目录清仓

## 目标

把仍有价值的知识迁入 Practice，把代码和运行资产放回正确项目，并在证据完整后清理旧顶层。

## 三段治理

1. 规则先行：T1 已建立目录、README、frontmatter 和状态规范。
2. 随任务迁移：T2-T4 分别迁移 Feishu、T21、Product、T5v 的相关文档和证据。
3. 最后清仓：对剩余旧资产逐项记录 `migrate / merge / archive / discard / defer`。

## 已锁定的 `migrate` 清单

2026-07-15 只读存在性检查确认以下七组资产仍是升级、运行归因或 Product 行为的必要证据；T5 必须先高保真迁移，不能判为 `discard`：

1. `docs/hermes-image-patches-knowledge/` 整目录。
2. `docs/hermes1-agong-dev-loop_20260707/reports/n9_first_trial_and_fixes_20260714.md`。
3. `docs/hermes1-agong-dev-loop_20260707/reports/n10_mention_meta_and_handoff_guard_20260714.md`。
4. `docs/hermes1-agong-dev-loop_20260707/reports/n11_diagnosis_confabulation_rca_20260715.md`。
5. `docs/hermes1-agong-dev-loop_20260707/reports/incident_design_hallucination_rca_20260714.md`。
6. `docs/hermes1-agong-dev-loop_20260707/reports/t5pc_product_confirmation_rollout_package_20260714.md`。
7. `docs/hermes-vision-image-fix/` 整目录；其中 `02_vision-timeout-fallback-401_20260715.md:60-103` 解释 H1/H3 最新 data 层 restart 与尚未修复的上游 fallback 问题。

这些旧文档没有本项目的 YAML frontmatter，迁移时必须用 live 日志、Git 和远程只读结果复核，不得仅凭旧正文把它们升级为当前权威。

## 分类规则

- Markdown：先读 frontmatter；无有效元信息时用最近 README 和代码/日志核验权威性。被运行时直接加载的 `SKILL.md`、prompt（提示词）或插件说明属于功能资产，迁入对应源码项目，不能只按普通文档处理。
- JSON、图片和证据附件：只有被当前文档引用才迁入对应 `assets/`。
- Python、shell 和测试：归正确项目的 `scripts/` 或测试目录，不留在 docs。
- 低敏配置：记录所属实例、来源提交或镜像、字段说明和摘要后进入对应项目；凭据值、`.env` 和认证材料不入 Git。
- CSV 等实验结果：只有被当前结论引用且能说明列定义时迁入 `assets/`；否则归档或丢弃。
- SQLite、运行日志和 data 快照：不直接进 Git；需要保留时记录外部备份位置、时间和 SHA256 摘要。
- Docker build context（构建目录）与镜像补丁：源码回到正确仓库；Dockerfile、固定 SHA 和产物摘要进入发布记录；重复生成物不当作权威源码。
- 依赖目录：只保留 lockfile（锁定文件）、版本和重建步骤，不迁移 `site-packages`、缓存或二进制副本。
- `.pyc`、缓存、PID、日志、`.DS_Store` 和确认无引用的异常临时文件：记录清单后 `discard`。
- 无法证明用途或当前性：标 `defer`，保留旧路径。

## 执行方式

最多三个只读 subagent 按互斥来源目录分区盘点，分别交付 `migrate / merge / archive / discard / defer` 建议及文件锚点。主 Agent统一处理跨目录重复、权威冲突、目标 README 和实际移动；任何 subagent 都不得批量删除旧资产。

T5 只治理资产，不代跑 hermes-1 的业务工作：供应商 contact 投影层修复、bot 的 `merge_uat` 或部署申请、真实消息、以及 Kit PR 何时合入 main，均保持原负责人和单独授权边界。

## 当前进度（删除前）

- 旧 docs：`603 = migrate 13 + archive 567 + discard 23`；原件压缩包 `603/603` 逐文件 SHA256 复核通过。
- 旧 Hermes dirty：`56 = migrate 20 + archive 36`；H3 插件与测试 `20/20` 迁入本地私有运行资产项目。
- 旧顶层：真实 `19` 项；两个异常空文件名以 Base64 路径字节登记，没有被换行误计数。
- 恢复验证：main 25 个、Product 8 个、T5v 5 个提交在临时 clone 中 `3/3` 恢复到相同 tree；main/T21 工作树补丁对干净索引检查通过。
- 私有运行资产项目固定为 `37322d411326c82698cb13f7e9904df178ccb8a7`，无 GitHub remote；原始 tar/patch 被 Git 忽略。第二份只读副本位于 `/Users/cicada/Documents/Codex/archives/openclaw-harmes-t5-20260715/`，26 个文件全部验签，Git bundle 固定同一 HEAD。
- 当前无 `defer`，但独立删除前复核与旧根实际删除尚未完成，A14 继续为 `INSUFFICIENT_EVIDENCE`。

## 验收与删除门禁

- 每个迁移后的 docs 目录有唯一 `README.md`，所有 Markdown frontmatter 合规且链接有效。
- 新项目 Git 状态、测试、GitHub URL、八个当前 PR（官方 #64892、#64895、#64971、#64972、#64973、#64975；Kit #1；Guardrails #1）和归档清单完整。
- 结束时重新只读检查 H1/H3；本任务不得改变镜像和启动时间。
- A14 只有在分类表无 `defer`、A15 PASS、A16 PASS 或有证据判定 NOT_APPLICABLE、独立最终验收 PASS 后才能通过。
- A14 未通过时只报告剩余项，旧 `/Users/cicada/SourceCode/openclaw-harmes` 整体保留。
