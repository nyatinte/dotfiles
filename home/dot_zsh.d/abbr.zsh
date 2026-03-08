# 略語設定 - zsh-abbr

# catの代替 - シンタックスハイライト付き
abbr cat='bat'

# Git便利略語
abbr g='git'
abbr gs='git status'
abbr ga='git add'
abbr gc='git commit'
abbr gp='git push'
abbr gl='git pull'
abbr gd='git diff'
abbr gb='git branch'
abbr gco='git checkout'
abbr gcb='git checkout -b'
abbr glog='git log --oneline --graph --decorate'
abbr gph='git push origin HEAD'
abbr gprw='gh pr view --web'
abbr grw='gh repo view --web'


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

# システム
abbr reload='source ~/.zshrc'

abbr cc='claude'
abbr cc-yolo='claude --dangerously-skip-permissions'

# デフォルトエディタで開く
abbr c.='${VISUAL} .'

# rmの代替 - ゴミ箱に移動
abbr rm='safe-rm'

# lazygit
abbr lg='lazygit'

# zellij
abbr zj='zellij'

# chezmoi
abbr chz='chezmoi'
