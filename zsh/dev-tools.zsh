# 開発ツール設定

# rye
source "$HOME/.rye/env"

# Docker Desktop
source "$HOME/.docker/init-zsh.sh" || true

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# mise
eval "$(mise activate zsh)"

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# zoxide - smarter cd command
eval "$(zoxide init zsh)"