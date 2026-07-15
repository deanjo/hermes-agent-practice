---
status: current
applies_when: "核对本次工作区迁移开始时的本地仓库、GitHub、远程实例和旧 docs 基线"
not_for: "把 2026-07-14 快照当成永久 live 状态；替代具体实现 task；直接决定未审计旧资产的去留"
current_authority: contract-current
supersedes: []
superseded_by: []
---

# 已核验基线与决策

基线时间：`2026-07-14 14:56:20 +08`。摘要只是导航，继续执行时必须重新运行对应检查。

## 已核验事实

| ID | 事实 | 证据 |
|---|---|---|
| B01 | 新工作区在阶段一开始前不存在 | `test ! -e /Users/cicada/SourceCode/openclaw-hermes-workspace` 输出 `workspace_absent` |
| B02 | 旧顶层不是 Git 仓库 | 在 `/Users/cicada/SourceCode/openclaw-harmes` 执行 Git 状态检查返回 `fatal: not a git repository` |
| B03 | 旧 docs 共 596 个文件 | `find docs -type f | wc -l` 输出 `596` |
| B04 | 旧 docs 含 335 个 Markdown | `find docs -type f -name '*.md' | wc -l` 输出 `335` |
| B05 | 旧 docs 混有 196 JSON、18 Python、14 pyc | 同一基线统计分别输出 `196 / 18 / 14` |
| B06 | 旧 Hermes main 不可作干净基线 | HEAD `6c54789953cf...`，状态为 `ahead 25, behind 13980` |
| B07 | 旧 Hermes main 有大量本地内容 | `git status --short` 显示 26 个修改文件和 19 个未跟踪路径 |
| B08 | DingTalk Kit 必须保留未提交内容 | `/Users/cicada/SourceCode/hermes-dingtalk-kit` 在 `f4e781651df7...` 上有 1 个修改文件和 4 个未跟踪路径 |
| B09 | 个人 Hermes fork 已存在且公开 | GitHub `deanjo/hermes-agent`，parent 为 `NousResearch/hermes-agent` |
| B10 | DingTalk Kit 已存在且公开 | GitHub `deanjo/hermes-dingtalk-kit` |
| B11 | Practice 与 Runtime Guardrails 仓库尚不存在 | GitHub 查询两个仓库均返回 `Could not resolve to a Repository` |
| B12 | 当前官方 main 为 `226e8de827a6...` | `git ls-remote https://github.com/NousResearch/hermes-agent.git refs/heads/main` |
| B13 | H1 当前运行 Product Confirmation 镜像 | 2026-07-14 14:43 CST：`hermes-agent:dingtalk-kit-h1-hermes-v0.18.0-pc-b8200e4ba-20260714`，status running |
| B14 | H1 容器含 T21 与 Product 标记 | `/opt/hermes/agent/conversation_loop.py` 有 `_after_session_search`；`turn_finalizer.py` 有 `SESSION_SEARCH_RAW_JSON_FALLBACK`；插件有 `WAITING_PRODUCT_CONFIRMATION` |
| B15 | H3 未证明使用上述三项修改 | H3 镜像为 `...h3-hermes-v0.18.0-t11-20260707210056`；只读检查未给出 T21/T5v/Product 证据 |
| B16 | 睡眠修复当前仍有效 | `pmset -g assertions` 输出两项值均为 `1`，且进程 `63976` 持有 `caffeinate -is` |

## T4 执行前补充基线

补充复核时间：`2026-07-15 16:37 CST`。B01-B16 保留为 T1-T3 历史快照；以下事实主导 T4 进入检查。

| ID | 事实 | 证据 |
|---|---|---|
| B17 | T3 的 Hermes 基线已过期 | 本地与 fork 为 `226e8de827a6...`，实时官方为 `569b912d7d09...`；官方领先 157 个提交、涉及 225 个文件 |
| B18 | 新 Hermes 仓库本身仍干净且 remote 角色正确 | `main@226e8de`；origin=`deanjo/hermes-agent`，upstream=`NousResearch/hermes-agent`；状态无修改 |
| B19 | Kit 新旧根目录都有用户资产，禁止原地切分支 | 两处各为 `1 modified + 16 untracked`，17 项 manifest SHA256 都是 `c7ee88ba...fc22eb6` |
| B20 | Kit mention 分支已实现部分 T4-Product 行为 | GitHub `feat/dingtalk-mention-meta@8b9f185`；本地 75 个单元测试全部通过；该分支同时带 3 份 gateway 整文件快照，不能整体合并 |
| B21 | H1 当前是“直接 COPY + Kit 标准安装器”的混合发布 | 现役 mentionguard 镜像历史有 8 个直接 COPY 项；同一层把精确 Kit `8b9f185` 归档后运行安装器；旧账本 `docs/hermes-image-patches-knowledge/README.md:33-55,130-132` |
| B22 | H1/H3 在 T4 前只读基线已固定 | H1 StartedAt=`2026-07-15T05:14:55Z`、RestartCount=`0`；H3 StartedAt=`2026-07-08T09:10:16Z`、RestartCount=`0` |
| B23 | H1 15:30 data 层变化已归因 | 远程 SOP SHA256=`91629af9...`；本地当前权威文档 `05_qwen-thinking-chain-and-diagnosis-fixes.md:83-90` 记录同一 `0/20 → 4/4` 实验和“铁律七”固化 |
| B24 | Hermes fork 已刷新到执行时官方基线 | 两次远端查询均为 `569b912d7d0931c7256e9f5fb326609e9deda377`；merge-base 为旧 HEAD `226e8de`；`git merge --ff-only` 后本地、origin、upstream 三者相等且工作树干净 |
| B25 | T21 已形成 fork 提交和官方 PR | `fca44fd00b5c0575469c51e96ec5fa731d5c7222`；仅 `agent/conversation_loop.py`、`agent/turn_finalizer.py` 两份生产文件；官方 PR [#64892](https://github.com/NousResearch/hermes-agent/pull/64892) |
| B26 | Product/mention 已回到 Kit 源码项目 | Kit `0e37e209cc6c1df8b96dd28f80adb7c00e09bc11`、PR [#1](https://github.com/deanjo/hermes-dingtalk-kit/pull/1)；Product/mention 的 Hermes core diff 为零 |
| B27 | Product-only 与旧兼容路径已经拆账 | 完整 Hermes `569b912` 上 `--plugins-only` verifier `35/35`、二次安装无变化；默认 legacy compat 缺 `run.reply_sentinel_constant`、`session.path_sensitive_validation` 两个锚点并成功回滚，结论 `ADAPT_REQUIRED` |
| B28 | T5v 首次停止需要通用 core 接缝 | Guardrails `14c28d4444273232c8753314ff928927fce651c3`、PR [#1](https://github.com/deanjo/hermes-agent-runtime-guardrails/pull/1)；fork `dd45532f563e72adcf0f605ff11ea441187232fc`、官方 PR [#64895](https://github.com/NousResearch/hermes-agent/pull/64895) 只改 `agent/tool_guardrails.py` 和 `run_agent.py` 两份通用生产文件 |
| B29 | T4 三路源码验收已收口 | T21 `15/15`、Kit `105 passed + 14 subtests`、T5v core `27/27`、Guardrails `45/45`；三路独立 review 均为 Critical=0、Important=0 |
| B30 | H1/H3 收口时启动时间变化已做功能归因 | H1 StartedAt=`2026-07-15T08:53:57.916638417Z`；H3 StartedAt=`2026-07-15T09:11:33.186856916Z`；两次都是 vision 数据层修改后的显式 `docker restart`，不是主机重启、容器重建、换镜像或 T4 源码部署 |
| B31 | 收口时官方与 fork main 仍等于冻结基线 | 实时 `git ls-remote`、本地 main、origin/main、upstream/main 均为 `569b912d7d0931c7256e9f5fb326609e9deda377` |
| B32 | T4R 的最新稳定官方 Release 已重新冻结 | GitHub `releases/latest` 返回 `v2026.7.7.2` / `Hermes Agent v0.18.2`、`draft=false`、`prerelease=false`、`published_at=2026-07-08T03:11:22Z`；tag 解引用 SHA 为 `9de9c25f620ff7f1ce0fd5457d596052d5159596` |
| B33 | 稳定 Release 与滚动 main 不是同一基线 | `upstream/main=9df5f879b4a5925c0f8f947e7e16ed8e845932c3`；`git rev-list --left-right --count release...main` 输出 `0 695`，release 与原 T4 `569b912...` 输出 `0 685` |
| B34 | T4R 授权和安装选择已关闭 | 2026-07-15 用户明确“同意部署”，随后确认“以最新的 release 版本为基线，其他的同意”；因此 Product 固定 `--plugins-only`，候选通过后允许 H1 数据冻结、切换与所需重启 |
| B35 | H1 第一批缓存清理已精确完成且未重启 | 删除前复核三个路径无打开文件/CWD、正式 JDK 17.0.17 与 Maven 3.9.12 可用；仅删除 `data/cache/toolchain`、`data/.cache`、`data/.local/jdk/jdk-17.0.19+10`，删除前 `du` 合计 `617016 KiB`；结果 `PASS`，image ID、StartedAt=`2026-07-15T08:53:57.916638417Z`、RestartCount=`0` 均不变。同期 `df` 净增仅 `408 KiB`，因此只证明路径和对应数据已移除，不把 `du` 数字冒充文件系统实际空闲增量 |
| B36 | T4R1 三路源码已固定并推送 | Release 运行分支 `release/h1-v2026.7.7.2-t4r@62b304750762c69e7d4e611c5f2ec3ff296f58e6`；Kit `735e943fe8d9d58ca007677a56dbad35a3e8d329`；Guardrails `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba`；三个工作树均无未提交文件 |
| B37 | 官方镜像底座和目标镜像可复现 | 官方 `v2026.7.7.2` 镜像摘要 `sha256:9c841866021c54c4596849f6135717e8a4d52ba510b7f52c50aef1de1a283973`；目标镜像摘要 `sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d`；镜像标签记录 Release、runtime、Kit、Guardrails 四个完整 SHA |
| B38 | T4R 已受控发布到 H1 | H1 `status=running`、版本 `0.18.2`、runtime SHA=`62b304750762c69e7d4e611c5f2ec3ff296f58e6`、StartedAt=`2026-07-15T13:11:21.295530766Z`、RestartCount=`0`；`127.0.0.1:8651/9131` 均连通；H3 镜像、StartedAt 和 RestartCount 与发布前一致 |
| B39 | T4R 回滚材料完整保留 | 备份根 `/Users/cicada/hermes-docker/hermes-1/backups/t4r-20260715210716` 为 `7221236 KiB`；冻结后 rsync 差异计数 `0`，dbstore `61424 KiB / 10 files`；旧 compose SHA256=`4c1c622b88dfef05d4df2267e31e95ac3dab51a2f4d10653eacd16e7794fed2e`，旧镜像摘要 `sha256:f4c19e19a19c0d4fe159768b6fe0e55a69fee6041bf21b440db8f5151886400c` 仍保留 |
| B40 | 候选与生产离线验收通过 | Release 重点回归 `103/103`、Kit `105/105` 且候选 verifier `35/35`、Guardrails `48/48`；Guardrails install/verify/install 的 changed_count=`1/0/0`，生产导入成功；H1 启动错误计数 `0`，未发送真实消息 |
| B41 | 官方 main 贡献线已补齐 | 官方 PR #64892、#64895、#64971、#64972、#64973、#64975 均为 OPEN；前两项在当前 main `9df5f879...` 上无冲突并通过合并回归 `42/42`，后四项直接从该 main 创建；Kit PR #1 与 Guardrails PR #1 均为 OPEN |

## 核心决策

| 主题 | 决策 | 原因与锚点 |
|---|---|---|
| 工作区 | 新建 `openclaw-hermes-workspace`，旧目录不原地改造 | B02、B06、B07 说明旧顶层和旧主仓库无法提供干净边界 |
| OpenClaw | 单独放入 `openclaw-workspace/sources/openclaw` | 旧 OpenClaw 未参与 H1/H3 部署，本轮只做源码分离 |
| Hermes 源码 | 从 `deanjo/hermes-agent` 全新 clone，配置官方 upstream | B09、B12；个人 fork 才能承载官方 PR 分支 |
| Hermes 修改 | H1 运行修复从最新稳定 Release 建 fork 发布分支；同一问题在当前 main 前向实现并向官方提 PR | B32-B33 证明 Release 与 main 相差 695 个提交；[04](04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) 固定双轨源码权威与升级取舍 |
| Feishu wsfix | 导出可恢复 patch 后退役 | 睡眠复盘与 B16 支持根因在 Mac 睡眠；分支当前仍有 7 个修改文件，删除前必须归档 |
| Product Confirmation | 放入 DingTalk Kit，核心修改目标为零 | 最新 Hermes 已有 `pre_gateway_dispatch` 公开 hook；staffId 来自 `event.source.user_id_alt` |
| DingTalk 发布 | Kit GitHub 提交先于镜像；Product-only 可用 `--plugins-only` 原子安装，默认 legacy compat 适配前不可发布 | B19-B21、B26-B27；整分支或旧 gateway 整文件覆盖会带回历史漂移 |
| T21 | 保留两文件最小核心修复并提交官方 PR | 流式内容在插件输出转换前可能已发送，需在 conversation loop 与 finalizer 拦截 |
| T5v | 独立通用插件负责治理；必要时配两文件通用 core 接缝 | 失败测试证明公开 hook 只能提出 halt、官方 core 不消费；`agent/tool_guardrails.py` 解析通用请求，`run_agent.py` 只修正首次停止话术，均不识别插件专名 |
| Docs | 规则先行、随任务迁移、最后清仓 | B03-B05 证明一次性全量搬运会把代码、缓存和证据混入新文档仓库 |
| 发布状态 | 分开记录 `SOURCE_COMPLETE / RELEASE_READY / RUNTIME_DEPLOYED` | 最终 Kit `105 passed + 14 subtests` 也只能证明源码行为，不能证明 H1 已更新；定义见 [04](04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) |

## 当前未知

- `[已关闭]` T3 当时官方 SHA 已由 R2 固定为 B12；B17 说明当前已继续前进，T4 必须重新冻结而不是改写历史验收。
- `[已关闭]` T21、Product 与 T5v 源码实现、测试、GitHub PR 和独立 review 已由 [R3](reviews/R3_t4_source_release_verification.md) 收口。
- `[已关闭]` mention 分支行为已精选进入 Kit；默认 legacy compat 在 `569b912` 上的两个缺失锚点为 `ADAPT_REQUIRED`，未整体迁入 gateway 三文件。
- `[未知]` 六个官方 PR 与 Kit、Guardrails 两个项目 PR 的合入时间；2026-07-15 查询时八个 PR 均为 OPEN。
- `[已关闭]` Product 使用 `--plugins-only`，T4R 构建、候选通过后的 H1 切换与所需重启已经用户授权，见 B34。
- `[已关闭]` T21、T5v、skill refresh、quotefix、toolgate、delegate 与 HANDOFF-GUARD 在 Release/main 两线均为 `LOCAL_REQUIRED`；固定提交、测试、官方 PR 和删除条件见 [T4R1](tasks/T4R1_reconcile_latest_release.md)。
- `[未知]` 596 个旧资产中每一项的最终分类；T5 在逐项证据审计前不得批量删除。
- `[未知]` H3 是否以其他补丁形式实现相同能力；本计划不根据镜像名推断。
