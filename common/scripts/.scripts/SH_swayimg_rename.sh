#!/usr/bin/env bash
# swayimg-rename: Wayland-native rename hook (Zenity version)

TARGET="$1"
[[ -z "$TARGET" ]] && exit 1

DIR="${TARGET%/*}"
BASE="${TARGET##*/}"

# Force GTK to skip DBus portal checks for faster launch
NEW_BASE=$(GTK_USE_PORTAL=0 zenity --entry --title="Rename Image" --text="New name:" --entry-text="$BASE" 2>/dev/null)

# Shift+Enter to apply renaming with Fuzzel
# NEW_BASE=$(fuzzel --dmenu --prompt="Rename: " < /dev/null)

# Execute only if zenity exited cleanly (0), string isn't empty, and a change was made
if [[ $? -eq 0 && -n "$NEW_BASE" && "$NEW_BASE" != "$BASE" ]]; then
    # Atomic rename, no destructive rm commands
    mv -n "$TARGET" "$DIR/$NEW_BASE"
fi
