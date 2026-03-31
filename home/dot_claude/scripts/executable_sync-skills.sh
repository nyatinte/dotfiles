#!/bin/bash
set -euo pipefail

CLAUDE_HOME="${HOME}/.claude"

# .claude/skills を持つ祖先ディレクトリを探す
find_project_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.claude/skills" ]]; then
      echo "$dir"
      return 0
    fi
    dir=$(dirname "$dir")
  done
  return 1
}

PROJECT_ROOT=$(find_project_root) || {
  echo "Error: .claude/skills が見つかりません" >&2
  echo "プロジェクトディレクトリ内から実行してください" >&2
  exit 1
}

# グローバル .claude 自身との同期を防止
if [[ "$PROJECT_ROOT" == "$HOME" ]]; then
  echo "Error: ~ 直下では実行できません" >&2
  exit 1
}

exec "$CLAUDE_HOME/node_modules/.bin/tsx" "$CLAUDE_HOME/scripts/sync-skills.ts" "$PROJECT_ROOT"
