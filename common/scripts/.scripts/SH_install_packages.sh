#!/bin/bash

# SH_install_packages.sh
# Installs packages from one or more packages.txt files in the dotfiles repo.
# Can be run standalone or called from deploy_v4.sh
#
# Usage:
#   bash SH_install_packages.sh common
#   bash SH_install_packages.sh legion
#   bash SH_install_packages.sh common legion

DOTFILES_DIR="$HOME/.dotfiles"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
echo -e "${BLUE}${BOLD}=== SH_install_packages.sh ===${NC}"
echo -e "${CYAN}Installs packages from one or more packages.txt files in your dotfiles repo.${NC}"
echo -e "${CYAN}Pass one or more profile names as arguments — each must have a packages.txt.${NC}\n"
echo -e "  ${YELLOW}Usage   :${NC} $0 <profile> [profile2 ...]"
echo -e "  ${YELLOW}Examples:${NC} $0 common"
echo -e "           $0 legion"
echo -e "           $0 common legion\n"

if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No profile specified.${NC}"
    exit 1
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    exit 1
fi

if ! command -v yay &> /dev/null; then
    echo -e "${RED}Error: yay not found. Run deploy_v4.sh first to bootstrap it.${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Install packages for each profile passed as argument
# ---------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}=== Package Installer ===${NC}\n"

ERRORS=0

for profile in "$@"; do
    PACKAGES_FILE="$DOTFILES_DIR/$profile/packages.txt"

    if [ ! -f "$PACKAGES_FILE" ]; then
        echo -e "${YELLOW}⚠  No packages.txt found for '$profile' at $PACKAGES_FILE — skipping.${NC}"
        continue
    fi

    mapfile -t PKGS < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')

    if [ ${#PKGS[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠  packages.txt for '$profile' is empty — skipping.${NC}"
        continue
    fi

    echo -e "${CYAN}${BOLD}[$profile]${NC} Packages to install:\n"
    for pkg in "${PKGS[@]}"; do
        echo -e "  ${CYAN}·${NC} $pkg"
    done
    echo ""

    echo -e "${YELLOW}  Installing [$profile] packages with yay...${NC}\n"
    if yay -S --needed --noconfirm "${PKGS[@]}"; then
        echo -e "${GREEN}✓ [$profile] packages installed successfully.${NC}\n"
    else
        echo -e "${RED}✗ [$profile] some packages failed to install.${NC}\n"
        ((ERRORS++))
    fi
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✅ All packages installed successfully.${NC}\n"
else
    echo -e "${YELLOW}${BOLD}⚠  Done with $ERRORS error(s). Check output above.${NC}\n"
fi
