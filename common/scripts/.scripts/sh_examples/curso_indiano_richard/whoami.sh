#!/bin/bash

# mostrar 3 linhas do cmd PS somente p/ root user

WHOAMI=$(whoami)

if [ "$WHOAMI" != "root" ]; then
  echo "vc n é o root, saindo.."
  exit 1
fi

ps -ef | head -3
