#!/usr/bin/env bash

# ==============================================================================
# 0. Injetar configurações dinâmicas do Niri
# ==============================================================================
WINDOW_RULES_FILE="$HOME/.config/niri/window-rules.kdl"
CONFIG_FILE="$HOME/.config/niri/config.kdl"

if ! grep -q "// START - BRAVE FOR TRADING!" "$WINDOW_RULES_FILE"; then
cat << 'EOF' >> "$WINDOW_RULES_FILE"
// START - BRAVE FOR TRADING!
window-rule {
    match title="(?i).*TradingView.*"
    border { off; }
    focus-ring { off; }
}
// END - BRAVE FOR TRADING!
EOF
fi

if ! grep -q "// START - BRAVE FOR TRADING!" "$CONFIG_FILE"; then
cat << 'EOF' >> "$CONFIG_FILE"
// START - BRAVE FOR TRADING!
workspace "Trading-DP1" {
    open-on-output "DP-1"
    layout {
        gaps 0
    }
}

workspace "Trading-HDMI" {
    open-on-output "HDMI-A-1"
    layout {
        gaps 0
    }
}
// END - BRAVE FOR TRADING!
EOF
fi

sleep 1

# ==============================================================================
# 1. Monitor DP-1: 2 janelas do Brave empilhadas (Stack Vertical)
# ==============================================================================
niri msg action focus-workspace "Trading-DP1"

nohup brave --user-data-dir="$HOME/.config/brave-trading" --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 &
nohup brave --user-data-dir="$HOME/.config/brave-trading" --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 &

sleep 4

niri msg action consume-or-expel-window-left
niri msg action maximize-column

# ==============================================================================
# 2. Monitor HDMI-A-1: 2 janelas do Brave empilhadas (Stack Vertical)
# ==============================================================================
niri msg action focus-workspace "Trading-HDMI"

nohup brave --user-data-dir="$HOME/.config/brave-trading" --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 &
nohup brave --user-data-dir="$HOME/.config/brave-trading" --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 &

sleep 4

niri msg action consume-or-expel-window-left
niri msg action maximize-column

# ==============================================================================
# 3. Monitor eDP-2 (Notebook): Discord
# ==============================================================================
niri msg action focus-monitor "eDP-2"
niri msg action focus-workspace 1

nohup discord > /dev/null 2>&1 &

sleep 6

niri msg action focus-monitor "eDP-2"
niri msg action focus-workspace 1
niri msg action maximize-column
