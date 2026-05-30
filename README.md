# Open Source Ready

English | [简体中文](README.zh-CN.md)

[![Validate](https://github.com/edward-zyz/open-source-ready/actions/workflows/validate.yml/badge.svg)](https://github.com/edward-zyz/open-source-ready/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-v0.1.0-blue.svg)](CHANGELOG.md)

An agent skill for getting private or personal repositories ready for a
professional open-source launch.

Open Source Ready is intentionally plan-first. It audits a repository, separates
blocking release risks from polish work, and produces a staged P0/P1/P2 upgrade
plan before making changes. It is built for safety-sensitive release work:
secrets, git history rewrites, license clarity, community health files, CI,
versioning, and security posture.

## Key Features

- **Release readiness audit**: checks license, README, community files, CI,
  Dependabot, changelog, tags, `.gitignore`, tracked `.env` files, and obvious
  secret patterns.
- **Safety-first workflow**: treats secret rotation, history rewrites, public
  pushes, and branch protection changes as explicit confirmation points.
- **Professional repo templates**: includes bilingual README templates,
  contribution/security/conduct docs, issue forms, PR template, Dependabot, and
  CI recipes.
- **Bilingual by default**: uses `README.md` as the English primary document and
  `README.zh-CN.md` as the Simplified Chinese document.
- **Agent-neutral design**: works as a readable skill folder for local coding
  agents with filesystem and shell access.

## Install

Copy this repository into the skills directory used by your agent runtime:

```bash
SKILLS_DIR=/path/to/your/agent/skills
mkdir -p "$SKILLS_DIR"
git clone https://github.com/edward-zyz/open-source-ready.git "$SKILLS_DIR/open-source-ready"
```

Then start a new agent session or reload skills if your runtime supports manual
skill refresh.

## Quick Start

Run a read-only assessment against any repository:

```bash
bash scripts/assess.sh /path/to/repo
```

Use it through an agent:

```text
Use $open-source-ready to assess this repo and prepare it for open-source release.
```

Natural prompts should also work:

```text
I want to make this repo public on GitHub. First assess the risks and give me a plan.
```

## What the Skill Does

The skill follows a staged workflow:

1. **Assess** the repository with `scripts/assess.sh`.
2. **Plan** P0/P1/P2 work before editing files.
3. **Gate destructive steps** such as git history rewrites or branch protection
   changes behind explicit confirmation.
4. **Fill only the gaps** instead of overwriting existing project-specific docs.
5. **Validate** the result with the same checks used by this repository.

## Included Resources

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

## Example Output

See [examples/assessment-sample.md](examples/assessment-sample.md) for the shape
of an assessment report and how to interpret P0/P1/P2 findings.

## Agent Compatibility

This repository is intentionally plain files plus shell/Python validation. An
agent can use it in three ways:

- Read `SKILL.md` directly for the current session.
- Install the whole folder into its local skills directory.
- Copy individual templates from `assets/` into a target repository during an
  open-source readiness pass.

No hosted service or package registry is required.

## Safety Model

Open Source Ready treats publication as a risk-management workflow:

- Do not make a private repository public before P0 cleanup is complete.
- Rotate or revoke exposed secrets before deleting them from history.
- Confirm history rewrites separately because they change commit hashes.
- Prefer a new clean repository when extracting a skill or package from a
  private monorepo.
- Keep existing project files unless the assessment shows they are missing or
  the user asks for replacement.

## Validation

Run the local validation commands:

```bash
python3 .github/scripts/validate_skill.py .
bash -n scripts/assess.sh
bash scripts/assess.sh .
```

The GitHub Actions workflow runs the same core checks on pull requests and
pushes to `main`.

## Roadmap

- Optional Scorecard workflow template.
- Optional release automation recipe for tagged skill releases.
- More ecosystem-specific CI and Dependabot examples.

## Author

- X: [@Edwardzyzt](https://x.com/Edwardzyzt)

## License

MIT
