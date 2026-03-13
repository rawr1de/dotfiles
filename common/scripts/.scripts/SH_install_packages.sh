#!/bin/bash

# SH_install_packages.sh (Arch / Void Linux)
# Installs packages and clones repos from files in the dotfiles repo.
#
# Supported files per profile:
#   Root profile folder: repos.txt
#   OS Subfolders (.VOID_pkgs / .ARCH_pkgs): Any .txt file (pkg_machine.txt, etc.)
#
# Usage:
#   bash SH_install_packages.sh common
#   bash SH_install_packages.sh legion
#   bash SH_install_packages.sh common templar

DOTFILES_DIR="$HOME/.dotfiles"

# The designated repo file
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
echo -e "${CYAN}Installs packages and clones repos from your dotfiles repo.${NC}\n"

if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No profile specified.${NC}"
    exit 1
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Distro detection
# ---------------------------------------------------------------------------
if command -v xbps-install &>/dev/null; then
    DISTRO="void"
    PKG_SUBDIR=".VOID_pkgs"
elif command -v pacman &>/dev/null; then
    DISTRO="arch"
    PKG_SUBDIR=".ARCH_pkgs"
else
    echo -e "${RED}Error: No supported package manager found (xbps-install or pacman).${NC}"
    exit 1
fi

echo -e "${CYAN}Detected : ${BOLD}$DISTRO${NC} — pkg subdir: ${BOLD}$PKG_SUBDIR${NC}\n"

# ---------------------------------------------------------------------------
# fzf check
# ---------------------------------------------------------------------------
if ! command -v fzf &>/dev/null; then
    echo -e "${YELLOW}fzf not found. Installing...${NC}"
    if [ "$DISTRO" = "void" ]; then
        sudo xbps-install -y fzf
    else
        sudo pacman -S --noconfirm fzf
    fi
    command -v fzf &>/dev/null || { echo -e "${RED}fzf install failed. Exiting.${NC}"; exit 1; }
    echo -e "${GREEN}✓ fzf installed.${NC}\n"
fi

# ---------------------------------------------------------------------------
# yay check (Arch only)
# ---------------------------------------------------------------------------
if [ "$DISTRO" = "arch" ] && ! command -v yay &>/dev/null; then
    echo -e "${YELLOW}⚠  yay not found.${NC}"
    echo -e "${YELLOW}   AUR packages will fail. To fix, run SH_keyrings_yay_handler.sh first,${NC}"
    echo -e "${YELLOW}   or install yay manually, then re-run this script.${NC}"
    echo ""
    read -rp "   Attempt to install yay now? [y/N] " _yay_prompt
    if [[ "$_yay_prompt" =~ ^[Yy]$ ]]; then
        _yay_dir="$(mktemp -d)"
        sudo pacman -S --needed base-devel git --noconfirm
        git clone https://aur.archlinux.org/yay.git "$_yay_dir" && \
            cd "$_yay_dir" && makepkg -si --noconfirm && cd - && rm -rf "$_yay_dir"
        if command -v yay &>/dev/null; then
            echo -e "${GREEN}✓ yay installed.${NC}\n"
        else
            echo -e "${RED}✗ yay install failed. AUR packages will be skipped.${NC}\n"
        fi
    else
        echo -e "${YELLOW}   Skipping yay install. AUR packages will be skipped.${NC}\n"
    fi
fi

# ---------------------------------------------------------------------------
# Tracking
# ---------------------------------------------------------------------------
ERRORS=0
declare -a FAILED_PKGS   # packages that could not be installed
declare -a FAILED_REPOS  # repos that failed to clone

# ---------------------------------------------------------------------------
# Install packages for each profile
# ---------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}=== Package Installer ===${NC}\n"

for profile in "$@"; do
    PROFILE_DIR="$DOTFILES_DIR/$profile"

    if [ ! -d "$PROFILE_DIR" ]; then
        echo -e "${YELLOW}⚠  Profile '$profile' not found at $PROFILE_DIR — skipping.${NC}\n"
        continue
    fi

    echo -e "${BLUE}${BOLD}=== Profile: $profile ===${NC}\n"

    AVAILABLE_FILES=()

    # 1. Grab any .txt file in the root of the profile (like repos.txt)
    while IFS= read -r root_file; do
        [ -n "$root_file" ] && AVAILABLE_FILES+=("$(basename "$root_file")")
    done < <(find "$PROFILE_DIR" -maxdepth 1 -type f -name "*.txt" 2>/dev/null)

    # 2. Grab any .txt file inside the correct distro subdirectory
    if [ -d "$PROFILE_DIR/$PKG_SUBDIR" ]; then
        while IFS= read -r sub_file; do
            [ -n "$sub_file" ] && AVAILABLE_FILES+=("$PKG_SUBDIR/$(basename "$sub_file")")
        done < <(find "$PROFILE_DIR/$PKG_SUBDIR" -maxdepth 1 -type f -name "*.txt" 2>/dev/null)
    fi

    if [ ${#AVAILABLE_FILES[@]} -eq 0 ]; then
        echo -e "${YELLOW}  ⚠  No .txt files found for profile '$profile' — skipping.${NC}\n"
        continue
    fi

    # Filter out empty files before passing to fzf
    VALID_FILES=()
    for file in "${AVAILABLE_FILES[@]}"; do
        if grep -q '[^[:space:]#]' "$PROFILE_DIR/$file" 2>/dev/null; then
            VALID_FILES+=("$file")
        fi
    done

    if [ ${#VALID_FILES[@]} -eq 0 ]; then
        echo -e "${YELLOW}  ⚠  All files in '$profile' are empty — skipping.${NC}\n"
        continue
    fi

    # fzf file picker
    echo -e "  ${CYAN}Select files to process for ${BOLD}$profile${NC}${CYAN}:${NC}\n"
    SELECTED_FILES=$(printf '%s\n' "${VALID_FILES[@]}" | \
        fzf --multi \
            --bind 'space:toggle,tab:toggle' \
            --prompt "[$profile] > " \
            --header 'SPACE/TAB: toggle | ENTER: confirm | CTRL-A: all | ESC: skip profile' \
            --color 'header:yellow,prompt:cyan,pointer:cyan,marker:cyan' \
            --marker '✓')

    if [ -z "$SELECTED_FILES" ]; then
        echo -e "${YELLOW}  ⚠  No files selected for '$profile' — skipping.${NC}\n"
        continue
    fi

    while IFS= read -r pkgfile; do

        # ---- Repos ----
        if [ "$(basename "$pkgfile")" = "$REPO_FILE" ]; then
            echo -e "\n  ${CYAN}${BOLD}[$pkgfile]${NC} Repos to clone:\n"
            mapfile -t REPOS < <(grep -v '^\s*#' "$PROFILE_DIR/$pkgfile" | grep -v '^\s*$')
            for entry in "${REPOS[@]}"; do
                url=$(awk '{print $1}' <<< "$entry")
                dest=$(awk '{print $2}' <<< "$entry" | sed "s|~|$HOME|g")
                echo -e "    ${CYAN}·${NC} $url → $dest"
            done
            echo ""

            for entry in "${REPOS[@]}"; do
                url=$(awk '{print $1}' <<< "$entry")
                dest=$(awk '{print $2}' <<< "$entry" | sed "s|~|$HOME|g")

                if [ -d "$dest" ]; then
                    echo -e "  ${YELLOW}⚠  $dest already exists — skipping.${NC}"
                    continue
                fi

                mkdir -p "$(dirname "$dest")"
                echo -e "  ${YELLOW}Cloning $url → $dest...${NC}"
                if git clone "$url" "$dest"; then
                    echo -e "  ${GREEN}✓ Cloned.${NC}\n"
                else
                    echo -e "  ${RED}✗ Failed to clone $url${NC}\n"
                    FAILED_REPOS+=("$url → $dest")
                    ((ERRORS++))
                fi
            done
            continue
        fi

        # ---- Packages ----
        PACKAGES_FILE="$PROFILE_DIR/$pkgfile"
        mapfile -t PKGS < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')

        echo -e "\n  ${CYAN}${BOLD}[$pkgfile]${NC} Packages to install:\n"
        for pkg in "${PKGS[@]}"; do
            echo -e "    ${CYAN}·${NC} $pkg"
        done
        echo ""

        echo -e "  ${YELLOW}Syncing repos...${NC}"
        if [ "$DISTRO" = "void" ]; then
            sudo xbps-install -S &>/dev/null
        else
            sudo pacman -Sy &>/dev/null
        fi

        echo -e "  ${YELLOW}Installing [$pkgfile] packages...${NC}\n"

        for pkg in "${PKGS[@]}"; do
            echo -e "  ${CYAN}· $pkg${NC}"
            if [ "$DISTRO" = "void" ]; then
                if ! xbps-query -Rs "$pkg" 2>/dev/null | grep -qw "$pkg"; then
                    echo -e "  ${RED}✗ $pkg not found in repos${NC}"
                    FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile)")
                    ((ERRORS++))
                    continue
                fi
                if sudo xbps-install -y "$pkg"; then
                    echo -e "  ${GREEN}✓ $pkg done${NC}"
                else
                    echo -e "  ${RED}✗ $pkg install failed${NC}"
                    FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile)")
                    ((ERRORS++))
                fi
            else
                if pacman -Si "$pkg" &>/dev/null; then
                    if sudo pacman -S --needed --noconfirm "$pkg"; then
                        echo -e "  ${GREEN}✓ $pkg done${NC}"
                    else
                        echo -e "  ${RED}✗ $pkg install failed${NC}"
                        FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile)")
                        ((ERRORS++))
                    fi
                elif command -v yay &>/dev/null; then
                    echo -e "  ${YELLOW}· $pkg not in official repos — trying AUR...${NC}"
                    if yay -S --needed --noconfirm "$pkg"; then
                        echo -e "  ${GREEN}✓ $pkg done (AUR)${NC}"
                    else
                        echo -e "  ${RED}✗ $pkg AUR install failed${NC}"
                        FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile) [AUR]")
                        ((ERRORS++))
                    fi
                else
                    echo -e "  ${RED}✗ $pkg not found in repos and yay unavailable${NC}"
                    FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile) [AUR - yay missing]")
                    ((ERRORS++))
                fi
            fi
        done
        echo ""

    done <<< "$SELECTED_FILES"
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}=== Summary ===${NC}\n"

if [ ${#FAILED_PKGS[@]} -gt 0 ]; then
    echo -e "${RED}${BOLD}Packages not installed (${#FAILED_PKGS[@]}):${NC}"
    for p in "${FAILED_PKGS[@]}"; do
        echo -e "  ${YELLOW}· $p${NC}"
    done
    echo ""
fi

if [ ${#FAILED_REPOS[@]} -gt 0 ]; then
    echo -e "${RED}${BOLD}Repos that failed to clone (${#FAILED_REPOS[@]}):${NC}"
    for r in "${FAILED_REPOS[@]}"; do
        echo -e "  ${YELLOW}· $r${NC}"
    done
    echo ""
fi

if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ All done successfully.${NC}\n"
else
    echo -e "${YELLOW}${BOLD}⚠  Done with $ERRORS error(s). See above.${NC}\n"
fi
