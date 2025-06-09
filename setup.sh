#!/bin/bash

# dotfiles setup script
# Creates symbolic links for configuration files

DOTFILES_DIR="$HOME/my_programs/dotfiles"

echo "Setting up dotfiles..."

# Function to create symbolic link with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file if it exists and is not a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $target to $target.backup"
        mv "$target" "$target.backup"
    fi
    
    # Remove existing symlink
    if [ -L "$target" ]; then
        rm "$target"
    fi
    
    # Create new symlink
    ln -s "$source" "$target"
    echo "Created symlink: $target -> $source"
}

# Git configuration
create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

# Zsh configuration
create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

# Starship configuration
create_symlink "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# Ghostty configuration
create_symlink "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

echo "Setup complete!"
echo "Please restart your shell or run 'source ~/.zshrc' to apply changes."