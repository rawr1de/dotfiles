#!/usr/bin/env bash

WINDOW_RULES_FILE="$HOME/.config/niri/window-rules.kdl"
CONFIG_FILE="$HOME/.config/niri/config.kdl"

# Remove o bloco do window-rules.kdl
sed -i '/\/\/ START - BRAVE FOR TRADING!/,/\/\/ END - BRAVE FOR TRADING!/d' "$WINDOW_RULES_FILE"

# Remove o bloco do config.kdl
sed -i '/\/\/ START - BRAVE FOR TRADING!/,/\/\/ END - BRAVE FOR TRADING!/d' "$CONFIG_FILE"
