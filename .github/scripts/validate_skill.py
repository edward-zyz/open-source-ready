#!/usr/bin/env python3
"""Minimal skill validator for CI without third-party dependencies."""

from pathlib import Path
import re
import sys


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    skill = root / "SKILL.md"
    if not skill.exists():
        print("SKILL.md not found", file=sys.stderr)
        return 1

    text = skill.read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not match:
        print("Invalid SKILL.md frontmatter", file=sys.stderr)
        return 1

    frontmatter = match.group(1)
    if not re.search(r"^name:\s*open-source-ready\s*$", frontmatter, re.M):
        print("Expected name: open-source-ready", file=sys.stderr)
        return 1
    if not re.search(r"^description:\s*>-", frontmatter, re.M):
        print("Expected folded description", file=sys.stderr)
        return 1

    required = [
        "agents/openai.yaml",
        "scripts/assess.sh",
        "references/checklist.md",
        "references/ci-recipes.md",
        "references/upgrade-guide.md",
        "references/sources.jsonl",
        "assets/CONTRIBUTING.md",
        "assets/CODE_OF_CONDUCT.md",
        "assets/CODEOWNERS",
        "assets/README.md",
        "assets/README.zh-CN.md",
        "assets/SECURITY.md",
        "assets/PULL_REQUEST_TEMPLATE.md",
        "assets/dependabot.yml",
        "assets/ISSUE_TEMPLATE/bug_report.yml",
        "assets/ISSUE_TEMPLATE/feature_request.yml",
        "examples/assessment-sample.md",
        ".github/CODEOWNERS",
    ]
    missing = [item for item in required if not (root / item).exists()]
    if missing:
        print("Missing required files:", file=sys.stderr)
        for item in missing:
            print(f"- {item}", file=sys.stderr)
        return 1

    readme = root / "README.md"
    readme_zh = root / "README.zh-CN.md"
    if not readme.exists() or not readme_zh.exists():
        print("Expected README.md and README.zh-CN.md", file=sys.stderr)
        return 1

    readme_text = readme.read_text(encoding="utf-8")
    readme_zh_text = readme_zh.read_text(encoding="utf-8")
    if "[简体中文](README.zh-CN.md)" not in readme_text:
        print("README.md must link to README.zh-CN.md", file=sys.stderr)
        return 1
    if "[English](README.md)" not in readme_zh_text:
        print("README.zh-CN.md must link to README.md", file=sys.stderr)
        return 1

    print("Skill is valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
