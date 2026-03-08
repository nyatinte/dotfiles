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
    git gtr new "$branch_name" --from "origin/$default_branch" && cd "$(git gtr go "$branch_name")" || return
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
