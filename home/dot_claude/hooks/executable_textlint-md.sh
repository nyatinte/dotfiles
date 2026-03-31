#!/bin/bash

# PR.mdファイルのAI Slop自動検出hook
# PostToolUseイベントでPR.mdファイル編集後に自動実行

# hookからJSON入力を読み取り
INPUT=$(cat)

# textlintの設定ファイルパス
CONFIG_FILE="$HOME/.claude/skills/document-writing/assets/.textlintrc"

CONFIG_DIR="$(dirname "$CONFIG_FILE")"

# 設定ディレクトリに package.json があり、pnpm で textlint を実行できるか確認
if [ ! -f "$CONFIG_FILE" ] || [ ! -f "$CONFIG_DIR/package.json" ]; then
  exit 0
fi
TEXTLINT_BIN="$CONFIG_DIR/node_modules/.bin/textlint"
if [ ! -f "$TEXTLINT_BIN" ] && [ ! -d "$TEXTLINT_BIN" ]; then
  exit 0
fi

# ファイルパスを収集
FILE_PATHS=()

# Edit/Writeツールの場合
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
if [ -n "$FILE_PATH" ] && [ "$FILE_PATH" != "null" ]; then
  FILE_PATHS+=("$FILE_PATH")
fi

# MultiEditの場合、edits配列から全てのファイルパスを取得
MULTI_EDIT_PATHS=$(echo "$INPUT" | jq -r '.tool_input.edits[]?.file_path // empty' 2>/dev/null)
if [ -n "$MULTI_EDIT_PATHS" ]; then
  while IFS= read -r path; do
    if [ -n "$path" ] && [ "$path" != "null" ]; then
      FILE_PATHS+=("$path")
    fi
  done <<< "$MULTI_EDIT_PATHS"
fi

# ファイルパスが取得できない場合はスキップ
if [ ${#FILE_PATHS[@]} -eq 0 ]; then
  exit 0
fi

# PR.mdファイルのみをフィルタリング
MD_FILES=()
for file_path in "${FILE_PATHS[@]}"; do
  # ファイル名がPR.mdの場合のみ対象
  if [[ "$(basename "$file_path")" == "PR.md" ]] && [ -f "$file_path" ]; then
    MD_FILES+=("$file_path")
  fi
done

# PR.mdファイルがない場合はスキップ
if [ ${#MD_FILES[@]} -eq 0 ]; then
  exit 0
fi

# 各.mdファイルに対してtextlintを実行（CONFIG_DIRでpnpm execによりローカルnode_modulesを利用）
HAS_ERRORS=false
ERROR_MESSAGES=""

for md_file in "${MD_FILES[@]}"; do
  if [[ "$md_file" != /* ]]; then
    MD_ABS="$(pwd)/$md_file"
  else
    MD_ABS="$md_file"
  fi
  LINT_OUTPUT=$(cd "$CONFIG_DIR" && "$TEXTLINT_BIN" --config "$(basename "$CONFIG_FILE")" "$MD_ABS" 2>&1)
  LINT_EXIT_CODE=$?

  if [ $LINT_EXIT_CODE -ne 0 ]; then
    HAS_ERRORS=true
    ERROR_MESSAGES="${ERROR_MESSAGES}
⚠️  AI Slop detected in $md_file:

$LINT_OUTPUT

"
  fi
done

# エラーがあればClaudeにフィードバック
if [ "$HAS_ERRORS" = true ]; then
  echo "$ERROR_MESSAGES" >&2
  echo "Please fix these issues to ensure natural Japanese writing." >&2
  exit 2  # exit 2 = Claudeにフィードバックを送信してブロック
fi

# すべてのチェックに合格
exit 0
