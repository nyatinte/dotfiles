#!/bin/bash
# Usage: check-branch.sh

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

echo "=== Existing PRs for this branch ==="
gh pr list --head "$CURRENT_BRANCH" --json number,url,title,state
echo ""
