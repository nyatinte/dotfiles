#!/bin/bash

# dotfiles セットアップスクリプト
# 設定ファイルのシンボリックリンクを作成

DOTFILES_DIR="$HOME/my_programs/dotfiles"

echo "dotfiles をセットアップしています..."

# バックアップ付きシンボリックリンクを作成する関数
create_symlink() {
    local source="$1"
    local target="$2"
    
    # ターゲットディレクトリが存在しない場合は作成
    mkdir -p "$(dirname "$target")"
    
    # 既存ファイルがあり、シンボリックリンクでない場合はバックアップ
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "既存の $target を $target.backup にバックアップしています"
        mv "$target" "$target.backup"
    fi
    
    # 既存のシンボリックリンクを削除
    if [ -L "$target" ]; then
        rm "$target"
    fi
    
    # 新しいシンボリックリンクを作成
    ln -s "$source" "$target"
    echo "シンボリックリンクを作成しました: $target -> $source"
}

# Git 設定
create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# Zsh 設定
create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

# Starship 設定
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# Ghostty 設定
create_symlink "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

echo "セットアップが完了しました！"
echo "シェルを再起動するか 'source ~/.zshrc' を実行して変更を適用してください。"