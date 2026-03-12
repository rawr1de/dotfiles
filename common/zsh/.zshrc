# set zsh as default shell
# chsh -s /usr/bin/zsh


# Start SSH agent and add machine-specific SSH key
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    case "$(hostname)" in
        legion)  ssh-add ~/.ssh/id_legion  2>/dev/null ;;
        templar) ssh-add ~/.ssh/id_templar 2>/dev/null ;;
    esac
fi



# ─── HISTORY ─────────────────────
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY           # don't overwrite history, append to it
setopt HIST_IGNORE_DUPS         # don't save duplicate commands
setopt HIST_IGNORE_SPACE        # don't save commands starting with a space
#setopt SHARE_HISTORY           # syncs history across multiple terminal sessions in real time
#setopt EXTENDED_HISTORY        # adds timestamps to history (useful but bloats)
#setopt HIST_EXPIRE_DUPS_FIRST  # delete duplicate history entries before unique ones when SAVEHIST limit is reached



# ─── KEYBINDINGS ─────────────────────
unsetopt beep
#bindkey -v                              # vim-style line editing
bindkey -e                              # emacs-style line editing
bindkey "^[[H" beginning-of-line        # <Home> → beginning of line



# ─── COMPLETION ──────────────────────
zstyle :compinstall filename '/home/rdo/.zshrc'
autoload -Uz compinit
compinit



# ─── ENVIRONMENT ─────────────────────
#export EDITOR="emacsclient -c"
#export VISUAL="emacsclient -c"

PATH=$PATH:~/.config
PATH=$PATH:~/.scripts
PATH=$PATH:~/.scripts/groff_helpers/helpers
PATH=$PATH:~/.scripts/PCs/Legion5/kb_controls/
PATH=$PATH:~/.themes
PATH=$PATH:~/.icons



# ─── ALIASES: PROGRAMS ───────────────
alias ra='ranger'                               # file manager
alias zi='yazi'                                 # file manager
alias cm='cmus'                                 # CMus music player
alias mk='musikcube'                            # MusikCube music player
alias tl='tldr'                                 # tl;dr commands lookup (net)
alias m='emacsclient -c -a emacs'               # emacs
alias ll='lsd -lAh --group-dirs first --hyperlink=auto'
alias ls='ls -h --color=auto --group-directories-first --hyperlink=auto'
alias le='bat'                                  # cat with syntax highlighting
alias df='duf -hide special'                    # disk usage
alias ggu='git add . && git commit && git push' # git add . commit push
alias ggs='git status'
alias ggp='git pull'



# ─── ALIASES: SHELL COMMANDS ─────────
alias pu='pushd'
alias po='popd'
alias mv='mv -iv'
alias cp='cp -iv'
alias cpr='rsync -ah --progress'
alias rm='rm -iv'
alias frm='\rm -rfv'                 # frm = force rm
alias x='exit'
alias reboot='loginctl reboot'
alias shutdown='loginctl poweroff'



# ─── ALIASES: DISPLAY-DEPENDENT ──────
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    alias cl='wl-copy'                          # clipboard (Wayland)
elif [[ -n "$DISPLAY" ]]; then
    alias cl='xclip -selection clipboard'       # clipboard (X11)
fi

# Created by `pipx` on 2026-03-08 17:54:45
#export PATH="$PATH:/home/rdo/.local/bin"



# ─── ALIASES: SCRIPTS ────────────────
alias fz='SH_fzf_search_editor.sh'             # fzf dynamic search
#alias mm='rofi_man.sh'                         # list & output man pages with rofi & zathura



# ─── EVAL ────────────────────────────
#eval "$(mcfly init zsh)"           # McFly
eval "$(atuin init zsh)"            # ATUIN (McFly alike)
eval "$(starship init zsh)"         # STARSHIP (POWERLINE alike)
eval "$(zoxide init zsh --cmd cd)"  # ZOXIDE
