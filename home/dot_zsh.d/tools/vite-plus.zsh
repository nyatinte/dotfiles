# PATH and the `vp` wrapper are set up in ~/.zshenv and core/path.zsh.
# Registering completions requires compinit and spawns `vp`, so defer it.
if (($+functions[compdef])) && (($+commands[vp])); then
	zsh-defer -c 'eval "$(VP_COMPLETE=zsh command vp)"' 2>/dev/null
fi
