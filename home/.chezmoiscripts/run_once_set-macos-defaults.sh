#!/bin/bash

set -euo pipefail

# Apply macOS user defaults for development environment
# Run once on new machines — re-run manually if settings need to be reapplied

echo "Applying macOS defaults..."

# === Finder ===
# Show hidden files (e.g. .env, .DS_Store)
defaults write com.apple.finder AppleShowAllFiles -bool true
# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show path bar at the bottom of Finder windows
defaults write com.apple.finder ShowPathbar -bool true
# Show status bar (file count, disk usage)
defaults write com.apple.finder ShowStatusBar -bool true
# Default search scope: current folder instead of the whole Mac
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# New Finder windows open ~/Developer
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Developer"

# === Keyboard ===
# Key repeat speed (2 = near maximum; system default is 6)
defaults write NSGlobalDomain KeyRepeat -int 2
# Delay before key repeat starts (12 = shorter delay; system default is 25)
defaults write NSGlobalDomain InitialKeyRepeat -int 12
# Disable auto-capitalization (was ON by default)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# === Dock ===
# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true
# Remove "Recent Applications" section from Dock
defaults write com.apple.dock show-recents -bool false

# === Hot Corners ===
# Bottom-right corner → Show Desktop (hides all windows, shows desktop)
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# === Startup ===
# Mute the startup chime
sudo nvram StartupMute=%01

# === Storage ===
# Automatically remove items from the Downloads folder after 30 days
defaults write com.apple.StorageManagement RemoveDownloadsAfter30Days -bool true

# === Screenshots ===
# Save screenshots to ~/Pictures/Screenshots instead of Desktop
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

echo "Restarting Finder, Dock, and SystemUIServer..."
killall Finder Dock SystemUIServer

echo "Done."
