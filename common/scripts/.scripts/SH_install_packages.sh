#!/bin/bash

# SH_install_packages.sh
# Installs packages from one or more package files in the dotfiles repo.
# Can be run standalone or called from deploy_v4.sh
#
# Supported package files per profile (all optional except packages.txt):
#   packages.txt          — core/official repo packages
#   packages_aur.txt      — AUR packages
#   packages_optional.txt — optional/extra packages
#
# Usage:
#   bash SH_install_packages.sh common
#   bash SH_install_packages.sh legion
#   bash SH_install_packages.sh common legion
#   bash SH_install_packages.sh wm/xfce

DOTFILES_DIR="$HOME/.dotfiles"

# Package files to look for in each profile directory (in order)
PACKAGE_FILES=("packages.txt" "packages_base.txt" "packages_opt.txt")

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
echo -e "${CYAN}Installs packages from one or more package files in your dotfiles repo.${NC}"
echo -e "${CYAN}Pass one or more profile names as arguments.${NC}\n"
echo -e "  ${YELLOW}Usage   :${NC} $0 <profile> [profile2 ...]"
echo -e "  ${YELLOW}Examples:${NC} $0 common"
echo -e "           $0 legion"
echo -e "           $0 common legion"
echo -e "           $0 wm/xfce\n"
echo -e "  ${YELLOW}Package files recognized per profile:${NC}"
for f in "${PACKAGE_FILES[@]}"; do
    echo -e "    ${CYAN}·${NC} $f"
done
echo ""

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
# Checkbox selection function
# ---------------------------------------------------------------------------
# Usage: checkbox_select RESULT_VAR "label1" "label2" ...
# Returns selected indices in RESULT_VAR as an array
checkbox_select() {
    local result_var="$1"
    shift
    local options=("$@")
    local selected=()
    local cursor=0
    local count=${#options[@]}

    # All start unchecked
    for ((i=0; i<count; i++)); do
        selected+=(0)
    done

    # Hide cursor
    tput civis

    _render_checkboxes() {
        for ((i=0; i<count; i++)); do
            if [ "$i" -eq "$cursor" ]; then
                echo -ne "  ${BOLD}${CYAN}▶${NC} "
            else
                echo -ne "    "
            fi
            if [ "${selected[$i]}" -eq 1 ]; then
                echo -e "${GREEN}[✔]${NC} ${options[$i]}"
            else
                echo -e "${YELLOW}[ ]${NC} ${options[$i]}"
            fi
        done
        echo -e "\n  ${YELLOW}(↑/↓ move, Space toggle, Enter confirm)${NC}"
    }

    _render_checkboxes

    while true; do
        # Read a key
        IFS= read -r -s -n1 key
        if [[ $key == $'\x1b' ]]; then
            read -r -s -n2 key2
            key+="$key2"
        fi

        # Move cursor up to re-render
        tput cuu $((count + 2))

        case "$key" in
            $'\x1b[A'|'k')  # Up
                ((cursor = (cursor - 1 + count) % count)) ;;
            $'\x1b[B'|'j')  # Down
                ((cursor = (cursor + 1) % count)) ;;
            ' ')             # Space — toggle
                if [ "${selected[$cursor]}" -eq 1 ]; then
                    selected[$cursor]=0
                else
                    selected[$cursor]=1
                fi ;;
            '')              # Enter — confirm
                break ;;
        esac

        _render_checkboxes
    done

    # Show cursor again
    tput cnorm

    # Return selected file names
    local result=()
    for ((i=0; i<count; i++)); do
        if [ "${selected[$i]}" -eq 1 ]; then
            result+=("${options[$i]}")
        fi
    done

    eval "$result_var=(\"\${result[@]}\")"
}

# ---------------------------------------------------------------------------
# Install packages for each profile passed as argument
# ---------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}=== Package Installer ===${NC}\n"

ERRORS=0

for profile in "$@"; do
    PROFILE_DIR="$DOTFILES_DIR/$profile"

    if [ ! -d "$PROFILE_DIR" ]; then
        echo -e "${YELLOW}⚠  Profile directory not found for '$profile' at $PROFILE_DIR — skipping.${NC}\n"
        continue
    fi

    echo -e "${BLUE}${BOLD}=== Profile: $profile ===${NC}\n"

    # Collect available (non-empty) package files
    AVAILABLE_FILES=()
    for pkgfile in "${PACKAGE_FILES[@]}"; do
        PACKAGES_FILE="$PROFILE_DIR/$pkgfile"
        if [ ! -f "$PACKAGES_FILE" ]; then
            continue
        fi
        mapfile -t _TMP < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')
        if [ ${#_TMP[@]} -eq 0 ]; then
            echo -e "  ${YELLOW}⚠  $pkgfile is empty — skipping.${NC}"
            continue
        fi
        AVAILABLE_FILES+=("$pkgfile")
    done

    if [ ${#AVAILABLE_FILES[@]} -eq 0 ]; then
        echo -e "${YELLOW}  ⚠  No package files found for profile '$profile' — skipping.${NC}\n"
        continue
    fi

    echo -e "  ${CYAN}Select package files to install for ${BOLD}$profile${NC}${CYAN}:${NC}\n"
    checkbox_select SELECTED_FILES "${AVAILABLE_FILES[@]}"
    echo ""

    if [ ${#SELECTED_FILES[@]} -eq 0 ]; then
        echo -e "${YELLOW}  ⚠  No files selected for profile '$profile' — skipping.${NC}\n"
        continue
    fi

    # Install each selected file
    for pkgfile in "${SELECTED_FILES[@]}"; do
        PACKAGES_FILE="$PROFILE_DIR/$pkgfile"
        mapfile -t PKGS < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')

        echo -e "\n  ${CYAN}${BOLD}[$pkgfile]${NC} Packages to install:\n"
        for pkg in "${PKGS[@]}"; do
            echo -e "    ${CYAN}·${NC} $pkg"
        done
        echo ""

        echo -e "  ${YELLOW}Installing [$pkgfile] packages with yay...${NC}\n"
        if yay -S --needed --noconfirm "${PKGS[@]}"; then
            echo -e "  ${GREEN}✓ [$pkgfile] packages installed successfully.${NC}\n"
        else
            echo -e "  ${RED}✗ [$pkgfile] some packages failed to install.${NC}\n"
            ((ERRORS++))
        fi
    done

done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✅ All packages installed successfully.${NC}\n"
else
    echo -e "${YELLOW}${BOLD}⚠  Done with $ERRORS error(s). Check output above.${NC}\n"
fi
