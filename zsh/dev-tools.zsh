# 開発ツール設定

# rye
source "$HOME/.rye/env"

# Docker Desktop
source "$HOME/.docker/init-zsh.sh" || true

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# mise - 遅延読み込み
if command -v mise > /dev/null; then
    eval "$(mise activate zsh --shims)"
fi

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# ni - package manager
export NI_DEFAULT_AGENT="bun"
export NI_GLOBAL_AGENT="bun"