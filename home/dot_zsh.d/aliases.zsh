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
    local default_branch=$(gh api repos/:owner/:repo --jq .default_branch 2>/dev/null || echo "main")
    # WHY g'w'r ? -> 'gtr' command conflicts. see <https://github.com/coderabbitai/git-worktree-runner/issues/11>
    gwr new "$branch_name" --from "origin/$default_branch" && cd "$(gwr go "$branch_name")"
}

# システム
alias reload='source ~/.zshrc'

alias cc='claude'

# rmの代替 - ゴミ箱に移動
alias rm='safe-rm'
