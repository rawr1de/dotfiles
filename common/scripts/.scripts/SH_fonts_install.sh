#!/bin/bash

# SH_fonts_install.sh
# Installs required fonts via the system package manager.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_fonts_install.sh ===${NC}\n"

# ---------------------------------------------------------------------------
# Font Packages
# ---------------------------------------------------------------------------
FONTS=(
    "font-jetbrains-mono-nerd-fonts"
    "font-awesome6"
    "noto-fonts-emoji"
    "nerd-fonts"
)

if ! command -v xbps-install &>/dev/null && ! command -v pacman &>/dev/null; then
    echo -e "${RED}No supported package manager found (xbps/pacman).${NC}"
    exit 1
fi

# Ensure fontconfig is installed so we can run fc-cache later
if ! command -v fc-cache &>/dev/null; then
    echo -e "${YELLOW}Installing fontconfig...${NC}"
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -y fontconfig >/dev/null
    else
        sudo pacman -S --needed --noconfirm fontconfig >/dev/null
    fi
fi

echo -e "${YELLOW}Installing fonts...${NC}\n"

ERRORS=0

# ---------------------------------------------------------------------------
# Installation Loop
# ---------------------------------------------------------------------------
for font in "${FONTS[@]}"; do
    echo -e "  ${CYAN}· ${font}${NC}"
    
    if command -v xbps-install &>/dev/null; then
        if sudo xbps-install -y "$font"; then
            echo -e "    ${GREEN}✓ Installed${NC}"
        else
            echo -e "    ${RED}✗ Failed${NC}"
            ((ERRORS++))
        fi
        
    elif command -v pacman &>/dev/null; then
        if sudo pacman -S --needed --noconfirm "$font" 2>/dev/null; then
            echo -e "    ${GREEN}✓ Installed${NC}"
        elif command -v yay &>/dev/null && yay -S --needed --noconfirm "$font" 2>/dev/null; then
            echo -e "    ${GREEN}✓ Installed (AUR)${NC}"
        else
            echo -e "    ${RED}✗ Failed${NC}"
            ((ERRORS++))
        fi
    fi
done

# ---------------------------------------------------------------------------
# Update Font Cache
# ---------------------------------------------------------------------------
echo -e "\n${YELLOW}Updating font cache...${NC}"
fc-cache -fv > /dev/null

if [ "$ERRORS" -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}✓ All fonts installed successfully.${NC}"
    echo -e "${GREEN}  Set in kitty: font_family JetBrainsMono Nerd Font${NC}\n"
else
    echo -e "\n${YELLOW}${BOLD}⚠ Finished with $ERRORS error(s).${NC}\n"
fi
