function repo() {
	local repo
	repo=$(ghq list -p | grep -v "/worktrees/" | fzf --height 50% --reverse \
		--header "Select repository to cd into" \
		--preview '
			echo "\033[1;35m$(basename {})\033[0m"
			url=$(git -C {} remote get-url origin 2>/dev/null | sed "s/\.git$//")
			[ -n "$url" ] && echo "\033[2;37m📡 $url\033[0m"
			echo "─────────────────────────────────────"
			echo ""
			echo "\033[1;36m📄 README\033[0m"
			bat --color=always --style=plain --line-range :30 "$(find {} -maxdepth 1 -iname "readme*" | head -1)" 2>/dev/null || echo "No README found"
			echo ""
			' \
		--preview-window right:50%:wrap)
	[[ -n "$repo" ]] && cd "$repo"
}
