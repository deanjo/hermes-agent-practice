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

H1 运行版本以执行时最新稳定官方 GitHub Release（正式发布版）的精确 tag 与解引用 commit 为底座；向 Hermes 官方提交的修复则在复核当刻的 `upstream/main` 上前向实现。两条线的自有源码都必须进入 `deanjo/hermes-agent` 的可审阅提交；DingTalk 修改只进入 `deanjo/hermes-dingtalk-kit`。H1 镜像和旧 `image-patches` 只证明“部署过什么”，不能反向覆盖仓库。

2026-07-15 的官方核验结果是：最新稳定 Release 为 `v2026.7.7.2`（产品版本 `v0.18.2`），tag 解引用后为 `9de9c25f620ff7f1ce0fd5457d596052d5159596`，`draft=false`、`prerelease=false`、发布时间 `2026-07-08T03:11:22Z`。同一时刻 `upstream/main=9df5f879b4a5925c0f8f947e7e16ed8e845932c3`，比该 Release 多 695 个提交；因此 Release 运行线和 main 上游线不得混写成一个“最新官方基线”。

## 当前事实与目标状态

T4R 前的 2026-07-15 只读盘点显示，旧 H1 镜像是混合方式：镜像历史包含 8 个核心或插件文件的直接 `COPY`，同时 mentionguard 层把 Kit `8b9f185` 打包后运行标准安装器。旧账本也明确写着补丁通过 `COPY` 进入镜像，见旧目录 `docs/hermes-image-patches-knowledge/README.md:33-55,130-132`。

T4R 已关闭这笔漂移：当前 H1 以官方 `v2026.7.7.2` 镜像摘要 `sha256:9c841866021c54c4596849f6135717e8a4d52ba510b7f52c50aef1de1a283973` 为底座，在镜像构建阶段叠加 fork `62b304750762c69e7d4e611c5f2ec3ff296f58e6` 的 12 份已提交生产文件；Kit 来自 `735e943fe8d9d58ca007677a56dbad35a3e8d329` 的标准 `--plugins-only` 安装，Guardrails 来自 `8d80a46817bb6fdd27bf67e1a4640f5fa99ed2ba` 的安装器。没有在运行容器内直接改 Hermes 或 DingTalk 源文件；目标镜像摘要为 `sha256:b67a60b32319f78a7b62b3b67d220f43e9d64c6ff4ca77c95bddbc0738ad188d`。

目标状态不是“禁止一切文件替换”，而是把边界固定下来：

| 内容 | 唯一源码权威 | 允许的安装方式 | 禁止的做法 |
|---|---|---|---|
| Hermes 通用核心修复（H1 运行线） | 最新稳定官方 Release tag 上创建的 `deanjo/hermes-agent` 发布分支与完整提交 | 从固定 Release SHA + fork SHA 构建镜像 | 用滚动 main 的未适配整树替代稳定 Release；从 H1、旧 worktree 或旧补丁目录拷回整文件 |
| Hermes 通用核心修复（官方 PR 线） | 复核当刻 `upstream/main` 上的 `deanjo/hermes-agent` 分支、提交和官方 PR | 不直接作为 H1 底座；只证明修复可向官方合入 | 把 Release 回移提交直接冒充 main 上的 PR 实现 |
| DingTalk adapter 与 Product Confirmation | `deanjo/hermes-dingtalk-kit` 的提交或 tag（标签：可复现版本名） | Kit 安装器可原子替换自己拥有的 `plugins/platforms/dingtalk/` 目录 | 先改远程容器、以后再补仓库 |
| Hermes 兼容接线 | Kit 仓库中的最小兼容 patcher（补丁器）及测试 | 只改清单允许的锚点，记录前后哈希，二次执行变更数必须为 0 | 用旧 `run.py`、`session.py`、`session_context.py` 整文件覆盖新版本 |
| 平台无关运行时治理 | `deanjo/hermes-agent-runtime-guardrails` 的提交或 tag | 插件安装、卸载和回滚脚本 | 把现役镜像中的散落文件当源码 |
| 镜像与 data 层 | 完整镜像 digest（内容摘要）和部署清单 | 仅作发布产物和运行证据 | 作为下一轮开发基线 |

## 官方升级时谁优先

结论：运行时以最新稳定 Release 的实际行为优先，向官方贡献时以复核当刻 main 的实际行为优先；旧实现代码对两条线都没有优先权。每个问题必须在两条干净基线上分别重跑同一回归测试，再分别给出以下结论：

| 结论 | 证据条件 | 处理 |
|---|---|---|
| `UPSTREAM_EQUIVALENT` | 对应的 Release 或 main 已通过同一回归测试 | 该线删除本地等价补丁；只有 H1 的 Release 底座实际包含修复后，才能从镜像中移除 |
| `LOCAL_REQUIRED` | 对应基线仍复现问题，本地最小补丁和测试通过 | Release 线保留最小回移；main 线保留或重做最小差异并继续官方 PR |
| `SPLIT_REQUIRED` | 官方只修了一部分 | 删除已等价部分，只保留测试证明缺失的最小部分 |
| `ADAPT_REQUIRED` | 官方接口或代码锚点变化，旧补丁无法安全套用 | 停止发布，在新基线上重新实现；禁止整文件覆盖 |

若 main 已等价修复、最新稳定 Release 尚未包含，处理结论应为“main=`UPSTREAM_EQUIVALENT`，Release=`LOCAL_REQUIRED`”：H1 发布分支暂留最小回移，并写明可删除它的后续 Release；不能因为 main 已修就提前从当前 H1 删除。反过来，Release 已通过测试时就不得继续携带旧补丁。以带 `/` 的 DingTalk session key 为例，不能因为 H1 过去部署过 `session.py` COPY 就继续覆盖官方新文件；旧账本已有相同禁令，见 `docs/hermes-image-patches-knowledge/04_dingtalk-reply-quote-and-session-env.md:88-91`。

## 三个完成状态

| 状态 | 必须具备的证据 | 明确不代表 |
|---|---|---|
| `SOURCE_COMPLETE` | 干净分支、可审阅提交、目标测试、独立 review（审阅）通过 | 已生成可部署包 |
| `RELEASE_READY` | 固定源码 SHA、依赖或归档摘要、安装清单、兼容清单、回滚步骤和离线验收通过 | H1 已更新 |
| `RUNTIME_DEPLOYED` | 获得单独部署授权后，记录镜像 digest、容器启动时间、重启次数、安装验证和冒烟结果 | 仅凭本地测试可宣称 |

T4 只允许做到 `SOURCE_COMPLETE / RELEASE_READY`；H1 的构建、部署和所需重启属于 [T4R](tasks/T4R_release_to_h1.md)，必须单独授权。2026-07-15 的 T4R 已获得授权并达到 `RUNTIME_DEPLOYED`；真实消息验收未获授权、也未执行。

## 每次发布的最小清单

1. `release_tag / release_sha`：官方稳定 Release 的 tag 与解引用完整 SHA；`upstream_main_sha`：PR 复核用 main；`runtime_fork_sha`：H1 发布分支；`pr_fork_sha`：官方 PR 分支；另记 `kit_sha` 和 `guardrails_sha`。
2. `base_image_digest` 与目标镜像 digest；只写 digest，不用易漂移的 tag 代替。
3. 每个本地补丁在 Release 线和 main 线各自的升级结论：`UPSTREAM_EQUIVALENT / LOCAL_REQUIRED / SPLIT_REQUIRED / ADAPT_REQUIRED`；Release 临时回移还必须写明删除条件。
4. Kit 拥有的插件文件清单，以及核心兼容接线的允许路径、代码锚点、安装前后哈希。
5. 安装、验证、二次执行幂等检查和回滚步骤；任一项缺失都不能标 `RELEASE_READY`。

## 紧急修复规则

若线上故障迫使临时修改容器或 build context（构建目录），它只能标为 `TEMPORARY_RUNTIME_HOTFIX`。同一修复必须回写正确 GitHub 项目、补测试并重新构建；在仓库提交和部署清单闭环前，不得称为正式版本，也不得作为下次升级来源。
