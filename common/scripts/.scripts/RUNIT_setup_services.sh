#!/bin/bash

# SH_setup_services.sh
# Enables and disables runit services for a fresh Void install.
# Void Linux only.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_setup_services.sh ===${NC}\n"

if ! command -v xbps-install &>/dev/null; then
    echo -e "${RED}This script is Void Linux only.${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Service lists
# ---------------------------------------------------------------------------
ENABLE=(
    acpid
    chronyd
    dbus
    elogind
    keyd
    NetworkManager
    polkitd
    sshd
    udevd
)

DISABLE=(
    dhcpcd
    wpa_supplicant
    greetd
)

# ---------------------------------------------------------------------------
# Preview
# ---------------------------------------------------------------------------
echo -e "${GREEN}Services to ENABLE:${NC}"
for s in "${ENABLE[@]}"; do
    echo -e "  ${GREEN}+${NC} $s"
done

echo -e "\n${RED}Services to DISABLE:${NC}"
for s in "${DISABLE[@]}"; do
    echo -e "  ${RED}-${NC} $s"
done

echo ""
read -rp "Proceed? [y/N]: " confirm
[[ "${confirm,,}" != "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }
echo ""

# ---------------------------------------------------------------------------
# Enable
# ---------------------------------------------------------------------------
ERRORS=0

for svc in "${ENABLE[@]}"; do
    if [ ! -d "/etc/sv/$svc" ]; then
        echo -e "${YELLOW}⚠ /etc/sv/$svc not found — is the package installed?${NC}"
        ((ERRORS++))
        continue
    fi
    if [ -L "/var/service/$svc" ]; then
        echo -e "${YELLOW}⊘ Already enabled: $svc${NC}"
        continue
    fi
    if sudo ln -s "/etc/sv/$svc" /var/service/; then
        echo -e "${GREEN}✓ Enabled: $svc${NC}"
    else
        echo -e "${RED}✗ Failed to enable: $svc${NC}"
        ((ERRORS++))
    fi
done

echo ""

# ---------------------------------------------------------------------------
# Disable
# ---------------------------------------------------------------------------
for svc in "${DISABLE[@]}"; do
    if [ ! -L "/var/service/$svc" ]; then
        echo -e "${YELLOW}⊘ Not enabled, skipping: $svc${NC}"
        continue
    fi
    if sudo rm "/var/service/$svc"; then
        echo -e "${RED}✓ Disabled: $svc${NC}"
    else
        echo -e "${RED}✗ Failed to disable: $svc${NC}"
        ((ERRORS++))
    fi
done

echo ""
if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ Services configured.${NC}"
    echo -e "${YELLOW}Note: run SH_tty1_autologin.sh separately to configure agetty-tty1.${NC}\n"
else
    echo -e "${YELLOW}${BOLD}⚠ Done with $ERRORS error(s). Check output above.${NC}\n"
fi
