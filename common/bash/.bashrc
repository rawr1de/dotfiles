#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  .bashrc
#  |_| \_\____/ \___/  |___/        (config file)
#

# If not running interactively, don't do anything [[ $- != *i* ]] && return

# Terminal prompt
PS1='[ $USER ] \$ '

# Terminal Aliases
alias fix='reset; stty sane; tput rs1; clear; echo -e "\033c"'       ## reset terminal
alias ll='lsd -lAh --group-dirs first --hyperlink=auto'
alias ls='ls -h --color=auto --group-directories-first --hyperlink=auto'
alias le='bat'

# CLI prog's 3rd party
alias ra='ranger'
alias cm='cmus'
alias tl='tldr'
alias m='emacsclient -c -a emacs'
#alias m='emacsclient -t --socket-name=/run/user/1000/emacs/server'
#alias v='nvim'

# CLI cmd's
alias pu='pushd'
alias po='popd'
alias mv='mv -iv'
alias cp='cp -iv'
alias cpr='rsync -ah --progress'
alias rm='rm -iv'
alias frm='\rm -rfv'   ## frm = force rm
alias x='exit'

# CLI rofi scripts 
alias se='script_editor.sh'   ## fzf search dir's .scipts & .config
alias fe='file_editor.sh'     ## fzf search current dir
alias mm='rofi_man.sh '       ## list & output man pages with rofi & zathura

# Paths
PATH=$PATH:~/.config
PATH=$PATH:~/.scripts
PATH=$PATH:~/.scripts/groff_helpers/helpers
PATH=$PATH:~/.scripts/PCs/Legion5/kb_controls/
PATH=$PATH:~/.themes
PATH=$PATH:~/.icons

# Readline customization
complete -cf sudo

# don't put duplicate lines or lines starting with spaces in the history
HISTCONTROL=ignoreboth

# history lenght
HISTSIZE=3000

# history file size
HISTFILESIZE=2000

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(mcfly init bash)"

# if [[ -r /usr/share/doc/mcfly/mcfly.bash ]]; then
# source /usr/share/doc/mcfly/mcfly.bash
# fi

PATH="/home/rdo/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/rdo/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/rdo/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/rdo/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/rdo/perl5"; export PERL_MM_OPT;


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
