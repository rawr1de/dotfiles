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

# Aguarde 1 segundo para o Niri recarregar as configurações automaticamente
sleep 1

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
