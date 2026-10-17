#!/usr/bin/env bash

# 1. Define as opções do menu
OPTIONS="1. Setup Desk (8 Braves + Discord)
2. Setup Desk (4 Braves + Discord)
3. Clean Up Desk"

# 2. Inicia o Fuzzel em modo dmenu (alargado para caber o texto extra)
CHOICE=$(echo "$OPTIONS" | fuzzel -d -p "Select Action: " -l 3 -w 60 --line-height=24)

# 3. Executa o script com base na escolha
case "$CHOICE" in
    "1. Setup Desk (8 Braves + Discord)")
        /home/rdo/.dotfiles/common/scripts/.scripts/SH_trading_desk_setup_8.sh
        ;;

    "2. Setup Desk (4 Braves + Discord)")
        # A apontar para o novo ficheiro que criou!
        /home/rdo/.dotfiles/common/scripts/.scripts/SH_trading_desk_setup_4.sh
        ;;

    "3. Clean Up Desk")
        /home/rdo/.dotfiles/common/scripts/.scripts/SH_trading_desk_cleanup.sh
        ;;

    *)
        exit 0
        ;;
esac
