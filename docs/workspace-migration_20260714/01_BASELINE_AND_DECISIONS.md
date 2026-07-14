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

## 核心决策

| 主题 | 决策 | 原因与锚点 |
|---|---|---|
| 工作区 | 新建 `openclaw-hermes-workspace`，旧目录不原地改造 | B02、B06、B07 说明旧顶层和旧主仓库无法提供干净边界 |
| OpenClaw | 单独放入 `openclaw-workspace/sources/openclaw` | 旧 OpenClaw 未参与 H1/H3 部署，本轮只做源码分离 |
| Hermes 源码 | 从 `deanjo/hermes-agent` 全新 clone，配置官方 upstream | B09、B12；个人 fork 才能承载官方 PR 分支 |
| Feishu wsfix | 导出可恢复 patch 后退役 | 睡眠复盘与 B16 支持根因在 Mac 睡眠；分支当前仍有 7 个修改文件，删除前必须归档 |
| Product Confirmation | 放入 DingTalk Kit，核心修改目标为零 | 最新 Hermes 已有 `pre_gateway_dispatch` 公开 hook；staffId 来自 `event.source.user_id_alt` |
| T21 | 保留两文件最小核心修复并提交官方 PR | 流式内容在插件输出转换前可能已发送，需在 conversation loop 与 finalizer 拦截 |
| T5v | 建独立通用插件项目 | 输出预算和结果转换可使用 middleware/hook；只在最新版无法首次 halt 时考虑一文件核心补丁 |
| Docs | 规则先行、随任务迁移、最后清仓 | B03-B05 证明一次性全量搬运会把代码、缓存和证据混入新文档仓库 |

## 当前未知

- `[未知]` 执行 T3 时官方 `upstream/main` 是否仍为 B12 的 SHA；必须现场重新读取。
- `[未知]` 最新 upstream 是否已进一步修复 T21 或新增 T5v 首次停止接口；T4 必须先复现再编码。
- `[未知]` 596 个旧资产中每一项的最终分类；T5 在逐项证据审计前不得批量删除。
- `[未知]` H3 是否以其他补丁形式实现相同能力；本计划不根据镜像名推断。
