# Open Source Ready

[English](README.md) | 简体中文

[![Validate](https://github.com/edward-zyz/open-source-ready/actions/workflows/validate.yml/badge.svg)](https://github.com/edward-zyz/open-source-ready/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-v0.1.0-blue.svg)](CHANGELOG.md)

一个帮助私有或个人仓库做好专业开源发布准备的通用 agent skill。

Open Source Ready 默认采用 plan-first 工作方式：先体检仓库，把真正阻塞发布的风险和后续润色工作分开，再输出 P0/P1/P2 分阶段升级方案，用户确认后才进入执行。它专注于开源发布前最容易出问题的环节：密钥、git 历史重写、许可证、社区健康文件、CI、版本发布和安全姿态。

## 核心能力

- **发布就绪体检**：检查许可证、README、社区文件、CI、Dependabot、CHANGELOG、tag、`.gitignore`、被跟踪的 `.env` 文件和明显密钥模式。
- **安全优先流程**：把密钥轮换、历史重写、公开 push、分支保护调整都视为需要明确确认的步骤。
- **专业仓库模板**：内置双 README、贡献指南、安全策略、行为准则、issue 表单、PR 模板、Dependabot 和 CI 配方。
- **默认双语**：`README.md` 是英文主文档，`README.zh-CN.md` 是简体中文文档。
- **agent 中立**：以普通文件夹形式提供，适合具备文件系统和 shell 能力的本地 coding agent 使用。

## 安装

把本仓库复制到你的 agent runtime 使用的 skills 目录：

```bash
SKILLS_DIR=/path/to/your/agent/skills
mkdir -p "$SKILLS_DIR"
git clone https://github.com/edward-zyz/open-source-ready.git "$SKILLS_DIR/open-source-ready"
```

然后开启新的 agent 会话，或在支持手动刷新的运行环境中重新加载 skills。

## 快速开始

对任意仓库运行只读体检：

```bash
bash scripts/assess.sh /path/to/repo
```

通过 agent 使用：

```text
Use $open-source-ready to assess this repo and prepare it for open-source release.
```

也可以自然表达：

```text
我想把这个仓库公开到 GitHub。先帮我评估风险并给出方案。
```

## 工作方式

这个 skill 按阶段推进：

1. 用 `scripts/assess.sh` 体检仓库。
2. 在修改文件前先规划 P0/P1/P2 工作。
3. 对 git 历史重写、分支保护调整等破坏性步骤单独确认。
4. 只补缺口，不覆盖已有项目文档。
5. 用本仓同款验证检查结果。

## 内置资源

```text
.
├── SKILL.md
├── agents/
│   └── runtime metadata
├── assets/
│   ├── README.md
│   ├── README.zh-CN.md
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   ├── SECURITY.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── dependabot.yml
│   └── ISSUE_TEMPLATE/
├── examples/
│   └── assessment-sample.md
├── references/
│   ├── checklist.md
│   ├── ci-recipes.md
│   ├── sources.jsonl
│   └── upgrade-guide.md
└── scripts/
    └── assess.sh
```

## 示例输出

查看 [examples/assessment-sample.md](examples/assessment-sample.md)，了解体检报告的大致形态以及如何解读 P0/P1/P2 结果。

## Agent 兼容性

本仓刻意保持为普通文件 + shell/Python 验证。agent 可以通过三种方式使用：

- 在当前会话中直接读取 `SKILL.md`。
- 把整个文件夹安装到本地 skills 目录。
- 在开源发布准备过程中，把 `assets/` 中的模板复制到目标仓库。

无需托管服务或包注册表。

## 安全模型

Open Source Ready 把开源发布当作风险管理流程：

- P0 清场完成前，不要把私有仓库转公开。
- 发现泄露密钥时，先轮换或吊销，再从历史中删除。
- 重写历史必须单独确认，因为它会改变 commit hash。
- 从私有 monorepo 抽取 skill 或包时，优先使用新的干净仓库。
- 只补缺失项；已有文件默认不覆盖，除非用户明确要求。

## 验证

运行本地验证命令：

```bash
python3 .github/scripts/validate_skill.py .
bash -n scripts/assess.sh
bash scripts/assess.sh .
```

GitHub Actions 会在 pull request 和推送到 `main` 时运行同样的核心检查。

## Roadmap

- 可选的 Scorecard workflow 模板。
- tagged skill release 的自动发布配方。
- 更多生态的 CI 和 Dependabot 示例。

## 作者

- X: [@Edwardzyzt](https://x.com/Edwardzyzt)

## 许可证

MIT
