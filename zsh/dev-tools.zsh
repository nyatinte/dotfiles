# 開発ツール設定

# Docker Desktop
source "$HOME/.docker/init-zsh.sh" || true

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# ni - package manager
export NI_DEFAULT_AGENT="pnpm"
export NI_GLOBAL_AGENT="pnpm"