---
name: openclaw-hermes3-yunyin
description: hermes-agent-practice 项目的 Hermes-3 / 云隐官远程实例事实与职责边界。作为 dependency skill，提供服务器连接信息、只读自检入口、产品职责和最小运维约束，不单独主导重建、重启、配置修改或真实发帖验收。触发词：hermes-3, hermer-3, hermers-3, 云隐官, Hermes-3 服务器, Hermes-3 职责。
metadata:
  scope: project
  project: hermes-agent-practice
  role: dependency
  risk: normal
---

# OpenClaw Hermes-3 云隐官

> 角色：`dependency`。只提供 Hermes-3 / 云隐官的实例事实、连接入口、职责边界和只读诊断入口；不替代部署、修复、E2E（端到端）验收等主任务。

## 使用边界

该用：
- 用户提到 `hermes-3`、`hermer-3`、`hermers-3` 或 `云隐官`，并询问服务器、容器、日志、职责、Discourse 发帖链路或 DingTalk 群聊行为。
- 需要先连接远程做只读事实核对。

不该用：
- 普通 OpenClaw 产品开发。
- 不涉及 Hermes-3 / 云隐官的 Discourse、DingTalk 或 Docker 问题。
- 需要修改远程配置、重建镜像、重启容器或触发真实发帖时，本 skill 只提供前置事实；执行前必须确认目标和影响范围。

## 最小流程

1. 读 `references/runtime.md` 获取服务器、路径、容器名和只读命令。
2. 读 `references/responsibility.md` 获取云隐官职责、边界和发帖链路。
3. 当前状态核对优先运行 `scripts/h3-readonly-check.sh`。
4. 回答中区分当前已验证事实、历史文档事实和假设，关键判断给文件行号、命令输出或日志锚点。

## 最小运维边界

- 禁止输出 `.env`、API key、token、cookie、session、Authorization header。
- 禁止整包覆盖远程 Hermes。
- 禁止用本地 `gateway/platforms/dingtalk.py` 覆盖远程 `/opt/hermes/plugins/platforms/dingtalk/adapter.py`。
- 禁止把 Hermes Kanban/worker 作为云隐官 V1 发帖主路径。
- 写操作、重启、重建、真实发帖都不属于本 dependency skill 的自动动作。
