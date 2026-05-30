# Assessment Sample

This is a shortened example of the report shape produced by:

```bash
bash scripts/assess.sh /path/to/repo
```

## Example

```text
════════════════════════════════════════════
 open-source-ready 体检: /path/to/repo
════════════════════════════════════════════

▸ 技术栈
  ✓ Node/JS (package.json)

▸ 法律 (P0)
  ✗ 缺 LICENSE —— 公开后默认保留所有权利，等于没真开源

▸ 社区健康文件 (community profile)
  ✓ README
  ! 缺 README.zh-CN.md（默认建议双 README：英文 README.md + 简体中文 README.zh-CN.md）
  ✗ 缺 CONTRIBUTING（assets/CONTRIBUTING.md）
  ✗ 缺 SECURITY（assets/SECURITY.md）

▸ 工程化信号
  ✓ GitHub Actions CI 存在
  ✗ 未配 Dependabot（assets/dependabot.yml）

▸ 发布前安全清场 (P0 —— 公开前必须做)
  ✓ .gitignore 存在
  ✓ .env 未被跟踪
```

## How to Interpret It

- `✗` marks a gap that should be considered in the upgrade plan.
- `!` marks an advisory item: useful for professional polish, but not always a
  hard blocker.
- P0 items should be resolved before making a private repository public.
- P1 items create visible professionalism: community files, CI, changelog, and
  dependency automation.
- P2 items improve trust posture after the repository is already structurally
  ready.
