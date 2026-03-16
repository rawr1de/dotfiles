#!/bin/bash

# SH_setup_nm.sh
# Migrates from wpa_supplicant + dhcpcd to NetworkManager.
# Void Linux only.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_setup_nm.sh ===${NC}\n"
echo -e "Swaps wpa_supplicant + dhcpcd for NetworkManager.\n"

if ! command -v xbps-install &>/dev/null; then
    echo -e "${RED}This script is Void Linux only.${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
if ! xbps-query NetworkManager &>/dev/null; then
    echo -e "${YELLOW}NetworkManager not installed. Installing...${NC}"
    sudo xbps-install -y NetworkManager
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install NetworkManager.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ NetworkManager installed.${NC}\n"
fi

read -rp "Proceed with migration? Active network will drop briefly. [y/N]: " confirm
[[ "${confirm,,}" != "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }
echo ""

ERRORS=0

# ---------------------------------------------------------------------------
# Disable old services
# ---------------------------------------------------------------------------
for svc in wpa_supplicant dhcpcd; do
    if [ -L "/var/service/$svc" ]; then
        sudo sv stop "$svc" 2>/dev/null
        sudo rm "/var/service/$svc"
        echo -e "${RED}✓ Disabled: $svc${NC}"
    else
        echo -e "${YELLOW}⊘ Not enabled, skipping: $svc${NC}"
    fi
done

echo ""

# ---------------------------------------------------------------------------
# Enable NetworkManager
# ---------------------------------------------------------------------------
if [ ! -d "/etc/sv/NetworkManager" ]; then
    echo -e "${RED}✗ /etc/sv/NetworkManager not found. Package may not be installed correctly.${NC}"
    exit 1
fi

if [ -L "/var/service/NetworkManager" ]; then
    echo -e "${YELLOW}⊘ NetworkManager already enabled.${NC}"
else
    sudo ln -s /etc/sv/NetworkManager /var/service/
    echo -e "${GREEN}✓ Enabled: NetworkManager${NC}"
fi

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
sleep 4
echo ""
if ping -c 2 -W 3 1.1.1.1 &>/dev/null; then
    echo -e "${GREEN}${BOLD}✓ Network is up under NetworkManager.${NC}\n"
else
    echo -e "${YELLOW}⚠ No connectivity yet. NetworkManager may still be initializing.${NC}"
    echo -e "${YELLOW}  Use 'nmtui' to configure your connection if needed.${NC}\n"
fi
