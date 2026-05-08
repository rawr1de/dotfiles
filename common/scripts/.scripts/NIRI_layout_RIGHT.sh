#!/usr/bin/env bash

# Fetch the current window tree from Niri
WINDOWS=$(niri msg -j windows)

# Check if our specific layout windows already exist anywhere in the compositor
# Returns "true" or "false"
HAS_EMACS=$(echo "$WINDOWS" | jq -r 'any(.[]; .title == "layout-emacs-right")')
HAS_FIREFOX=$(echo "$WINDOWS" | jq -r 'any(.[]; .app_id == "layout-firefox")')

# Respawn Emacs if it is missing
if [[ "$HAS_EMACS" == "false" ]]; then
    emacsclient -c -F '((name . "layout-emacs-right"))' -a "emacs --init-directory=/home/rdo/.dotfiles/common/emacs.d/" &
fi

# Respawn Firefox if it is missing
if [[ "$HAS_FIREFOX" == "false" ]]; then
    firefox --new-window --name "layout-firefox" &
fi
