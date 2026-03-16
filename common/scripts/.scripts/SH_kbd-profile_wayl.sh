#!/bin/bash

CONFIG="$HOME/.config/niri/config.kdl"

faster() {
    sed -i 's/repeat-delay .*/repeat-delay 200/' "$CONFIG"
    sed -i 's/repeat-rate .*/repeat-rate 110/' "$CONFIG"
}

fast() {
    sed -i 's/repeat-delay .*/repeat-delay 200/' "$CONFIG"
    sed -i 's/repeat-rate .*/repeat-rate 80/' "$CONFIG"
}

slow() {
    sed -i 's/repeat-delay .*/repeat-delay 600/' "$CONFIG"
    sed -i 's/repeat-rate .*/repeat-rate 5/' "$CONFIG"
}

case "$1" in
    faster) faster ;;
    fast) fast ;;
    slow) slow ;;
    *) echo "Usage: kb-profile [slow|fast|faster]" ;;
esac

niri msg action load-config-file
