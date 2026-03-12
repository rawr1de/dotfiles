#!/bin/bash

# SH_tty1_autologin.sh
# Configures TTY1 to automatically log in the current user on boot.
# Void Linux only — uses runit/agetty service configuration.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

AGETTY_CONF="/etc/sv/agetty-tty1/conf"
TARGET_USER="${1:-$(whoami)}"

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
echo -e "${BLUE}=== TTY1 Autologin Setup ===${NC}\n"
echo -e "This script will configure TTY1 to automatically log in as:"
echo -e "  ${YELLOW}$TARGET_USER${NC}\n"
echo -e "File to be modified: ${YELLOW}$AGETTY_CONF${NC}\n"

# Check if agetty conf exists
if [ ! -f "$AGETTY_CONF" ]; then
    echo -e "${RED}Error: $AGETTY_CONF not found.${NC}"
    echo -e "${RED}Are you on Void Linux with agetty-tty1 service?${NC}"
    exit 1
fi

# Show current contents
echo -e "${BLUE}Current contents of $AGETTY_CONF:${NC}"
cat "$AGETTY_CONF"
echo ""

# ---------------------------------------------------------------------------
# Confirm
# ---------------------------------------------------------------------------
read -rp "Proceed with autologin setup for '$TARGET_USER'? [y/N]: " confirm
if [[ ! "${confirm,,}" == "y" ]]; then
    echo -e "${YELLOW}Aborted. No changes made.${NC}"
    exit 0
fi

# ---------------------------------------------------------------------------
# Apply
# ---------------------------------------------------------------------------
sudo tee "$AGETTY_CONF" << EOF
# TTY1 autologin — managed by SH_tty1_autologin.sh
# To disable: remove --autologin and the username, then restart agetty-tty1
GETTY_ARGS="--autologin $TARGET_USER --noclear"
BAUD_RATE=38400
TERM_NAME=linux
EOF

echo -e "\n${GREEN}✓ Autologin configured for '$TARGET_USER' on TTY1.${NC}"
echo -e "${YELLOW}Restart agetty to apply:${NC}"
echo -e "  sudo sv restart agetty-tty1"
