# Hermes-3 Runtime

## Current Remote Instance

- SSH: `cicada@192.168.88.33`
- Deploy dir: `/Users/cicada/hermes-docker/hermes-3`
- Container: `hermes-3`
- Data dir: `/Users/cicada/hermes-docker/hermes-3/data`
- Compose: `/Users/cicada/hermes-docker/hermes-3/compose.yml`
- Platform: DingTalk Stream Mode

2026-07-15 只读核对快照：

```text
status=running
image=hermes-agent:dingtalk-kit-h3-hermes-v0.18.0-t11-20260707210056
image_id=sha256:884a722f5e4461c3e4f1e898c56189a95a927d4dbc3989c49bb496b0cc6fdd68
started=2026-07-15T09:11:33.186856916Z
restart_count=0
```

镜像和启动时间会变化；回答“当前状态”前必须重跑 `scripts/h3-readonly-check.sh`，不能把本快照当永久事实。

## Read-Only Checks

```bash
/Users/cicada/SourceCode/openclaw-hermes-workspace/hermes-workspace/projects/hermes-agent-practice/.agents/skills/openclaw-hermes3-yunyin/scripts/h3-readonly-check.sh
```

## Write Boundary

不要读取或输出 `.env`、API key、token、cookie、session、Authorization header。

以下操作不属于本只读 skill：

- 重启或重建 `hermes-3`
- 修改远程 `config.yaml`、`SOUL.md` 或 `.env`
- 触发真实发帖或群消息验收
