#!/usr/bin/env bash
FILE="$HOME/.config/niri/input.kdl"

if grep -q '// off // trackpad-toggle' "$FILE"; then
    sed -i 's|// off // trackpad-toggle|off // trackpad-toggle|' "$FILE"
    echo "Trackpad disabled"
else
    sed -i 's|off // trackpad-toggle|// off // trackpad-toggle|' "$FILE"
    echo "Trackpad enabled"
fi

niri msg action load-config-file
