#!/bin/bash

# SH_00_connect_wifi.sh
# Connects to a WPA2 network via wpa_supplicant on a fresh Void install.
# Interactive — prompts for SSID and password at runtime.
# Void Linux only.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_00_connect_wifi.sh ===${NC}\n"

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
if ! command -v wpa_supplicant &>/dev/null; then
    echo -e "${RED}wpa_supplicant not found. Are you on a base Void install?${NC}"
    exit 1
fi

# Detect wireless interface
IFACE=$(ip link | awk '/^[0-9]+: w/{gsub(/:/, "", $2); print $2; exit}')
if [ -z "$IFACE" ]; then
    echo -e "${RED}No wireless interface detected.${NC}"
    exit 1
fi
echo -e "  ${YELLOW}Interface :${NC} $IFACE"

# ---------------------------------------------------------------------------
# Credentials
# ---------------------------------------------------------------------------
echo ""
read -rp "SSID: " SSID
read -rsp "Password: " PSK
echo ""

if [ -z "$SSID" ] || [ -z "$PSK" ]; then
    echo -e "${RED}SSID and password cannot be empty.${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Generate wpa_supplicant config
# ---------------------------------------------------------------------------
WPA_CONF=$(mktemp /tmp/wpa_XXXXXX.conf)
wpa_passphrase "$SSID" "$PSK" > "$WPA_CONF"
# Clear PSK from memory
PSK=""

echo -e "\n${YELLOW}Bringing up $IFACE...${NC}"
ip link set "$IFACE" up

echo -e "${YELLOW}Starting wpa_supplicant...${NC}"
# Kill any existing instance first
pkill wpa_supplicant 2>/dev/null
sleep 1

wpa_supplicant -B -i "$IFACE" -c "$WPA_CONF"
if [ $? -ne 0 ]; then
    echo -e "${RED}wpa_supplicant failed to start.${NC}"
    rm -f "$WPA_CONF"
    exit 1
fi

echo -e "${YELLOW}Requesting DHCP lease...${NC}"
dhcpcd "$IFACE"

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
sleep 3
if ping -c 2 -W 3 1.1.1.1 &>/dev/null; then
    echo -e "\n${GREEN}${BOLD}✓ Connected. Network is up.${NC}"
else
    echo -e "\n${RED}✗ No connectivity. Check SSID/password or signal.${NC}"
    rm -f "$WPA_CONF"
    exit 1
fi

rm -f "$WPA_CONF"
echo -e "${YELLOW}Note: this connection is temporary. Run SH_04_setup_nm.sh after package install.${NC}\n"
