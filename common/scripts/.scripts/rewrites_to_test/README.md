# .scripts

Shell scripts for system setup, maintenance, and daily use.
Located at `~/.dotfiles/common/scripts/.scripts/`.

Distro support: **Void Linux** (primary), **Arch/Manjaro** (where noted).

---

## Bootstrap — Void Linux fresh install

Run these in order after booting a base Void ISO.
All scripts must live in the same directory. The orchestrator finds them relative to itself.

```bash
bash ~/.dotfiles/common/scripts/.scripts/SH_main.sh
```

| Step | Script | Purpose |
|------|--------|---------|
| 00 | `SH_00_connect_wifi.sh` | Temporary WiFi via wpa_supplicant |
| 01 | `SH_install_packages.sh` | Install packages from dotfiles profile lists |
| 02 | `SH_02_setup_services.sh` | Enable/disable runit services |
| 03 | `SH_stow_handler_stower.sh` | Deploy dotfiles via GNU Stow |
| 04 | `SH_04_setup_nm.sh` | Swap wpa_supplicant → NetworkManager |
| 05 | `SH_tty1_autologin.sh` | Configure agetty-tty1 autologin |
| 06 | `SH_06_setup_polkit.sh` | Deploy polkit power management rules |
| 07 | `SH_rename_xdg_dirs.sh` | Rename home dirs per user-dirs.dirs |
| 08 | `SH_ssh_perms.sh` | Fix ~/.ssh permissions |
| 09 | `SH_fonts_install.sh` | Install JetBrainsMono Nerd Font |

Each step prompts `y/n/q` before running. Failures are logged and skippable.
Full log saved to `/tmp/SH_main_<timestamp>.log`.

---

## All scripts

### `SH_main.sh`
Bootstrap orchestrator. Calls all steps above in order.
Detects scripts relative to its own location — no path configuration needed.
```bash
bash SH_main.sh
```

---

### `SH_install_packages.sh`
Installs packages and clones repos from dotfiles profile package lists.
Supports Arch and Void. Uses fzf to select which package files to process.
Package lists live inside the profile directory under `.VOID_pkgs/` or `.ARCH_pkgs/`.
```bash
bash SH_install_packages.sh common
bash SH_install_packages.sh templar
bash SH_install_packages.sh common templar wm/niri
```

---

### `SH_stow_handler_stower.sh`
Scans dotfiles repo for stow packages and deploys them to `$HOME`.
Shows `[stowed]` marker on already-deployed packages. Handles conflicts interactively per file.
```bash
bash SH_stow_handler_stower.sh common
bash SH_stow_handler_stower.sh common templar wm/niri
```

---

### `SH_stow_handler_remover.sh`
Scans `$HOME` for symlinks pointing into the dotfiles repo and unstows selected packages.
```bash
bash SH_stow_handler_remover.sh common
bash SH_stow_handler_remover.sh common wm/niri
```

---

### `SH_00_connect_wifi.sh`
Connects to a WPA2 network on a fresh Void install using wpa_supplicant.
Prompts for SSID and password at runtime. Connection is temporary — replaced by
NetworkManager in step 04.
```bash
bash SH_00_connect_wifi.sh
```

---

### `SH_02_setup_services.sh`
Enables and disables runit services for a clean Void install.

Enabled: `acpid chronyd dbus elogind keyd NetworkManager polkitd sshd udevd udisks2`
Disabled: `dhcpcd wpa_supplicant greetd`
```bash
bash SH_02_setup_services.sh
```

---

### `SH_04_setup_nm.sh`
Migrates from wpa_supplicant + dhcpcd to NetworkManager.
Installs NetworkManager if missing, disables old services, verifies connectivity.
```bash
bash SH_04_setup_nm.sh
```

---

### `SH_06_setup_polkit.sh`
Deploys `/etc/polkit-1/rules.d/10-power-management.rules`.
Allows wheel group users to reboot/poweroff without a password prompt.
```bash
bash SH_06_setup_polkit.sh
```

---

### `SH_tty1_autologin.sh`
Configures agetty-tty1 for automatic login. Void Linux only.
Defaults to current user if no argument given.
```bash
bash SH_tty1_autologin.sh
bash SH_tty1_autologin.sh rdo
```

---

### `SH_rename_xdg_dirs.sh`
Reads `~/.config/user-dirs.dirs` and renames standard home directories
to match the custom names defined there.
```bash
bash SH_rename_xdg_dirs.sh
```

---

### `SH_ssh_perms.sh`
Sets correct permissions on `~/.ssh` and its contents.
`700` on dir, `600` on keys and config, `644` on public keys.
```bash
bash SH_ssh_perms.sh
```

---

### `SH_fonts_install.sh`
Downloads and installs JetBrainsMono Nerd Font for the current user.
Supports Arch and Void for dependency installation.
```bash
bash SH_fonts_install.sh
```

---

### `SH_bookmarks_export.sh`
Exports Brave bookmarks to the dotfiles repo as timestamped Firefox-importable HTML.
Auto-commits and pushes to GitHub. Requires python3 and git.
```bash
bash SH_bookmarks_export.sh
```

---

### `SH_fzf_search_editor.sh`
fzf file picker with preset search roots (current dir, `~/.config`, `~/.scripts`).
Opens selected file in Emacs via emacsclient.
```bash
bash SH_fzf_search_editor.sh
```

---

### `SH_kbd-profile_wayl.sh`
Sets keyboard repeat rate in niri config (`~/.config/niri/config.kdl`).
Reloads niri config after applying.
```bash
bash SH_kbd-profile_wayl.sh fast
bash SH_kbd-profile_wayl.sh slow
```

---

### `SH_kbd-profile_x11.sh`
Sets keyboard repeat rate on X11 via `xset r rate`.
```bash
bash SH_kbd-profile_x11.sh fast
bash SH_kbd-profile_x11.sh slow
```

---

### `SH_keyrings_yay_handler.sh`
Fixes GPG keyrings and bootstraps yay (AUR helper).
**Arch/Manjaro only.**
```bash
bash SH_keyrings_yay_handler.sh
```

---

### `SH_rofi_man_manuals.sh`
Browse man pages via rofi, renders selected page as PDF in zathura.
**X11 only.** Run `sudo mandb` once first to build the database.
```bash
bash SH_rofi_man_manuals.sh
```

---

### `SH_fuzzel_man_manuals.sh`
Browse man pages via fuzzel, renders selected page as PDF in zathura.
**Wayland (niri).** Run `sudo mandb` once first to build the database.
```bash
bash SH_fuzzel_man_manuals.sh
```

---

### `SH_lyrics_format.sh`
Formats a raw lyrics text file — numbered song headers, configurable blank lines between songs.
```bash
bash SH_lyrics_format.sh input.txt output.txt
bash SH_lyrics_format.sh input.txt output.txt 2
```

---

### `CONV_m3u_plist_music.sh`
Converts audio files listed in an m3u playlist to a target format.
Supported formats: `mpc` `mp3` `ogg` `opus` `flac`.
Quality profiles vary per format. Output goes to `<format>_enc/` alongside source files.
Default: `~/Musk/`, format `mpc`, quality `high`.
```bash
bash CONV_m3u_plist_music.sh
bash CONV_m3u_plist_music.sh -f mp3 -q standard
bash CONV_m3u_plist_music.sh -i ~/tmp/mylist.m3u -r ~/Musk -f opus -q high
```

---

### `SH_kde-connect_send2phone.sh`
Sends selected files to a paired phone via KDE Connect.
Bind in ranger: `map bp shell -f send2phone %s`
Requires exactly one paired device. Uses `kdeconnect-cli`.
```
# rc.conf
map bp shell -f SH_kde-connect_send2phone.sh %s
```

---

### `tmatrix_bg.sh`
Launches two borderless Kitty terminals running tmatrix (yellow + black).
```bash
bash tmatrix_bg.sh
```
