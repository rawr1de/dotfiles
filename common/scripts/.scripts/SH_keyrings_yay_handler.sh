#!/bin/bash

# SH_keyrings_yay_handler.sh (Arch / Manjaro)
# Fixes GPG keyrings and bootstraps yay (AUR helper).
# Run this BEFORE SH_install_packages.sh on a fresh Arch/Manjaro install.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_keyrings_yay_handler.sh ===${NC}\n"

# ---------------------------------------------------------------------------
# 1. Fix keyrings (crucial for fresh ISOs — outdated keys cause pacman failures)
# ---------------------------------------------------------------------------
echo -e "${YELLOW}Fixing GPG keyrings...${NC}"
sudo pacman -Sy archlinux-keyring manjaro-keyring --noconfirm
sudo pacman-key --init && sudo pacman-key --populate archlinux manjaro
echo -e "${GREEN}✓ Keyrings updated.${NC}\n"

# ---------------------------------------------------------------------------
# 2. Bootstrap yay
# ---------------------------------------------------------------------------
if command -v yay &>/dev/null; then
    echo -e "${GREEN}✓ yay already installed — skipping.${NC}\n"
else
    echo -e "${YELLOW}Installing yay...${NC}"
    sudo pacman -S --needed base-devel git --noconfirm

    _yay_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$_yay_dir"

    cd "$_yay_dir" && makepkg -si --noconfirm && cd - && rm -rf "$_yay_dir"

    if command -v yay &>/dev/null; then
        echo -e "${GREEN}✓ yay installed.${NC}\n"
    else
        echo -e "${RED}✗ yay install failed. Check errors above.${NC}\n"
        exit 1
    fi
fi
