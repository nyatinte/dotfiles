# Cache proto activate output to avoid subprocess eval on every startup.
# Invalidated when the proto binary is newer than the cache file.
() {
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/proto_activate_zsh.sh"
    local proto_bin="${PROTO_HOME}/bin/proto"
    if [[ ! -f "$cache" || "$proto_bin" -nt "$cache" ]]; then
        mkdir -p "${cache:h}"
        proto activate zsh --no-shim >| "$cache"
    fi
    source "$cache"
}
export PROTO_AUTO_INSTALL=true
