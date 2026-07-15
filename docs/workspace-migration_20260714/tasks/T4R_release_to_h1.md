---
status: current
applies_when: "A11-A13 与 A15 已 PASS，并且用户明确授权把固定版本构建、部署或重启到 H1"
not_for: "T4 本地实现；未提交源码；直接编辑运行容器；部署 H3；发送真实 DingTalk/Feishu 消息"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T4R 受控发布到 H1

## 当前状态

`BLOCKED / REQUIRES_EXPLICIT_DEPLOY_AUTHORIZATION`。T4 的“继续推进”只授权本地源码、测试、文档和 GitHub 流程；没有新的“部署 H1 / 允许重启”文字前，本任务不得执行远程写操作。

## 进入条件

1. A11、A12、A13、A15 全部 `PASS`，三路都至少达到 `RELEASE_READY`。
2. 发布清单固定 `upstream_sha / fork_sha / kit_sha / guardrails_sha / base_image_digest`。
3. 每个旧补丁已按 [源码、发布与官方升级原则](../04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) 给出升级结论。
4. H1 的 image、StartedAt、RestartCount、关键文件哈希与开始发布前的只读基线一致；不一致先归因。
5. 用户明确授权本次构建、部署和所需重启；授权必须指明 H1，不从 T4 实现授权推断。

## 发布顺序

1. 在固定官方基线构建候选镜像，写入四个源码完整 SHA 与 base image digest。
2. 用精确 Kit Git archive（Git 归档）运行标准安装器；插件目录可由 Kit 原子替换，Hermes 核心只允许最小兼容 patcher。
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
- 候选镜像测试失败、回滚材料不完整、H1 发生未归因变化。
- 需要部署 H3、发送真实消息或执行业务仓操作；这些都不在本任务授权内。

## 验收

A16 只有在固定版本、安装验证、H1 运行证据和回滚证据齐全后才能 `PASS`；仅完成构建或本地测试时保持 `BLOCKED / INSUFFICIENT_EVIDENCE`。
