#!/bin/bash

# dotfiles セットアップスクリプト
# 設定ファイルのシンボリックリンクを作成

# カラーコードの定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# アイコン定義
SUCCESS_ICON="✓"
ERROR_ICON="✗"
WARNING_ICON="⚠"
INFO_ICON="ℹ"
ARROW="→"

# 出力関数
print_success() {
    echo -e "${GREEN}${SUCCESS_ICON}${NC} $1"
}

print_error() {
    echo -e "${RED}${ERROR_ICON}${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}${WARNING_ICON}${NC} $1"
}

print_info() {
    echo -e "${BLUE}${INFO_ICON}${NC} $1"
}

print_step() {
    echo -e "${CYAN}${ARROW}${NC} $1"
}

print_header() {
    echo -e "\n${PURPLE}=== $1 ===${NC}\n"
}

DOTFILES_DIR="$HOME/my_programs/dotfiles"

print_header "dotfiles セットアップスクリプト"
print_info "設定ファイルのシンボリックリンクを作成します"

# バックアップ付きシンボリックリンクを作成する関数
create_symlink() {
    local source="$1"
    local target="$2"
    local step_num="$3"
    local total_steps="$4"
    local config_name="$5"
    
    print_step "[$step_num/$total_steps] $config_name の設定中..."
    
    # ソースファイルの存在確認
    if [ ! -f "$source" ]; then
        print_error "ソースファイルが見つかりません: $source"
        return 1
    fi
    
    # ターゲットディレクトリが存在しない場合は作成
    local target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        print_info "ディレクトリを作成中: $target_dir"
        if ! mkdir -p "$target_dir"; then
            print_error "ディレクトリの作成に失敗しました: $target_dir"
            return 1
        fi
    fi
    
    # 既存ファイルがあり、シンボリックリンクでない場合はバックアップ
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        print_warning "既存ファイルをバックアップ中: $target.backup"
        if ! mv "$target" "$target.backup"; then
            print_error "バックアップに失敗しました: $target"
            return 1
        fi
    fi
    
    # 既存のシンボリックリンクを削除
    if [ -L "$target" ]; then
        if ! rm "$target"; then
            print_error "既存のシンボリックリンクの削除に失敗しました: $target"
            return 1
        fi
    fi
    
    # 新しいシンボリックリンクを作成
    if ln -s "$source" "$target"; then
        print_success "シンボリックリンクを作成: $(basename "$target") ${ARROW} $source"
        return 0
    else
        print_error "シンボリックリンクの作成に失敗しました: $target"
        return 1
    fi
}

# 設定ファイルの定義（source:target:name の形式）
declare -a configs=(
    "git/gitconfig:$HOME/.gitconfig:Git"
    "zsh/zshrc:$HOME/.zshrc:Zsh"
    "starship/starship.toml:$HOME/.config/starship.toml:Starship"
    "ghostty/config:$HOME/.config/ghostty/config:Ghostty"
)

# エラーカウンター
error_count=0
total_steps=${#configs[@]}

print_info "セットアップを開始します...\n"

# 各設定ファイルを処理
for i in "${!configs[@]}"; do
    IFS=':' read -r source target name <<< "${configs[i]}"
    step_num=$((i + 1))
    
    if ! create_symlink "$DOTFILES_DIR/$source" "$target" "$step_num" "$total_steps" "$name"; then
        ((error_count++))
    fi
done

# 結果報告
echo
print_header "セットアップ結果"

if [ $error_count -eq 0 ]; then
    print_success "すべての設定が正常に完了しました！ ($total_steps/$total_steps)"
    print_info "変更を適用するには以下を実行してください："
    echo -e "  ${CYAN}source ~/.zshrc${NC}  # または新しいターミナルセッションを開く"
else
    print_error "$error_count 個のエラーが発生しました。上記のエラーメッセージを確認してください。"
    exit 1
fi