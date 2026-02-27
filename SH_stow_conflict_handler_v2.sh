#!/bin/bash

# Stow Conflict Handler
# Detects conflicting files and offers to back them up or delete them
# Repo structure: packages live inside category dirs (common/, git/, wm/, legion/, templar/)

DOTFILES_DIR="${1:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1

# ---------------------------------------------------------------------------
# Category dirs that contain stow packages as subdirectories.
# Non-package dirs at root (deploy.sh, README.md, this script, etc.) are
# excluded automatically because we only look inside known category dirs.
# ---------------------------------------------------------------------------
CATEGORY_DIRS=("common" "git" "wm" "legion" "templar")

# Build a list of "category package" pairs (e.g. "common bash", "wm bspwm")
declare -a PACKAGE_PAIRS   # each element: "category/package"

for category in "${CATEGORY_DIRS[@]}"; do
    CATEGORY_PATH="$DOTFILES_DIR/$category"
    if [ ! -d "$CATEGORY_PATH" ]; then
        continue
    fi

    while IFS= read -r -d '' pkg_dir; do
        pkg_name=$(basename "$pkg_dir")
        # Skip files, READMEs, notes, and packages.txt masquerading as dirs
        # (they won't be dirs anyway, but be safe)
        [[ "$pkg_name" == README* ]] && continue
        [[ "$pkg_name" == NOTES*  ]] && continue
        [[ "$pkg_name" == packages* ]] && continue
        PACKAGE_PAIRS+=("$category/$pkg_name")
    done < <(find "$CATEGORY_PATH" -maxdepth 1 -mindepth 1 -type d -print0)
done

if [ ${#PACKAGE_PAIRS[@]} -eq 0 ]; then
    echo -e "${RED}No stow packages found under category dirs in $DOTFILES_DIR${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Helper: run stow for all packages
# stow must be run with --dir pointing at the category dir so it knows where
# the package lives, and --target pointing at $HOME.
# ---------------------------------------------------------------------------
stow_all_packages() {
    local simulate="${1:-no}"   # pass "simulate" for dry-run
    local flag=""
    [ "$simulate" = "simulate" ] && flag="-n"

    for pair in "${PACKAGE_PAIRS[@]}"; do
        category="${pair%%/*}"
        package="${pair##*/}"
        echo -e "${GREEN}Stowing $category/$package...${NC}"
        stow $flag -v --dir="$DOTFILES_DIR/$category" --target="$HOME" "$package"
    done
}

# ---------------------------------------------------------------------------
# FUNCTION: purge_only
# Lists and deletes every file that stow would try to populate — nothing more.
# ---------------------------------------------------------------------------
purge_only() {
    echo -e "${BLUE}=== Purge Mode ===${NC}"
    echo -e "${YELLOW}Scanning for files that stow would populate...${NC}\n"

    declare -a TARGETS

    for pair in "${PACKAGE_PAIRS[@]}"; do
        category="${pair%%/*}"
        package="${pair##*/}"

        STOW_OUTPUT=$(stow -n -v --dir="$DOTFILES_DIR/$category" --target="$HOME" "$package" 2>&1)

        # Collect files stow would LINK (i.e. they are the targets stow manages)
        while IFS= read -r line; do
            # stow -v prints lines like: LINK: .config/kitty/kitty.conf => ...
            if [[ "$line" =~ ^LINK:\ (.+)\ =\> ]]; then
                target_rel="${BASH_REMATCH[1]}"
                target_abs="$HOME/$target_rel"
                # Only add if the file actually exists (conflict)
                if [ -e "$target_abs" ] || [ -L "$target_abs" ]; then
                    TARGETS+=("$target_abs")
                fi
            fi
            # Also catch stow conflict lines for non-link files
            if echo "$line" | grep -q "existing target"; then
                conflict=$(echo "$line" | sed 's/.*existing target is neither a link nor a directory: //' \
                                        | sed 's/.*existing target is not owned by stow: //')
                [ -n "$conflict" ] && TARGETS+=("$HOME/$conflict")
            fi
        done <<< "$STOW_OUTPUT"
    done

    # Deduplicate
    declare -a UNIQUE_TARGETS
    declare -A SEEN
    for t in "${TARGETS[@]}"; do
        if [ -z "${SEEN[$t]+x}" ]; then
            SEEN[$t]=1
            UNIQUE_TARGETS+=("$t")
        fi
    done

    if [ ${#UNIQUE_TARGETS[@]} -eq 0 ]; then
        echo -e "${GREEN}✓ Nothing to purge — no conflicting files found.${NC}"
        return 0
    fi

    echo -e "${RED}The following ${#UNIQUE_TARGETS[@]} file(s) will be permanently deleted:${NC}\n"
    for i in "${!UNIQUE_TARGETS[@]}"; do
        echo -e "${YELLOW}  $((i+1)). ${UNIQUE_TARGETS[$i]#$HOME/}${NC}"
    done

    echo ""
    read -p "Confirm permanent deletion — type 'DELETE' to proceed: " confirm

    if [ "$confirm" != "DELETE" ]; then
        echo -e "${YELLOW}Aborted. No files were deleted.${NC}"
        return 1
    fi

    echo ""
    for target in "${UNIQUE_TARGETS[@]}"; do
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm -rf "$target"
            echo -e "${RED}✗ Deleted: ${target#$HOME/}${NC}"
        fi
    done

    echo -e "\n${GREEN}✓ Purge complete.${NC}"
}

# ---------------------------------------------------------------------------
# Main conflict detection
# ---------------------------------------------------------------------------
echo -e "${BLUE}=== Stow Conflict Checker ===${NC}"
echo -e "Dotfiles dir : ${GREEN}$DOTFILES_DIR${NC}"
echo -e "Packages found:\n"
for pair in "${PACKAGE_PAIRS[@]}"; do
    echo -e "  ${GREEN}$pair${NC}"
done
echo ""

declare -a CONFLICTS

for pair in "${PACKAGE_PAIRS[@]}"; do
    category="${pair%%/*}"
    package="${pair##*/}"

    echo -e "${YELLOW}Checking $category/$package...${NC}"

    STOW_OUTPUT=$(stow -n -v --dir="$DOTFILES_DIR/$category" --target="$HOME" "$package" 2>&1)

    PACKAGE_CONFLICTS=$(echo "$STOW_OUTPUT" | grep "existing target" \
        | sed 's/.*existing target is neither a link nor a directory: //' \
        | sed 's/.*existing target is not owned by stow: //')

    if [ -n "$PACKAGE_CONFLICTS" ]; then
        while IFS= read -r conflict; do
            [ -n "$conflict" ] && CONFLICTS+=("$HOME/$conflict")
        done <<< "$PACKAGE_CONFLICTS"
    fi
done

# Check for known KDE/user config files that stow would overwrite
echo -e "\n${YELLOW}Checking for existing KDE/user config files in ~/.config...${NC}"

CONFIG_FILES=(
    "dolphinrc"
    "kcminputrc"
    "kdeglobals"
    "kglobalshortcutsrc"
    "khotkeysrc"
    "kscreenlockerrc"
    "kwalletrc"
    "kwinrc"
    "kwinrulesrc"
    "kxkbrc"
    "mimeapps.list"
    "user-dirs.dirs"
    "user-dirs.locale"
)

for cfg_file in "${CONFIG_FILES[@]}"; do
    FULL_CFG_PATH="$HOME/.config/$cfg_file"
    if [ -e "$FULL_CFG_PATH" ]; then
        ALREADY_TRACKED=0
        for existing in "${CONFLICTS[@]}"; do
            [ "$existing" = "$FULL_CFG_PATH" ] && { ALREADY_TRACKED=1; break; }
        done
        if [ "$ALREADY_TRACKED" -eq 0 ]; then
            CONFLICTS+=("$FULL_CFG_PATH")
            echo -e "${YELLOW}  Found: .config/$cfg_file${NC}"
        fi
    fi
done

# ---------------------------------------------------------------------------
# No conflicts — stow everything and exit
# ---------------------------------------------------------------------------
if [ ${#CONFLICTS[@]} -eq 0 ]; then
    echo -e "\n${GREEN}✓ No conflicts found! Stowing packages...${NC}\n"
    stow_all_packages
    echo -e "\n${GREEN}✓ All packages stowed successfully!${NC}"
    exit 0
fi

# ---------------------------------------------------------------------------
# Present conflict menu
# ---------------------------------------------------------------------------
echo -e "\n${RED}⚠ Found ${#CONFLICTS[@]} conflicting file(s):${NC}"
for i in "${!CONFLICTS[@]}"; do
    echo -e "${YELLOW}  $((i+1)). ${CONFLICTS[$i]#$HOME/}${NC}"
done

echo -e "\n${BLUE}Options:${NC}"
echo "  [A] Backup ALL conflicting files and proceed"
echo "  [D] Delete ALL conflicting files and proceed"
echo "  [I] Handle each file individually"
echo "  [P] Purge mode — delete stow targets only, then exit (no stowing)"
echo "  [Q] Quit without changes"
echo ""
read -p "Choose an option [A/D/I/P/Q]: " choice

case "${choice^^}" in
    A)
        mkdir -p "$BACKUP_DIR"
        echo -e "\n${YELLOW}Backing up files to $BACKUP_DIR${NC}"

        for conflict in "${CONFLICTS[@]}"; do
            if [ -e "$conflict" ]; then
                RELATIVE_PATH="${conflict#$HOME/}"
                BACKUP_SUBDIR="$BACKUP_DIR/$(dirname "$RELATIVE_PATH")"
                mkdir -p "$BACKUP_SUBDIR"
                mv "$conflict" "$BACKUP_SUBDIR/"
                echo -e "${GREEN}✓ Backed up: $RELATIVE_PATH${NC}"
            fi
        done

        echo -e "\n${GREEN}Stowing packages...${NC}"
        stow_all_packages
        echo -e "\n${GREEN}✓ Done! Backups saved in $BACKUP_DIR${NC}"
        ;;

    D)
        echo -e "\n${RED}⚠ WARNING: This will permanently delete ${#CONFLICTS[@]} file(s)!${NC}"
        read -p "Are you absolutely sure? Type 'DELETE' to confirm: " confirm

        if [ "$confirm" = "DELETE" ]; then
            for conflict in "${CONFLICTS[@]}"; do
                if [ -e "$conflict" ]; then
                    RELATIVE_PATH="${conflict#$HOME/}"
                    rm -rf "$conflict"
                    echo -e "${RED}✗ Deleted: $RELATIVE_PATH${NC}"
                fi
            done

            echo -e "\n${GREEN}Stowing packages...${NC}"
            stow_all_packages
            echo -e "\n${GREEN}✓ Done!${NC}"
        else
            echo -e "${YELLOW}Aborted. No changes made.${NC}"
            exit 1
        fi
        ;;

    I)
        mkdir -p "$BACKUP_DIR"

        for conflict in "${CONFLICTS[@]}"; do
            [ ! -e "$conflict" ] && continue

            RELATIVE_PATH="${conflict#$HOME/}"
            echo -e "\n${YELLOW}File: $RELATIVE_PATH${NC}"
            echo "  [B] Backup this file"
            echo "  [D] Delete this file"
            echo "  [S] Skip this file"
            echo "  [Q] Quit"

            read -p "Choose [B/D/S/Q]: " file_choice

            case "${file_choice^^}" in
                B)
                    BACKUP_SUBDIR="$BACKUP_DIR/$(dirname "$RELATIVE_PATH")"
                    mkdir -p "$BACKUP_SUBDIR"
                    mv "$conflict" "$BACKUP_SUBDIR/"
                    echo -e "${GREEN}✓ Backed up${NC}"
                    ;;
                D)
                    rm -rf "$conflict"
                    echo -e "${RED}✗ Deleted${NC}"
                    ;;
                S)
                    echo -e "${BLUE}⊘ Skipped${NC}"
                    ;;
                Q)
                    echo -e "${YELLOW}Quitting...${NC}"
                    exit 0
                    ;;
                *)
                    echo -e "${YELLOW}Invalid choice. Skipping...${NC}"
                    ;;
            esac
        done

        echo -e "\n${GREEN}Stowing packages...${NC}"
        for pair in "${PACKAGE_PAIRS[@]}"; do
            category="${pair%%/*}"
            package="${pair##*/}"
            stow -v --dir="$DOTFILES_DIR/$category" --target="$HOME" "$package" 2>/dev/null \
                || echo -e "${YELLOW}⚠ Some conflicts remain in $category/$package${NC}"
        done

        if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
            echo -e "\n${GREEN}✓ Done! Backups saved in $BACKUP_DIR${NC}"
        else
            rm -rf "$BACKUP_DIR"
            echo -e "\n${GREEN}✓ Done!${NC}"
        fi
        ;;

    P)
        purge_only
        ;;

    Q)
        echo -e "${YELLOW}Exiting without changes.${NC}"
        exit 0
        ;;

    *)
        echo -e "${RED}Invalid option. Exiting.${NC}"
        exit 1
        ;;
esac
