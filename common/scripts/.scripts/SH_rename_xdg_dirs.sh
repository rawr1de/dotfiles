#!/bin/bash

# XDG Directory Renamer
# Reads ~/.config/user-dirs.dirs and renames standard home directories
# to match the custom names defined in that file.

USER_DIRS_FILE="$HOME/.config/user-dirs.dirs"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ── Sanity check ────────────────────────────────────────────────────────────────
if [ ! -f "$USER_DIRS_FILE" ]; then
    echo -e "${RED}Error: $USER_DIRS_FILE not found.${NC}"
    exit 1
fi

# ── Map each XDG key to the conventional default directory name ──────────────────
declare -A XDG_DEFAULTS=(
    ["XDG_DESKTOP_DIR"]="Desktop"
    ["XDG_DOWNLOAD_DIR"]="Downloads"
    ["XDG_DOCUMENTS_DIR"]="Documents"
    ["XDG_PICTURES_DIR"]="Pictures"
    ["XDG_VIDEOS_DIR"]="Videos"
    ["XDG_MUSIC_DIR"]="Music"
    ["XDG_TEMP_DIR"]="tmp"
)

echo -e "${BLUE}=== XDG Directory Renamer ===${NC}"
echo -e "Config file: ${GREEN}$USER_DIRS_FILE${NC}\n"

# ── Parse user-dirs.dirs and build rename plan ───────────────────────────────────
declare -a RENAME_FROM
declare -a RENAME_TO

while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue

    key="${key//[[:space:]]/}"
    # Strip surrounding quotes and resolve $HOME
    value="${value//\"/}"
    value="${value//\$HOME/$HOME}"
    value="${value//[[:space:]]/}"

    # Only process keys we know about
    if [[ -v XDG_DEFAULTS["$key"] ]]; then
        DEFAULT_DIR="$HOME/${XDG_DEFAULTS[$key]}"
        TARGET_DIR="$value"

        # Nothing to do if names already match
        if [ "$DEFAULT_DIR" = "$TARGET_DIR" ]; then
            echo -e "${BLUE}⊘ Already correct:${NC} ${XDG_DEFAULTS[$key]}"
            continue
        fi

        RENAME_FROM+=("$DEFAULT_DIR")
        RENAME_TO+=("$TARGET_DIR")
    fi
done < "$USER_DIRS_FILE"

# ── Nothing to rename? ────────────────────────────────────────────────────────────
if [ ${#RENAME_FROM[@]} -eq 0 ]; then
    echo -e "\n${GREEN}✓ All directories already match the config. Nothing to do.${NC}"
    exit 0
fi

# ── Preview the rename plan ───────────────────────────────────────────────────────
echo -e "${YELLOW}The following directories will be renamed:${NC}\n"
for i in "${!RENAME_FROM[@]}"; do
    FROM_NAME=$(basename "${RENAME_FROM[$i]}")
    TO_NAME=$(basename "${RENAME_TO[$i]}")

    if [ -d "${RENAME_FROM[$i]}" ]; then
        echo -e "  ${YELLOW}$FROM_NAME${NC}  →  ${GREEN}$TO_NAME${NC}"
    elif [ -d "${RENAME_TO[$i]}" ]; then
        echo -e "  ${BLUE}$TO_NAME${NC}  (target already exists, source '${FROM_NAME}' not found — will skip)"
    else
        echo -e "  ${RED}$FROM_NAME${NC}  →  ${GREEN}$TO_NAME${NC}  ${RED}[source not found — will skip]${NC}"
    fi
done

echo ""
read -p "Proceed with renaming? [y/N]: " confirm
if [[ ! "${confirm,,}" =~ ^y$ ]]; then
    echo -e "${YELLOW}Aborted. No changes made.${NC}"
    exit 0
fi

# ── Execute renames ───────────────────────────────────────────────────────────────
echo ""
ERRORS=0
for i in "${!RENAME_FROM[@]}"; do
    FROM="${RENAME_FROM[$i]}"
    TO="${RENAME_TO[$i]}"
    FROM_NAME=$(basename "$FROM")
    TO_NAME=$(basename "$TO")

    if [ ! -d "$FROM" ]; then
        echo -e "${YELLOW}⚠ Skipped:${NC} '$FROM_NAME' not found."
        continue
    fi

    if [ -d "$TO" ]; then
        echo -e "${YELLOW}⚠ Skipped:${NC} '$TO_NAME' already exists at destination."
        continue
    fi

    if mv "$FROM" "$TO"; then
        echo -e "${GREEN}✓ Renamed:${NC} $FROM_NAME  →  $TO_NAME"
    else
        echo -e "${RED}✗ Failed:${NC}  $FROM_NAME  →  $TO_NAME"
        ((ERRORS++))
    fi
done

# ── Summary ───────────────────────────────────────────────────────────────────────
echo ""
if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}✓ All done! You may want to log out and back in for apps to pick up the new paths.${NC}"
else
    echo -e "${YELLOW}⚠ Done with $ERRORS error(s). Check output above.${NC}"
fi
