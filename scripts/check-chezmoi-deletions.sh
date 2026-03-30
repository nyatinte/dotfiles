#!/bin/bash
# pre-commit hook: warn if deleted/moved chezmoi source files are not listed in .chezmoiignore
# If a file is removed from chezmoi source but not in .chezmoiignore,
# the user should add it to either .chezmoiignore or .chezmoiremove.

CHEZMOIIGNORE="home/.chezmoiignore"

# Get staged deleted files and old paths of renamed/moved files
DELETED=$(git diff --cached --diff-filter=D --name-only)
RENAMED_OLD=$(git diff --cached --diff-filter=R --name-status | awk '{print $2}')

ALL_REMOVED=$(printf '%s\n%s' "$DELETED" "$RENAMED_OLD")

# Convert chezmoi source path (e.g. home/dot_config/dot_zshrc) to target path (e.g. .config/.zshrc)
chezmoi_to_target() {
  local path="$1"
  # Must start with home/
  path="${path#home/}"

  local result=""
  IFS='/' read -ra parts <<< "$path"
  for part in "${parts[@]}"; do
    # Remove .tmpl suffix
    part="${part%.tmpl}"
    # Remove known chezmoi prefixes (order matters: longest first to avoid partial matches)
    for prefix in "private_dot_" "executable_dot_" "symlink_dot_" "readonly_dot_" "private_" "executable_" "symlink_" "readonly_" "empty_" "once_" "onchange_" "run_"; do
      if [[ "$part" == "${prefix}"* ]]; then
        part="${part#$prefix}"
        # If prefix ended with dot_, restore the dot
        if [[ "$prefix" == *"dot_" ]]; then
          part=".${part}"
        fi
        break
      fi
    done
    # Replace remaining dot_ prefix with .
    if [[ "$part" == dot_* ]]; then
      part=".${part#dot_}"
    fi

    if [ -n "$result" ]; then
      result="$result/$part"
    else
      result="$part"
    fi
  done
  echo "$result"
}

# Check if a target path matches any pattern in .chezmoiignore
is_in_chezmoiignore() {
  local target="$1"
  if [ ! -f "$CHEZMOIIGNORE" ]; then
    return 1
  fi
  while IFS= read -r pattern || [ -n "$pattern" ]; do
    # Skip empty lines and comments
    [[ -z "$pattern" || "$pattern" == \#* ]] && continue
    # shellcheck disable=SC2254
    if [[ "$target" == $pattern ]]; then
      return 0
    fi
  done < "$CHEZMOIIGNORE"
  return 1
}

warnings=()

while IFS= read -r file; do
  [ -z "$file" ] && continue
  # Only care about chezmoi source files under home/
  [[ "$file" != home/* ]] && continue

  target=$(chezmoi_to_target "$file")
  if ! is_in_chezmoiignore "$target"; then
    warnings+=("  $file  →  ~/$target")
  fi
done <<< "$ALL_REMOVED"

if [ ${#warnings[@]} -gt 0 ]; then
  echo ""
  echo "⚠️  Warning: 以下の chezmoi 管理ファイルが削除/移動されましたが、home/.chezmoiignore に記載されていません:"
  echo ""
  for w in "${warnings[@]}"; do
    echo "$w"
  done
  echo ""
  echo "  対処方法:"
  echo "    - ターゲットファイルをそのまま残す場合 → home/.chezmoiignore にパターンを追加"
  echo "    - ターゲットファイルも削除する場合     → home/.chezmoiremove にパターンを追加"
  echo ""
  echo "  チェックをスキップする場合: git commit --no-verify"
  echo ""
  exit 1
fi
