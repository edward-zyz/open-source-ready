#!/usr/bin/env bash
# open-source-ready · repo 体检：探测技术栈 + 列出开源化差距 + 快速密钥风险扫描。
# 用法: bash assess.sh [repo根目录，默认当前目录]
# 只读，不修改任何文件。退出码恒为 0（体检报告，不当作 gate）。
set -uo pipefail

ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "✗ 目录不存在: $ROOT"; exit 0; }

ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
miss() { printf '  \033[31m✗\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }

have() { [ -e "$1" ] || [ -e ".github/$1" ] || [ -e "docs/$1" ]; }
# community profile 文件允许放 根 / .github / docs 三处

echo "════════════════════════════════════════════"
echo " open-source-ready 体检: $(pwd)"
echo "════════════════════════════════════════════"

# ── 技术栈探测 ──────────────────────────────
echo ""
echo "▸ 技术栈"
STACK=""
[ -f package.json ]   && { STACK="$STACK node";   ok "Node/JS (package.json)"; }
[ -f pyproject.toml ] || [ -f setup.py ] || [ -f requirements.txt ] && { STACK="$STACK python"; ok "Python"; }
[ -f go.mod ]         && { STACK="$STACK go";     ok "Go (go.mod)"; }
[ -f Cargo.toml ]     && { STACK="$STACK rust";   ok "Rust (Cargo.toml)"; }
[ -f pom.xml ] || [ -f build.gradle ] && { STACK="$STACK jvm"; ok "JVM (maven/gradle)"; }
[ -z "$STACK" ] && warn "未识别出主流栈（CI/lint/Dependabot 需手动定）"

# ── 法律 (P0) ───────────────────────────────
echo ""
echo "▸ 法律 (P0)"
if have LICENSE || have LICENSE.md || have LICENSE.txt || have COPYING; then ok "LICENSE 存在"; else miss "缺 LICENSE —— 公开后默认保留所有权利，等于没真开源"; fi

# ── 社区健康文件 (P1) ───────────────────────
echo ""
echo "▸ 社区健康文件 (community profile)"
have README.md || have README   && ok "README"     || miss "缺 README"
[ -f README.zh-CN.md ] && ok "README.zh-CN" || warn "缺 README.zh-CN.md（默认建议双 README：英文 README.md + 简体中文 README.zh-CN.md）"
have CONTRIBUTING.md             && ok "CONTRIBUTING" || miss "缺 CONTRIBUTING（assets/CONTRIBUTING.md）"
have CODE_OF_CONDUCT.md          && ok "CODE_OF_CONDUCT" || miss "缺 CODE_OF_CONDUCT（assets/CODE_OF_CONDUCT.md = Contributor Covenant 2.1）"
have SECURITY.md                 && ok "SECURITY"   || miss "缺 SECURITY（assets/SECURITY.md）"
[ -d .github/ISSUE_TEMPLATE ]    && ok "issue 模板" || miss "缺 .github/ISSUE_TEMPLATE/"
[ -f .github/PULL_REQUEST_TEMPLATE.md ] || [ -f .github/pull_request_template.md ] && ok "PR 模板" || miss "缺 .github/PULL_REQUEST_TEMPLATE.md"
[ -f .github/CODEOWNERS ] || [ -f CODEOWNERS ] && ok "CODEOWNERS" || warn "无 CODEOWNERS（可选，但加分）"

# ── 工程化 (P1) ─────────────────────────────
echo ""
echo "▸ 工程化信号"
if [ -d .github/workflows ] && find .github/workflows -maxdepth 1 -type f \( -name '*.yml' -o -name '*.yaml' \) | grep -q .; then ok "GitHub Actions CI 存在"; else miss "缺 CI —— 一条绿色 build 勾是工程成熟度最强信号（references/ci-recipes.md）"; fi
[ -f .editorconfig ]          && ok ".editorconfig" || warn "无 .editorconfig（零成本细节，assets/.editorconfig）"
[ -f .pre-commit-config.yaml ] && ok "pre-commit"   || warn "无 pre-commit（可选）"
[ -f .github/dependabot.yml ] || [ -f .github/dependabot.yaml ] && ok "Dependabot" || miss "未配 Dependabot（assets/dependabot.yml）"

# ── 版本与发布 (P1) ─────────────────────────
echo ""
echo "▸ 版本与发布"
if git rev-parse --git-dir >/dev/null 2>&1; then
  TAGS=$(git tag 2>/dev/null | wc -l | tr -d ' ')
  [ "$TAGS" -gt 0 ] && ok "有 $TAGS 个 git tag" || miss "无任何 tag —— 无版本线一眼'个人玩具'（SemVer + Release）"
  have CHANGELOG.md && ok "CHANGELOG" || miss "缺 CHANGELOG（Keep a Changelog 格式）"
else
  warn "当前目录不是 git 仓库"
fi

# ── 安全清场 (P0) ───────────────────────────
echo ""
echo "▸ 发布前安全清场 (P0 —— 公开前必须做)"
[ -f .gitignore ] && ok ".gitignore 存在" || miss "缺 .gitignore"
if git rev-parse --git-dir >/dev/null 2>&1; then
  if git ls-files 2>/dev/null | grep -qE '(^|/)\.env($|\.)' ; then
    miss ".env 当前被 git 跟踪 —— 必须移出并加 .gitignore"
  else
    ok ".env 未被跟踪"
  fi
  # history 里是否出现过 .env
  if git log --all --pretty=format: --name-only --diff-filter=A 2>/dev/null | grep -qE '(^|/)\.env($|\.)'; then
    miss "git 历史中出现过 .env —— 需重写历史清除（先轮换密钥）"
  fi
fi

echo ""
echo "▸ 密钥扫描"
if command -v gitleaks >/dev/null 2>&1; then
  if gitleaks detect --no-banner --redact -v >/tmp/p2g_gitleaks.log 2>&1; then
    ok "gitleaks: 工作区+历史无 finding"
  else
    miss "gitleaks 发现疑似密钥 —— 详见 /tmp/p2g_gitleaks.log，先轮换再重写历史"
  fi
else
  warn "未装 gitleaks，退化为内置正则快扫（建议 brew install gitleaks 做权威扫描）"
  HITS=$(git grep -nE \
    'AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|(api[_-]?key|secret|token|password)["'"'"']?\s*[:=]\s*["'"'"'][^"'"'"']{8,}' \
    $(git rev-list --all 2>/dev/null) 2>/dev/null | head -20)
  if [ -n "$HITS" ]; then
    miss "内置正则在历史中命中疑似密钥（前 20 条，可能含误报）："
    echo "$HITS" | sed 's/^/      /'
  else
    ok "内置正则未在历史中命中明显密钥（不等于绝对干净，权威扫描用 gitleaks）"
  fi
fi

echo ""
echo "════════════════════════════════════════════"
echo " ✗ = 缺口需补  ! = 可选/提醒  ✓ = 已具备"
echo " 下一步：据此产出 P0→P2 有序方案给用户确认（见 SKILL.md 阶段 A）"
echo "════════════════════════════════════════════"
