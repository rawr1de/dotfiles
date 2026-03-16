#!/bin/bash

# SH_setup_keyd.sh
# Creates the keyd config directory and copies the default configuration.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_setup_keyd.sh ===${NC}\n"

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
SOURCE_CONF="$DOTFILES_DIR/wm/niri/default.conf"
DEST_DIR="/etc/keyd"
DEST_CONF="$DEST_DIR/default.conf"

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
if [ ! -f "$SOURCE_CONF" ]; then
    echo -e "${RED}✗ Source config not found: $SOURCE_CONF${NC}"
    echo -e "${YELLOW}Make sure your dotfiles are cloned and the path is correct.${NC}"
    exit 1
fi

echo -e "${YELLOW}Setting up keyd configuration...${NC}"
echo -e "  ${CYAN}Source:${NC} $SOURCE_CONF"
echo -e "  ${CYAN}Dest  :${NC} $DEST_CONF\n"

read -rp "Proceed? [y/N]: " confirm
[[ "${confirm,,}" != "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }
echo ""

# ---------------------------------------------------------------------------
# Execution
# ---------------------------------------------------------------------------
# 1. Create directory
if sudo mkdir -p "$DEST_DIR"; then
    echo -e "${GREEN}✓ Created directory: $DEST_DIR${NC}"
else
    echo -e "${RED}✗ Failed to create directory: $DEST_DIR${NC}"
    exit 1
fi

# 2. Copy config
if sudo cp "$SOURCE_CONF" "$DEST_CONF"; then
    echo -e "${GREEN}✓ Copied config to: $DEST_CONF${NC}"
else
    echo -e "${RED}✗ Failed to copy configuration file.${NC}"
    exit 1
fi

# 3. Reload keyd (if installed and running)
if command -v keyd &>/dev/null; then
    echo -e "${YELLOW}Reloading keyd daemon...${NC}"
    if sudo keyd reload 2>/dev/null; then
        echo -e "${GREEN}✓ keyd reloaded successfully.${NC}"
    else
        echo -e "${YELLOW}⚠ keyd is installed but not running (or reload failed).${NC}"
        echo -e "  Ensure the service is enabled via SH_setup_services.sh.${NC}"
    fi
fi

echo -e "\n${GREEN}${BOLD}✓ keyd setup complete.${NC}\n"
