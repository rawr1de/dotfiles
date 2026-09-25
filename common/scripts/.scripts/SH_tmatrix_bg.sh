#!/bin/bash

# Cria o diretório e arquivo temporário para configuração do kitty
TEMP_DIR=$(mktemp -d)
CONFIG_FILE="${TEMP_DIR}/tmatrix_config"

cat <<EOF > "$CONFIG_FILE"
background_opacity 1.0
hide_window_decorations yes
window_border_width 0
enable_csi_u_mode yes
EOF

# Função para abrir, focar, mover e maximizar a janela no Niri
launch_and_move() {
    local title="$1"
    local color="$2"
    local monitor="$3"

    # Abre o kitty em segundo plano
    kitty --title "$title" --config "$CONFIG_FILE" sh -c "tmatrix -C $color" &

    # Pausa de meio segundo para o Niri mapear e focar a nova janela
    sleep 0.5

    # Move a janela atualmente em foco para o monitor desejado
    niri msg action move-window-to-monitor "$monitor"

    # Maximiza a janela na tela em que ela acabou de ser colocada
    niri msg action maximize-column

    # DICA: Se quiser tela cheia (sem exibir a barra de status ou painel do sistema),
    # comente a linha acima e descomente a linha abaixo:
    # niri msg action fullscreen-window
}

# 1. Tmatrix Verde no monitor Gigabyte DP-1
launch_and_move "Tmatrix Green" "green" "DP-1"

# 2. Tmatrix Amarelo no monitor Gigabyte HDMI-A-1
launch_and_move "Tmatrix Yellow" "yellow" "HDMI-A-1"

# 3. Tmatrix Preto na tela do notebook eDP-2
launch_and_move "Tmatrix Black" "blue" "eDP-2"

# Aguarda os processos para manter os arquivos temporários vivos
wait

# Limpeza automática ao sair
trap "rm -f \"$CONFIG_FILE\"; rmdir \"$TEMP_DIR\"" EXIT

echo "Terminais abertos, posicionados e maximizados. Você pode fechar esta janela."
