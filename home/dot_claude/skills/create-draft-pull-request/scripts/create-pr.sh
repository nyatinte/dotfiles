#!/bin/bash
# Usage: create-pr.sh [PR_FILE] BASE_BRANCH
#   PR_FILE: path to PR.md (default: PR.md). First line = title, rest = body.
#   BASE_BRANCH: target branch (e.g. develop, main).

set -e

PR_FILE="${1:-PR.md}"
BASE_BRANCH="${2:?Usage: create-pr.sh [PR_FILE] BASE_BRANCH}"

if [[ ! -f "$PR_FILE" ]]; then
  echo "Error: PR file not found: $PR_FILE" >&2
  exit 1
fi

TITLE=$(head -n 1 "$PR_FILE")
BODY_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE"' EXIT
tail -n +2 "$PR_FILE" > "$BODY_FILE"

gh pr create --base "$BASE_BRANCH" --title "$TITLE" --body-file "$BODY_FILE" --draft
