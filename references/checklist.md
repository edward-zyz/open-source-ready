# open-source-ready — 私有 repo 开源化执行清单

> 按顺序执行。P0 必须在 `push` 公开**之前**完成；P1/P2 可公开后持续补。
> 详细依据与引用见同目录 `upgrade-guide.md`。

## P0 · 发布前清场（做错有真实损失，不可跳过）
- [ ] 扫描整条 git history 找密钥/敏感信息：`gitleaks detect` 或 `trufflehog git file://. `
- [ ] 发现的密钥**先轮换/吊销**（不要先删提交）
- [ ] 用 `git filter-repo` 或 `BFG Repo-Cleaner` 从 history 移除敏感文件/字符串（先备份）
- [ ] 清引用：`git reflog expire --expire=now --all && git gc --prune=now --aggressive`
- [ ] 复检 history 干净（再跑一次 gitleaks）
- [ ] 检查 issue / PR 评论里有无内部信息
- [ ] `.gitignore` 覆盖 `.env`、本地配置、构建产物、IDE 目录；真实 `.env` → `.env.example`(占位值)
- [ ] 检查 `git log` 作者邮箱（必要时换 GitHub noreply 邮箱）

## P0 · 法律
- [ ] 选许可证（MIT=最宽松默认 / Apache-2.0=带专利条款 / GPL-3.0=copyleft），choosealicense.com 选型
- [ ] 根目录放 `LICENSE`，确认 GitHub 自动识别
- [ ] README/包元数据标注 SPDX identifier（如 `MIT` / `Apache-2.0`）
- [ ] 确认依赖许可与本项目兼容

## P1 · 社区健康文件（community profile 基线）
- [ ] `README.md` + `README.zh-CN.md`：默认双 README；英文主文档顶部链接简体中文，中文文档顶部反链英文；两份文档都覆盖一句话定位、Key Features、Install、Quick Start、Usage、Documentation、Safety and Trust、License + 顶部徽章墙；安装命令、许可证/SPDX、支持渠道保持一致
- [ ] `CONTRIBUTING.md`：报 bug / 提 feature / 环境搭建 / 测试要求
- [ ] `CODE_OF_CONDUCT.md`：采用 Contributor Covenant 2.1（填联系邮箱）
- [ ] `SECURITY.md`：私密漏洞上报渠道 + 支持版本
- [ ] `.github/ISSUE_TEMPLATE/`（bug_report + feature_request，YAML form）
- [ ] `.github/PULL_REQUEST_TEMPLATE.md`（含 checklist）
- [ ] （可选）`.github/CODEOWNERS`、`GOVERNANCE.md`/`MAINTAINERS.md`、`FUNDING.yml`
- [ ] 核对 Insights → Community Standards 全绿

## P1 · 工程化与专业感证据
- [ ] GitHub Actions：PR 跑 lint + test (+ build)，README 挂 build 徽章
- [ ] workflow 安全：`GITHUB_TOKEN` 最小权限 + 第三方 action pin 到 SHA
- [ ] shields.io 徽章：build / coverage / license / version
- [ ] lint + formatter 强制（ESLint/Prettier · ruff/black · gofmt/golangci-lint）
- [ ] `pre-commit` hooks + `.editorconfig`
- [ ] 测试 + 覆盖率徽章
- [ ] 开启 Dependabot（version + security updates）
- [ ] 公开后开 secret scanning + push protection

## P1 · 版本与发布
- [ ] 采用 SemVer（MAJOR.MINOR.PATCH）
- [ ] 提交用 Conventional Commits（feat/fix/feat!）
- [ ] `CHANGELOG.md` 遵循 Keep a Changelog
- [ ] semantic-release / release-please 在 CI 自动定版本+changelog+tag+Release
- [ ] （库）发布到 npm / PyPI / pkg.go.dev，挂 version + 下载量徽章

## P2 · 安全姿态量化背书
- [ ] 默认分支启用 branch protection（要求 review + CI 通过 + 分支最新）
- [ ] 接入 OpenSSF Scorecard（GitHub Action），README 挂 Scorecard 徽章，逐项修复
- [ ] bestpractices.dev 自评，争取 OpenSSF Best Practices passing 徽章
- [ ] （进阶）配 GPG / Sigstore 签名提交，commit 显示 Verified

---
### 最高性价比优先级（时间有限时）
1. 清场（P0 安全）→ 2. LICENSE → 3. 一条绿色 CI → 4. README 徽章墙 → 5. SemVer+CHANGELOG+Release → 6. community health files → 7. Scorecard/Best Practices Badge
