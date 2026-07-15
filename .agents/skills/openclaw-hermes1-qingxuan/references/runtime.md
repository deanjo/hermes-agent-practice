# Hermes-1 Runtime

## Current Remote Instance

- SSH: `cicada@192.168.88.33`（本地 SSH 配置存在时可用 `rmini`）。
- Current topology: Docker container，不是 launchd 裸机进程。
- Deploy dir: `/Users/cicada/hermes-docker/hermes-1`
- Container: `hermes-1`
- Data dir: `/Users/cicada/hermes-docker/hermes-1/data`
- Container mount: `/Users/cicada/hermes-docker/hermes-1/data -> /opt/data`
- DB volume mount: `hermes-1_dbstore -> /opt/dbstore`
- API port: `127.0.0.1:8651 -> 8651/tcp`
- Dashboard port: `127.0.0.1:9131 -> 9119/tcp`

2026-07-15 只读核对快照：

```text
status=running
image=hermes-agent:dingtalk-kit-h1-v0.18.2-t4r-62b30475-735e943f
image_id=sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d
started=2026-07-15T13:11:21.295530766Z
restart_count=0
```

镜像和启动时间会变化；回答“当前状态”前必须重跑 `scripts/h1-readonly-check.sh`，不能把本快照当永久事实。

## Historical Native Process

旧文档提到 `com.cicada.hermes.h1`、`/Users/cicada/hermes-native/h1` 和端口 `9101`。这些都是历史入口，除非当前只读检查证明它们重新启用。

## Read-Only Checks

```bash
/Users/cicada/SourceCode/openclaw-hermes-workspace/hermes-workspace/projects/hermes-agent-practice/.agents/skills/openclaw-hermes1-qingxuan/scripts/h1-readonly-check.sh
```

## Write Boundary

不要读取或输出 `.env`、API key、token、cookie、session、Authorization header。

以下操作不属于本只读 skill：

- 重启或重建 `hermes-1`
- 修改远程 `config.yaml`、`SOUL.md` 或 `.env`
- 触发真实飞书/Lark 消息验收
