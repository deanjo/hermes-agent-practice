---
status: current
applies_when: "核对 T5 是否已完成旧资产分类、可恢复归档、旧根删除和删除后零漂移，并判断 A14"
not_for: "清理 H1 远程 data；部署或重启 H1/H3；实现归档中的历史源码；发送真实平台消息"
current_authority: acceptance-current
supersedes: []
superseded_by: []
gate: t5-legacy-cleanup-verification
round: 1
reviewer: t5_old_hermes_dirty
rollup: CLEARED
scope: "A14 旧根删除门与删除后验证；A15/A16 只做保持性复核"
---

# R5 T5 旧资产清仓复核

## Input Packet

- 任务：[T5_govern_docs_and_cleanup_legacy.md](../tasks/T5_govern_docs_and_cleanup_legacy.md)。
- 验收项：[A14-A16](../02_ACCEPTANCE_MATRIX.md)。
- Practice 删除前固定提交：`45b9a25a5cc1ae8520c892c3a1050e2590be3472`，已推送到 `origin/main`。
- 私有运行资产固定提交：`37322d411326c82698cb13f7e9904df178ccb8a7`，本地 Git、无 remote。
- 逐文件清单：`docs_inventory.tsv`、`legacy_hermes_dirty_inventory.tsv`、`root_inventory.tsv`；恢复说明位于 sibling 项目 `hermes-runtime-assets/manifests/T5_ASSET_MANIFEST.md`。

## 独立删除前复核

独立 reviewer 的最终结论为 `PRE_DELETE_PASS / Critical=0 / Important=0`：

| 检查 | 结果 |
|---|---|
| docs | `603 = migrate 13 + archive 567 + discard 23`，无 `defer`；tar 为 `603` 个普通文件与 `186` 个目录项，逐文件路径/大小/SHA256 `603/603` 一致，AppleDouble=`0` |
| 旧 Hermes dirty | `56 = migrate 20 + archive 36`；H3 插件与测试 `20/20` SHA 一致；26 个 tracked archive 文件由 main patch 覆盖且 apply check 通过，10 个 untracked archive 文件在 tar 中逐项一致 |
| Git 恢复 | main/Product/T5v 的 `25/8/5` 个提交在临时 clone 中恢复为相同 tree；T21 工作树补丁检查通过 |
| 顶层 | 真实 `19` 项；两个带换行的异常空文件名以 Base64 路径字节登记，没有按行误计为 26 |
| 双副本 | 主归档 docs SHA256=`a632845fe3c8fe3a7918201fe1e2314bc40d407c63fd1ce6d1c688dcfddf723b`；第二副本 26 文件，根 `SHA256SUMS` 对其余 25 文件 `25/25 OK`，与主 private archive `diff=0`；Git bundle 完整固定 `37322d41...` |
| Git 与 GitHub | Practice 21 份 docs/4 目录元信息、README、链接均 0 异常；8 个 PR 均 OPEN；Practice 与 Guardrails 均为 `PUBLIC / main / MIT` |
| 运行态 | H1 `b67a60b3... / StartedAt=2026-07-15T13:11:21.295530766Z / RestartCount=0`；H3 `884a722f... / StartedAt=2026-07-15T09:11:33.186856916Z / RestartCount=0` |

reviewer 曾发现两项 Important，均在删除前关闭：macOS tar 的 `._*` 元数据已通过 `COPYFILE_DISABLE=1` 重打包清零；私有归档单副本已通过 `~/Documents/Codex/archives/openclaw-harmes-t5-20260715/` 第二副本与完整 Git bundle 消除。

## 删除后复核

主 Agent 在 `PRE_DELETE_PASS` 后删除精确路径 `/Users/cicada/SourceCode/openclaw-harmes`，结果：

- 路径不存在；删除前占用 `2,076,904 KiB`。
- 主 docs 归档 SHA256 仍为 `a632845f...723b`；第二副本根校验仍为 `25/25 OK`。
- H1/H3 的 image ID、StartedAt、RestartCount 与删除前逐字一致。
- 新 OpenClaw、Hermes source、Practice、Guardrails、runtime-assets 五个仓库工作树状态均为 `0`。
- Codex trusted project 已从旧根切换到 `/Users/cicada/SourceCode/openclaw-hermes-workspace`。

## 判定

`CLEARED`：T5 分类无 `defer`，恢复材料有双副本且实测可恢复，A15/A16 保持 `PASS`，独立删除门为 `PRE_DELETE_PASS`，删除后旧路径消失且运行态零漂移。A14=`PASS`；A01-A16 全部收口。

本复核没有清理 H1 data、部署或重启 H1/H3、发送真实消息、操作业务仓或把历史源码合并进当前 Release。
