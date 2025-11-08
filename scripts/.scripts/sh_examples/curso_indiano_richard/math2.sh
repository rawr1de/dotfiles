#!/usr/bin/env bash

#   ____  ____   ___  
#  |  _ \|  _ \ / _ \
#  | |_) | | | | | | |  -->  Post Instal Script
#  |  _ <| |_| | |_| |
#  |_| \_\____/ \___/ 
#  

echo -n "Primeiro nº: "
read PRIM
echo -n "Segundo nº: "
read SEGU

#fazer alguns LET aqui
let RESULT=PRIM+SEGU
echo "$PRIM + $SEGU = $RESULT"

#fazer alguns bc
RESULT=`echo "$PRIM^$SEGU" | bc`
echo "$PRIM ^ $SEGU = $RESULT"
