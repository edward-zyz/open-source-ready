---
name: open-source-ready
description: >-
  把一个私有/个人 repo 升级成专业、可信、"看起来启动成本很高"的开源 GitHub
  项目。覆盖发布前安全清场（git 历史密钥扫描+轮换+重写）、法律（LICENSE/SPDX）、
  社区健康文件（README.md 英文主文档 + README.zh-CN.md 简体中文文档、CONTRIBUTING/CODE_OF_CONDUCT/SECURITY/issue+PR 模板）、
  工程化信号（CI 徽章/lint/pre-commit/Dependabot）、版本与发布（SemVer/Conventional
  Commits/CHANGELOG/自动 Release）、安全姿态背书（OpenSSF Scorecard/分支保护）。
  工作方式是 plan-first：先给这个具体 repo 做差距分析并产出有序升级方案、用户确认后再逐项执行；
  破坏性步骤（重写 git 历史）必须先确认。只要用户想"开源/公开这个项目"、"把 repo
  发到 GitHub 上"、"让这个项目看起来更专业/正规"、"open source this"、"make this
  repo public"、"publish to GitHub"、"准备开源发布"，即使没点名本 skill，也应触发。
  涉及把私有代码转公开、给项目补 LICENSE/README/CI/社区文件、做开源前的密钥清理时，优先用本 skill。
---

# open-source-ready — 私有 repo → 专业开源 repo

## 这个 skill 在做什么

把"能跑的个人项目"升级成"经得起公开审视的开源项目"。难点不在写文件，而在两件容易做错的事：

1. **顺序**——唯一会造成真实损失的是发布前没清干净 git 历史里的密钥/内部信息。门面可以慢慢补，泄露无法撤回。所以**安全清场（P0）必须在 repo 转公开/push 之前完成**。
2. **一致性**——"专业感"是一组互相印证的信号（法律清晰 + 贡献路径清晰 + 工程纪律可见 + 安全姿态可量化）。缺一项不致命，但**矛盾**最暴露业余（华丽 README 却没 LICENSE、有徽章却红色 CI）。先保证自洽，再加厚。

完整的依据、引用与六维度详解在 `references/upgrade-guide.md`；可勾选执行清单在 `references/checklist.md`。本文件是**工作流入口**，按下面的流程走。

## 工作流：plan-first，再分阶段执行

### 阶段 A — 体检 + 出方案（动手改之前必做）

1. **跑体检脚本**拿到这个 repo 的现状差距，而不是凭印象：
   ```bash
   bash scripts/assess.sh [repo根目录，默认当前目录]
   ```
   它会探测技术栈、列出已有/缺失的社区文件、CI、版本/tag 状态，并对 **git 历史里的密钥风险**做一次快速扫描（有 `gitleaks` 则用，没有则退化为内置正则）。

2. **读 `references/upgrade-guide.md`** 校准六维度基线（清场 / 法律 / 社区 / 工程化 / 版本 / 背书）。

3. **产出一份针对这个 repo 的有序升级方案**给用户确认，而不是直接开干。方案要：
   - 按 **P0 → P1 → P2** 优先级排（P0=清场+法律，必须先做；P1=社区+工程化+版本；P2=安全背书）。
   - 明确标出**这个 repo 缺什么、已有什么**（来自体检脚本），只做缺的，已有的不动（外科手术式，别"顺手重写"人家已有的 README/CI）。
   - 标出**破坏性/不可逆步骤**（重写历史、改默认分支保护），这些要单独确认。
   - 给出"今天就能发的最小集"和"完整专业集"两档，让用户选投入程度（见 upgrade-guide 的"两档落地方案"）。

> 用户确认方案后再进入阶段 B。如果用户只想要方案不想执行，到这里就停。

### 阶段 B — 分阶段执行（每阶段做完报告，再进下一阶段）

按确认后的方案逐阶段做。关键阶段的执行要点：

**B0 · 安全清场（P0，硬门槛，公开前必须完成）**

这是唯一"做错有真实损失"的阶段，照 `references/checklist.md` 的 P0 段逐条做。铁律：

- **先轮换，再删历史**。发现密钥时第一步是吊销/轮换那个密钥（公开前它可能已被抓取），**不是**先删提交。
- **重写历史前必须显式确认**。用 `git filter-repo` 或 BFG 重写历史会改写所有 commit hash、影响协作者、不可逆——动手前先 `git clone --mirror` 备份，并向用户说清后果、取得明确同意。
- 重写后清引用（`reflog expire` + `gc --prune`）并复扫确认干净。
- 把真实 `.env` 换成 `.env.example`（占位值），`.gitignore` 补齐 `.env`/构建产物/IDE 目录。
- repo 转公开后立刻开 secret scanning + push protection（公开 repo 免费）。

**B1 · 法律（P0）**

- 选许可证（MIT=最宽松默认 / Apache-2.0=带专利条款 / GPL-3.0=copyleft），不确定就问用户用途。生成根目录 `LICENSE`（填好年份+版权人），README 标注 SPDX id。
- 确认依赖许可与所选许可兼容。

**B2 · 社区健康文件（P1）**

直接从 `assets/` 拷模板填占位符，不要从零写——写一次复用：

| 目标文件 | 模板 | 填什么 |
|---|---|---|
| `README.md` | `assets/README.md` | 英文主文档、徽章墙、定位、安装、快速开始、文档链接、安全边界、许可证 |
| `README.zh-CN.md` | `assets/README.zh-CN.md` | 简体中文文档，命令/链接/许可证与英文版保持一致 |
| `CONTRIBUTING.md` | `assets/CONTRIBUTING.md` | 项目名、环境搭建命令、测试命令、PR 流程 |
| `CODE_OF_CONDUCT.md` | `assets/CODE_OF_CONDUCT.md`（Contributor Covenant 2.1 原文） | 联系邮箱 |
| `SECURITY.md` | `assets/SECURITY.md` | 私密上报邮箱、支持版本 |
| `.github/PULL_REQUEST_TEMPLATE.md` | `assets/PULL_REQUEST_TEMPLATE.md` | 一般无需改 |
| `.github/ISSUE_TEMPLATE/bug_report.yml` | `assets/ISSUE_TEMPLATE/bug_report.yml` | 项目名 |
| `.github/ISSUE_TEMPLATE/feature_request.yml` | `assets/ISSUE_TEMPLATE/feature_request.yml` | — |
| `.github/CODEOWNERS` | `assets/CODEOWNERS` | 默认维护者或核心 review 负责人 |
| `.editorconfig` | `assets/.editorconfig` | 按栈微调缩进 |
| `.github/dependabot.yml` | `assets/dependabot.yml` | 按栈选 package-ecosystem |

README 是门面：默认生成**双 README**，除非用户明确要求单语。GitHub 惯例是 `README.md` 作为英文主文档，顶部放 `English | [简体中文](README.zh-CN.md)`；`README.zh-CN.md` 作为简体中文文档，顶部放 `[English](README.md) | 简体中文`。两份文档都至少覆盖：一句话定位、Key Features、Install、Quick Start、Usage、Documentation、Safety and Trust、License。顶部徽章墙放在两份文档中，徽章与命令保持语言无关。可叠加 `add-badges`、`readme-generator` 两个已装 skill 加速，但要检查两份 README 的安装命令、许可证/SPDX、支持渠道和安全边界一致。

专业感来自“能立即判断能不能用”：README 顶部应有一句清楚的定位、3-6 个真实 key features、最短安装路径、一个可复制的 quick start、仓库结构或资源索引、明确的安全承诺。不要堆口号；每个 claims 都要能在文件、脚本或 workflow 中找到对应证据。

**B3 · 工程化信号（P1，最高性价比）**

- **CI 绿勾**是工程成熟度最强的单一信号。按技术栈从 `references/ci-recipes.md` 取对应 GitHub Actions 配方（Node/Python/Go），跑 lint+test，README 挂 build 徽章。workflow 安全细节：`GITHUB_TOKEN` 设最小权限、第三方 action pin 到 commit SHA（同时拉高 Scorecard 分）。
- lint+formatter 在 CI 强制；可选 `pre-commit` hooks。
- 开 Dependabot（上面模板）。

**B4 · 版本与发布（P1）**

- 采用 SemVer + Conventional Commits（`feat:`/`fix:`/`feat!:`）。
- 维护 `CHANGELOG.md`（Keep a Changelog 格式），理想由 semantic-release / release-please 在 CI 自动生成 + 打 tag + 建 GitHub Release。
- 打出第一个 SemVer tag 与 Release——规范的版本线是"产品级"信号。

**B5 · 安全姿态背书（P2，可信度天花板）**

- 默认分支开 branch protection（要求 review + CI 通过）。
- 接入 OpenSSF Scorecard（GitHub Action）挂徽章，逐项修复低分项（常见 0 分：未配分支保护、未签名提交、action 用可变 tag 未 pin）。
- 进阶：bestpractices.dev 自评争取 passing 徽章；配 GPG/Sigstore 签名提交让 commit 显示 Verified。

## 护栏（务必遵守）

- **绝不在 P0 清场完成前把 repo 转公开或 push 到公开 remote。** 顺序就是风险管理。
- **任何重写 git 历史 / 改分支保护 / 删历史的操作，执行前单独取得用户确认，并先备份。** 这些不可逆。
- **只做缺的。** 体检脚本说已有的（README/CI/LICENSE 等），默认不覆盖、不"顺手优化"，除非用户要求。匹配 repo 现有风格。
- **栈相关的东西按实际栈来**，别假定语言。CI/lint/Dependabot 配置随 `package.json`/`pyproject.toml`/`go.mod` 等而定。

## 文件索引

- `references/upgrade-guide.md` — 六维度完整调研报告 + 引用 + 两档方案（动手前读，校准基线）
- `references/checklist.md` — P0→P2 可勾选执行清单（执行阶段照着做）
- `references/ci-recipes.md` — Node/Python/Go 的 GitHub Actions CI 配方
- `references/sources.jsonl` — 28 条权威来源登记
- `scripts/assess.sh` — repo 现状差距体检（阶段 A 第一步跑）
- `assets/` — 可直接拷贝填占位的社区文件/配置模板
