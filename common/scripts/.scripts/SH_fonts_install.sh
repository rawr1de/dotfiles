#!/bin/bash

# SH_fonts_install.sh
# Installs fonts via package manager and manually downloads JetBrainsMono Nerd Font.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_fonts_install.sh ===${NC}\n"

FONT_DIR="$HOME/.local/share/fonts"
JB_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
JB_ZIP="/tmp/JetBrainsMono.zip"

# Fonts to install via package manager
# Note: 'nerd-fonts' on Void is a massive package. If you only want JetBrains, 
# you might want to remove 'nerd-fonts' from this list, but I left it per your request.
REPO_FONTS=(
    "font-awesome6"
    "noto-fonts-emoji"
    "nerd-fonts"
)

# ---------------------------------------------------------------------------
# Package Manager Setup
# ---------------------------------------------------------------------------
if command -v xbps-install &>/dev/null; then
    PM_INSTALL="sudo xbps-install -y"
elif command -v pacman &>/dev/null; then
    PM_INSTALL="sudo pacman -S --needed --noconfirm"
else
    echo -e "${RED}No supported package manager found (xbps/pacman).${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Install Dependencies & Repo Fonts
# ---------------------------------------------------------------------------
echo -e "${YELLOW}Installing dependencies and repo fonts...${NC}"

ERRORS=0

# Ensure we have curl, unzip, and fontconfig for the manual download
for pkg in curl unzip fontconfig "${REPO_FONTS[@]}"; do
    echo -e "  ${CYAN}· ${pkg}${NC}"
    if $PM_INSTALL "$pkg" >/dev/null 2>&1; then
        echo -e "    ${GREEN}✓ Installed${NC}"
    else
        # Try AUR fallback if on Arch and pacman failed
        if command -v yay &>/dev/null && yay -S --needed --noconfirm "$pkg" >/dev/null 2>&1; then
            echo -e "    ${GREEN}✓ Installed (AUR)${NC}"
        else
            echo -e "    ${RED}✗ Failed${NC}"
            ((ERRORS++))
        fi
    fi
done

# ---------------------------------------------------------------------------
# Manual JetBrains Mono Nerd Font Download
# ---------------------------------------------------------------------------
echo -e "\n${YELLOW}Downloading JetBrains Mono Nerd Font...${NC}"
mkdir -p "$FONT_DIR"

if curl -L --progress-bar "$JB_URL" -o "$JB_ZIP"; then
    echo -e "${YELLOW}Extracting to $FONT_DIR...${NC}"
    if unzip -oq "$JB_ZIP" -d "$FONT_DIR"; then
        echo -e "  ${GREEN}✓ JetBrains Mono installed.${NC}"
        rm -f "$JB_ZIP"
    else
        echo -e "  ${RED}✗ Failed to extract $JB_ZIP${NC}"
        ((ERRORS++))
    fi
else
    echo -e "  ${RED}✗ Failed to download JetBrains Mono.${NC}"
    ((ERRORS++))
fi

# ---------------------------------------------------------------------------
# Update Font Cache
# ---------------------------------------------------------------------------
echo -e "\n${YELLOW}Updating font cache...${NC}"
if command -v fc-cache &>/dev/null; then
    fc-cache -fv > /dev/null
    echo -e "  ${GREEN}✓ Cache updated.${NC}"
else
    echo -e "  ${RED}✗ fc-cache not found. Font cache not updated.${NC}"
    ((ERRORS++))
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
if [ "$ERRORS" -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}✓ All fonts installed successfully.${NC}"
    echo -e "${CYAN}  Set in kitty: font_family JetBrainsMono Nerd Font${NC}\n"
else
    echo -e "\n${YELLOW}${BOLD}⚠ Finished with $ERRORS error(s).${NC}\n"
fi
