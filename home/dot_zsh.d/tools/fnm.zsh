# Switch Node per directory using .node-version / .nvmrc
if (($+commands[fnm])); then
	eval "$(fnm env --use-on-cd --log-level quiet --shell zsh)"
fi
