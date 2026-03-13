# Apps List

> Evaluated & reorganized. X11-specific tools grouped separately. Video-specific libs stripped.
> Legend: ⚠️ outdated/superseded · ❌ drop · ✅ keep · 🔄 replaced by

---

## 🧱 Base — Any Linux

Core tools that belong on every machine regardless of DE/WM.

| Package | Notes |
|---|---|
| `git` | |
| `emacs-pgtk` / `emacs-wayland` | Wayland build — distro name differs, see package_reference.md |
| `neovim` | fallback editor |
| `nano` | emergency fallback |
| `kitty` | terminal |
| `fzf` | fuzzy finder — used by scripts, yazi, ranger |
| `rsync` | |
| `wget` | |
| `man-db` | manuals |
| `tldr` | simplified manuals — both coexist, different use |
| `glow` | markdown viewer — integrated into ranger/yazi |
| `unzip` / `unrar` / `p7zip` / `atool` | atool is the wrapper, others are backends |
| `ntfs-3g` | NTFS mount |
| `dosfstools` / `exfat-utils` / `mtools` | FAT/exFAT |
| `dbus` | IPC, required by everything |
| `htop` | process monitor |
| `acpi` | battery/power info |
| `tlp` | laptop power management — makes real battery difference |
| `brightnessctl` | screen brightness |
| `bc` | calculator |
| `ripgrep` | fast grep replacement, used in scripts |
| `imagemagick` | |
| `fastfetch` | system info — replaces abandoned neofetch |
| `lsd` | ls replacement |
| `bat` | cat replacement |
| `stow` | dotfile management |
| `atuin` | shell history |
| `starship` | prompt |
| `zoxide` | cd replacement |
| `cronie` | cron — available on both Void and Arch |
| `chrony` | NTP time sync — not a cron, different purpose |
| `gtypist` | typing tutor |

---

## 🌐 Networking & System

| Package | Notes |
|---|---|
| `networkmanager` | |
| `network-manager-applet` | |
| `iwd` | wifi backend |
| `wpa_supplicant` | bootstrap/fallback only — NM takes over after setup |
| `dhcpcd` | bootstrap only |
| `bluez` + `bluez-utils` | bluetooth |
| `gvfs` + `gvfs-mtp` | file manager backends, MTP/Android |
| `android-udev` | Android device rules |
| `udiskie` | removable disk automounter |
| `ventoy` | bootable USB multi-ISO — Arch: AUR, Void: manual install |
| `cups` + `hplip` | printing — install on demand |

---

## 🖥️ Wayland Stack

| Package | Notes |
|---|---|
| `niri` | WM |
| `keyd` | key remapping |
| `fuzzel` | launcher |
| `dunst` | notifications |
| `cliphist` | clipboard manager |
| `wl-clipboard` | clipboard CLI backend for cliphist |
| `xwayland-satellite` | XWayland for legacy apps under niri |
| `swaylock` | screen locker |
| `swayidle` | idle/lock trigger |
| `swww` | wallpaper daemon |
| `grim` + `slurp` | screenshot + region select |
| `gammastep` | blue light filter — replaces redshift |
| `kanshi` | display profile switching |
| `libnotify` | notify-send library |
| `xdg-utils` / `xdg-user-dirs` | |
| `pipewire` + `wireplumber` | audio — replaces pulseaudio entirely |
| `pulsemixer` | TUI mixer — works via pipewire-pulse compat layer |
| `pamixer` | CLI mixer — used in keybind volume scripts |
| `alsa-utils` | still needed for low-level ALSA |

---

## 🪟 X11-Specific (Legacy / Reference Only)

Not needed on Wayland. Kept as reference for what replaced what.

| Package | Status | Wayland replacement |
|---|---|---|
| `xorg-server` + `xorg-xinit` | X11 only | niri |
| `xorg-xbacklight` | ❌ | `brightnessctl` |
| `xorg-setxkbmap` / `xorg-xmodmap` | ❌ | `keyd` |
| `xorg-xkill` / `xorg-xset` / `xorg-xev` | ❌ | — |
| `xorg-xprop` / `xorg-xwininfo` / `xorg-xdpyinfo` | ❌ | — |
| `xclip` | ❌ | `wl-clipboard` |
| `clipmenu` | ❌ | `cliphist` |
| `xcape` | ❌ | `keyd` |
| `xdo` / `xdotool` | ❌ | — |
| `xsettingsd` | ❌ | — |
| `xwallpaper` / `hsetroot` | ❌ | `swww` |
| `maim` / `flameshot` | ❌ | `grim` + `slurp` |
| `unclutter` | ❌ | — |
| `slock` / `betterlockscreen` | ❌ | `swaylock` |
| `picom` | ❌ | compositing built into niri |
| `arandr` / `autorandr` / `xlayoutdisplay` | ❌ | `kanshi` |
| `sxhkd` | ❌ | niri keybinds config |
| `numlockx` | ❌ | — |
| `rofi` / `rofi-emoji` / `rofi-calc` | ❌ | `fuzzel` |
| `xf86-video-ati` / `xf86-video-intel` | ❌ | modesetting default |
| `xf86-input-synaptics` | ❌ | libinput |
| `dwm` | ❌ | `niri` |
| `polybar` / `tint2` | ❌ | niri status bar config |
| `redshift` | ❌ | `gammastep` |
| `ueberzug` | ❌ | yazi built-in kitty/sixel protocol |
| `feh` | ⚠️ | still works as image viewer, `imv` preferred on Wayland |

---

## 📁 File Management

| Package | Notes |
|---|---|
| `yazi` | primary file manager |
| `ranger` | keeping during yazi migration |
| `thunar` | GUI file manager |
| `dragon-drop` | drag-and-drop — Wayland supported |
| `zathura` + `zathura-pdf-poppler` + `zathura-djvu` | document viewer |
| `glow` | markdown viewer (also in base) |
| `plocate` | fast file index — replaces mlocate |

---

## 🎵 Audio & Media — Base

| Package | Notes |
|---|---|
| `cmus` | terminal music player |
| `mpv` | video player |
| `ffmpeg` | encode/convert/stream |
| `mediainfo` | file info CLI |
| `alsa-utils` | (also in Wayland stack) |

---

## 🎵 Audio & Media — Full

| Package | Notes |
|---|---|
| `audacity` | audio editor |
| `lame` | MP3 encoder |
| `shntool` + `cuetools` | lossless audio splitting |
| `flacon` | album splitter GUI |
| `wavpack` | lossless audio codec |
| `musepack-tools` | MPC decode |
| `taglib` | audio tag library — dep for other tools |
| `puddletag` | audio tag editor GUI |
| `freac` | audio converter GUI — Arch: `freac-bin` |
| `fatsort` | FAT directory order — car audio players |

---

## 🖼️ Image & Screenshots

| Package | Notes |
|---|---|
| `imv` | Wayland-native image viewer — base |
| `nsxiv` | X11 image viewer — replaces abandoned sxiv |
| `grim` + `slurp` | screenshot tools (also in Wayland stack) |
| `gimp` + `gimp-plugin-gmic` | full image editor — full build |
| `img2pdf` | image → PDF |
| `pdftk` | PDF manipulation CLI |
| `imagemagick` | (also in base) |
| `gpick` | color picker |
| `ocrmypdf` | OCR layer for scanned PDFs — Arch: AUR |

---

## 🌍 Browsers, Web & File Transfer

| Package | Notes |
|---|---|
| `firefox` | primary browser |
| `brave` | Arch: `brave-bin` AUR · Void: Flatpak or AppImage |
| `yt-dlp` | replaces abandoned youtube-dl |
| `transmission-cli` | lightweight torrent — base |
| `qbittorrent` | full torrent client with built-in search engine — full build |
| `kdeconnect` | persistent phone↔PC sync |
| `wormhole-rs` | internet file transfer — single binary, no account needed |
| `quickserve` | LAN one-shot HTTP share — receiver needs only a browser |

---

## 📝 Documents & Office

| Package | Notes |
|---|---|
| `libreoffice` | Arch: `libreoffice-fresh` · Void: `libreoffice` |
| `sc-im` | terminal spreadsheet — Arch: AUR |
| `calcurse` | terminal calendar/organizer |
| `newsboat` | RSS reader |
| `neomutt` + `mutt-wizard` | terminal email |
| `irssi` | IRC client |
| `texlive-latexextra` | LaTeX for emacs org-export |
| `ditaa` | ASCII diagrams in emacs |
| `lnav` | log file navigator |

---

## 🔧 Dev & Scripting

| Package | Notes |
|---|---|
| `ctags` | code indexing |
| `highlight` | syntax highlighting in ranger/yazi previews |
| `task-spooler` (`ts`) | batch job queue |
| `socat` | socket utility |
| `exiv2` / `perl-image-exiftool` | metadata r/w — distro casing differs, see package_reference.md |
| `wine-staging` | Arch · Void: `wine` — staging has better out-of-box compat |
| `winetricks` | wine helper scripts |

---

## 🎬 Video Production (Install on Demand)

| Package | Notes |
|---|---|
| `obs-studio` | recording/streaming |
| `kdenlive` | video editor |
| `mkvtoolnix-gui` | MKV tools |
| `vidcutter` | simple cutter/joiner |
| `handbrake` | transcoder |
| `davinci-resolve` | professional editor (proprietary) |
| `guvcview` | webcam capture |

---

## 🎮 Gaming (Full Build)

| Package | Notes |
|---|---|
| `steam` | |
| `wine-staging` | Windows app/game compatibility |
| `winetricks` | wine helper scripts |
| `gamemode` | performance mode for games |
| `mangohud` | in-game overlay (FPS, temps) |

---

## 🔤 Fonts

| Package | Void | Arch |
|---|---|---|
| JetBrains Mono Nerd | `font-jetbrains-mono-nerd-fonts` | `ttf-jetbrains-mono-nerd` |
| Font Awesome | `font-awesome6` | `otf-font-awesome` |
| Noto Emoji | `noto-fonts-emoji` | `noto-fonts-emoji` |
| Nerd Fonts symbols | `nerd-fonts` | `ttf-nerd-fonts-symbols` |
| Math/LaTeX fonts | `texlive-core` | `texlive-core` |

---

## ❌ Dropped — Do Not Reinstall

| Package | Reason |
|---|---|
| `neofetch` | abandoned — use `fastfetch` |
| `haveged` | obsolete since kernel 5.6 |
| `mcfly` | replaced by `atuin` |
| `anymeal` | abandoned |
| `liquid-prompt` | replaced by `starship` |
| `youtube-dl` | abandoned — use `yt-dlp` |
| `sxiv` | abandoned — use `nsxiv` |
| `viewnior` | abandoned |
| `pulseaudio` stack | replaced by pipewire |
| `lxsession` | X11 session manager, no use case |
| `xkeycaps` / `gucharmap` | X11/GTK bloat, no use case |
| `xfburn` / `bashburn` | CD burning — install on demand if ever needed |
| `archlinux-xdg-menu` | Arch/X11 specific |
| `xdg-user-dirs-gtk` | GTK-heavy DE only |
| `cmatrix` | use `tmatrix` |
| `thunar-media-tags-plugin` | barely maintained |
| `thunar-archive-plugin` | barely maintained |
