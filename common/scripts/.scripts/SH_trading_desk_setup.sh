#!/usr/bin/env bash

# ==============================================================================
# 1. Monitor DP-1: 2 janelas do Brave (TradingView) em Stack Vertical
# ==============================================================================
niri msg action focus-workspace "Trading-DP1"

brave --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 4

brave --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 4

# Empilha as janelas em coluna
niri msg action consume-or-expel-window-left
niri msg action maximize-column

# ==============================================================================
# 2. Monitor HDMI-A-1: 2 janelas do Brave (TradingView) na Workspace 2
# ==============================================================================
niri msg action focus-workspace "Trading-HDMI"

brave --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 4

brave --new-window --app="https://www.tradingview.com/chart/0LQdFlnI/" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 4

# Empilha as janelas em coluna
niri msg action consume-or-expel-window-left
niri msg action maximize-column

# ==============================================================================
# 3. Monitor eDP-2 (Notebook): Brave comum no Discord
# ==============================================================================
niri msg action focus-monitor "eDP-2"
niri msg action focus-workspace 3

brave --new-window "https://discord.com/channels/1218766394997346395/1222377337975210064" --enable-features=UseOzonePlatform --ozone-platform=wayland &
sleep 3

# Maximiza a coluna/janela do Discord no eDP-2 mantendo os gaps normais
niri msg action maximize-column
