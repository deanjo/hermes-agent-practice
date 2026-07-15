---
status: current
applies_when: "开发 Hermes 核心修复、DingTalk Kit 或 Runtime Guardrails，并判断源码权威、发布状态和官方升级取舍"
not_for: "未经单独授权部署或重启 H1/H3；把现役容器或旧 image-patches 当成源码仓库；替代具体实现 task"
current_authority: contract-current
supersedes:
  - "旧流程中直接从运行容器或 image-patches 复制文件作为下一版源码的做法"
superseded_by: []
---

# 源码、发布与官方升级原则

## 一句话定论

Hermes 核心修改以 `deanjo/hermes-agent` 的可审阅提交为唯一自有源码，DingTalk 修改以 `deanjo/hermes-dingtalk-kit` 的可审阅提交为唯一插件源码；H1 镜像和旧 `image-patches` 只证明“部署过什么”，不能反向覆盖仓库。

## 当前事实与目标状态

2026-07-15 只读盘点显示，H1 现役镜像仍是混合方式：镜像历史包含 8 个核心或插件文件的直接 `COPY`，同时 mentionguard 层已把 Kit `8b9f185` 打包后运行标准安装器。旧账本也明确写着补丁通过 `COPY` 进入镜像，见旧目录 `docs/hermes-image-patches-knowledge/README.md:33-55,130-132`。

目标状态不是“禁止一切文件替换”，而是把边界固定下来：

| 内容 | 唯一源码权威 | 允许的安装方式 | 禁止的做法 |
|---|---|---|---|
| Hermes 通用核心修复 | 执行时最新官方基线上的 `deanjo/hermes-agent` 分支、提交和官方 PR | 从固定完整 SHA 构建镜像 | 从 H1、旧 worktree 或旧补丁目录拷回整文件 |
| DingTalk adapter 与 Product Confirmation | `deanjo/hermes-dingtalk-kit` 的提交或 tag（标签：可复现版本名） | Kit 安装器可原子替换自己拥有的 `plugins/platforms/dingtalk/` 目录 | 先改远程容器、以后再补仓库 |
| Hermes 兼容接线 | Kit 仓库中的最小兼容 patcher（补丁器）及测试 | 只改清单允许的锚点，记录前后哈希，二次执行变更数必须为 0 | 用旧 `run.py`、`session.py`、`session_context.py` 整文件覆盖新版本 |
| 平台无关运行时治理 | `deanjo/hermes-agent-runtime-guardrails` 的提交或 tag | 插件安装、卸载和回滚脚本 | 把现役镜像中的散落文件当源码 |
| 镜像与 data 层 | 完整镜像 digest（内容摘要）和部署清单 | 仅作发布产物和运行证据 | 作为下一轮开发基线 |

## 官方升级时谁优先

结论：以“执行时最新官方代码的实际行为”优先，不以旧实现代码优先。升级前必须在干净官方基线上重跑每个问题的复现测试，再逐项给出以下唯一结论：

| 结论 | 证据条件 | 处理 |
|---|---|---|
| `UPSTREAM_EQUIVALENT` | 官方代码已通过同一回归测试 | 删除本地等价补丁；只有部署基线确实包含该官方提交后，才能从镜像中移除 |
| `LOCAL_REQUIRED` | 官方仍复现问题，本地最小补丁和测试通过 | 在 fork 上保留或重做最小差异，并继续官方 PR |
| `SPLIT_REQUIRED` | 官方只修了一部分 | 删除已等价部分，只保留测试证明缺失的最小部分 |
| `ADAPT_REQUIRED` | 官方接口或代码锚点变化，旧补丁无法安全套用 | 停止发布，在新基线上重新实现；禁止整文件覆盖 |

例如，官方若已让带 `/` 的 DingTalk session key 重启后仍能加载，回归测试通过后就删除本地 session 修复；不能因为 H1 过去部署过 `session.py` COPY 就继续覆盖官方新文件。旧账本已经给出相同禁令，见 `docs/hermes-image-patches-knowledge/04_dingtalk-reply-quote-and-session-env.md:88-91`。

## 三个完成状态

| 状态 | 必须具备的证据 | 明确不代表 |
|---|---|---|
| `SOURCE_COMPLETE` | 干净分支、可审阅提交、目标测试、独立 review（审阅）通过 | 已生成可部署包 |
| `RELEASE_READY` | 固定源码 SHA、依赖或归档摘要、安装清单、兼容清单、回滚步骤和离线验收通过 | H1 已更新 |
| `RUNTIME_DEPLOYED` | 获得单独部署授权后，记录镜像 digest、容器启动时间、重启次数、安装验证和冒烟结果 | 仅凭本地测试可宣称 |

T4 只允许做到 `SOURCE_COMPLETE / RELEASE_READY`；H1 的构建、部署、重启和真实消息验收属于 [T4R](tasks/T4R_release_to_h1.md)，必须单独授权。

## 每次发布的最小清单

1. `upstream_sha`：官方完整 SHA；`fork_sha`：我们的完整 SHA；`kit_sha` 和 `guardrails_sha`：对应项目完整 SHA。
2. `base_image_digest` 与目标镜像 digest；只写 digest，不用易漂移的 tag 代替。
3. 每个本地补丁的升级结论：`UPSTREAM_EQUIVALENT / LOCAL_REQUIRED / SPLIT_REQUIRED / ADAPT_REQUIRED`。
4. Kit 拥有的插件文件清单，以及核心兼容接线的允许路径、代码锚点、安装前后哈希。
5. 安装、验证、二次执行幂等检查和回滚步骤；任一项缺失都不能标 `RELEASE_READY`。

## 紧急修复规则

若线上故障迫使临时修改容器或 build context（构建目录），它只能标为 `TEMPORARY_RUNTIME_HOTFIX`。同一修复必须回写正确 GitHub 项目、补测试并重新构建；在仓库提交和部署清单闭环前，不得称为正式版本，也不得作为下次升级来源。
