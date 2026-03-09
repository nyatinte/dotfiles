# proto - version manager activation
eval "$(proto activate zsh --no-shim)"
export PROTO_AUTO_INSTALL=true
# Global npm packages PATH
export PATH="$PROTO_HOME/tools/node/globals/bin:$PATH"

# Docker Desktop (optional - only present when Docker Desktop is installed)
[[ -f "$HOME/.docker/init-zsh.sh" ]] && source "$HOME/.docker/init-zsh.sh"

# ni - package manager
export NI_DEFAULT_AGENT="pnpm"
export NI_GLOBAL_AGENT="pnpm"

# Code editor
export VISUAL="cursor"
export EDITOR="hx"

# Lazygit
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"