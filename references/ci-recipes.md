# GitHub Actions CI Recipes

Use this file only after `scripts/assess.sh` identifies the repo stack. Start
from the closest recipe, then adapt commands to the repo's actual package
manager, test runner, and default branch.

## Security defaults

- Set `permissions: contents: read` by default; add narrower write permissions
  only when release automation needs them.
- Pin third-party actions to commit SHA before merging a public-facing workflow.
  During drafting, tags are acceptable for readability; the final PR should use
  immutable SHAs.
- Keep secrets out of PR workflows from forks. Use `pull_request`, not
  `pull_request_target`, unless the workflow is deliberately designed for it.
- Make lint/test/build fail fast and visible. A red badge is worse than no badge.

## Node / JavaScript / TypeScript

Use when the repo has `package.json`.

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<PINNED_SHA>
      - uses: actions/setup-node@<PINNED_SHA>
        with:
          node-version: "20"
          cache: "npm"
      - run: npm ci
      - run: npm run lint --if-present
      - run: npm test -- --passWithNoTests
      - run: npm run build --if-present
```

Adjust for package managers:

- npm: `npm ci`, cache `npm`
- pnpm: `corepack enable && pnpm install --frozen-lockfile`, cache `pnpm`
- yarn: `corepack enable && yarn install --immutable`, cache `yarn`

## Python

Use when the repo has `pyproject.toml`, `setup.py`, or `requirements.txt`.

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<PINNED_SHA>
      - uses: actions/setup-python@<PINNED_SHA>
        with:
          python-version: "3.12"
          cache: "pip"
      - run: python -m pip install --upgrade pip
      - run: |
          if [ -f pyproject.toml ]; then
            python -m pip install -e ".[dev]"
          elif [ -f requirements.txt ]; then
            python -m pip install -r requirements.txt
          fi
      - run: ruff check . || true
      - run: pytest
```

Remove `|| true` after the repo has ruff configured. For mature repos, fail on
lint immediately.

## Go

Use when the repo has `go.mod`.

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<PINNED_SHA>
      - uses: actions/setup-go@<PINNED_SHA>
        with:
          go-version-file: "go.mod"
          cache: true
      - run: go test ./...
      - run: go vet ./...
```

## README badges

Use the real owner/repo and workflow filename:

```markdown
[![CI](https://github.com/{{OWNER}}/{{REPO}}/actions/workflows/ci.yml/badge.svg)](https://github.com/{{OWNER}}/{{REPO}}/actions/workflows/ci.yml)
```

Add license/version/coverage badges only after the corresponding source of truth
exists, so the badge wall stays accurate.
