# WHY: https://zenn.dev/sprout2000/articles/bd1fac2f3f83bc
typeset -U path PATH

path=(
	/opt/homebrew/bin
	/opt/homebrew/sbin
	/usr/bin
	/usr/sbin
	/bin
	/sbin
	/usr/local/bin
	/usr/local/sbin
	/Library/Apple/usr/bin
	$HOME/.local/bin
	$HOME/.bun/bin
	$HOME/.antigravity/antigravity/bin
)
