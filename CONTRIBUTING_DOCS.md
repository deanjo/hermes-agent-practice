---
status: current
applies_when: "在 hermes-agent-practice 新建、修改、迁移、归档或删除文档"
not_for: "Hermes/OpenClaw 源码编码规范；直接判断远程运行状态；替代具体任务 Roadmap"
current_authority: contract-current
supersedes: []
superseded_by: []
---

# 文档协作规范

结论：任何新文档必须先确定职责、状态、目录和验收证据，再落文件；不要把聊天摘要、临时日志或脚本直接塞进 `docs/`。

## 1. 目录规则

1. `docs/` 下每个目录必须有且只有一个大小写固定的 `README.md`。
2. `README.md` 只做范围说明、当前入口和导航；任务细节放 Roadmap、task 或报告。
3. 目录与文件路径使用 ASCII。长期文档用稳定主题名；事故、迁移和一次性报告可追加 `_YYYYMMDD`。
4. 文档标题和正文使用中文；首次出现的英文术语给出中文解释。
5. 图片、JSON 样例等证据只能放在对应主题的 `assets/`，且该目录也必须有 `README.md` 说明来源和引用者。
6. Python、shell、测试代码放 `scripts/` 或项目源码，不放 `docs/`；`.pyc`、PID、日志、缓存和 `.DS_Store` 不进入仓库。
7. 被运行时直接读取的 `SKILL.md`、prompt（提示词）、插件描述或规则 Markdown 是功能资产，跟随对应源码项目和测试；`docs/` 只保存其契约、版本与验证证据。

## 2. 必填 frontmatter

`docs/**/*.md` 的 H1 前必须包含：

```yaml
---
status: current | draft | archive | superseded
applies_when: "本文件应该被读取的具体任务"
not_for: "容易混淆但不应由本文件主导的任务"
current_authority: "权威等级"
supersedes: []
superseded_by: []
---
```

字段规则：

| status | 含义 | current_authority | superseded_by |
|---|---|---|---|
| `current` | 当前可主导执行或导航 | `router-current`、`roadmap-current`、`task-current`、`contract-current`、`acceptance-current` | 必须为空数组 |
| `draft` | 尚未批准，不可主导执行 | `draft-non-authoritative` | 必须为空数组 |
| `archive` | 只保留历史或证据价值 | `historical-evidence` | 可为空 |
| `superseded` | 已被明确的新文档取代 | `historical-evidence` | 必须至少列一个替代路径 |

出现 `status: archive` 配 `task-current`、或 `status: superseded` 却没有 `superseded_by`，都属于元信息冲突；先修元信息，再读正文。

## 3. 文档类型

| 类型 | 适合内容 | 不适合内容 |
|---|---|---|
| `operations/` | 当前部署拓扑、运维手册、实例入口 | 单次事故过程日志 |
| `integrations/` | DingTalk 等平台集成契约与适配经验 | Hermes 通用核心补丁 |
| `upstream/` | 上游差异、复现、补丁和 PR 追踪 | 本地临时实验 |
| `incidents/` | 已有证据的事故复盘 | 未核验猜测 |
| `projects/` | 有 Roadmap 和验收矩阵的执行计划 | 永久堆积的聊天摘要 |
| `archive/` | 已退出默认加载路径的历史证据 | 当前权威文档 |

目录按需要创建，不为凑结构创建空目录。

### Operations 文档最小运行谱系

`operations/` 中任何声称“当前生效”或“可发布”的文档，除六个通用 frontmatter 字段外，正文必须给出以下字段；缺一项就只能写成带时间的证据快照：

| 字段 | 例子或要求 |
|---|---|
| `as_of` | `2026-07-15T16:37:00+08:00`，说明检查时间 |
| `target` | `H1/hermes-1`，不能只写“线上” |
| `source_commit` | Hermes、Kit、Guardrails 的完整 Git SHA |
| `image_digest` | `sha256:...`；tag 只能辅助，不能替代 digest |
| `data_layers` | 挂载配置、运行 skill、额外依赖的路径、时间和摘要；没有则写 `none` |
| `verification` | 实际测试、安装验证、StartedAt、RestartCount 和结果 |
| `rollback` | 上一镜像 digest、data 备份与恢复步骤 |
| `superseded_by` | 被新运行记录替代时指向新文件；仍 current 时与 frontmatter 一致为空 |

源码权威和三个发布状态以 [源码、发布与官方升级原则](docs/workspace-migration_20260714/04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md) 为准；operations 文档不能把运行容器反写成源码。

## 4. 新建文档流程

1. 从最近的 `README.md` 确认本目录职责和当前权威入口。
2. 搜索是否已有同主题文档；能更新就不重复创建。
3. 写 frontmatter，并让 `applies_when`、`not_for` 可实际判断。
4. 在最近的 `README.md` 增加导航链接。
5. 检查相对链接、状态映射和 `superseded_by`。
6. 在任务验收记录中写明变更文件和证据，不只写“已完成”。

## 5. 迁移分类

旧资产只能使用以下五种结论：

| 结论 | 使用条件 | 处理方式 |
|---|---|---|
| `migrate` | 内容仍当前有效且职责单一 | 迁入新目录并补齐元信息 |
| `merge` | 与当前文档重复但有独有证据 | 合并独有部分，记录旧路径 |
| `archive` | 不再指导当前执行但有历史价值 | 放入 `archive/`，退出默认导航 |
| `discard` | 缓存、生成物、无引用临时文件 | 记录清单后删除 |
| `defer` | 证据不足，暂时无法判断 | 保留原位并阻塞旧目录整体删除 |

## 6. 提交前检查

- 每个新目录存在唯一 `README.md`。
- 每个 Markdown 都有六个必填 frontmatter 字段。
- 所有相对链接指向现存文件。
- 当前文档没有指向已 superseded 文档作为权威来源。
- 文档没有收录凭据值、`.env` 内容或原始认证材料。
- 迁移文档记录了旧路径和迁移结论。
- 当前 operations 文档包含 `as_of / target / source_commit / image_digest / data_layers / verification / rollback / superseded_by`。
- 功能 Markdown、配置、实验数据和 build context 已按运行资产分类，没有伪装成普通说明文档。
