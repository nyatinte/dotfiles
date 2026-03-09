# proto - version manager activation（バイナリ更新時のみ再生成）
() {
  local cache="${HOME}/.cache/zsh/proto_activate.zsh"
  local bin
  bin=$(whence -p proto 2>/dev/null)
  if [[ -n $bin && ( ! -f $cache || $bin -nt $cache ) ]]; then
    mkdir -p "${cache:h}"
    proto activate zsh --no-shim >"$cache"
  fi
  [[ -f $cache ]] && source "$cache"
}
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