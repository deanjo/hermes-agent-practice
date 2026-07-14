---
status: current
applies_when: "完成任一迁移阶段、准备提交代码、创建上游 PR 或删除旧资产前"
not_for: "用反复 review 扩大业务范围；把 Minor 建议变成无限优化；替代 acceptance matrix"
current_authority: contract-current
supersedes: []
superseded_by: []
---

# Review 与完成门禁

## 第一阶段门禁

第一阶段不做代码 review，也不启用 subagent。主 Agent 只验证：

1. 目录与固定文档是否齐全。
2. 每个 docs 目录是否有唯一 `README.md`。
3. 每个 `docs/**/*.md` 是否包含六个 frontmatter 字段。
4. 新工作区及 Practice 是否没有 `.git`。
5. `sources/` 是否仍未 clone 源码。
6. 旧目录、GitHub 和远程 H1/H3 是否未被本阶段修改。

第一阶段证据记录：

```text
as_of=2026-07-14 14:56-15:00 +08
result=A01-A06 LOCAL_PASS
implementation_scope=new workspace files only
workspace_files=20
docs_markdown=12
docs_directories=3
docs_directories_missing_README=0
frontmatter_errors=0
broken_relative_links=0
parent_git=absent
source_non_readme_files=0
source_clone=not performed
github_write=not performed
remote_write=not performed
legacy_delete=not performed
legacy_docs_files_before_after=596/596
legacy_docs_markdown_before_after=335/335
legacy_hermes_head_before_after=6c54789953cf/6c54789953cf
dingtalk_kit_head_before_after=f4e781651df7/f4e781651df7
h1_image_before_after=hermes-agent:dingtalk-kit-h1-hermes-v0.18.0-pc-b8200e4ba-20260714/same
h1_started_before_after=2026-07-14T04:04:57.139661091Z/same
h3_image_before_after=hermes-agent:dingtalk-kit-h3-hermes-v0.18.0-t11-20260707210056/same
h3_started_before_after=2026-07-08T09:10:16.506671846Z/same
user_acceptance=confirmed_20260714
```

## Multi-agent 编排门禁

- T2、T3 的写操作由主 Agent 串行执行；subagent 只能提供只读复核，不能与主 Agent 同时改共享 worktree、remote 或 GitHub 仓库。
- T4 最多启动三个 worker，固定为 T21、Product、T5v；每个 worker 只写一个仓库，禁止派生子 Agent。
- T5 可按旧 docs 的互斥目录分区盘点，但 canonical（权威）分类表、README 和最终移动由主 Agent统一写入。
- subagent 使用有限任务上下文，不接收整段会话；输出上限约 60 行，只含结论、证据锚点、修改文件、测试和阻塞点。
- 如果两个任务需要修改同一个仓库，后一个改为串行；当前明确案例是 T5v 的可选 `agent/tool_guardrails.py` 核心补丁必须等 T21 完成后再处理。

## T2 独立复核

- Record：[reviews/R1_t2_archive_verification.md](reviews/R1_t2_archive_verification.md)
- Roll-up：`CLEARED`，Critical=0、Important=0、Minor=1。
- Minor 是 `checksums.txt` 混入说明行；主 Agent 已改为纯 SHA256 清单，随后直接执行 `shasum -a 256 -c checksums.txt`，6/6 OK。
- 删除后证据：源 worktree 路径已不存在、worktree 登记已移除、退役分支仍指向 `c2b7669ad3dd...`、桌面归档仍 6/6 校验通过。
- H1/H3 镜像和启动时间与 T2 前一致，T2 未修改远程运行态。

## 后续实现门禁

每个代码任务最多进行一轮独立 Design Drift + Code Review 合并审阅，输入必须包含：

- 当前 task 与 acceptance 行。
- changed files 或 diff。
- 实际运行的测试及结果。
- 明确的非目标和停止条件。

Critical、Important 必须为零；Minor 修复或记录裁决后停止，不追加无关治理。

## 最终完成定义

1. 实现者先完成最小有效测试和 Git diff 检查。
2. 独立 reviewer 给出带文件锚点的结论。
3. 主 Agent逐行更新验收矩阵，不把局部测试写成全链路 PASS。
4. 记录未验证范围、GitHub URL、上游 PR、旧资产归档和回滚方式。
5. 只有 A01-A14 全部 PASS 或经证据判定 NOT_APPLICABLE，才能删除旧顶层。

## 停止 review 的条件

- Critical、Important 已清零。
- 剩余内容只是命名偏好、未来增强或非当前 contract 场景。
- reviewer 连续提出超出 task 的新范围；此时记录为后续事项，不继续消耗当前任务。
