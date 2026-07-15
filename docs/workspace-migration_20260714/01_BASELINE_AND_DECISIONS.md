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

## 核心决策

| 主题 | 决策 | 原因与锚点 |
|---|---|---|
| 工作区 | 新建 `openclaw-hermes-workspace`，旧目录不原地改造 | B02、B06、B07 说明旧顶层和旧主仓库无法提供干净边界 |
| OpenClaw | 单独放入 `openclaw-workspace/sources/openclaw` | 旧 OpenClaw 未参与 H1/H3 部署，本轮只做源码分离 |
| Hermes 源码 | 从 `deanjo/hermes-agent` 全新 clone，配置官方 upstream | B09、B12；个人 fork 才能承载官方 PR 分支 |
| Hermes 修改 | 所有自有核心修复只在执行时最新官方基线上的 fork 分支实现，并向官方提 PR | B17 证明冻结基线会过期；[04](04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) 固定源码权威与升级取舍 |
| Feishu wsfix | 导出可恢复 patch 后退役 | 睡眠复盘与 B16 支持根因在 Mac 睡眠；分支当前仍有 7 个修改文件，删除前必须归档 |
| Product Confirmation | 放入 DingTalk Kit，核心修改目标为零 | 最新 Hermes 已有 `pre_gateway_dispatch` 公开 hook；staffId 来自 `event.source.user_id_alt` |
| DingTalk 发布 | Kit GitHub 提交先于镜像；标准安装器只原子替换 Kit 自有插件目录，核心只做可验证的最小兼容接线 | B19-B21；整分支或旧 gateway 整文件覆盖会带回历史漂移 |
| T21 | 保留两文件最小核心修复并提交官方 PR | 流式内容在插件输出转换前可能已发送，需在 conversation loop 与 finalizer 拦截 |
| T5v | 建独立通用插件项目 | 输出预算和结果转换可使用 middleware/hook；只在最新版无法首次 halt 时考虑一文件核心补丁 |
| Docs | 规则先行、随任务迁移、最后清仓 | B03-B05 证明一次性全量搬运会把代码、缓存和证据混入新文档仓库 |
| 发布状态 | 分开记录 `SOURCE_COMPLETE / RELEASE_READY / RUNTIME_DEPLOYED` | 本地 75/75 测试只能证明源码行为，不能证明 H1 已更新；定义见 [04](04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) |

## 当前未知

- `[已关闭]` T3 当时官方 SHA 已由 R2 固定为 B12；B17 说明当前已继续前进，T4 必须重新冻结而不是改写历史验收。
- `[未知]` `569b912` 或编码开始前更晚的 upstream 是否已修复 T21、Product 接口缺口或 T5v 首次停止；T4 必须先复现再编码。
- `[未知]` mention 分支中 `37e0147` 的 gateway 三文件哪些已被最新官方吸收；Product 只精选 adapter 行为，禁止整体迁入三个文件。
- `[未知]` T4 三路完成后采用哪个具体发布窗口；在用户单独授权 T4R 前不构建、部署或重启 H1。
- `[未知]` 596 个旧资产中每一项的最终分类；T5 在逐项证据审计前不得批量删除。
- `[未知]` H3 是否以其他补丁形式实现相同能力；本计划不根据镜像名推断。
