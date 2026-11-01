# PATH and the `vp` wrapper are already set up in ~/.zshenv.
# Re-sourcing here is only needed to register the completion, which requires
# compinit. It spawns `vp`, so keep it off the startup path.
if [[ -f "${HOME}/.vite-plus/env" ]]; then
	zsh-defer source "${HOME}/.vite-plus/env"
fi
