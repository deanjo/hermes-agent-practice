---
status: current
applies_when: "核对 T4 的 A11-A13、A15，确认三路源码和限定发布材料是否足以收口"
not_for: "证明 H1 已部署；授权构建或重启 H1/H3；批准默认 Kit legacy compat；删除旧目录"
current_authority: acceptance-current
supersedes: []
superseded_by: []
gate: t4-source-release-verification
round: 1
reviewer: t4_source_release_rollup
source_reviewers:
  - t21_final_review
  - product_final_review
  - t5v_closure_review
documentation_reviewer: practice_doc_audit
rollup: CLEARED
scope: "SOURCE_COMPLETE / RELEASE_READY_SCOPED；不包含 T4R"
---

# R3 T4 源码与限定发布材料复核

## Input Packet

- 任务：[T4_extract_core_and_plugins.md](../tasks/T4_extract_core_and_plugins.md)。
- 验收行：[A11-A13、A15](../02_ACCEPTANCE_MATRIX.md)。
- 源码与升级契约：[04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md](../04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md)。
- 复核时间：`2026-07-15 18:39:06 +08`；GitHub 状态和远程运行态均是该时点快照。
- 执行时官方基线：`569b912d7d0931c7256e9f5fb326609e9deda377`。
- 非目标：不构建镜像，不部署或重启 H1/H3，不发送真实 DingTalk/Feishu 消息，不删除旧目录。

## Roll-up

```text
Critical（严重）=0
Important（重要）=0
Roll-up=CLEARED
Scope=SOURCE_COMPLETE / RELEASE_READY_SCOPED
```

三路源码独立 review 都已清零 Critical、Important；最终只读复核又确认官方远端、fork main 和本地 main 仍为 `569b912d7d0931c7256e9f5fb326609e9deda377`。以下 `PASS` 不外推为 H1 已更新。

## 固定源码与 GitHub

| 路径 | Base | Head | PR 与当前状态 |
|---|---|---|---|
| T21 Hermes core | `569b912d7d0931c7256e9f5fb326609e9deda377` | `fca44fd00b5c0575469c51e96ec5fa731d5c7222` | [NousResearch/hermes-agent #64892](https://github.com/NousResearch/hermes-agent/pull/64892)，OPEN，`mergeable=true`，`mergeable_state=blocked`，check-runs=0 |
| Product/mention Kit | `f4e781651df7606b4f7a7a8a43d49616775bc43e` | `0e37e209cc6c1df8b96dd28f80adb7c00e09bc11` | [deanjo/hermes-dingtalk-kit #1](https://github.com/deanjo/hermes-dingtalk-kit/pull/1)，OPEN，`mergeable_state=clean`，check-runs=0 |
| T5v generic core | `569b912d7d0931c7256e9f5fb326609e9deda377` | `dd45532f563e72adcf0f605ff11ea441187232fc` | [NousResearch/hermes-agent #64895](https://github.com/NousResearch/hermes-agent/pull/64895)，OPEN，`mergeable=true`，`mergeable_state=blocked`，check-runs=0 |
| Runtime Guardrails | `461a171379bad488a577289c7dbf6560b3f40951` | `14c28d4444273232c8753314ff928927fce651c3` | [deanjo/hermes-agent-runtime-guardrails #1](https://github.com/deanjo/hermes-agent-runtime-guardrails/pull/1)，OPEN，`mergeable_state=clean`，check-runs=0 |

两个官方 PR 的 `blocked` 是 GitHub 合并门未满足，不是本地测试失败；API 同时返回 check-runs=0，因此本记录不猜测具体仓库规则。四个 PR 都尚未合并，升级时仍须重新跑同一回归。

## A11 Product Confirmation

1. 源码只在 Kit 提交 `0e37e209cc6c1df8b96dd28f80adb7c00e09bc11`；Product/mention 增量的 Hermes core diff 为零。
2. 全量测试命令返回 `105 passed, 14 subtests passed`；实现阶段的 Product/mention 定向测试为 `44/44`。
3. overlay（覆盖层）验证器返回 `check_count=50 / failure_count=0`。在完整干净 Hermes `569b912` 临时 root 上，`--plugins-only` 首次和第二次安装都为 `failure_count=0`，验证器 `35/35`；第二次两个插件目录均为 `already matches source`，`core_manifest.changed_paths=[]`。
4. 默认 legacy compat（旧兼容接线）在同一干净基线上缺 `run.reply_sentinel_constant`、`session.path_sensitive_validation` 两个锚点。安装器在临时修改后完整恢复 gateway 三文件和原插件目录，证明原子回滚有效；升级结论仍是 `ADAPT_REQUIRED`。
5. 五个工具、持久化状态机、staffId 公开 hook、DingTalk mention 元信息和 `errcode != 0` 交付判定均在 Kit 代码与测试内；没有把运行容器文件反写成源码。

结论：A11 `PASS`，发布范围只能写 `SOURCE_COMPLETE / RELEASE_READY_PRODUCT_ONLY`。当前默认安装模式不可发布。

## A12 T21

1. 分支直接基于 `569b912d7d0931c7256e9f5fb326609e9deda377`，生产修改只有 `agent/conversation_loop.py`、`agent/turn_finalizer.py`。
2. 最终命令 `scripts/run_tests.sh tests/run_agent/test_session_search_output_boundary.py -q` 返回 `15/15`；实现阶段另跑相关套件 `148/148` 与旧 stream/silence `2/2`。
3. 用例覆盖空 follow-up 不复用旧 assistant 文本、原始 session JSON 不进入流式输出/最终返回/持久化、provider reasoning 字段过滤，以及安全 summary/refusal 保留。
4. fork 提交已推送，官方 PR #64892 的 head 精确等于 `fca44fd00b5c0575469c51e96ec5fa731d5c7222`。

结论：A12 `PASS`，状态 `SOURCE_COMPLETE / RELEASE_READY`；尚未合入官方，也没有部署。

## A13 T5v

1. Guardrails 插件提交 `14c28d4444273232c8753314ff928927fce651c3`；项目规定命令 `python3 -m unittest discover -s tests -v` 返回 `45/45`。
2. 插件实现 `8192 UTF-8 bytes / 200 lines`、官方顶层多模态原对象透传、跨 `terminal / execute_code` 同根因归并、不同业务目标隔离，以及缺凭据/401/403 第一次发出通用 halt 请求。普通说明文字 `missing API key` 和否定句 `No credentials are missing` 不会误停。
3. 失败测试证明公开 `transform_tool_result` hook 只能返回请求，官方 `569b912` 不消费它。串行 core 提交 `dd45532f563e72adcf0f605ff11ea441187232fc` 因此使用两份通用生产文件：`agent/tool_guardrails.py` 消费 `hermes.tool_guardrail.request/v1`，`run_agent.py` 只修正首次不可重试阻塞的话术；两处均无插件专名。
4. core 命令 `scripts/run_tests.sh tests/agent/test_tool_guardrails.py tests/run_agent/test_tool_call_guardrail_runtime.py -q` 返回 `27/27`；集成用例证明第一次失败后 `api_calls=1 / tool_calls=1 / turn_exit_reason=guardrail_halt`。
5. 离线管理流程依次得到 install `changed_count=1`、verify `0`、reinstall `0`、uninstall `1`、第二次 uninstall `0`、rollback `1`、最终 verify `0`；恢复摘要为 `c0128d450c32477be078859f18bb521360d8ea1978e2be0e95fe75a2c10c56b5`。Hermes PluginManager（插件管理器）只读加载结果为 enabled=true、error=null、三个 hook 数量 `1/1/1`。

结论：A13 `PASS`，插件与通用 core 必须作为同一固定版本发布；只装插件不能声称“已真正停止本轮”。

## A15 与范围核对

| 验收点 | 证据 | 判定 |
|---|---|---|
| 四路完整 SHA | upstream、T21 fork、Kit、T5v core、Guardrails 均固定在上表 | `PASS` |
| 安装与回滚 | Kit Product-only 二次安装无变化；默认 legacy 失败后恢复；Guardrails install/verify/uninstall/rollback 幂等（重复执行结果不变） | `PASS` |
| 兼容结论 | Product-only 可发布；默认 legacy 两锚点 `ADAPT_REQUIRED`；T5v core 为经失败测试证明的 `LOCAL_REQUIRED` | `PASS` |
| 独立 review | T21、Product、T5v 三路 Critical=0、Important=0 | `PASS` |

因此 A15 `PASS`，但状态名称必须保留 `RELEASE_READY_SCOPED`：T21/T5v 为 `RELEASE_READY`，Product 为 `RELEASE_READY_PRODUCT_ONLY`。

## 运行态停止条件归因

收口检查发现此前基线已变化，先按 Roadmap 停止并做只读归因：

- H1：`2026-07-15T08:53:54Z` 开始 `kill → stop → die → start → restart`，当前 StartedAt=`2026-07-15T08:53:57.916638417Z`；容器 ID `7349092006e...`、镜像 ID `f4c19e19a19c...`、Created 时间未变，RestartCount=0。
- H3：`2026-07-15T09:11:29Z` 开始同一事件序列，当前 StartedAt=`2026-07-15T09:11:33.186856916Z`；容器 ID `dd3e1b7b99e...`、镜像 ID `884a722f5e44...`、Created 时间未变，RestartCount=0。
- data 文件修改时间分别早于 restart 17 秒和 37 秒；旧目录 `docs/hermes-vision-image-fix/02_vision-timeout-fallback-401_20260715.md:60-75` 记录同一 vision timeout `30 → 120`、区域配置和 `docker restart -t 200`。该旧文档没有本项目 YAML frontmatter，只作归因线索；live Docker 事件、文件时间和差异检查是主证据。
- H1 `/opt/hermes/` 差异计数为 0；H3 只有 4 个 `yunyin_discourse/__pycache__/*.pyc`，没有 `.py` 源码变化。宿主机启动时间仍为 `2026-06-23 19:10:15`，排除主机重启。

结论为 `RUNTIME_CHANGE_ATTRIBUTED_EXTERNAL`：这是 T4 外的数据层 vision 调整，不是容器重建、换镜像或 T4 源码部署。Docker 事件不记录客户端身份，所以具体调用人仍为 `UNKNOWN`；这不影响功能归因，但必须保留在后续 T4R 输入中。

## 最终判定与安静缩水检查

| ID | 判定 | 没有被悄悄缩掉的边界 |
|---|---|---|
| A11 | `PASS` | Product 五工具、状态机、mention、errcode、安装和回滚均覆盖；只把默认 legacy 发布排除并明确记为 `ADAPT_REQUIRED` |
| A12 | `PASS` | 同时覆盖 stream、return、persistence 和空 follow-up，不是只修最终显示 |
| A13 | `PASS` | 插件能力与真正 halt 的通用 core consumer 都覆盖；没有把“发出请求”冒充“已经停止” |
| A15 | `PASS` | 四个提交、四个 PR、安装/兼容/回滚和 review 都可追溯；范围名称明确为 `SCOPED` |
| A16 | `BLOCKED` | 没有部署授权、镜像 digest 或 H1 冒烟，不能用本地测试替代 |
| A14 | `INSUFFICIENT_EVIDENCE` | T5 未执行且 A16 阻塞，旧目录继续保留 |

本任务没有构建镜像，没有部署或重启 H1/H3，没有发真实消息，没有删除旧目录，也没有批准 bot 的 `merge_uat` 或业务仓部署申请。
