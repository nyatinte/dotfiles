#!/bin/bash
# Usage: analyze-git-diff.sh [--no-diff]

set -e

NO_DIFF=false
[[ "${1:-}" == "--no-diff" ]] && NO_DIFF=true

BRANCH=$(git branch --show-current)
echo "branch: ${BRANCH:-detached}"
echo ""

echo "=== git status ==="
git status --short
echo ""

REFS=$(echo "${BRANCH:-}" | grep -oE '#[0-9]+|/[0-9]+|-[0-9]+' | grep -oE '[0-9]+' | sort -un | sed 's|^|#|' | tr '\n' ' ')
[[ -n "$REFS" ]] && echo "Refs: $REFS" && echo ""

if ! git diff --cached --quiet; then
	echo "=== staged (to be committed) ==="
	git diff --cached --stat
	echo ""
fi

if ! git diff --quiet; then
	echo "=== unstaged ==="
	git diff --stat
	echo ""
fi

echo "=== git log -5 ==="
AUTHOR=$(git config user.email)
if [[ -n "$AUTHOR" ]]; then
	git log --oneline -5 --author="$AUTHOR"
else
	git log --oneline -5
fi
echo ""

echo "=== git diff HEAD ==="
if [[ "$NO_DIFF" == "true" ]]; then
	echo "(--no-diff)"
elif [[ $(git diff HEAD | wc -l) -gt 500 ]]; then
	git diff HEAD | head -400
	echo "..."
else
	git diff HEAD
fi
