<!-- https://readme-typing-svg.demolab.com/demo/?weight=600&pause=500&color=A8D8E8&background=1A2633&center=true&vCenter=true&multiline=true&height=80&lines=Nyatinte+dotfiles+%F0%9F%90%A7;Managed+with+chezmoi%E2%9C%A8 -->
<div align="center">
  <a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&pause=500&color=A8D8E8&background=1A2633&center=true&vCenter=true&multiline=true&width=435&height=80&lines=Nyatinte+dotfiles+%F0%9F%90%A7;Managed+with+chezmoi%E2%9C%A8" alt="Nyatinte dotfiles - Managed with chezmoiG" />
</div>

## 📝 About

This is nyatinte's private dotfiles repository, managed with [chezmoi](https://www.chezmoi.io/) for consistent configuration across multiple machines.

## 🚀 Setup

### Prerequisites

Install the following tools:

```bash
# Install npm dependencies (Prettier, concurrently, lefthook)
npm install

# Install shfmt (shell script formatter)
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Install shellcheck (shell script linter)
# macOS
brew install shellcheck

# Ubuntu/Debian
apt-get install shellcheck

# Other: https://github.com/koalaman/shellcheck#installing
```

### VSCode Extensions

Install recommended extensions for automatic formatting:

- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [shell-format](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format)
- [ShellCheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)

## 🔧 Usage

```bash
# Format all files
npm run format

# Check formatting (CI)
npm run format:check

# Format specific types
npm run format:prettier  # JSON, YAML, Markdown
npm run format:shell     # Shell scripts
```
