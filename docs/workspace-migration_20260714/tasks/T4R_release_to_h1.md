---
status: current
applies_when: "A11-A13 与 A15 已 PASS，Product 安装模式已明确，并且用户明确授权把固定版本构建、部署或重启到 H1"
not_for: "T4 本地实现；未提交源码；直接编辑运行容器；部署 H3；发送真实 DingTalk/Feishu 消息"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T4R 受控发布到 H1

## 当前状态

`PASS / RUNTIME_DEPLOYED_H1_20260715`。2026-07-15 用户明确同意部署；[T4R1](T4R1_reconcile_latest_release.md) 完成后，H1 已从最新稳定官方 Release 受控切换并通过离线与运行检查。

已完成的独立维护项：H1 第一批缓存按三个绝对路径删除，删除前 `du` 合计 `617016 KiB`；正式 JDK/Maven 复测通过，镜像、StartedAt 与 RestartCount 均未变化。该清理不等于候选发布，也不能让 A16 提前 PASS，证据见 [B35](../01_BASELINE_AND_DECISIONS.md)。

## 固定发布清单

| 项目 | 固定值 |
|---|---|
| 官方 Release | `v2026.7.7.2`；解引用 SHA `9de9c25f620ff7f1ce0fd5457d596052d5159596`；产品版本 `0.18.2` |
| 当前 upstream/main | `9df5f879b4a5925c0f8f947e7e16ed8e845932c3` |
| runtime / Kit / Guardrails | `62b304750762c69e7d4e611c5f2ec3ff296f58e6` / `735e943fe8d9d58ca007677a56dbad35a3e8d329` / `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba` |
| 官方底座镜像 | `sha256:9c841866021c54c4596849f6135717e8a4d52ba510b7f52c50aef1de1a283973` |
| 发布前旧镜像 | `sha256:f4c19e19a19c0d4fe159768b6fe0e55a69fee6041bf21b440db8f5151886400c` |
| 当前目标镜像 | `sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d` |

目标镜像使用官方 Release 镜像作底座，再从 runtime Git 归档叠加 12 份已提交生产文件；`pyproject.toml`、`uv.lock`、`package.json`、`package-lock.json` 与官方 Release 均为零差异。Kit 在镜像构建时运行仓库内标准安装器 `--plugins-only`；Guardrails 在切换窗口由仓库安装器写入 data。整个过程没有直接编辑运行容器中的 Hermes 或 DingTalk 源文件。

## 发布与验收结果

- 候选：Hermes `0.18.2`、runtime SHA 正确、导入冒烟通过；Kit verifier `35/35` 且二次安装无变化；Guardrails `48/48`、安装幂等和候选导入通过。
- 快照：`/Users/cicada/hermes-docker/hermes-1/backups/t4r-20260715210716`；冻结后 data rsync 差异计数 `0`，dbstore `61424 KiB / 10 files`；旧 compose SHA256=`4c1c622b88dfef05d4df2267e31e95ac3dab51a2f4d10653eacd16e7794fed2e`。
- 安装：Guardrails install/verify/install 的 changed_count=`1/0/0`，digest=`1bd276c76b6ef6a890aded6b311efecf13092acdf166b6977078a1fc0aca19d7`；Kit 生产 verifier `35/35`。
- 运行：H1 `status=running`，image=`hermes-agent:dingtalk-kit-h1-v0.18.2-t4r-62b30475-735e943f`，`StartedAt=2026-07-15T13:11:21.295530766Z`、`RestartCount=0`；版本 `0.18.2`，runtime SHA 正确，`127.0.0.1:8651/9131` 两个端口均连通，启动错误计数 `0`。
- 边界：H3 的镜像、启动时间和重启次数与切换前一致；没有发送真实 DingTalk/Feishu 消息，没有执行业务仓操作，没有删除旧目录。

## 进入条件

1. A11、A12、A13、A15 全部 `PASS`；T21/T5v 达到 `RELEASE_READY`，Product 使用已验证的 `RELEASE_READY_PRODUCT_ONLY` 路径，或先完成 legacy compat 适配。
2. 发布清单固定 `release_tag / release_sha / upstream_main_sha / runtime_fork_sha / pr_fork_sha / kit_sha / guardrails_sha / base_image_digest`。
3. 每个旧补丁已按 [源码、发布与官方升级原则](../04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) 给出升级结论。
4. H1 的 image、StartedAt、RestartCount、关键文件哈希与开始发布前的只读基线一致；不一致先归因。
5. [T4R1](T4R1_reconcile_latest_release.md) 全部验收通过，且切换前 latest Release 仍等于冻结 tag。
6. Product 固定使用已验证的 `--plugins-only`；禁止运行当前默认 legacy compat，也不等待两个旧锚点适配。

## 发布顺序

1. 从固定 Release tag 与 fork 发布提交构建候选镜像，写入双基线和各路源码完整 SHA 与 base image digest。
2. 用精确 Kit Git archive（Git 归档）运行标准安装器；当前可用路径是 `--plugins-only` 原子替换 Kit 自有插件目录。只有两个 `ADAPT_REQUIRED` 锚点另行适配并通过验证后，才允许启用 legacy compat patcher。
3. 离线运行 Kit 安装后 verifier（验证器）、T21 回归、T5v 测试；再次运行安装器时 `changed_count=0`。
4. 用独立容器、独立端口和独立 data 副本做候选验证，不覆盖现役 H1。
5. 候选全部通过后，按本次已获授权冻结 data 写入、做完整 data 副本与一致的 dbstore 快照，再更新 H1；记录新 image digest、StartedAt、RestartCount 和安装清单。
6. 只做不发送真实平台消息的本地/离线冒烟；真实 DingTalk 消息仍需另行授权。

## 回滚

- 回滚单位是“上一完整镜像 digest + 上一 Kit/Guardrails 提交 + data 备份”，不是散落的 `.bak` 文件。
- 发布前记录上一镜像 digest、容器参数和 data 备份摘要；任何启动或验证失败立即恢复完整上一版本。
- 回滚后重新记录 image、StartedAt、RestartCount 和关键文件哈希；不能只凭容器为 running（运行中）判断成功。

## 停止条件

- latest Release 在切换前变化；冻结 tag 被移动；或 fork、Kit、Guardrails 的目标提交发生替换。
- 任一旧核心补丁无法归入四种升级结论，或必须整文件覆盖新 Hermes 核心。
- Kit 安装器要修改允许清单之外的核心文件，或二次执行仍产生变化。
- 未明确 Product 安装模式却准备运行默认安装器，或两个旧锚点仍不匹配。
- 候选镜像测试失败、回滚材料不完整、H1 发生未归因变化。
- 需要部署 H3、发送真实消息或执行业务仓操作；这些都不在本任务授权内。

## 验收

A16=`PASS`：固定版本、安装验证、H1 运行证据、完整 data/dbstore 快照和旧镜像回滚材料均已齐全；独立复核记录见 [R4](../reviews/R4_t4r_h1_release_verification.md)。
