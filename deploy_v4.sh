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

install_packages_from_file() {
    local packages_file="$1"
    local label="$2"

    if [ ! -f "$packages_file" ]; then
        echo -e "${YELLOW}  No packages.txt found at $packages_file, skipping...${NC}"
        return
    fi

    mapfile -t PKGS < <(grep -v '^\s*#' "$packages_file" | grep -v '^\s*$')

    if [ ${#PKGS[@]} -eq 0 ]; then
        echo -e "${YELLOW}  $label packages.txt is empty, skipping...${NC}"
        return
    fi

    echo -e "${CYAN}  [$label] Packages to install:${NC}"
    for pkg in "${PKGS[@]}"; do
        echo -e "    ${CYAN}·${NC} $pkg"
    done
    echo ""

    echo -e "${YELLOW}  Installing $label packages with yay...${NC}"
    yay -S --needed --noconfirm "${PKGS[@]}"
}

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

# 1. Install common packages
print_header "Installing common packages"
install_packages_from_file "$DOTFILES_DIR/common/packages.txt" "common"

# 2. Install machine-specific packages
print_header "Installing $MACHINE packages"
install_packages_from_file "$DOTFILES_DIR/$MACHINE/packages.txt" "$MACHINE"

# 3. Stow selected common packages
if [ ${#SELECTED_COMMON[@]} -gt 0 ]; then
    print_header "Stowing common packages"
    for pkg in "${SELECTED_COMMON[@]}"; do
        stow_package "common" "$pkg"
    done
fi

# 4. Stow chosen WM
if [ -n "$CHOSEN_WM" ]; then
    print_header "Stowing WM configs"
    stow_package "wm" "$CHOSEN_WM"
fi

# 5. KDE post-install notice
if [ "$CHOSEN_WM" = "kde" ]; then
    echo -e "\n${YELLOW}⚠  KDE configs deployed. Log out and back in for changes to take effect.${NC}"
fi

echo -e "\n${GREEN}${BOLD}✅ Dotfiles deployed successfully!${NC}\n"
