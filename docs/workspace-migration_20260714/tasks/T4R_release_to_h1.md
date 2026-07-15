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

`BLOCKED / REQUIRES_EXPLICIT_DEPLOY_AUTHORIZATION_AND_INSTALL_MODE`。T4 的“继续推进”只授权本地源码、测试、文档和 GitHub 流程；没有新的“部署 H1 / 允许重启”文字前，本任务不得执行远程写操作。另一个门禁是 Product：`--plugins-only` 已可发布，默认 legacy compat 仍有两个 `ADAPT_REQUIRED` 锚点，发布前必须明确选择前者或先完成适配。

## 进入条件

1. A11、A12、A13、A15 全部 `PASS`；T21/T5v 达到 `RELEASE_READY`，Product 使用已验证的 `RELEASE_READY_PRODUCT_ONLY` 路径，或先完成 legacy compat 适配。
2. 发布清单固定 `upstream_sha / fork_sha / kit_sha / guardrails_sha / base_image_digest`。
3. 每个旧补丁已按 [源码、发布与官方升级原则](../04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) 给出升级结论。
4. H1 的 image、StartedAt、RestartCount、关键文件哈希与开始发布前的只读基线一致；不一致先归因。
5. 用户明确授权本次构建、部署和所需重启；授权必须指明 H1，不从 T4 实现授权推断。
6. Product 安装模式有书面结论：使用已验证的 `--plugins-only`，或先让 `run.reply_sentinel_constant`、`session.path_sensitive_validation` 在冻结 Hermes 上通过；禁止直接运行当前默认 legacy compat。

## 发布顺序

1. 在固定官方基线构建候选镜像，写入四个源码完整 SHA 与 base image digest。
2. 用精确 Kit Git archive（Git 归档）运行标准安装器；当前可用路径是 `--plugins-only` 原子替换 Kit 自有插件目录。只有两个 `ADAPT_REQUIRED` 锚点另行适配并通过验证后，才允许启用 legacy compat patcher。
3. 离线运行 Kit 安装后 verifier（验证器）、T21 回归、T5v 测试；再次运行安装器时 `changed_count=0`。
4. 用独立容器、独立端口和独立 data 副本做候选验证，不覆盖现役 H1。
5. 用户再次确认切换窗口后才更新 H1；记录新 image digest、StartedAt、RestartCount 和安装清单。
6. 只做不发送真实平台消息的本地/离线冒烟；真实 DingTalk 消息仍需另行授权。

## 回滚

- 回滚单位是“上一完整镜像 digest + 上一 Kit/Guardrails 提交 + data 备份”，不是散落的 `.bak` 文件。
- 发布前记录上一镜像 digest、容器参数和 data 备份摘要；任何启动或验证失败立即恢复完整上一版本。
- 回滚后重新记录 image、StartedAt、RestartCount 和关键文件哈希；不能只凭容器为 running（运行中）判断成功。

## 停止条件

- 官方 main、fork、Kit 或 Guardrails 在冻结后继续变化。
- 任一旧核心补丁无法归入四种升级结论，或必须整文件覆盖新 Hermes 核心。
- Kit 安装器要修改允许清单之外的核心文件，或二次执行仍产生变化。
- 未明确 Product 安装模式却准备运行默认安装器，或两个旧锚点仍不匹配。
- 候选镜像测试失败、回滚材料不完整、H1 发生未归因变化。
- 需要部署 H3、发送真实消息或执行业务仓操作；这些都不在本任务授权内。

## 验收

A16 只有在固定版本、安装验证、H1 运行证据和回滚证据齐全后才能 `PASS`；仅完成构建或本地测试时保持 `BLOCKED / INSUFFICIENT_EVIDENCE`。
