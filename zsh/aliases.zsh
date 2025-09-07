# エイリアス設定 - 改良版コマンドツール

# catの代替 - シンタックスハイライト付き
alias cat='bat'

# lsの代替 - 色付き、アイコン付き
alias ls='eza --icons --git'
alias ll='eza -alF --icons --git'
alias la='eza -A --icons --git'

# tree表示 - ezaベース
alias tree='eza --tree --icons --git'
alias tree2='eza --tree --level=2 --icons --git'
alias tree3='eza --tree --level=3 --icons --git'

# findの代替 - 高速検索
alias find='fd'

# grepの代替 - 高速grep
alias grep='rg'

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

# システム
alias reload='source ~/.zshrc'

# Claude Code便利エイリアス
alias claude="~/.local/bin/claude"
alias cc='claude'
alias yolo="claude --dangerously-skip-permissions"

# rmの代替 - ゴミ箱に移動
alias rm='safe-rm'
