#!/bin/bash

# SH_install_packages.sh (Arch / Void Linux)
# Installs packages and clones repos from files in the dotfiles repo.
#
# Supported files per profile:
#   packages.txt      — core packages
#   packages_base.txt — base packages
#   packages_opt.txt  — optional packages
#   pkg_wayd_base.txt — wayland base
#   pkg_wayd_full.txt — wayland full
#   pkg_xorg_base.txt — xorg base
#   pkg_xorg_full.txt — xorg full
#   repos.txt         — git repos to clone (format: url ~/destination)
#
# Usage:
#   bash SH_install_packages.sh common
#   bash SH_install_packages.sh legion
#   bash SH_install_packages.sh common legion
#   bash SH_install_packages.sh wm/niri

DOTFILES_DIR="$HOME/.dotfiles"

# Package files split by scope — see distro detection block below
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
echo -e "${BLUE}${BOLD}=== SH_install_packages.sh (Void Linux) ===${NC}"
echo -e "${CYAN}Installs packages and clones repos from your dotfiles repo.${NC}\n"
echo -e "  ${YELLOW}Usage   :${NC} $0 <profile> [profile2 ...]"
echo -e "  ${YELLOW}Examples:${NC} $0 common"
echo -e "           $0 legion"
echo -e "           $0 common legion"
echo -e "           $0 wm/niri\n"

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
# Tracking
# ---------------------------------------------------------------------------
ERRORS=0
declare -a FAILED_PKGS   # packages xbps could not find/install
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

    # Collect available files
    # Root-level files (common to all distros)
    ROOT_PKG_FILES=("packages.txt" "packages_base.txt" "packages_opt.txt")
    # Distro-specific files live inside PKG_SUBDIR
    SUBDIR_PKG_FILES=("pkg_wayd_base.txt" "pkg_wayd_full.txt" "pkg_xorg_base.txt" "pkg_xorg_full.txt")

    AVAILABLE_FILES=()

    for pkgfile in "${ROOT_PKG_FILES[@]}"; do
        PACKAGES_FILE="$PROFILE_DIR/$pkgfile"
        [ ! -f "$PACKAGES_FILE" ] && continue
        mapfile -t _TMP < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')
        [ ${#_TMP[@]} -eq 0 ] && { echo -e "  ${YELLOW}⚠  $pkgfile is empty — skipping.${NC}"; continue; }
        AVAILABLE_FILES+=("$pkgfile")
    done

    SUBDIR_PATH="$PROFILE_DIR/$PKG_SUBDIR"
    if [ -d "$SUBDIR_PATH" ]; then
        for pkgfile in "${SUBDIR_PKG_FILES[@]}"; do
            PACKAGES_FILE="$SUBDIR_PATH/$pkgfile"
            [ ! -f "$PACKAGES_FILE" ] && continue
            mapfile -t _TMP < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')
            [ ${#_TMP[@]} -eq 0 ] && { echo -e "  ${YELLOW}⚠  $PKG_SUBDIR/$pkgfile is empty — skipping.${NC}"; continue; }
            AVAILABLE_FILES+=("$PKG_SUBDIR/$pkgfile")
        done
    else
        # Fallback: check root-level for the subdir files too (old structure)
        for pkgfile in "${SUBDIR_PKG_FILES[@]}"; do
            PACKAGES_FILE="$PROFILE_DIR/$pkgfile"
            [ ! -f "$PACKAGES_FILE" ] && continue
            mapfile -t _TMP < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')
            [ ${#_TMP[@]} -eq 0 ] && continue
            AVAILABLE_FILES+=("$pkgfile")
        done
    fi

    REPOS_FILE="$PROFILE_DIR/$REPO_FILE"
    if [ -f "$REPOS_FILE" ]; then
        mapfile -t _TMP < <(grep -v '^\s*#' "$REPOS_FILE" | grep -v '^\s*$')
        [ ${#_TMP[@]} -gt 0 ] && AVAILABLE_FILES+=("$REPO_FILE")
    fi

    if [ ${#AVAILABLE_FILES[@]} -eq 0 ]; then
        echo -e "${YELLOW}  ⚠  No files found for profile '$profile' — skipping.${NC}\n"
        continue
    fi

    # fzf file picker
    echo -e "  ${CYAN}Select files to process for ${BOLD}$profile${NC}${CYAN}:${NC}\n"
    SELECTED_FILES=$(printf '%s\n' "${AVAILABLE_FILES[@]}" | \
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
        if [ "$pkgfile" = "$REPO_FILE" ]; then
            echo -e "\n  ${CYAN}${BOLD}[$REPO_FILE]${NC} Repos to clone:\n"
            mapfile -t REPOS < <(grep -v '^\s*#' "$REPOS_FILE" | grep -v '^\s*$')
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
        PACKAGES_FILE="$PROFILE_DIR/$pkgfile"  # works for both root and subdir paths since subdir files are stored as "$PKG_SUBDIR/filename"
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
            echo -ne "  ${CYAN}· $pkg${NC} ... "
            if [ "$DISTRO" = "void" ]; then
                if ! xbps-query -Rs "$pkg" 2>/dev/null | grep -qw "$pkg"; then
                    echo -e "${RED}not found in repos${NC}"
                    FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile)")
                    ((ERRORS++))
                    continue
                fi
                if sudo xbps-install -y "$pkg" &>/dev/null; then
                    echo -e "${GREEN}✓${NC}"
                else
                    echo -e "${RED}✗ install failed${NC}"
                    FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile)")
                    ((ERRORS++))
                fi
            else
                if ! pacman -Si "$pkg" &>/dev/null; then
                    echo -e "${RED}not found in repos${NC}"
                    FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile)")
                    ((ERRORS++))
                    continue
                fi
                if sudo pacman -S --needed --noconfirm "$pkg" &>/dev/null; then
                    echo -e "${GREEN}✓${NC}"
                else
                    echo -e "${RED}✗ install failed${NC}"
                    FAILED_PKGS+=("$pkg  (profile: $profile / $pkgfile)")
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
