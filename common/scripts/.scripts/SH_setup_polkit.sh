#!/bin/bash

# SH_06_setup_polkit.sh
# Deploys polkit power management rules for wheel group.
# Allows reboot/poweroff without password for wheel users.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

RULES_DIR="/etc/polkit-1/rules.d"
RULES_FILE="$RULES_DIR/10-power-management.rules"

echo -e "${BLUE}${BOLD}=== SH_06_setup_polkit.sh ===${NC}\n"
echo -e "Deploys power management polkit rules for the wheel group."
echo -e "Enables reboot/poweroff without password prompt.\n"
echo -e "  ${YELLOW}Target:${NC} $RULES_FILE\n"

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
if [ ! -d "$RULES_DIR" ]; then
    echo -e "${RED}✗ $RULES_DIR not found. Is polkit installed?${NC}"
    exit 1
fi

if [ -f "$RULES_FILE" ]; then
    echo -e "${YELLOW}Existing file found:${NC}"
    cat "$RULES_FILE"
    echo ""
    read -rp "Overwrite? [y/N]: " confirm
    [[ "${confirm,,}" != "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }
    echo ""
fi

# ---------------------------------------------------------------------------
# Deploy
# ---------------------------------------------------------------------------
sudo tee "$RULES_FILE" > /dev/null << 'RULES'
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.login1.reboot" ||
         action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
         action.id == "org.freedesktop.login1.power-off" ||
         action.id == "org.freedesktop.login1.power-off-multiple-sessions") &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
RULES

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Rules deployed to $RULES_FILE${NC}"
    echo -e "${YELLOW}Note: ensure your user is in the wheel group:${NC}"
    echo -e "  sudo usermod -aG wheel \$USER\n"
else
    echo -e "${RED}✗ Failed to write rules file.${NC}"
    exit 1
fi
