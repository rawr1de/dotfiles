#!/bin/bash

set -e  # Exit on error

DOTFILES_DIR="$HOME/dotfiles"

echo "🚀 Deploying dotfiles..."

# Clone repo if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📦 Cloning dotfiles repository..."
    git clone https://github.com/rawr1de/dotfiles.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# Pull latest changes if repo already exists
git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true

# Install GNU Stow if not present
if ! command -v stow &> /dev/null; then
    echo "⚠️  GNU Stow not found. Please install it:"
    echo "  Ubuntu/Debian: sudo apt install stow"
    echo "  Fedora: sudo dnf install stow"
    echo "  Arch: sudo pacman -S stow"
    echo "  macOS: brew install stow"
    exit 1
fi

# Stow all packages
echo "🔗 Creating symlinks..."
for dir in */; do
    package="${dir%/}"
    echo "  → Stowing $package"
    stow -R "$package"  # -R restows (useful for updates)
done

# After the stow loop, add:
if command -v kquitapp5 &> /dev/null; then
    echo "⚠️  KDE configs deployed. Please log out and back in for changes to take effect."
fi

# Common KDE Files to Track
# ~/.config/kglobalshortcutsrc                       # Global shortcuts
# ~/.config/kwinrc                                   # Window manager settings
# ~/.config/kdeglobals                               # General KDE settings
# ~/.config/plasma-org.kde.plasma.desktop-appletsrc  # Plasma panels/widgets
# ~/.config/khotkeysrc                               # Custom shortcuts
# ~/.config/konsolerc                                # Konsole terminal
# ~/.config/dolphinrc                                # Dolphin file manager

echo "✅ Dotfiles deployed successfully!"
