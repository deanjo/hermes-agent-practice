---
status: archive
applies_when: "核对旧 openclaw-harmes 运行文档是否已高保真保留，或追溯 2026-07-14 至 07-15 的 H1 修复证据"
not_for: "指导当前部署、恢复凭据值、替代 T4R 运行记录或直接判断 H1/H3 当前状态"
current_authority: historical-evidence
supersedes: []
superseded_by: []
---

# 旧运行文档迁移索引（2026-07-15）

## 结论

旧 `docs/` 的 603 个文件已逐字节进入本机私有归档；压缩包大小 `3,434,754` bytes，SHA256 为 `878ea76ea557463bddb377797226878f8b68dd7dabc03e71d6ac26a830738dc6`，包内文件数与源文件数均为 `603`。原件不进入公开 Git，避免把旧命令、实例标识和认证材料重新发布成当前权威。

私有归档位置：`projects/hermes-runtime-assets/private-archives/openclaw-harmes-docs-raw-20260715.tar.gz`。逐文件路径、大小、SHA256 和分类位于同项目的 `manifests/docs_inventory.tsv`。

## T5 锁定的 13 份证据

| 旧相对路径 | SHA256 | 当前处理 |
|---|---|---|
| `docs/hermes-image-patches-knowledge/README.md` | `ea582f729330e22bc18de30b61b26c5907af230238e32d9d9175ffe697b8566d` | 原件迁入私有归档；发布原则由当前 04 契约主导 |
| `docs/hermes-image-patches-knowledge/01_session-key-slash-amnesia.md` | `1e390bbca394b1914ee35fc47186e0f7c48d21d951cd17c36589db5bfd304643` | 原件迁入私有归档；当前实现回到源码与测试 |
| `docs/hermes-image-patches-knowledge/02_upgrade-redeploy-sop.md` | `a7ec9fafa576d18b841469619558551e8b09468c31312ac189df4244435fb985` | 原件迁入私有归档；当前发布以 T4R 为准 |
| `docs/hermes-image-patches-knowledge/03_hermes1-adapter-provenance.md` | `e91d7b19eeff5f5a6934f6221e49dc1aa92d6819ebd50b9b9ce0bee49fc1c9b1` | 原件迁入私有归档；Kit Git 提交为源码权威 |
| `docs/hermes-image-patches-knowledge/04_dingtalk-reply-quote-and-session-env.md` | `50178862c03f489e46426d18a9159aa2bc4acf5a376a513f8bc121bb756225f1` | 原件迁入私有归档；当前实现回到 Kit/核心源码 |
| `docs/hermes-image-patches-knowledge/05_qwen-thinking-chain-and-diagnosis-fixes.md` | `1eeab2e623332d3d542b87a005203c95589362d5d13af5c2c22d4fa3747e923d` | 原件迁入私有归档；引用的 live 资产另从 H1 只读抓取 |
| `docs/hermes-vision-image-fix/README.md` | `e14260e1af7d0525448e24b368b6496b397ac8489aeb7284e2862e281233531f` | 历史事故证据，不作为当前部署手册 |
| `docs/hermes-vision-image-fix/02_vision-timeout-fallback-401_20260715.md` | `1461683b8ad3aa17d57bae406c736fcfbe08f441dbe0223e5f70e233c924daec` | 历史事故证据；未修上游项保持独立问题 |
| `docs/hermes1-agong-dev-loop_20260707/reports/n9_first_trial_and_fixes_20260714.md` | `11956bffc2278c750b9c8d1a22d857b6b5e49494ebcae590657fc9f6a7e5c8bf` | 历史试运行证据 |
| `docs/hermes1-agong-dev-loop_20260707/reports/n10_mention_meta_and_handoff_guard_20260714.md` | `c5811bb4348c3f238b8543709b8d2c515f6da5ae756e534a688ac8363a51c53a` | 原件归档；mention 与 guard 已回到 Kit/Guardrails 源码 |
| `docs/hermes1-agong-dev-loop_20260707/reports/n11_diagnosis_confabulation_rca_20260715.md` | `251093d7a5b1adc8f4b56309118dd0032de0697db19bc955a9719e1ed75a3503` | 原件归档；tools、SOP、查询脚本另从 H1 抓取 |
| `docs/hermes1-agong-dev-loop_20260707/reports/incident_design_hallucination_rca_20260714.md` | `c657a46cd84f3c06a5bee691a33a62094b005380358605cee020884df96fecae` | 历史事故证据 |
| `docs/hermes1-agong-dev-loop_20260707/reports/t5pc_product_confirmation_rollout_package_20260714.md` | `d5f93b87198ac50b9887a418377bacb53f0187d0d3f8655f94fcf30d244ced76` | 历史行为基线；当前源码以 Kit PR #1 为准 |

## 当前权威映射

- 源码、发布与官方升级：[`workspace-migration_20260714/04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md`](workspace-migration_20260714/04_SOURCE_RELEASE_AND_UPGRADE_POLICY.md)。
- H1 最新稳定 Release 发布记录：[`workspace-migration_20260714/tasks/T4R_release_to_h1.md`](workspace-migration_20260714/tasks/T4R_release_to_h1.md)。
- T4 源码验收：[`workspace-migration_20260714/reviews/R3_t4_source_release_verification.md`](workspace-migration_20260714/reviews/R3_t4_source_release_verification.md)。
- T4R 运行验收：[`workspace-migration_20260714/reviews/R4_t4r_h1_release_verification.md`](workspace-migration_20260714/reviews/R4_t4r_h1_release_verification.md)。

旧文档只回答“当时发生过什么”；任何当前运行结论都必须重新读取 Git、测试、容器与 data 层事实。
