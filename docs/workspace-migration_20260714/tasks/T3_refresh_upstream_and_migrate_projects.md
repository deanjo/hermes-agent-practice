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

`IN_PROGRESS / GOAL_ACTIVE`（2026-07-14）：T2 已通过 A07；当前先由三个只读 subagent 核对源码远端、DingTalk Kit dirty manifest 和公开建仓条件，所有 clone、remote、迁移和 GitHub 写操作由主 Agent 串行执行。
