# Get hostname from file since the 'hostname' binary may be missing
CURRENT_HOSTNAME=$(< /etc/hostname)

# Start SSH agent and add machine-specific SSH key
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    case "$CURRENT_HOSTNAME" in
        legion)  ssh-add ~/.ssh/id_legion  2>/dev/null ;;
        templar) ssh-add ~/.ssh/id_templar 2>/dev/null ;;
    esac
fi

# Source Legion-specific tweaks for hardware
if [[ "$CURRENT_HOSTNAME" == "legion" ]]; then
    [[ -f ~/.zsh_legion ]] && source ~/.zsh_legion
fi


# ─── VISUAL ─────────────────────
# bigger font in TTY
setfont /usr/share/kbd/consolefonts/latarcyrheb-sun32


# ─── ENVIRONMENT ─────────────────────
# System-wide PATH — ensures all installed binaries are accessible
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.config
export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:$HOME/.scripts/groff_helpers/helpers
export PATH=$PATH:$HOME/.scripts/PCs/Legion5/kb_controls/
export PATH=$PATH:$HOME/.themes
export PATH=$PATH:$HOME/.icons

export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

export MOZ_ENABLE_WAYLAND=1 firefox
export XDG_CURRENT_DESKTOP=niri
export XDG_SESSION_TYPE=wayland
# This is crucial for niri to handle portals correctly
export XDG_MENU_PREFIX=gnome-


# ─── WAYLAND AUTOSTART ─────────────────────
# Must be last — exec replaces the shell, nothing below this runs
 if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
     export XDG_RUNTIME_DIR="/run/user/$(id -u)"
     export XDG_SESSION_TYPE=wayland
     export XDG_SESSION_DESKTOP=niri
     export MOZ_ENABLE_WAYLAND=1
     export QT_QPA_PLATFORM=wayland
     export ELECTRON_OZONE_PLATFORM_HINT=wayland
     exec dbus-run-session niri
fi
