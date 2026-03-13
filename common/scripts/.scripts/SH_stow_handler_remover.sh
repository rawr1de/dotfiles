#!/bin/bash

# stow_handler_remover.sh
# Scans $HOME for symlinks pointing into the dotfiles repo,
# resolves their stow package, and lets you select which to unstow.
# Usage: stow_handler_remover.sh common wm/niri [...]

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
# Build search paths
# ---------------------------------------------------------------------------
SEARCH_PATHS=()
for arg in "$@"; do
    TARGET="$DOTFILES_DIR/$arg"
    if [ ! -d "$TARGET" ]; then
        echo -e "${YELLOW}Warning: $TARGET not found, skipping.${NC}"
        continue
    fi
    SEARCH_PATHS+=("$TARGET")
done

if [ ${#SEARCH_PATHS[@]} -eq 0 ]; then
    echo -e "${RED}No valid paths found. Exiting.${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Scan $HOME for symlinks pointing into the search paths
# Resolve to stow package (category/pkg)
# ---------------------------------------------------------------------------
echo -e "\n${BLUE}Scanning \$HOME for stowed symlinks...${NC}"

declare -A PKG_SEEN
declare -a PKG_LABELS
declare -A PKG_META   # label -> "stow_dir|stow_pkg"

while IFS= read -r symlink; do
    target=$(readlink -f "$symlink" 2>/dev/null) || continue

    matched_base=""
    for base in "${SEARCH_PATHS[@]}"; do
        [[ "$target" == "$base"/* ]] && { matched_base="$base"; break; }
    done
    [ -z "$matched_base" ] && continue

    rel="${target#$DOTFILES_DIR/}"
    # Resolve up to 3 levels deep: category/subpath/pkg or category/pkg
    category="${rel%%/*}"
    rest="${rel#*/}"
    pkg_name="${rest%%/*}"
    rest2="${rest#*/}"
    pkg_name2="${rest2%%/*}"

    # Check if this belongs to a subpath (e.g. wm/niri/fuzzel)
    # by seeing if dotfiles/category/pkg_name is a dir containing the pkg
    if [ -d "$DOTFILES_DIR/$category/$pkg_name" ] && [ -n "$pkg_name2" ] &&        [ -d "$DOTFILES_DIR/$category/$pkg_name/$pkg_name2" ]; then
        label="$category/$pkg_name/$pkg_name2"
        stow_dir="$DOTFILES_DIR/$category/$pkg_name"
        stow_pkg="$pkg_name2"
    else
        label="$category/$pkg_name"
        stow_dir="$DOTFILES_DIR/$category"
        stow_pkg="$pkg_name"
    fi

    [ -z "$category" ] || [ -z "$pkg_name" ] && continue

    if [ -z "${PKG_SEEN[$label]}" ]; then
        PKG_SEEN[$label]=1
        PKG_LABELS+=("$label")
        PKG_META[$label]="$stow_dir|$stow_pkg"
    fi
done < <(find "$HOME" -maxdepth 6 -type l 2>/dev/null)

if [ ${#PKG_LABELS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No stowed packages found from the given paths.${NC}"
    exit 0
fi

echo -e "${GREEN}Found ${#PKG_LABELS[@]} stowed package(s).${NC}\n"

# ---------------------------------------------------------------------------
# fzf multi-select
# ---------------------------------------------------------------------------
SELECTED=$(printf '%s\n' "${PKG_LABELS[@]}" | \
    fzf --multi \
        --bind 'space:toggle,tab:toggle' \
        --prompt 'UNSTOW > ' \
        --header 'SPACE/TAB: toggle | ENTER: confirm | CTRL-A: all | ESC: abort' \
        --color 'header:yellow,prompt:red,pointer:red,marker:red' \
        --marker '✓')

if [ -z "$SELECTED" ]; then
    echo -e "${YELLOW}Nothing selected. Exiting.${NC}"
    exit 0
fi

# ---------------------------------------------------------------------------
# Confirm
# ---------------------------------------------------------------------------
echo -e "\n${RED}About to UNSTOW:${NC}"
while IFS= read -r label; do
    echo -e "  ${YELLOW}- $label${NC}"
done <<< "$SELECTED"

echo ""
read -rp "Proceed? [y/N]: " confirm
[[ ! "${confirm,,}" == "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }

# ---------------------------------------------------------------------------
# Unstow
# ---------------------------------------------------------------------------
echo ""
ERRORS=0

while IFS= read -r label; do
    meta="${PKG_META[$label]}"
    stow_dir="${meta%%|*}"
    stow_pkg="${meta##*|}"

    echo -ne "${YELLOW}Unstowing $label...${NC} "
    if stow -D --dir="$stow_dir" --target="$HOME" "$stow_pkg" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ failed${NC}"
        ((ERRORS++))
    fi
done <<< "$SELECTED"

echo ""
[ "$ERRORS" -eq 0 ] \
    && echo -e "${GREEN}✓ Done.${NC}" \
    || echo -e "${YELLOW}Done with $ERRORS error(s). Re-run with stow -Dv to debug.${NC}"
