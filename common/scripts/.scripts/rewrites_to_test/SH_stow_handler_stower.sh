#!/bin/bash

# stow_handler_stower.sh
# Scans dotfiles repo under given paths, lists all stow packages,
# lets user select which to stow. On conflict, asks per-file to replace or skip.
# Usage: stow_handler_stower.sh common wm/niri [...]

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# fzf check
# ---------------------------------------------------------------------------
if ! command -v fzf &>/dev/null; then
    echo -e "${YELLOW}fzf not found. Installing...${NC}"
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -y fzf
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm fzf
    elif command -v yay &>/dev/null; then
        yay -S --noconfirm fzf
    elif command -v paru &>/dev/null; then
        paru -S --noconfirm fzf
    else
        echo -e "${RED}No supported package manager found. Install fzf manually.${NC}"
        exit 1
    fi
    command -v fzf &>/dev/null || { echo -e "${RED}fzf install failed. Exiting.${NC}"; exit 1; }
    echo -e "${GREEN}✓ fzf installed.${NC}"
fi

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage: $(basename "$0") <category>[/<subpath>] ...${NC}"
    echo -e "  Examples:"
    echo -e "    $(basename "$0") common"
    echo -e "    $(basename "$0") wm/niri"
    echo -e "    $(basename "$0") common wm/niri legion"
    exit 1
fi

# ---------------------------------------------------------------------------
# Resolve conflicts for a package — ask per-file: replace or skip
# Returns 1 if user chose to skip the entire package
# ---------------------------------------------------------------------------
resolve_conflicts() {
    local stow_dir="$1"
    local stow_pkg="$2"

    local conflicts
    conflicts=$(stow -n --dir="$stow_dir" --target="$HOME" "$stow_pkg" 2>&1 \
        | grep -E "existing target is neither|existing target is not owned" \
        | sed 's/.*: //')

    [ -z "$conflicts" ] && return 0

    echo -e "\n${RED}Conflicts in $stow_dir/$stow_pkg:${NC}"

    while IFS= read -r conflict; do
        [ -z "$conflict" ] && continue
        local full_path="$HOME/$conflict"

        echo -e "\n  ${YELLOW}$conflict${NC}"
        echo -e "  ${BLUE}[r] Replace  [s] Skip file  [S] Skip package${NC}"
        read -rp "  Choice [r/s/S]: " choice

        case "${choice}" in
            r) rm -rf "$full_path" && echo -e "  ${RED}✗ Deleted: $conflict${NC}" ;;
            s) echo -e "  ${CYAN}⊘ Skipped file${NC}" ;;
            S) echo -e "  ${YELLOW}Skipping package.${NC}"; return 1 ;;
            *) echo -e "  ${YELLOW}Invalid — skipping file.${NC}" ;;
        esac
    done <<< "$conflicts"

    return 0
}

# ---------------------------------------------------------------------------
# Build search paths
# ---------------------------------------------------------------------------
SEARCH_PATHS=()
for arg in "$@"; do
    TARGET="$DOTFILES_DIR/$arg"
    if [ ! -d "$TARGET" ]; then
        echo -e "${YELLOW}Warning: $TARGET not found, skipping.${NC}"
        continue
    fi
    SEARCH_PATHS+=("$arg")
done

[ ${#SEARCH_PATHS[@]} -eq 0 ] && { echo -e "${RED}No valid paths found. Exiting.${NC}"; exit 1; }

# ---------------------------------------------------------------------------
# Discover stow packages under each search path
# ---------------------------------------------------------------------------
SKIP_NAMES=("README.md" "README" "NOTES.md" "NOTES" "packages.txt"
            "packages_opt.txt" "pkg_wayd_base.txt" "pkg_wayd_full.txt"
            "pkg_xorg_base.txt" "pkg_xorg_full.txt")

declare -a PKG_LABELS
declare -A PKG_META

echo -e "\n${BLUE}Scanning dotfiles repo...${NC}"

for arg in "${SEARCH_PATHS[@]}"; do
    TARGET="$DOTFILES_DIR/$arg"
    category="${arg%%/*}"
    subpath="${arg#*/}"
    stow_dir="$DOTFILES_DIR/$category"

    if [ "$subpath" = "$arg" ]; then
        # category-level: scan direct subdirs as packages
        # stow_dir = dotfiles/category, pkg = subdir name
        while IFS= read -r -d '' pkg_dir; do
            pkg_name=$(basename "$pkg_dir")
            skip=0
            for s in "${SKIP_NAMES[@]}"; do [ "$pkg_name" = "$s" ] && { skip=1; break; }; done
            [ "$skip" = "1" ] && continue
            label="$category/$pkg_name"
            PKG_LABELS+=("$label")
            PKG_META[$label]="$stow_dir|$pkg_name"
        done < <(find "$TARGET" -maxdepth 1 -mindepth 1 -type d -print0)
    else
        # subpath-level (e.g. wm/niri): treat the subpath as the stow dir,
        # scan its subdirs as individual packages
        local_stow_dir="$DOTFILES_DIR/$arg"
        while IFS= read -r -d '' pkg_dir; do
            pkg_name=$(basename "$pkg_dir")
            skip=0
            for s in "${SKIP_NAMES[@]}"; do [ "$pkg_name" = "$s" ] && { skip=1; break; }; done
            [ "$skip" = "1" ] && continue
            label="$arg/$pkg_name"
            PKG_LABELS+=("$label")
            PKG_META[$label]="$local_stow_dir|$pkg_name"
        done < <(find "$TARGET" -maxdepth 1 -mindepth 1 -type d -print0)
    fi
done

if [ ${#PKG_LABELS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No stow packages found.${NC}"
    exit 0
fi

# ---------------------------------------------------------------------------
# Check which packages are already stowed
# ---------------------------------------------------------------------------
echo -e "${BLUE}Checking stow status...${NC}"

declare -A STOWED_PKGS

while IFS= read -r symlink; do
    target=$(readlink -f "$symlink" 2>/dev/null) || continue
    [[ "$target" != "$DOTFILES_DIR"/* ]] && continue
    rel="${target#$DOTFILES_DIR/}"
    category="${rel%%/*}"
    rest="${rel#*/}"
    pkg_name="${rest%%/*}"
    [ -n "$category" ] && [ -n "$pkg_name" ] && STOWED_PKGS["$category/$pkg_name"]=1
done < <(find "$HOME" -maxdepth 6 -type l 2>/dev/null)

# Build display list with [stowed] marker
declare -a DISPLAY_LABELS
for label in "${PKG_LABELS[@]}"; do
    if [ "${STOWED_PKGS[$label]}" = "1" ]; then
        DISPLAY_LABELS+=("$label  [stowed]")
    else
        DISPLAY_LABELS+=("$label")
    fi
done

echo -e "${GREEN}Found ${#PKG_LABELS[@]} package(s).${NC}\n"

# ---------------------------------------------------------------------------
# fzf multi-select
# ---------------------------------------------------------------------------
SELECTED=$(printf '%s\n' "${DISPLAY_LABELS[@]}" | \
    fzf --multi \
        --bind 'space:toggle,tab:toggle' \
        --prompt 'STOW > ' \
        --header 'SPACE/TAB: toggle | ENTER: confirm | CTRL-A: all | ESC: abort' \
        --color 'header:yellow,prompt:green,pointer:green,marker:green' \
        --marker '✓')

if [ -z "$SELECTED" ]; then
    echo -e "${YELLOW}Nothing selected. Exiting.${NC}"
    exit 0
fi

# Strip [stowed] suffix to recover label
SELECTED_LABELS=()
while IFS= read -r line; do
    SELECTED_LABELS+=("${line%%  *}")
done <<< "$SELECTED"

# ---------------------------------------------------------------------------
# Confirm
# ---------------------------------------------------------------------------
echo -e "\n${GREEN}About to STOW:${NC}"
for label in "${SELECTED_LABELS[@]}"; do
    if [ "${STOWED_PKGS[$label]}" = "1" ]; then
        echo -e "  ${YELLOW}- $label  (restow)${NC}"
    else
        echo -e "  ${GREEN}- $label${NC}"
    fi
done

echo ""
read -rp "Proceed? [y/N]: " confirm
[[ ! "${confirm,,}" == "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }

# ---------------------------------------------------------------------------
# Stow
# ---------------------------------------------------------------------------
echo ""
ERRORS=0

for label in "${SELECTED_LABELS[@]}"; do
    meta="${PKG_META[$label]}"
    stow_dir="${meta%%|*}"
    stow_pkg="${meta##*|}"

    echo -ne "${CYAN}Stowing $label...${NC} "

    if stow -n --dir="$stow_dir" --target="$HOME" "$stow_pkg" 2>&1 | grep -q "existing target"; then
        echo -e "${YELLOW}conflicts detected${NC}"
        resolve_conflicts "$stow_dir" "$stow_pkg" || { echo -e "  ${YELLOW}⊘ Skipped $label${NC}"; continue; }
    fi

    if stow --dir="$stow_dir" --target="$HOME" "$stow_pkg" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ failed${NC}"
        ((ERRORS++))
    fi
done

echo ""
[ "$ERRORS" -eq 0 ] \
    && echo -e "${GREEN}✓ Done.${NC}" \
    || echo -e "${YELLOW}Done with $ERRORS error(s). Re-run with stow -v to debug.${NC}"
