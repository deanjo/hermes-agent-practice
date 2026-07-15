---
status: archive
applies_when: "核对 2026-07-15 H1 data 本次清理、保留、备份与恢复证据"
not_for: "判断 H1 当前 live 状态；授权继续删除；替代 T4R/R4 发布验收"
current_authority: historical-evidence
supersedes: []
superseded_by: []
---

# H1 data 清理与保留记录（2026-07-15）

## 结论

本次没有删除 H1 data。唯一超过 `100 MiB` 且名称明确的缓存候选是 `host-runner/yarn-cache`，但最终复核发现目标下仍有 `6,109` 条打开文件记录；按照“打开文件不为零就保留”的停止条件，本次将其记录为“待维护窗口清理”，不冒险删除。

这项保留不改变工作区迁移结论：T1-T5 及 T4R 已通过，A01-A16 仍全部为 `PASS`。H1 data 后续维护不属于 [R5](reviews/R5_t5_legacy_cleanup_verification.md) 的 A14 验收范围。

## 运行谱系

| 字段 | 本次证据 |
|---|---|
| `as_of` | `2026-07-15T22:54:27+08:00` |
| `target` | `H1/hermes-1`；宿主 data=`/Users/cicada/hermes-docker/hermes-1/data`，容器挂载=`/opt/data` |
| `source_commit` | Hermes `62b304750762c69e7d4e611c5f2ec3ff296f58e6`；Kit `735e943fe8d9d58ca007677a56dbad35a3e8d329`；Guardrails `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba` |
| `image_digest` | `sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d` |
| `data_layers` | data 总量 `7,170,916 KiB`；逐项处置见下表 |
| `verification` | H1=`running`；StartedAt=`2026-07-15T13:11:21.295530766Z`；RestartCount=`0`；缓存目标仍存在；保留目录与 T4R 备份检查均为 `PASS` |
| `rollback` | 本次未删除文件，不需要恢复；T4R 完整备份和新旧镜像均继续保留，见 [R4](reviews/R4_t4r_h1_release_verification.md) |
| `superseded_by` | `[]`；本文件是带时间的历史证据，不是当前 live 状态入口 |

## 清理候选与停止证据

精确候选路径：

`/Users/cicada/hermes-docker/hermes-1/data/host-runner/yarn-cache`

| 检查 | 结果 | 判定 |
|---|---:|---|
| 目录大小 | `2,437,696 KiB` | 逻辑上可回收约 `2.32 GiB` |
| 普通文件数 | `79,760` | Yarn v6 依赖缓存 |
| 打开文件记录 | `6,109` | 不满足删除门槛 |
| 打开者 | `com.apple.Virtualization.VirtualMachine`，PID `69250` | 与 Docker 文件共享层有关；是否仍被其他运行任务间接使用证据不足 |
| 容器状态 | `running`，RestartCount=`0` | 禁止为清缓存重启 H1 或 Docker |

远程 `host-runner/bin/hermes1-host-runner.sh` 第 19、26、28 行定义、导出并自动创建 `YARN_CACHE_FOLDER`，因此目录结构可重建；但本次没有验证依赖包源和网络是否可用，不能把“可重建目录”扩大成“现在删除一定无影响”。

两个独立只读复核出现不同判定：一份认为 `6,109` 条句柄全部来自虚拟化文件共享、业务进程句柄为零，可删除；另一份认为打开文件不为零且包源未验证，应保留。最终采用可观测事实优先的保守判定：目标仍有打开文件，所以不删除。

## 本次保留清单

| 路径或资产 | 大小 | 保留原因 |
|---|---:|---|
| `data/workspace` | `3,805,492 KiB` | 当前业务运行、开发目录和 worktree，不是缓存 |
| `data/host-runner` | `2,465,240 KiB` | 包含 client、bin、state、logs、venv、yarn-links 及待清缓存；不能删除父目录 |
| `data/host-runner/yarn-cache` | `2,437,696 KiB` | 当前唯一大缓存候选，但有 `6,109` 条打开文件记录 |
| `data/toolchains` | `335,596 KiB` | 当前工具链 |
| `data/.m2` | `266,140 KiB` | Maven 本地依赖；本次存在虚拟化层打开目录证据，保留 |
| `data/profiles` | `136,324 KiB` | 运行配置资产 |
| `data/lazy-packages` | `71,208 KiB` | 当前额外依赖层 |
| `data/skills` | `30,644 KiB` | H1 运行 skill |
| `data/logs` | `5,640 KiB` | 当前日志仍有写入句柄，且体量很小 |
| `data/plugins`、`data/sessions` | `456 KiB`、`1,188 KiB` | 当前插件和会话数据 |
| `/Users/cicada/hermes-docker/hermes-1/backups/t4r-20260715210716` | `7,221,236 KiB` | A16 的完整 data/dbstore 回滚证据，禁止作为缓存删除 |
| 新旧 H1 镜像 | 当前 `b67a60b3...`；旧 `f4c19e19...` | T4R 完整镜像回滚单位 |

本次名称限定扫描中，data 下没有发现第二个名称匹配 `cache/log/tmp/temp` 且超过 `100 MiB` 的明确清理候选；这只说明本次扫描范围，没有把所有大目录推断成永久有效资产。

## 后续允许清理的最低条件

下一维护窗口仅在以下条件同时满足时删除 `yarn-cache`：

1. 精确路径和真实路径一致，目标不是软链接或独立挂载点。
2. 目标下打开文件记录为 `0`，且没有 Yarn、npm、Node 或 host-runner 任务正在使用目标。
3. 已验证依赖包源可用，删除后 Yarn 可以重新下载所需依赖。
4. 删除前固定 H1 的 image ID、StartedAt、RestartCount；删除后这三项逐字不变，`8651/9131` 端口仍可用。
5. `workspace`、host-runner 非缓存目录、sessions、skills、plugins、`/opt/dbstore`、T4R 备份和新旧镜像全部仍存在。

清理完成时记录“目标路径实际移除”和 data 的 `du` 变化；不把 `du` 数字写成文件系统一定释放了同等空间。APFS（苹果文件系统）和虚拟化打开句柄可能延迟物理空间回收，已有同类证据见 [01_BASELINE_AND_DECISIONS.md](01_BASELINE_AND_DECISIONS.md)。
