# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi


# CLI prog's 3rd party
alias ra='ranger'  		# file manager
alias cm='cmus'			# CMus music player
alias mk='musikcube'		# MusikCube music player
alias tl='tldr'			# tl;dr commands lookup (net)
alias m='emacsclient -c -a emacs'
alias ll='lsd -lAh --group-dirs first --hyperlink=auto'
alias ls='ls -h --color=auto --group-directories-first --hyperlink=auto'
alias le='bat'
alias df='duf -hide special'


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

# don't put duplicate lines or lines starting with spaces in the history
HISTCONTROL=ignoreboth

# history lenght
HISTSIZE=2000

# history file size
HISTFILESIZE=2000

eval "$(mcfly init zsh)"
