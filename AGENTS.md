# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is **nyatinte's dotfiles repository**, managed by **chezmoi** for consistent configuration across multiple machines. The repository is macOS-oriented and provides a complete developer environment.

### Key Design Principles

- **Minimal configuration**: Only add what the user explicitly requests. Avoid over-engineering.
- **Chezmoi source files only**: Always edit files in this repo, never the deployed files in `~/`.
- **Run `chezmoi apply` after edits** to deploy changes to the home directory.

## Repository Structure

```
dotfiles/
├── home/                        # Chezmoi source root (maps to ~/)
│   ├── .chezmoi.toml.tmpl       # Prompts for git.email and git.name on first run
│   ├── .chezmoiexternal.toml    # External assets (Moralerspace & MPLUS1p fonts)
│   ├── .chezmoiremove           # Files to remove on apply
│   ├── .chezmoiscripts/         # One-time setup scripts (run_once_*)
│   ├── dot_zshrc                # Main zsh entry point
│   ├── dot_zsh.d/               # Modular zsh configuration
│   ├── dot_gitconfig.tmpl       # Git config template (uses .git.email / .git.name)
│   ├── dot_config/              # XDG config files (~/.config/)
│   ├── dot_claude/              # Claude Code config and skills (~/.claude/)
│   └── dot_agents/              # Agent skills (~/.agents/)
├── .chezmoiroot                 # Contains "home" — marks the source directory
├── AGENTS.md                    # This file (loaded via @AGENTS.md in CLAUDE.md)
├── lefthook.yml                 # Git hooks (pre-commit, pre-push)
├── package.json                 # Node dev deps: lefthook, markdownlint-cli2, vite-plus
├── pnpm-workspace.yaml          # pnpm workspace config
└── vite.config.ts               # vite-plus formatter config
```

## Chezmoi File Naming Conventions

| Prefix/Suffix | Meaning | Example |
|---|---|---|
| `dot_` | Becomes `.` | `dot_zshrc` → `~/.zshrc` |
| `.tmpl` | Go template, processed with variables | `dot_gitconfig.tmpl` |
| `executable_` | Sets 755 permissions | `executable_notify.sh` |
| `private_` | Sets 600 permissions | `private_secret` |
| `symlink_` | Creates a symlink | `symlink_agent-browser` |
| `run_once_` | Script runs once ever | `run_once_install-global-markdownlint.sh` |

Template variables are defined in `home/.chezmoi.toml.tmpl` and populated on first run:

- `{{ .git.email }}` — user's Git email
- `{{ .git.name }}` — user's Git name

## Common Commands

```bash
# Apply dotfiles to home directory
chezmoi apply

# Preview what would change (safe, read-only)
chezmoi diff

# Edit a deployed file via chezmoi (opens source file)
chezmoi edit ~/.zshrc

# Add a new file to management
chezmoi add ~/.config/newfile

# Re-run one-time scripts (useful after updates)
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

## Managed Tools & Configurations

### Shell (Zsh)

Entry point: `home/dot_zshrc` — sources modules in order:

1. `dot_zsh.d/core/path.zsh` — PATH setup (Homebrew, local bins, Bun)
2. `dot_zsh.d/core/env.zsh` — Editor (`hx`/cursor), `NI_AGENT=pnpm`, LG config
3. `dot_zsh.d/tools/mise.zsh` — Activates mise runtime manager
4. `dot_zsh.d/tools/docker.zsh` — Docker init
5. `dot_zsh.d/tools/fzf.zsh` — FZF keybindings (Ctrl+T, Alt+C, Ctrl+R, Ctrl+G)
6. `dot_zsh.d/tools/vite-plus.zsh` — vite-plus env
7. `dot_zsh.d/.local.zsh` (optional, not committed) — machine-local overrides
8. `sheldon source` — loads zsh plugins
9. `dot_zsh.d/functions/*.zsh` — custom functions

**Abbreviations**: `dot_zsh.d/abbreviations` — 26 shortcuts (e.g., `g`→`git`, `chz`→`chezmoi`)

**Functions**:
- `gwn()` — git worktree runner (`git-worktree-runner`)
- `mdcd()` — `mkdir -p` then `cd`

### Git

- Config: `home/dot_gitconfig.tmpl` (template)
- Delta pager with side-by-side diffs, Dracula syntax theme
- SSH rewrite rule for GitHub (HTTPS → SSH)
- Aliases: `st`, `co`, `br`, `ci`, `df`, `lg`, `cp`, `sw`
- Global ignores: `home/dot_config/git/ignore`
  - Ignores: `.claude/settings.local.json`, `CLAUDE.local.md`, `.wtp.yml`, `.worktrees/`, `PR.md`

### Runtime Versions (mise)

Managed in `home/dot_config/mise/config.toml`:
- Node.js LTS, Bun, Python
- CLI tools: pnpm, fzf, eza, and others

### Terminal Stack

- **Ghostty** (`dot_config/ghostty/`) — terminal emulator; Everblush theme, Moralerspace font
- **Zellij** (`dot_config/zellij/`) — terminal multiplexer; git branch keybinding, solarized-dark
- **Lazygit** (`dot_config/lazygit/config.yml.tmpl`) — git UI with delta pager

### Zsh Plugin Manager (Sheldon)

Config: `home/dot_config/sheldon/plugins.toml`

Key plugins:
- `zsh-defer` — deferred plugin loading
- `zsh-abbr` — abbreviation expansion
- `zsh-autosuggestions`
- `fast-syntax-highlighting`
- `pure` prompt (custom Nord colors)

### Linting

- **markdownlint** (`dot_markdownlint.json`) — MD013 (line length) disabled
- **textlint** (`dot_textlintrc.json`) — Japanese technical writing rules
  - `preset-ja-technical-writing`, AI-writing, terminology, spacing

### Fonts (External Assets)

Downloaded by chezmoi via `home/.chezmoiexternal.toml`:
- **Moralerspace** v2.0.0 — primary coding font
- **MPLUS1p** — all weights (Thin → Black)

Refreshed every 720 hours (30 days).

### One-Time Setup Scripts

Located in `home/.chezmoiscripts/`:
- `run_once_install-global-markdownlint.sh` — installs `markdownlint-cli2` globally via pnpm
- `run_once_install-global-textlint.sh` — installs textlint + Japanese rules globally
- `run_once_set-macos-defaults.sh` — applies macOS system defaults (Finder, keyboard, Dock)

## Claude Code Integration

Claude Code config lives in `home/dot_claude/` (deploys to `~/.claude/`).

### Custom Skills (7 total)

Located in `home/dot_claude/skills/`:

| Skill | Purpose |
|---|---|
| `git-commit` | Generate commit messages from diffs |
| `create-draft-pull-request` | Create GitHub PRs with generated descriptions |
| `pull-request-review` | Conduct detailed code reviews |
| `pr-review-handler` | Handle incoming PR review comments |
| `document-writing` | Assist with documentation |
| `resolve-conflict` | Resolve merge conflicts |
| `strategic-compact` | Context compaction strategy |

### Symlinked Agent Skills

Located in `home/dot_agents/skills/`:
- `agent-browser` — browser automation
- `grill-me` — interview/stress-test design
- `write-a-skill` — skill creation guide

### Hooks

Located in `home/dot_claude/hooks/`:
- `executable_notify.sh` — sends notifications (permission prompts, idle, completion) via cmux
- `executable_pre-compact.js` — pre-compact hook
- `executable_suggest-compact.js` — suggests compact when editing/writing large files
- `executable_skill-forced-eval-hook.sh` — skill evaluation hook

Settings template: `home/dot_claude/settings.example.json`
- Default model: claude-sonnet-4-6
- Status line integration configured

### CC Status Line

Config in `home/dot_config/ccstatusline/`:
- `executable_repo-url.sh` — displays GitHub repo URL as a clickable hyperlink in the status bar

## Development Workflow

### Git Hooks (lefthook)

Configured in `lefthook.yml`:

**pre-commit** (parallel):
- `shfmt -d` — validates shell script formatting (`*.sh`, `*.bash`, `*.zsh`)
- `pnpm exec vp check --fix` — formats JS/TS/JSON/TOML/YAML/Markdown
- `pnpm exec markdownlint-cli2` — lints Markdown files

**pre-push**:
- Runs `chezmoi diff` and **blocks push** if there are unapplied changes

### Setup

```bash
# Install Node deps (required for hooks)
pnpm install

# Install hooks
pnpm exec lefthook install
```

### Node.js Version

Specified in `.node-version`: `24.11.1`
Package manager: `pnpm@10.33.0`

### Formatting

- Shell scripts: `shfmt`
- JS/TS/JSON/TOML/YAML/Markdown: `vp check` (vite-plus with oxfmt)

## Scripts

- `home/scripts/executable_zellij-new-branch-tab.sh` — creates a new Zellij tab named after the current git branch and launches Claude Code
- `home/dot_config/raycast/scripts/executable_markdown-lint-fix.sh` — Raycast script to lint clipboard Markdown content

## Machine-Local Overrides

The file `~/.zsh.d/.local.zsh` is intentionally **not tracked** by chezmoi (listed in `.chezmoiremove`). Use this file for machine-specific shell configuration that should not be shared across machines.

## What NOT to Do

- Do not edit files in `~/` directly — edit the chezmoi source in this repo
- Do not push without running `chezmoi apply` first (pre-push hook enforces this)
- Do not add unnecessary configuration or features the user hasn't requested
- Do not commit `.local.zsh` or `settings.local.json` — these are machine-local and gitignored
