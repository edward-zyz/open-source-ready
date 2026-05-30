# Contributing to {{PROJECT_NAME}}

Thanks for taking the time to contribute! This document explains how to get set up and what to expect.

## Ways to contribute

- **Report a bug** — open an issue using the Bug report template. Include steps to reproduce, what you expected, and what actually happened.
- **Request a feature** — open an issue using the Feature request template and describe the use case.
- **Submit code** — see below.

## Development setup

```bash
# {{FILL: clone + install + run, e.g.}}
git clone https://github.com/{{OWNER}}/{{PROJECT_NAME}}.git
cd {{PROJECT_NAME}}
{{INSTALL_CMD}}     # e.g. npm install / pip install -e ".[dev]" / go mod download
{{TEST_CMD}}        # e.g. npm test / pytest / go test ./...
```

## Pull request process

1. Fork the repo and create your branch from `main` (`git checkout -b feat/short-description`).
2. Make your change. Keep it focused — one logical change per PR.
3. Add or update tests; make sure `{{TEST_CMD}}` and `{{LINT_CMD}}` pass locally.
4. Use [Conventional Commits](https://www.conventionalcommits.org/) for your commit messages
   (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`; `feat!:` or a `BREAKING CHANGE:`
   footer for breaking changes). This drives automated versioning and the changelog.
5. Open the PR, fill in the template, and link any related issue.

CI must be green and at least one maintainer review is required before merge.

## Code style

Run the formatter/linter before pushing:

```bash
{{LINT_CMD}}    # e.g. npm run lint / ruff check . / golangci-lint run
```

## Reporting security issues

Please **do not** open public issues for security vulnerabilities. See [SECURITY.md](SECURITY.md).

## Code of Conduct

This project follows a [Code of Conduct](CODE_OF_CONDUCT.md). By participating you agree to uphold it.
