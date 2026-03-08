#!/bin/bash

# 1. Purge WM and X11 Bloat while keeping Manjaro internals
echo "Purging WM and X11 bloat..."
sudo pacman -Rns i3-wm i3status i3lock lightdm lightdm-gtk-greeter dmenu --noconfirm

# 2. Install Niri and dependencies
echo "Installing Niri and portals..."
sudo pacman -S niri xdg-desktop-portal-gnome polkit-gnome --noconfirm

# 3. Enable TTY1 Autologin
echo "Configuring TTY1 autologin..."
CONF_DIR="/etc/systemd/system/getty@tty1.service.d"
sudo mkdir -p "$CONF_DIR"
cat <<EOF | sudo tee "$CONF_DIR/override.conf"
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF

# 4. Generate .zprofile
echo "Configuring .zprofile..."
cat <<EOF > ~/.zprofile
# --- Common Environment ---
export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

# --- Legion 5 Hardware Logic ---
if [[ "\$(hostname)" == "legion" ]]; then
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export LIBVA_DRIVER_NAME=nvidia
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM="wayland;xcb"
fi

# --- TTY1 Autostart ---
if [[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]]; then
    export XDG_CURRENT_DESKTOP=niri
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=niri
    exec niri-session
fi
EOF

# 5. NVIDIA Modesetting in GRUB
echo "Ensuring NVIDIA modesetting..."
if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 /' /etc/default/grub
    sudo update-grub
fi

echo "Setup complete. Review ~/.zprofile and reboot."
