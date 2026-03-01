#!/bin/bash

# Script Editor (search files in .scripts/ .config/ Docs/linux_shit/

du -a ~/.config/ | awk '{print $2}' | fzf -i | xargs -I{} emacsclient -c {}

# complementar scrip com condicional SE;
# se for .pdf ou qualquer outro arq. executável pelo zathura abrir nele
# caso n seja, abrir no emacs
