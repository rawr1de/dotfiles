#!/bin/bash

# Script Editor (search files in .scripts/ .config/ Docs/linux_shit/

du -a ~/.scripts/ ~/.config/  ~/Docs/linux_shit/ | awk '{print $2}' | fzf -i | xargs -i bash -c "emacs {} & disown -h"

# complementar scrip com condicional SE;
# se for .pdf ou qualquer outro arq. executável pelo zathura abrir nele
# caso n seja, abrir no emacs
