#!/bin/bash
# Usage: analyze-pr-context.sh

set -e

BASE_BRANCH=$(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)
CURRENT_BRANCH=$(git branch --show-current)

echo "=== Current Branch ==="
echo "$CURRENT_BRANCH"
echo ""

echo "=== Base Branch (Default) ==="
echo "$BASE_BRANCH"
echo ""

echo "=== Commit Count (from Base Branch) ==="
git rev-list --count "${BASE_BRANCH}..HEAD"
echo ""

echo "=== Recent Commits (from Base Branch) ==="
git log "${BASE_BRANCH}..HEAD" --oneline --reverse || echo "No commits"
echo ""

echo "=== Existing PR (head=current branch) ==="
if [[ -n "$CURRENT_BRANCH" ]]; then
	PR_JSON=$(gh pr list --head "$CURRENT_BRANCH" --json number,url 2>/dev/null || true)
	if echo "$PR_JSON" | grep -q '"number"'; then
		echo "$PR_JSON" | jq -r '.[0] | "number: \(.number)\nurl: \(.url)"'
	else
		echo "none"
	fi
else
	echo "none"
fi
