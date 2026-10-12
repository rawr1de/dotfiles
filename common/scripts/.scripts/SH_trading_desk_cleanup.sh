#!/usr/bin/env bash

echo "Iniciando Desmontagem da Secretária de Operações..."

# ==============================================================================
# 1. Fechar o Discord e as Janelas do TradingView
# ==============================================================================
echo "Encerrando Discord e Gráficos..."

# Mata qualquer processo que tenha a palavra "discord" no caminho original (-f)
pkill -f -i discord
# Fallback caso o sistema use um wrapper diferente
killall -I -q discord

# Fecha APENAS a instância isolada do Brave de trading, preservando o seu navegador principal!
pkill -f "brave-trading"

# Aguarda 2 segundos para dar tempo ao sistema de destruir os processos
sleep 2

# ==============================================================================
# 2. Resgatar Janelas Sobreviventes (TWS, Zoom, etc.)
# ==============================================================================
echo "Resgatando IBKR TWS e Zoom para workspaces com gaps..."

rescue_windows() {
    local ws=$1
    if niri msg action focus-workspace "$ws" 2>/dev/null; then
        for i in {1..5}; do
            niri msg action move-window-to-workspace-down 2>/dev/null
            niri msg action focus-workspace "$ws" 2>/dev/null
        done
    fi
}

# Limpa a tela principal (DP-1)
rescue_windows "Trading-DP1"
# Limpa a tela do TWS (HDMI-A-1)
rescue_windows "Trading-HDMI"

# ==============================================================================
# 3. Focar na Workspace 2 em Todos os Monitores
# ==============================================================================
echo "Focando na workspace 2 em todos os monitores..."

# Itera sobre os monitores para garantir que todos mudam para a workspace 2
for mon in "DP-1" "HDMI-A-1" "eDP-2"; do
    niri msg action focus-monitor "$mon" 2>/dev/null
    niri msg action focus-workspace 2 2>/dev/null
done

# Volta o foco do rato/teclado para o monitor do IBKR TWS (ajuste se preferir outro)
niri msg action focus-monitor "HDMI-A-1" 2>/dev/null

# ==============================================================================
# 4. Remover Configurações Dinâmicas do Niri (Restaurar Gaps)
# ==============================================================================
echo "Removendo injeção de layout (Restaurando Gaps)..."

WINDOW_RULES_FILE="$HOME/.config/niri/window-rules.kdl"
CONFIG_FILE="$HOME/.config/niri/config.kdl"

sed -i '/\/\/ START - BRAVE FOR TRADING!/,/\/\/ END - BRAVE FOR TRADING!/d' "$WINDOW_RULES_FILE"
sed -i '/\/\/ START - BRAVE FOR TRADING!/,/\/\/ END - BRAVE FOR TRADING!/d' "$CONFIG_FILE"

echo "Tudo limpo! A sua secretária regressou ao estado normal."
