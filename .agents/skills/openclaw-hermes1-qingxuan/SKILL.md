---
name: openclaw-hermes1-qingxuan
description: hermes-agent-practice 项目的 Hermes-1 / 青玄 Docker 实例事实与职责边界。作为 dependency skill，提供服务器连接信息、只读自检入口、项目协同职责和最小运维约束，不单独主导重建、重启、配置修改或真实飞书消息验收；不用于 Hermes-3 / 云隐官 / DingTalk 职责问题。触发词：hermes-1, Hermes-1, h1, 青玄, 青玄项目协同, Hermes-1 服务器, Hermes-1 职责。
metadata:
  scope: project
  project: hermes-agent-practice
  role: dependency
  risk: normal
---

# OpenClaw Hermes-1 青玄

> 角色：`dependency`。只提供 Hermes-1 / 青玄的实例事实、连接入口、职责边界和只读诊断入口；不替代部署、修复、E2E（端到端）验收等主任务。

## 使用边界

该用：
- 用户提到 `hermes-1`、`Hermes-1`、`h1`、`青玄` 或 `青玄项目协同`，并询问服务器、容器、日志、职责、飞书/Lark 行为或项目协同入口。
- 需要先连接远程做只读事实核对。

不该用：
- Hermes-3 / 云隐官 / DingTalk / Discourse 社区运营问题；这类问题用 `openclaw-hermes3-yunyin`。
- 普通 OpenClaw 产品开发。
- 需要修改远程配置、重建镜像、重启容器或触发真实飞书消息时，本 skill 只提供前置事实；执行前必须确认目标和影响范围。

## 最小流程

1. 读 `references/runtime.md` 获取服务器、Docker 容器、路径、端口和只读命令。
2. 读 `references/responsibility.md` 获取青玄职责、边界和与 Hermes-3 / 云隐官的区别。
3. 当前状态核对优先运行 `scripts/h1-readonly-check.sh`。
4. 回答中区分当前已验证事实、历史文档事实和假设，关键判断给文件行号、命令输出或日志锚点。
5. 旧裸机 `com.cicada.hermes.h1` / `/Users/cicada/hermes-native/h1` 已不是当前入口；不要用 launchd 命令判断当前 Hermes-1 状态。

## 最小运维边界

- 禁止输出 `.env`、API key、token、cookie、session、Authorization header。
- 禁止整包覆盖远程 Hermes。
- 禁止把 `/Users/cicada/openclaw-harmes-deploy` 的 `clawh-hermes-1` 当成当前 Hermes-1 入口，除非当前 `docker inspect` 明确证实。
- 写操作、重启、重建、真实飞书消息验收都不属于本 dependency skill 的自动动作。

当主任务明确要求远程写操作时，先确认目标、影响范围、回滚点和验收标准；本 skill 本身仍只提供事实与只读入口。
