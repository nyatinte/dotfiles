# proto - version manager activation
eval "$(proto activate zsh --no-shim)"
export PROTO_AUTO_INSTALL=true
# Global npm packages PATH
export PATH="$PROTO_HOME/tools/node/globals/bin:$PATH"

# Docker Desktop
source "$HOME/.docker/init-zsh.sh" || true

# wtp
eval "$(wtp completion zsh)"

# ni - package manager
export NI_DEFAULT_AGENT="pnpm"
export NI_GLOBAL_AGENT="pnpm"

# Code editor
export VISUAL="code"
