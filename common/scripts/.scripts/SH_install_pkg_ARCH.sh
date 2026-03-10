#!/bin/bash

# SH_install_packages.sh
# Installs packages and clones repos from files in the dotfiles repo.
# Can be run standalone or called from deploy_v4.sh
#
# Supported files per profile:
#   packages.txt      — core/official repo packages
#   packages_base.txt — base packages
#   packages_opt.txt  — optional packages
#   repos.txt         — git repos to clone (format: url ~/destination)
#
# Usage:
#   bash SH_install_packages.sh common
#   bash SH_install_packages.sh legion
#   bash SH_install_packages.sh common legion
#   bash SH_install_packages.sh wm/xfce

DOTFILES_DIR="$HOME/.dotfiles"

PACKAGE_FILES=("packages.txt" "packages_base.txt" "packages_opt.txt")
REPO_FILE="repos.txt"

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
echo -e "${CYAN}Installs packages and clones repos from your dotfiles repo.${NC}"
echo -e "${CYAN}Pass one or more profile names as arguments.${NC}\n"
echo -e "  ${YELLOW}Usage   :${NC} $0 <profile> [profile2 ...]"
echo -e "  ${YELLOW}Examples:${NC} $0 common"
echo -e "           $0 legion"
echo -e "           $0 common legion"
echo -e "           $0 wm/xfce\n"
echo -e "  ${YELLOW}Files recognized per profile:${NC}"
for f in "${PACKAGE_FILES[@]}"; do
    echo -e "    ${CYAN}·${NC} $f"
done
echo -e "    ${CYAN}·${NC} $REPO_FILE"
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
checkbox_select() {
    local result_var="$1"
    shift
    local options=("$@")
    local selected=()
    local cursor=0
    local count=${#options[@]}

    for ((i=0; i<count; i++)); do
        selected+=(0)
    done

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
        IFS= read -r -s -n1 key
        if [[ $key == $'\x1b' ]]; then
            read -r -s -n2 key2
            key+="$key2"
        fi

        tput cuu $((count + 2))

        case "$key" in
            $'\x1b[A'|'k')
                ((cursor = (cursor - 1 + count) % count)) ;;
            $'\x1b[B'|'j')
                ((cursor = (cursor + 1) % count)) ;;
            ' ')
                if [ "${selected[$cursor]}" -eq 1 ]; then
                    selected[$cursor]=0
                else
                    selected[$cursor]=1
                fi ;;
            '')
                break ;;
        esac

        _render_checkboxes
    done

    tput cnorm

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

    AVAILABLE_FILES=()

    for pkgfile in "${PACKAGE_FILES[@]}"; do
        PACKAGES_FILE="$PROFILE_DIR/$pkgfile"
        [ ! -f "$PACKAGES_FILE" ] && continue
        mapfile -t _TMP < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')
        if [ ${#_TMP[@]} -eq 0 ]; then
            echo -e "  ${YELLOW}⚠  $pkgfile is empty — skipping.${NC}"
            continue
        fi
        AVAILABLE_FILES+=("$pkgfile")
    done

    REPOS_FILE="$PROFILE_DIR/$REPO_FILE"
    if [ -f "$REPOS_FILE" ]; then
        mapfile -t _TMP < <(grep -v '^\s*#' "$REPOS_FILE" | grep -v '^\s*$')
        [ ${#_TMP[@]} -gt 0 ] && AVAILABLE_FILES+=("$REPO_FILE")
    fi

    if [ ${#AVAILABLE_FILES[@]} -eq 0 ]; then
        echo -e "${YELLOW}  ⚠  No files found for profile '$profile' — skipping.${NC}\n"
        continue
    fi

    echo -e "  ${CYAN}Select files to process for ${BOLD}$profile${NC}${CYAN}:${NC}\n"
    checkbox_select SELECTED_FILES "${AVAILABLE_FILES[@]}"
    echo ""

    if [ ${#SELECTED_FILES[@]} -eq 0 ]; then
        echo -e "${YELLOW}  ⚠  No files selected for profile '$profile' — skipping.${NC}\n"
        continue
    fi

    for pkgfile in "${SELECTED_FILES[@]}"; do

        if [ "$pkgfile" == "$REPO_FILE" ]; then
            echo -e "\n  ${CYAN}${BOLD}[$REPO_FILE]${NC} Repos to clone:\n"
            mapfile -t REPOS < <(grep -v '^\s*#' "$REPOS_FILE" | grep -v '^\s*$')
            for entry in "${REPOS[@]}"; do
                url=$(echo "$entry" | awk '{print $1}')
                dest=$(echo "$entry" | awk '{print $2}' | sed "s|~|$HOME|g")
                echo -e "    ${CYAN}·${NC} $url → $dest"
            done
            echo ""

            for entry in "${REPOS[@]}"; do
                url=$(echo "$entry" | awk '{print $1}')
                dest=$(echo "$entry" | awk '{print $2}' | sed "s|~|$HOME|g")

                if [ -d "$dest" ]; then
                    echo -e "  ${YELLOW}⚠  $dest already exists — skipping $url${NC}"
                    continue
                fi

                mkdir -p "$(dirname "$dest")"
                echo -e "  ${YELLOW}Cloning $url into $dest...${NC}"
                if git clone "$url" "$dest"; then
                    echo -e "  ${GREEN}✓ Cloned successfully.${NC}\n"
                else
                    echo -e "  ${RED}✗ Failed to clone $url.${NC}\n"
                    ((ERRORS++))
                fi
            done
            continue
        fi

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
    echo -e "${GREEN}${BOLD}✅ All done successfully.${NC}\n"
else
    echo -e "${YELLOW}${BOLD}⚠  Done with $ERRORS error(s). Check output above.${NC}\n"
fi
