#!/usr/bin/env bash

pathname="$HOME/.bashrc"

result=$(dirname "$pathname")

echo $result

# remove o nome do arquivo '.bashrc' do caminho (path) do arquivo, printando o resultado na tela
