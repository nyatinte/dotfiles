# AGENTS.md

Guidance for AI coding agents (Claude Code, Codex, OpenCode, …) working in this repository.

## Repository Overview

This is nyatinte's personal dotfiles repository, managed with **chezmoi**.
The chezmoi source root is `home/` (see `.chezmoiroot`), so everything that maps to `~/` lives under `home/`.

Chezmoi naming conventions:

- `dot_` prefix → `.` (e.g. `home/dot_zshrc` → `~/.zshrc`)
- `.tmpl` suffix → Go template (e.g. `home/dot_gitconfig.tmpl`)
- `private_` / `executable_` prefixes → file permissions
- `symlink_` prefix → symlink

## Common Commands

```bash
chezmoi status           # show drift between source and $HOME
chezmoi diff             # preview what would change
chezmoi apply            # apply source to $HOME
chezmoi add ~/.config/foo
chezmoi edit ~/.zshrc
```

**Always edit the source files under `home/` in this repo**, never the deployed copies in `$HOME`.
After editing, run `chezmoi apply` to deploy.

## Skills

Agent skills are intentionally **not** managed by chezmoi. They are installed and
updated with the [`skills` CLI](https://skills.sh) and recorded in the global lock
file, which chezmoi keeps in sync:

- lock: `~/.agents/.skill-lock.json` → `home/dot_agents/dot_skill-lock.json`
- install / update / remove: `skills add <owner/repo> --skill <name> -g`, `skills update -g`, `skills remove -g`
- restore on a new machine: `home/.chezmoiscripts/run_once_install-global-skills.sh`
- keep skill bodies and generated files unmanaged: see `home/.chezmoiignore`

## Development Policy

- **Minimal configuration**: only add what is explicitly requested.
- Keep machine-local or tool-generated files out of chezmoi; list them in `home/.chezmoiignore`.
- Run `pnpm install` if dependencies change; git hooks are managed by lefthook.
