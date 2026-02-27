#!/usr/bin/env bash

# ____  ____   ___  
#|  _ \|  _ \ / _ \
#| |_) | | | | | | |  -->  Measure Time, example
#|  _ <| |_| | |_| |
#|_| \_\____/ \___/ 
#

# timer, inico
START=$(date +%s)

# ação (comando) que se quer medir o tempo
cp ~/Musk/Alkymist\ -\ Sanctuary/06.\ Desolated\ Sky.flac ~/.scripts/

END=$(date +%s)

# tempo gasto (diferença)
DIF=$(( END - START ))

echo "tempo gasto: $DIF segundos."
