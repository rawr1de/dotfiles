00 — connect_wifi        (wpa_supplicant temporary connection)
01 — install_packages    (xbps install from dotfiles package lists)
02 — setup_services      (enable/disable runit services)
03 — deploy_dotfiles     (stow from dotfiles repo)
04 — setup_keyd
04 — setup_nm            (swap wpa_supplicant → NetworkManager)
~~05 — tty1_autologin      (configure agetty-tty1)~~
06 — setup_polkit        (power management rules)
07a — run: xdg-user-dirs-update
07b — rename_xdg_dirs     (rename home dirs per user-dirs.dirs)
08 — ssh_perms           (fix ~/.ssh permissions)
09 — fonts_install       (JetBrainsMono Nerd Font)
