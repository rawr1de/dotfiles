#!/bin/bash

CONFIG="$HOME/.config/niri/config.kdl"

fast() {
    sed -i 's/repeat-delay .*/repeat-delay 230/' "$CONFIG"
    sed -i 's/repeat-rate .*/repeat-rate 100/' "$CONFIG"
}

slow() {
    sed -i 's/repeat-delay .*/repeat-delay 600/' "$CONFIG"
    sed -i 's/repeat-rate .*/repeat-rate 5/' "$CONFIG"
}

case "$1" in
    fast) fast ;;
    slow) slow ;;
    *) echo "Usage: kb-profile [fast|slow]" ;;
esac

niri msg action reload-config
