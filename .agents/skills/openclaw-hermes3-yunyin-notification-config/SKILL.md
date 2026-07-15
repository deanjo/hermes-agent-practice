---
name: OpenClaw Hermes-3 云隐官通知配置
description: 管理 Hermes-3 / 云隐官通知闭环的运行时配置。作为云隐官通知配置 entry skill，主导通过受控工具维护新帖广播目标群、通知轮询开关和轮询间隔；不用于部署、重启、改远程 config.yaml、真实发帖、真实群推或真实私聊验收。触发词：云隐官通知配置, 新帖广播群配置, 云隐官轮询时间, yunyin_manage_notification_config。
metadata:
  scope: project
  project: hermes-agent-practice
  role: entry
  risk: high
---

# OpenClaw Hermes-3 云隐官通知配置

> 角色：`entry`。主导云隐官通知闭环运行时配置，不替代 Hermes-3 runtime skill、部署流程或真实 E2E（端到端）验收。
> 操作目标：Hermes-3 / 云隐官 `yunyin_discourse` 插件的受控 SQLite 运行时配置表。
> 风险级别：`high`。任何写操作都必须先确认动作、目标群、轮询开关或间隔及影响范围。

## 使用边界

- 该用：用户要求通过云隐官对话维护新帖广播目标群、删除/停用广播群、查看通知配置、开启/关闭通知轮询或调整轮询时间。
- 不该用：远程部署、重启容器、改 `/Users/cicada/hermes-docker/hermes-3/data/config.yaml`、读取 `.env`、真实发帖、真实群推、真实私聊验收。
- 不该用：普通社区发帖、搜索、回复、撤回等内容操作；这些继续走 `openclaw-hermes3-yunyin` 和 `yunyin_discourse` 既有工具。

## 前置条件

- 先读 `.agents/skills/openclaw-hermes3-yunyin/SKILL.md`。
- 运行时工具名：`yunyin_manage_notification_config`。
- 可变配置落在受控业务库，不直接改远程 `config.yaml`，因此修改群清单或轮询时间不需要重启。

## 主流程

1. 区分 `list_config`、`upsert_group`、`remove_group`、`set_loop`。
2. 写操作前复述低敏摘要：群名、动作、是否启用、轮询秒数；不回显原始 `openConversationId`、DingTalk userId、token、cookie、session 或 Authorization。
3. 调用 `yunyin_manage_notification_config`；`interval_seconds` 不得低于 60。
4. 结果只展示群名、hash、启用状态、轮询开关和间隔。
5. `商越官方群` 是硬排除项，不能成为有效广播目标。

## 确认与回滚

- 写操作前必须确认动作、群名、启用状态、轮询间隔和影响范围。
- 误加群用 `remove_group`；误开轮询用 `set_loop enabled=false`；误设间隔写回上一个确认值。
- 远程部署、重启、重建、改远程 config、真实群推、真实私聊、真实发帖仍需单独明确授权。
