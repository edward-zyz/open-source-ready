# Contributing to Open Source Ready

Thanks for taking the time to contribute.

## Development Setup

```bash
git clone https://github.com/edward-zyz/open-source-ready.git
cd open-source-ready
bash -n scripts/assess.sh
bash scripts/assess.sh /tmp
python3 .github/scripts/validate_skill.py .
```

## Pull Request Process

1. Create a focused branch from `main`.
2. Keep one logical change per pull request.
3. Update `README.md`, `SKILL.md`, or references when behavior changes.
4. Run the validation commands locally.
5. Use Conventional Commits such as `feat:`, `fix:`, `docs:`, `test:`, or `chore:`.

## What Good Changes Look Like

- They keep the skill plan-first and safe by default.
- They do not automate destructive operations without explicit confirmation.
- They preserve the split bilingual README expectation: English in
  `README.md`, Simplified Chinese in `README.zh-CN.md`.
- They keep `SKILL.md` concise and move detailed material into `references/`.

## Security Issues

Please do not report security vulnerabilities through public issues. See
`SECURITY.md`.

## Code of Conduct

This project follows `CODE_OF_CONDUCT.md`.
