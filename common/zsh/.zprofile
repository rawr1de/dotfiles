# Start SSH agent
eval "$(ssh-agent -s)" > /dev/null 2>&1

# Start SSH agent and add machine-specific SSH key
case "$(hostname)" in
    legion)  ssh-add ~/.ssh/id_legion  ;;
    templar) ssh-add ~/.ssh/id_templar ;;
esac


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
