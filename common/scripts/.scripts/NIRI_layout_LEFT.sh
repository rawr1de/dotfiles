#!/usr/bin/env bash

FOCUSED_WS_ID=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused == true) | .id')
WINDOW_COUNT=$(niri msg -j windows | jq -r "[.[] | select(.workspace_id == $FOCUSED_WS_ID)] | length")

if (( WINDOW_COUNT > 0 )); then
    exit 0
fi

# Use -F to set the frame name, plus your fallback init directory
emacsclient -c -F '((name . "layout-emacs"))' -a "emacs --init-directory=/home/rdo/.dotfiles/common/emacs.d/" &

kitty --class layout-kitty &




#!/usr/bin/env bash

# Fetch the current window tree from Niri
WINDOWS=$(niri msg -j windows)

# Check if our specific layout windows already exist anywhere in the compositor
# Returns "true" or "false"
HAS_EMACS=$(echo "$WINDOWS" | jq -r 'any(.[]; .title == "layout-emacs-left")')
HAS_KITTY=$(echo "$WINDOWS" | jq -r 'any(.[]; .app_id == "layout-kitty")')

# Respawn Emacs if it is missing
if [[ "$HAS_EMACS" == "false" ]]; then
    emacsclient -c -F '((name . "layout-emacs-right"))' -a "emacs --init-directory=/home/rdo/.dotfiles/common/emacs.d/" &
fi

# Respawn Firefox if it is missing
if [[ "$HAS_KITTY" == "false" ]]; then
    kitty --new-window --name "layout-kitty" &
fi
