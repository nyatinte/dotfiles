#!/bin/bash
# Usage: analyze-conflict.sh
# コンフリクト状態を分析し、解決に必要な情報を収集する

set -e

BRANCH=$(git branch --show-current)
echo "branch: ${BRANCH:-detached}"
echo ""

# コンフリクト状態の判定
echo "=== conflict state ==="
if [ -d "$(git rev-parse --git-dir)/rebase-merge" ] || [ -d "$(git rev-parse --git-dir)/rebase-apply" ]; then
  echo "state: rebase"
elif [ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ]; then
  echo "state: merge"
else
  echo "state: none"
  echo ""
  echo "現在コンフリクトは発生していません"
  exit 0
fi
echo ""

echo "=== git status ==="
git status --short
echo ""

echo "=== conflicted files ==="
CONFLICTED=$(git diff --name-only --diff-filter=U)
if [[ -z "$CONFLICTED" ]]; then
  echo "(no conflicted files)"
  exit 0
fi
echo "$CONFLICTED"
echo ""

echo "=== conflict markers ==="
for file in $CONFLICTED; do
  MARKER_COUNT=$(grep -c '^<<<<<<<' "$file" 2>/dev/null || echo 0)
  echo "$file: $MARKER_COUNT conflict(s)"
done
echo ""

# ブランチ名からissue参照を抽出
REFS=$(echo "${BRANCH:-}" | grep -oE '#[0-9]+|/[0-9]+|-[0-9]+' | grep -oE '[0-9]+' | sort -un | sed 's|^|#|' | tr '\n' ' ')
[[ -n "$REFS" ]] && echo "Refs: $REFS" && echo ""

echo "=== git log -10 ==="
git log --oneline -10
echo ""

echo "=== file change history ==="
for file in $CONFLICTED; do
  echo "--- $file ---"
  git log --oneline -5 --all -- "$file"
  echo ""
done
