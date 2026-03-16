#!/bin/bash

# SH_setup_keyd.sh
# Creates the keyd config directory, copies the default configuration,
# and enables/restarts the systemd service.

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

# 3. Enable and restart keyd via systemd
echo -e "${YELLOW}Configuring systemd service...${NC}"
if command -v systemctl &>/dev/null; then
    # Enable the service to start on boot
    if sudo systemctl enable keyd.service 2>/dev/null; then
        echo -e "${GREEN}✓ keyd.service enabled for boot.${NC}"
    else
        echo -e "${RED}✗ Failed to enable keyd.service.${NC}"
    fi

    # Restart the service to apply the new config immediately
    if sudo systemctl restart keyd.service; then
        echo -e "${GREEN}✓ keyd daemon restarted successfully.${NC}"
    else
        echo -e "${RED}✗ Failed to restart keyd.service. Check 'systemctl status keyd' for details.${NC}"
    fi
else
    echo -e "${RED}✗ systemctl command not found. Is systemd running?${NC}"
fi

echo -e "\n${GREEN}${BOLD}✓ keyd setup complete.${NC}\n"
