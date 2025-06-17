# モダンCLIツール ガイド

このdotfilesリポジトリで使用されているモダンCLIツールのインストール方法と機能を説明します。

## 🛠 ツール一覧

### catの代替: bat
**説明**: シンタックスハイライト付きのcat代替ツール  
**GitHub**: https://github.com/sharkdp/bat  
**インストール方法**:
```bash
brew install bat
```

### lsの代替: eza
**説明**: 色付き、アイコン付きのls代替ツール  
**GitHub**: https://github.com/eza-community/eza  
**インストール方法**:
```bash
# Homebrewでの直接インストールは未対応
# 詳細はINSTALL.mdを参照
# Nixでのテスト:
nix run github:eza-community/eza
```

### findの代替: fd  
**説明**: 高速ファイル検索ツール  
**GitHub**: https://github.com/sharkdp/fd  
**インストール方法**:
```bash
brew install fd
```

### grepの代替: ripgrep (rg)
**説明**: 高速grep代替ツール  
**GitHub**: https://github.com/BurntSushi/ripgrep  
**インストール方法**:
```bash
brew install ripgrep
```

### ディレクトリ移動: zoxide
**説明**: スマートなcd代替ツール（履歴ベース）  
**GitHub**: https://github.com/ajeetdsouza/zoxide  
**インストール方法**:
```bash
brew install zoxide
```

### ファジーファインダー: fzf
**説明**: コマンドラインファジーファインダー  
**GitHub**: https://github.com/junegunn/fzf  
**インストール方法**:
```bash
brew install fzf
```

### ランタイム管理: mise
**説明**: 複数言語のランタイムバージョン管理ツール  
**GitHub**: https://github.com/jdx/mise  
**インストール方法**:
```bash
curl https://mise.run | sh
```

### Python管理: rye
**説明**: Pythonプロジェクト管理ツール  
**GitHub**: https://github.com/mitsuhiko/rye  
**インストール方法**:
```bash
curl -sSf https://rye.astral.sh/get | bash
```

### Node.js管理: volta
**説明**: JavaScript/Node.jsツールマネージャー  
**GitHub**: https://github.com/volta-cli/volta  
**インストール方法**:
詳細は https://docs.volta.sh/guide/getting-started を参照

### JavaScript/TypeScript: bun
**説明**: 高速なJavaScript/TypeScriptランタイム・パッケージマネージャー  
**GitHub**: https://github.com/oven-sh/bun  
**インストール方法**:
```bash
brew tap oven-sh/bun
brew install bun
```
または：
```bash
curl -fsSL https://bun.sh/install | bash
```

## 🔧 一括インストールスクリプト

以下のコマンドで主要なツールを一括インストール可能です：

```bash
# Homebrewベースのツール
brew install bat fd ripgrep zoxide fzf

# Homebrewでタップが必要なツール
brew tap oven-sh/bun
brew install bun

# カスタムインストールスクリプトが必要なツール
curl https://mise.run | sh
curl -sSf https://rye.astral.sh/get | bash
```

## 📝 エイリアス設定

このdotfilesでは以下のエイリアスが設定されています（`zsh/aliases.zsh`）：

```bash
# ファイル操作
alias cat='bat'
alias ls='eza --icons --git'
alias ll='eza -alF --icons --git'
alias tree='eza --tree --icons --git'

# 検索
alias find='fd'
alias grep='rg'

# ディレクトリ移動
alias cd='z'  # zoxide
```

## ⚡ セットアップ方法

### 1. ツールのインストール
上記の一括インストールスクリプトを実行してツールをインストールします。

### 2. dotfilesの設定適用
リポジトリの`setup.sh`スクリプトを実行してシンボリックリンクを作成：

```bash
./setup.sh
```

このスクリプトにより以下が自動設定されます：
- `~/.zshrc` → `dotfiles/zsh/zshrc`
- `~/.gitconfig` → `dotfiles/git/gitconfig`
- `~/.config/starship.toml` → `dotfiles/starship/starship.toml`
- `~/.config/ghostty/config` → `dotfiles/ghostty/config`

### 3. 設定の読み込み
新しいターミナルセッションを開くか、以下を実行：

```bash
source ~/.zshrc
```

## 🎯 自動設定される機能

`zsh/dev-tools.zsh`により以下のツールが自動初期化されます：

- **zoxide**: `eval "$(zoxide init zsh)"` - スマートなディレクトリ移動
- **fzf**: `source <(fzf --zsh)` - ファジーファインダー統合
- **mise**: `eval "$(mise activate zsh)"` - ランタイム管理
- **rye**: `source "$HOME/.rye/env"` - Python環境管理
- **bun**: `source "$HOME/.bun/_bun"` - bunコマンド補完

これらの設定により、ツールインストール後すぐに高度な機能が利用可能になります。