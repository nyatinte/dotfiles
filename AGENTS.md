# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed by **chezmoi**. Chezmoi uses special file naming conventions:

- `dot_` prefix → `.` (e.g., `dot_zshrc` → `~/.zshrc`)
- `.tmpl` suffix → Template files processed with variables (e.g., `dot_gitconfig.tmpl`)

## Common Commands

```bash
# Apply dotfiles to home directory
chezmoi apply

# Edit a managed file
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Add new file to management
chezmoi add ~/.config/newfile
```

## Important

**Always edit chezmoi source files** (files in this repo), not the deployed files in your home directory. After editing, run `chezmoi apply` to deploy changes.

## Development Policy

- **Minimal configuration**: Only add what the user explicitly requests. Avoid over-engineering or adding unnecessary features.
- **Use context7**: When you need more information about chezmoi features or best practices, use the context7 tool to get up-to-date documentation.
