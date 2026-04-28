function repo() {
  for cmd in ghq fzf bat; do
    command -v "$cmd" &>/dev/null || { echo "Missing: $cmd"; return 1; }
  done
  local repo
  repo=$(ghq list -p | grep -v "/worktrees/" | fzf --height 50% --reverse \
    --header "Select repository to cd into" \
    --preview '
      echo "\033[1;35m$(basename {})\033[0m"
      url=$(git -C {} remote get-url origin 2>/dev/null | sed s/\.git$//)
      [ -n "$url" ] && echo "\033[2;37m$url\033[0m"
      readme=$(find {} -maxdepth 1 -iname "README*" | head -1)
      [ -n "$readme" ] && bat --color=always --style=plain --language=markdown "$readme" 2>/dev/null || echo "No README found"
      ' \
    --preview-window right:50%:wrap)
  [[ -n "$repo" ]] && cd "$repo"
}
