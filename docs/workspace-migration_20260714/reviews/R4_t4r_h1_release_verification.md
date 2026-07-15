---
status: current
applies_when: "核对 T4R 是否已把最新稳定 Release 的固定版本受控发布到 H1，并判断 A16"
not_for: "批准 T5 删除旧目录；部署 H3；发送真实 DingTalk/Feishu 消息；替代 R3 的源码历史复核"
current_authority: acceptance-current
supersedes: []
superseded_by: []
gate: t4r-h1-release-verification
round: 1
reviewer: h1_data_manifest_audit
rollup: CLEARED
scope: "A16 运行态与回滚材料；不包含 T5/A14"
---

# R4 T4R H1 生产发布复核

## Input Packet

- 任务：[T4R_release_to_h1.md](../tasks/T4R_release_to_h1.md)。
- 验收项：[A16](../02_ACCEPTANCE_MATRIX.md)。
- 运行底座：`v2026.7.7.2@9de9c25f620ff7f1ce0fd5457d596052d5159596`。
- 运行提交：Hermes `62b304750762c69e7d4e611c5f2ec3ff296f58e6`、Kit `735e943fe8d9d58ca007677a56dbad35a3e8d329`、Guardrails `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba`。

## 独立只读复核

独立 reviewer 截至 `2026-07-15T13:21:07Z` 的只读结果：

| 检查 | 结果 |
|---|---|
| H1 容器 | `running`；image ID=`sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d`；StartedAt=`2026-07-15T13:11:21.295530766Z`；RestartCount=`0` |
| 端口与挂载 | `8651/tcp -> 127.0.0.1:8651`、`9119/tcp -> 127.0.0.1:9131`；data 仍挂载到 `/opt/data`，dbstore 仍挂载到 `/opt/dbstore` |
| 镜像标签 | version=`v2026.7.7.2`；revision=`62b304750762c69e7d4e611c5f2ec3ff296f58e6`；Release SHA、官方底座摘要、Kit SHA、Guardrails SHA 六个必需键均存在并与 Input Packet 一致 |
| 回滚镜像 | 旧镜像 `sha256:f4c19e19a19c0d4fe159768b6fe0e55a69fee6041bf21b440db8f5151886400c` 及 `...mentionguard-20260714` tag 仍保留 |
| 备份 | `/Users/cicada/hermes-docker/hermes-1/backups/t4r-20260715210716` 存在，`7221236 KiB`，含 `compose.yml.before-t4r`、`data/`、`dbstore/` |
| H3 边界 | 仍为 `...h3-hermes-v0.18.0-t11-20260707210056`；StartedAt=`2026-07-15T09:11:33.186856916Z`；RestartCount=`0`，与发布前一致 |

## 发布脚本证据

切换脚本在失败时会恢复旧 compose、旧镜像和 Guardrails；本次正常完成，记录为：data 冻结后 rsync 差异 `0`，dbstore `61424 KiB / 10 files`，Kit verifier `35/35`，Guardrails install/verify/install changed_count=`1/0/0`，生产导入成功，端口 `2/2`，启动错误计数 `0`，`real_messages_sent=false`。旧 compose SHA256=`4c1c622b88dfef05d4df2267e31e95ac3dab51a2f4d10653eacd16e7794fed2e`。

独立 reviewer 没有重复运行 Kit verifier，因为它会创建临时目录；也没有重复执行 Guardrails verify/import、compose SHA 和 dbstore 文件计数。这些项目使用切换脚本的固定输出，不冒充第二次独立执行。

## 判定

`CLEARED`：A16 的固定版本、运行态、端口、镜像标签、完整 data/dbstore 备份和旧镜像回滚材料均存在，未发现 H1 发布后漂移或 H3 越界修改。A16=`PASS`；T5 未执行，所以 A14 仍为 `INSUFFICIENT_EVIDENCE`，旧目录不得删除。

本复核没有读取日志正文、输出 secret、写远程文件、发送真实消息或操作业务仓。
