---
name: managing-skills
description: Manage agent skills in this dotfiles repo with the skills CLI. Use when installing, updating, removing, or restoring skills, syncing ~/.agents/.skill-lock.json to chezmoi, adding a project skill, choosing target agents (Claude Code, OpenCode, Codex), or when the user mentions skills.sh, the skills CLI, skill-lock.json, or skill installation.
---

# Managing Skills in This Dotfiles Repo

Skills are installed and updated by the `skills` CLI (<https://skills.sh>); chezmoi
only keeps the lock file in sync so a new machine can restore the same set.

## Why not `gh skill`

`gh skill` (gh ≥ 2.101, preview) also installs skills, but it copies bodies per
agent instead of centralizing them: OpenCode gets a real directory under
`~/.config/opencode/skills`, which chezmoi manages as
`home/dot_config/opencode/skills`. The two would overwrite each other. The
`skills` CLI instead treats OpenCode and Codex as "universal" (both read
`~/.agents/skills`) and only symlinks Claude Code, which is what
`home/.chezmoiignore` is written for. Do not mix the two tools; they share the
same lock file and will clobber each other's state.

## Model

| Layer                      | Path                                                      | Managed by          |
| -------------------------- | --------------------------------------------------------- | ------------------- |
| Skill bodies (canonical)   | `~/.agents/skills/<name>/`                                | `skills` CLI        |
| Claude Code link           | `~/.claude/skills/<name>` → `../../.agents/skills/<name>` | `skills` CLI        |
| OpenCode                   | reads `~/.agents/skills` directly                         | `skills` CLI        |
| Codex                      | reads `$HOME/.agents/skills` directly                     | `skills` CLI        |
| Lock file (live)           | `~/.agents/.skill-lock.json`                              | `skills` CLI writes |
| Lock file (chezmoi source) | `home/dot_agents/dot_skill-lock.json`                     | chezmoi             |
| Project skills (this repo) | `.claude/skills/<name>/`                                  | git                 |

`home/.chezmoiignore` excludes `.agents/skills` and `.claude/skills` so chezmoi
and the CLI do not overwrite each other. Never edit the lock file by hand.

OpenCode and Codex are "universal": they read `~/.agents/skills` natively, so the
CLI does not create files under `~/.config/opencode/skills` or `~/.codex/skills`.

## Install

```bash
# 1. Inspect available skills in a repo
skills add <owner/repo> -l

# 2. Install globally to the three agents this repo targets
skills add <owner/repo> -s <skill> -a claude-code -a opencode -a codex -g -y

# 3. Sync the updated lock file into the chezmoi source
chezmoi add ~/.agents/.skill-lock.json

# 4. Verify
chezmoi status          # should be clean
```

`-s` and `-a` are repeatable flags. Pass each value separately; comma-separated
values are treated as one literal name and match nothing.

```bash
# correct
skills add owner/repo -s a -s b -a claude-code -a codex -g -y
# wrong: no skills match
skills add owner/repo -s a,b -a claude-code,codex -g -y
```

Use `--all` only when you want every skill in a repo for every agent.

## Update and Remove

```bash
skills update -g                  # update all global skills
skills update -g <name>           # update one skill
skills remove -g -s <name>        # remove one skill

chezmoi add ~/.agents/.skill-lock.json   # sync the lock after either
```

## Restore on a New Machine

`home/.chezmoiscripts/run_once_install-global-skills.sh` reads the lock file and
replays `skills add` for each entry. Keep the lock in sync; do not add manual
install steps anywhere else.

## Project Skills in This Repo

Project skills live in `.claude/skills/<name>/SKILL.md` and are git-tracked;
Claude Code and OpenCode read them while working in this repo. To let Codex read
one too, symlink it into `.agents/skills`:

```bash
mkdir -p .agents/skills
ln -s ../../.claude/skills/<name> .agents/skills/<name>
```

`managing-skills` itself uses this symlink. The repo-root `.agents` is not
covered by `home/.chezmoiignore` because it lives in the repo, not in `$HOME`.

## Gotchas

- Comma-separated `-s`/`-a` values silently match nothing (see Install).
- `chezmoi apply` overwrites the live lock from source. After the CLI writes the
  lock, run `chezmoi add`, not `chezmoi apply`, to sync it.
- Removing a skill from the lock does not delete its body under
  `~/.agents/skills`; remove with the CLI first, then sync the lock.
- If a future agent stores global skills in a chezmoi-managed directory, add that
  directory to `home/.chezmoiignore` before installing.
