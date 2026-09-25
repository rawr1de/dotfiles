#!/usr/bin/env bash

# ==============================================================================
# 1. Monitor DP-1: 2 janelas do Brave (TradingView) em Stack Vertical
# ==============================================================================
niri msg action focus-monitor "DP-1"

brave --new-window --app="https://www.tradingview.com" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 4

brave --new-window --app="https://www.tradingview.com" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 4

# Empilha as janelas em coluna
niri msg action consume-or-expel-window-left

# Maximiza a coluna atual preenchendo a tela do monitor
niri msg action maximize-column

# ==============================================================================
# 2. Monitor HDMI-A-1: Brave na Workspace 2
# ==============================================================================
niri msg action focus-monitor "HDMI-A-1"
niri msg action focus-workspace 2
niri msg action move-workspace-to-monitor "HDMI-A-1"

brave --new-window --app="https://www.tradingview.com" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 3

# ==============================================================================
# 3. Monitor eDP-2 (Notebook): Brave comum no Discord
# ==============================================================================
niri msg action focus-monitor "eDP-2"
niri msg action focus-workspace 3

brave --new-window "https://discord.com/channels/1218766394997346395/1222377337975210064" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 3

# Maximiza a coluna/janela do Discord no eDP-2
niri msg action maximize-column
