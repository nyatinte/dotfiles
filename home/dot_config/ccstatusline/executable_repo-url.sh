#!/bin/sh

GITHUB_ICON=""

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "repository not found"; exit 0; }

repo_data=$(gh repo view --json url,nameWithOwner 2>/dev/null) || { echo "repository not found"; exit 0; }

repo_url=$(printf '%s' "$repo_data" | jq -r .url)
name_with_owner=$(printf '%s' "$repo_data" | jq -r .nameWithOwner)

printf '\033[96m\033]8;;%s\033\\%s%s\033]8;;\033\\\033[0m\n' "$repo_url" "$GITHUB_ICON" "$name_with_owner"
