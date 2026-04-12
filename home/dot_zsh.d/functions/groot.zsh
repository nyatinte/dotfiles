groot() {
  local root && root="$(git rev-parse --show-toplevel)" || { echo "groot: not a git repository" >&2; return 1; }
  cd "$root"
}
