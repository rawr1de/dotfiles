#!/bin/bash

# SH_install_jetbrainsmono.sh
# Downloads and installs JetBrainsMono Nerd Font for the current user.

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

FONT_DIR="$HOME/.local/share/fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
FONT_ZIP="$FONT_DIR/JetBrainsMono.zip"

# ---------------------------------------------------------------------------
# Check and install dependencies
# ---------------------------------------------------------------------------
install_pkg() {
    local pkg="$1"
    echo -e "${YELLOW}$pkg not found. Installing...${NC}"
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -y "$pkg"
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm "$pkg"
    else
        echo -e "${RED}No supported package manager found. Install $pkg manually.${NC}"
        exit 1
    fi
}

for dep in curl unzip fc-cache; do
    if ! command -v "$dep" &>/dev/null; then
        case "$dep" in
            curl)    install_pkg curl ;;
            unzip)   install_pkg unzip ;;
            fc-cache) install_pkg fontconfig ;;
        esac
    fi
done

# ---------------------------------------------------------------------------
# Download and install
# ---------------------------------------------------------------------------
mkdir -p "$FONT_DIR"

echo -e "${YELLOW}Downloading JetBrainsMono Nerd Font...${NC}"
if ! curl -L --progress-bar "$FONT_URL" -o "$FONT_ZIP"; then
    echo -e "${RED}Download failed.${NC}"
    exit 1
fi

echo -e "${YELLOW}Extracting...${NC}"
if ! unzip -o "$FONT_ZIP" -d "$FONT_DIR" > /dev/null; then
    echo -e "${RED}Extraction failed.${NC}"
    exit 1
fi

rm -f "$FONT_ZIP"

echo -e "${YELLOW}Updating font cache...${NC}"
fc-cache -fv > /dev/null

echo -e "${GREEN}✓ JetBrainsMono Nerd Font installed.${NC}"
echo -e "${GREEN}  Set in kitty: font_family JetBrainsMono Nerd Font${NC}"
