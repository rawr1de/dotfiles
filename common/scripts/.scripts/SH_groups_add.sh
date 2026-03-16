#!/bin/bash

# SH_groups_add.sh
# Appends essential Wayland and hardware groups to the current user
# and prompts for a reboot to apply the changes.
# if using virtual machines:
# 1. sudo pacman -S libvirt qemu-desktop
# 2. swap GROUPS_TO_ADD line to: GROUPS_TO_ADD="video,lp,rfkill,libvirt,kvm"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

GROUPS_TO_ADD="video,lp,rfkill,kvm"

echo -e "${YELLOW}Adding user '$USER' to groups: $GROUPS_TO_ADD${NC}...\n"

# Run usermod with sudo. (Using $USER ensures it targets your actual user account, 
# as long as you run the script directly and not via 'sudo ./script.sh')
if sudo usermod -aG "$GROUPS_TO_ADD" "$USER"; then
    echo -e "${GREEN}✓ Groups successfully updated!${NC}\n"
else
    echo -e "${RED}✗ Failed to update groups. Please check your permissions.${NC}"
    exit 1
fi

echo -e "Reboot required to assign new groups"
read -rp "Reboot now? [y/N]: " confirm

# Check if the user typed 'y' or 'Y'
if [[ "${confirm,,}" == "y" ]]; then
    echo -e "${YELLOW}Rebooting system...${NC}"
    
    # Grab OS info dynamically instead of relying on hostnames
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        CURRENT_OS="$ID"
    else
        CURRENT_OS="unknown"
    fi

    # Reboot machine based on OS installed
    case "$CURRENT_OS" in
        arch)
            reboot
            ;;
        void)
            loginctl reboot
            ;;
        *)
            # Fallback
            reboot
            ;;
    esac
else
    echo -e "\n${GREEN}Reboot cancelled.${NC} Remember to log out or reboot later to apply the changes."
fi
