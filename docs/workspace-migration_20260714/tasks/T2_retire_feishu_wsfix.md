---
status: current
applies_when: "归档并退役旧 hermes-agent-feishu-wsfix worktree"
not_for: "修复当前 DingTalk 连接；调整 Mac 睡眠配置；删除其他 Hermes worktree"
current_authority: task-current
supersedes: []
superseded_by: []
---

# T2 退役 Feishu wsfix

## 目标

把旧 Feishu wsfix 的独有源码差异做成可恢复归档，再安全移除该 worktree。

## 当前证据

- worktree：`/Users/cicada/SourceCode/openclaw-harmes/hermes-agent-feishu-wsfix`
- 分支：`fix/feishu-ws-reconnect-lark-169`
- 基线提交：`c2b7669ad3dd02232d06cde36f6e56ef04dec970`
- 当前修改：`gateway/config.py`、`gateway/platforms/base.py`、`gateway/platforms/feishu.py`、`pyproject.toml`、两个测试和 `uv.lock`，共 7 个 tracked 文件。
- 当前系统证据：33 号机器两类防睡眠 assertion 均为 1，`caffeinate -is` 正在运行。

## 实施

1. 重新记录分支、HEAD、remote、status 和 diff stat。
2. 写入 `/Users/cicada/Desktop/openclaw-hermes-retired-20260714/feishu-wsfix/`：`README.md`、binary patch、状态清单、提交信息、SHA256。
3. 在同一基线的临时干净树执行 `git apply --check`。
4. 确认无未跟踪独有文件；若出现，先纳入归档并重新校验。
5. 使用 Git worktree 正常移除并 prune；不删除主仓库或其他分支。

## 执行方式

- 主 Agent 独占归档写入和 worktree 移除。
- 归档生成后、删除前启动 1 个只读 subagent，独立核对修改文件数、未跟踪文件、patch SHA256 和 `git apply --check`。
- subagent 不编辑归档、不执行 worktree remove、不派生其他 Agent；主 Agent 根据复核证据作最终删除决定。

## 验收与停止

- A07 PASS 后才能移除。
- patch 无法应用、校验值不一致或出现未分类资产时立即停止。

## 当前状态

`PASS`（2026-07-14 15:22 +08）：

- 桌面归档：`/Users/cicada/Desktop/openclaw-hermes-retired-20260714/feishu-wsfix/`
- patch SHA256：`2c304955c3c26fc449dd9613161537cb94271db73536f97b6539adcdded4dd08`
- `git apply --check`：PASS；应用后源文件字节比较：7/7 PASS。
- 独立复核：[R1_t2_archive_verification.md](../reviews/R1_t2_archive_verification.md)，`CLEARED`。
- 原 worktree 路径和登记均已移除；分支 `fix/feishu-ws-reconnect-lark-169` 仍保留在 `c2b7669ad3dd...`。
- H1/H3 镜像与启动时间未变化；两类防睡眠 assertion 仍为 1。
