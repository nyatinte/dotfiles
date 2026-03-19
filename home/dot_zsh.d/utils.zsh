# Also register abbreviations as regular aliases (fallback before expansion)
() {
  local abbr_file="${ABBR_USER_ABBREVIATIONS_FILE:-$HOME/.zsh.d/abbreviations}"
  [[ -f "$abbr_file" ]] || return
  local line name value
  while IFS= read -r line; do
    [[ "$line" =~ '^abbr[[:space:]]+"([^"]+)"="(.*)"[[:space:]]*$' ]] || continue
    name="${match[1]}"
    value="${(e)match[2]}"
    alias "${name}=${value}"
  done < "$abbr_file"
}

# Git worktree runner -- <https://github.com/coderabbitai/git-worktree-runner>
gwn() {
    local branch_name="$1"
    if [ -z "$branch_name" ]; then
        echo "Usage: gwn <branch-name>"
        return 1
    fi
    local default_branch
    default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')
    if [ -z "$default_branch" ] && command -v gh >/dev/null 2>&1; then
        if default_branch=$(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name 2>/dev/null); then
            :
        fi
    fi
    git gtr new "$branch_name" --from "origin/$default_branch" && cd "$(git gtr go "$branch_name")"
}

# 長時間コマンドの完了通知
notify-after() {
  "$@"
  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    cmux notify --title "✓ Command Complete" --body "$1"
  else
    cmux notify --title "✗ Command Failed" --body "$1 (exit $exit_code)"
  fi
  return $exit_code
}
