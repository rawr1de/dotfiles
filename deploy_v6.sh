#!/bin/bash

# deploy.sh — Interactive dotfiles deployment
# Assumes: Arch Linux, GNU Stow, clean slate (run SH_stow_conflict_handler.sh first)

DOTFILES_DIR="$HOME/.dotfiles"
YAY_BUILD_DIR="$HOME/tmp/yay_build"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
print_header() {
    echo -e "\n${BLUE}${BOLD}=== $1 ===${NC}\n"
}

stow_package() {
    local category="$1"
    local package="$2"
    echo -e "  ${GREEN}→ Stowing $category/$package${NC}"
    stow -R --dir="$DOTFILES_DIR/$category" --target="$HOME" "$package"
}

INSTALL_SCRIPT="$DOTFILES_DIR/common/scripts/SH_install_packages.sh"

echo -e "${BLUE}${BOLD}=== deploy_v4.sh ===${NC}"
echo -e "${CYAN}Interactive dotfiles deployment script for Arch Linux.${NC}"
echo -e "${CYAN}Steps through machine selection, WM selection, common package stowing,${NC}"
echo -e "${CYAN}package installation and WM-specific post-install tasks.${NC}\n"
echo -e "  ${YELLOW}Prerequisites :${NC} ~/.dotfiles repo cloned, GNU Stow installed"
echo -e "  ${YELLOW}Run first     :${NC} bash SH_stow_conflict_handler.sh  (resolves stow conflicts)"
echo -e "  ${YELLOW}Usage         :${NC} bash deploy_v4.sh  (no arguments — fully interactive)\n"

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    echo -e "${YELLOW}Clone your repo first: git clone https://github.com/rawr1de/dotfiles.git $DOTFILES_DIR${NC}"
    exit 1
fi

if ! command -v stow &> /dev/null; then
    echo -e "${RED}GNU Stow not found. Install it first: sudo pacman -S stow${NC}"
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1

# ---------------------------------------------------------------------------
# Step 0 — Ensure yay is available
# ---------------------------------------------------------------------------
print_header "Step 0 — Checking for yay"

if command -v yay &> /dev/null; then
    echo -e "${GREEN}✓ yay is already installed, skipping bootstrap.${NC}"
else
    echo -e "${YELLOW}yay not found — bootstrapping from AUR...${NC}\n"

    echo -e "${CYAN}  Installing base-devel, make and go via pacman...${NC}"
    sudo pacman -Syyy --needed --noconfirm base-devel make go

    echo -e "${CYAN}  Cloning yay into $YAY_BUILD_DIR...${NC}"
    mkdir -p "$YAY_BUILD_DIR"
    git clone https://aur.archlinux.org/yay.git "$YAY_BUILD_DIR"

    echo -e "${CYAN}  Building and installing yay...${NC}"
    cd "$YAY_BUILD_DIR" || exit 1
    makepkg -si --noconfirm

    cd "$DOTFILES_DIR" || exit 1

    echo -e "${CYAN}  Cleaning up build directory...${NC}"
    rm -rf "$YAY_BUILD_DIR"

    if ! command -v yay &> /dev/null; then
        echo -e "${RED}yay installation failed. Aborting.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ yay installed successfully.${NC}"
fi

# ---------------------------------------------------------------------------
# Step 1 — Machine selection
# ---------------------------------------------------------------------------
print_header "Step 1 — Select your machine"

MACHINES=()
for d in "$DOTFILES_DIR"/*/; do
    name=$(basename "$d")
    [[ "$name" == "common" ]] && continue
    [[ "$name" == "wm"     ]] && continue
    [[ "$name" == "git"    ]] && continue
    [[ "$name" == ".*"     ]] && continue
    [ -d "$d" ] && MACHINES+=("$name")
done

if [ ${#MACHINES[@]} -eq 0 ]; then
    echo -e "${RED}No machine directories found in $DOTFILES_DIR${NC}"
    exit 1
fi

echo -e "Available machines:\n"
for i in "${!MACHINES[@]}"; do
    echo -e "  ${CYAN}[$((i+1))]${NC} ${MACHINES[$i]}"
done
echo ""

while true; do
    read -p "Select machine [1-${#MACHINES[@]}]: " machine_choice
    if [[ "$machine_choice" =~ ^[0-9]+$ ]] && \
       [ "$machine_choice" -ge 1 ] && \
       [ "$machine_choice" -le "${#MACHINES[@]}" ]; then
        MACHINE="${MACHINES[$((machine_choice-1))]}"
        echo -e "${GREEN}✓ Machine: $MACHINE${NC}"
        break
    fi
    echo -e "${RED}Invalid choice, try again.${NC}"
done

# ---------------------------------------------------------------------------
# Step 2 — WM selection
# ---------------------------------------------------------------------------
print_header "Step 2 — Select your Window Manager / Desktop Environment"

WM_DIR="$DOTFILES_DIR/wm"
WMS=()

for d in "$WM_DIR"/*/; do
    name=$(basename "$d")
    [ -d "$d" ] && WMS+=("$name")
done

if [ ${#WMS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No WM directories found under wm/, skipping WM stow.${NC}"
    CHOSEN_WM=""
else
    echo -e "Available window managers:\n"
    for i in "${!WMS[@]}"; do
        echo -e "  ${CYAN}[$((i+1))]${NC} ${WMS[$i]}"
    done
    echo ""

    while true; do
        read -p "Select WM [1-${#WMS[@]}]: " wm_choice
        if [[ "$wm_choice" =~ ^[0-9]+$ ]] && \
           [ "$wm_choice" -ge 1 ] && \
           [ "$wm_choice" -le "${#WMS[@]}" ]; then
            CHOSEN_WM="${WMS[$((wm_choice-1))]}"
            echo -e "${GREEN}✓ WM: $CHOSEN_WM${NC}"
            break
        fi
        echo -e "${RED}Invalid choice, try again.${NC}"
    done
fi

# ---------------------------------------------------------------------------
# Step 3 — Common packages selection
# ---------------------------------------------------------------------------
print_header "Step 3 — Select common packages to stow"

COMMON_DIR="$DOTFILES_DIR/common"
COMMON_PKGS=()

for d in "$COMMON_DIR"/*/; do
    name=$(basename "$d")
    [[ "$name" == README*   ]] && continue
    [[ "$name" == NOTES*    ]] && continue
    [[ "$name" == packages* ]] && continue
    [ -d "$d" ] && COMMON_PKGS+=("$name")
done

if [ ${#COMMON_PKGS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No packages found under common/, skipping.${NC}"
    SELECTED_COMMON=()
else
    echo -e "Select which common packages to stow."
    echo -e "${YELLOW}(Enter numbers separated by spaces, or 'all' for everything)\n${NC}"

    for i in "${!COMMON_PKGS[@]}"; do
        echo -e "  ${CYAN}[$((i+1))]${NC} ${COMMON_PKGS[$i]}"
    done
    echo ""

    read -p "Your selection: " common_input

    SELECTED_COMMON=()

    if [[ "${common_input,,}" == "all" ]]; then
        SELECTED_COMMON=("${COMMON_PKGS[@]}")
    else
        for token in $common_input; do
            if [[ "$token" =~ ^[0-9]+$ ]] && \
               [ "$token" -ge 1 ] && \
               [ "$token" -le "${#COMMON_PKGS[@]}" ]; then
                SELECTED_COMMON+=("${COMMON_PKGS[$((token-1))]}")
            else
                echo -e "${YELLOW}  Ignoring invalid selection: $token${NC}"
            fi
        done
    fi

    if [ ${#SELECTED_COMMON[@]} -eq 0 ]; then
        echo -e "${YELLOW}No common packages selected.${NC}"
    else
        echo -e "${GREEN}✓ Selected: ${SELECTED_COMMON[*]}${NC}"
    fi
fi

# ---------------------------------------------------------------------------
# Summary before proceeding
# ---------------------------------------------------------------------------
print_header "Deployment Summary"

echo -e "  ${BOLD}Machine       :${NC} $MACHINE"
echo -e "  ${BOLD}WM            :${NC} ${CHOSEN_WM:-none}"
echo -e "  ${BOLD}Common stow   :${NC} ${SELECTED_COMMON[*]:-none}"
echo -e "  ${BOLD}Packages      :${NC} common/packages.txt + $MACHINE/packages.txt"
echo ""
read -p "Proceed? [y/N]: " confirm
[[ "${confirm,,}" != "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }

# ---------------------------------------------------------------------------
# Execute
# ---------------------------------------------------------------------------

# 1. Install common + machine packages
print_header "Installing packages"

if [ -f "$INSTALL_SCRIPT" ]; then
    bash "$INSTALL_SCRIPT" common "$MACHINE"
else
    echo -e "${RED}✗ SH_install_packages.sh not found at $INSTALL_SCRIPT — skipping package installs.${NC}"
fi

# 2. Stow selected common packages
if [ ${#SELECTED_COMMON[@]} -gt 0 ]; then
    print_header "Stowing common packages"
    for pkg in "${SELECTED_COMMON[@]}"; do
        stow_package "common" "$pkg"
    done
fi

# 3. Stow chosen WM
if [ -n "$CHOSEN_WM" ]; then
    print_header "Stowing WM configs"
    stow_package "wm" "$CHOSEN_WM"
fi

# 4. KDE post-install notice
if [ "$CHOSEN_WM" = "kde" ]; then
    echo -e "\n${YELLOW}⚠  KDE configs deployed. Log out and back in for changes to take effect.${NC}"
fi

# 5. XFCE post-install
if [ "$CHOSEN_WM" = "xfce" ]; then
    print_header "XFCE post-install"

    # Copy xfce4-desktop.xml (disables desktop icons)
    XFCE_XML="$DOTFILES_DIR/wm/xfce/xfce4-desktop.xml"
    XFCE_XML_TARGET="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"

    if [ -f "$XFCE_XML" ]; then
        mkdir -p "$(dirname "$XFCE_XML_TARGET")"
        cp "$XFCE_XML" "$XFCE_XML_TARGET"
        echo -e "${GREEN}✓ xfce4-desktop.xml deployed (desktop icons disabled).${NC}"
    else
        echo -e "${YELLOW}⚠  wm/xfce/xfce4-desktop.xml not found, skipping.${NC}"
    fi

    # Rename XDG home directories
    RENAME_SCRIPT="$DOTFILES_DIR/common/scripts/SH_rename_xdg_dirs.sh"

    if [ -f "$RENAME_SCRIPT" ]; then
        echo -e "${CYAN}  Running XDG directory renamer...${NC}"
        bash "$RENAME_SCRIPT"
    else
        echo -e "${YELLOW}⚠  common/scripts/SH_rename_xdg_dirs.sh not found, skipping.${NC}"
    fi

    echo -e "\n${YELLOW}⚠  XFCE configs deployed. Log out and back in for changes to take effect.${NC}"
fi

echo -e "\n${GREEN}${BOLD}✅ Dotfiles deployed successfully!${NC}\n"
