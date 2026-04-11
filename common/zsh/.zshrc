# set zsh as default shell
# chsh -s /usr/bin/zsh


# --- SSH AGENT MANAGEMENT ---
() { # Anonymous function to keep 'keys' and 'current_host' local
    local keys=()
    [[ -f ~/.ssh/id_legion ]] && keys+=(id_legion)
    [[ -f ~/.ssh/id_templar ]] && keys+=(id_templar)

    if command -v keychain >/dev/null 2>&1; then
        # The modern keychain way
        eval $(keychain --eval --quiet "${keys[@]}")
    else
        # Fallback for fresh installs / TTY work
        if [[ -z "$SSH_AUTH_SOCK" ]]; then
            eval "$(ssh-agent -s)" > /dev/null 2>&1

            local current_host=$(cat /etc/hostname 2>/dev/null)
            case "$current_host" in
                legion)  ssh-add ~/.ssh/id_legion  2>/dev/null ;;
                templar) ssh-add ~/.ssh/id_templar 2>/dev/null ;;
            esac
        fi
    fi
}


# ─── OS & HOSTNAME DETECTION ─────────
CURRENT_HOSTNAME=$(< /etc/hostname)

# Safely source OS ID (arch, void, etc.)
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    CURRENT_OS="$ID"
fi

# ─── HARDWARE & OS SPECIFIC TWEAKS ───
if [[ "$CURRENT_HOSTNAME" == "legion" ]]; then
    if [[ "$CURRENT_OS" == "void" && -f ~/.zsh_legion_VOID ]]; then
        source ~/.zsh_legion_VOID
    elif [[ "$CURRENT_OS" == "arch" && -f ~/.zsh_legion_ARCH ]]; then
        source ~/.zsh_legion_ARCH
    fi
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
# Ergonomic History Search (Alt+K for Up, Alt+J for Down)
bindkey "^[k" up-line-or-search
bindkey "^[j" down-line-or-search


# ─── COMPLETION ──────────────────────
zstyle :compinstall filename '/home/rdo/.zshrc'
autoload -Uz compinit
compinit



# ─── ENVIRONMENT ─────────────────────
PATH=$PATH:~/.local/bin
PATH=$PATH:~/.config
PATH=$PATH:~/.scripts
PATH=$PATH:~/.scripts/groff_helpers/helpers
PATH=$PATH:~/.scripts/PCs/Legion5/kb_controls/
PATH=$PATH:~/.themes
PATH=$PATH:~/.icons

EDITOR="emacsclient -c"
VISUAL="emacsclient -c"

export MOZ_ENABLE_WAYLAND=1 firefox

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
alias ggp='git pull'


# ─── ALIASES: SHELL COMMANDS ─────────
alias pu='pushd'
alias po='popd'
alias mv='mv -iv'
alias cp='cp -iv'
alias cpr='rsync -ah --progress'
alias rm='rm -iv'
alias frm='\rm -rfv'                 # frm = force rm
alias yys='yay -S'
alias yyr='yay -Rns'
alias pac='pacseek'
alias x='exit'


# ─── HEX COLOR CHECKER ─────────
# Usage: color #abb2bf
color() {
    local hex=${1#\#}
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    printf "\n  \e[48;2;%s;%s;%sm        \e[0m  #%s\n\n" "$r" "$g" "$b" "$hex"
}


# ─── FIREFOX RIPGREP SEARCHER ─────────
ff-book() {
  # 1. Force find the profile in YOUR specific path
  local profile=$(ls -d ~/.config/mozilla/firefox/*.default-release 2>/dev/null | head -n 1)

  if [[ -z "$profile" ]]; then
    echo "Error: Profile not found in ~/.config/mozilla/firefox/"
    return 1
  fi

  # 2. Use \cp to FORCE overwrite /tmp without asking
  \cp -f "$profile/places.sqlite" /tmp/ff_places.sqlite

  # 3. Query bookmarks
  sqlite3 /tmp/ff_places.sqlite \
    "SELECT b.title, h.url FROM moz_bookmarks b JOIN moz_places h ON b.fk = h.id WHERE b.title IS NOT NULL;" | rg -i "$1"
}


# ─── ALIASES: DISPLAY-DEPENDENT ──────
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    alias cl='wl-copy'                          # clipboard (Wayland)
elif [[ -n "$DISPLAY" ]]; then
    alias cl='xclip -selection clipboard'       # clipboard (X11)
fi


# ─── ALIASES: SCRIPTS ────────────────
alias fz='SH_fzf_search_editor.sh'             # fzf dynamic search
#alias mm='rofi_man.sh'                         # list & output man pages with rofi & zathura


# ─── EVAL ────────────────────────────
# FOCE ATUIN to READ HIST FILE
# HISTFILE=~/.histfile atuin import zsh
eval "$(atuin init zsh --disable-up-arrow)" # ATUIN (McFly alike)
eval "$(starship init zsh)"         # STARSHIP (POWERLINE alike)
eval "$(zoxide init zsh --cmd cd)"  # ZOXIDE
