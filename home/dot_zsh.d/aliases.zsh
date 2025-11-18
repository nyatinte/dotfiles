# エイリアス設定 - 改良版コマンドツール

# catの代替 - シンタックスハイライト付き
alias cat='bat'

# Git便利エイリアス
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias glog='git log --oneline --graph --decorate'
alias gprw="gh pr view --web"
alias grw="gh repo view --web"


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

# システム
alias reload='source ~/.zshrc'

alias cc='claude'

# rmの代替 - ゴミ箱に移動
alias rm='safe-rm'
