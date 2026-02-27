#!/bin/bash

# termina o script SE não houver exatamente 2 argumentos
if [ ! $# -eq 2 ]; then
  echo "Necessario 2 argumentos! Rodar o script com 2 args"
  exit 1
fi

FIRST=$1
SECOND=$2

let RESULT=FIRST*SECOND

if [ $? -ne 0 ]; then
  echo "Coloque 2 numeros inteiros no argumentos"
  exit 2
else
  echo "$FIRST * $SECOND = $RESULT"
fi
