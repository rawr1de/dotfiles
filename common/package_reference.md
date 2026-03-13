# Package Reference — Void & Arch/Manjaro

> Ground truth verified March 2026. Void on Templar, Arch/Manjaro on Legion.
> Use this as the master reference when updating `.txt` pkg files.

## Legend

| Symbol | Meaning |
|---|---|
| ✅ | Available, install normally |
| `AUR` | Arch User Repository — needs yay/paru |
| ⚠️ | Not in repos — see workaround |
| `[*]` | Currently installed on Templar |
| —  | Same name on both distros |

---

## 🖥️ Wayland Stack

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| niri | `niri` ✅ `[*]` | `niri` extra ✅ | |
| keyd | `keyd` ✅ `[*]` | `keyd` extra ✅ | runit/systemd service |
| fuzzel | `fuzzel` ✅ `[*]` | `fuzzel` extra ✅ | launcher |
| cliphist | `cliphist` ✅ `[*]` | `cliphist` extra ✅ | clipboard manager |
| swww | `swww` ✅ | `swww` extra ✅ | wallpaper daemon |
| grim | `grim` ✅ | `grim` extra ✅ | screenshot |
| slurp | `slurp` ✅ | `slurp` extra ✅ | region select for grim |
| swaylock | `swaylock` ✅ | `swaylock` extra ✅ | screen locker |
| swayidle | `swayidle` ✅ | `swayidle` extra ✅ | idle/lock trigger |
| gammastep | `gammastep` ✅ | `gammastep` extra ✅ | blue light filter |
| kanshi | `kanshi` ✅ | `kanshi` extra ✅ | display profile switching |
| dunst | `dunst` ✅ | `dunst` extra ✅ | notification daemon |
| libnotify | `libnotify` ✅ `[*]` | `libnotify` extra ✅ | notify-send library |
| xwayland-satellite | `xwayland-satellite` ✅ | `xwayland-satellite` extra ✅ | XWayland for niri |
| dragon-drop | `dragon-drop` ✅ | `dragon-drop` AUR ✅ | drag-and-drop |

---

## ✏️ Editors

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| Emacs (Wayland) | `emacs-pgtk` ✅ `[*]` | `emacs-wayland` extra ✅ | ⚠️ different names — both are PGTK build. Do NOT install base `emacs` on Wayland |
| neovim | `neovim` ✅ | `neovim` extra ✅ | |

---

## 🖥️ Terminal & Shell

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| kitty | `kitty` ✅ `[*]` | `kitty` extra ✅ | |
| zsh | `zsh` ✅ `[*]` | `zsh` extra ✅ | |
| atuin | `atuin` ✅ `[*]` | `atuin` extra ✅ | shell history |
| starship | `starship` ✅ `[*]` | `starship` extra ✅ | prompt |
| zoxide | `zoxide` ✅ `[*]` | `zoxide` extra ✅ | cd replacement |
| bat | `bat` ✅ `[*]` | `bat` extra ✅ | cat replacement |
| lsd | `lsd` ✅ `[*]` | `lsd` extra ✅ | ls replacement |
| fzf | `fzf` ✅ | `fzf` extra ✅ | fuzzy finder |
| ripgrep | `ripgrep` ✅ | `ripgrep` extra ✅ | fast grep replacement |
| fastfetch | `fastfetch` ✅ | `fastfetch` extra ✅ | system info |

---

## 🗂️ File Management

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| yazi | `yazi` ✅ `[*]` | `yazi` extra ✅ | primary file manager |
| ranger | `ranger` ✅ | `ranger` extra ✅ | keeping during migration |
| thunar | `thunar` ✅ | `thunar` extra ✅ | GUI file manager |
| gvfs | `gvfs` ✅ | `gvfs` extra ✅ | virtual filesystem |
| gvfs-mtp | `gvfs-mtp` ✅ | `gvfs-mtp` extra ✅ | Android MTP |
| android-udev | `android-udev` ✅ | `android-udev` extra ✅ | Android device rules |
| udiskie | `udiskie` ✅ | `udiskie` extra ✅ | automounter |
| imv | `imv` ✅ | `imv` extra ✅ | Wayland-native image viewer |
| nsxiv | `nsxiv` ✅ | `nsxiv` extra ✅ | X11 image viewer |
| zathura | `zathura` ✅ | `zathura` extra ✅ | document viewer |
| zathura-pdf-poppler | `zathura-pdf-poppler` ✅ | `zathura-pdf-poppler` extra ✅ | PDF backend |
| zathura-djvu | `zathura-djvu` ✅ | `zathura-djvu` extra ✅ | DjVu backend |

---

## ⏰ Task Scheduling & Time

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| cronie | `cronie` ✅ | `cronie` extra ✅ | recommended cron — available both distros |
| fcron | `fcron` ✅ | `fcron` extra ✅ | feature-rich cron, wake-from-sleep jobs |
| chrony | `chrony` ✅ `[*]` | `chrony` extra ✅ | NTP time sync — **not a cron, different purpose** |

---

## 🔊 Audio

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| pipewire | `pipewire` ✅ `[*]` | `pipewire` extra ✅ | |
| wireplumber | `wireplumber` ✅ `[*]` | `wireplumber` extra ✅ | |
| wireplumber-elogind | `wireplumber-elogind` ✅ | — n/a | Void only — needed with elogind |
| pulsemixer | `pulsemixer` ✅ | `pulsemixer` extra ✅ | TUI mixer |
| pamixer | `pamixer` ✅ | `pamixer` extra ✅ | CLI mixer |
| alsa-utils | `alsa-utils` ✅ | `alsa-utils` extra ✅ | low-level ALSA tools |
| alsa-pipewire | `alsa-pipewire` ✅ | — (included in pipewire) | Void needs explicit install |

---

## 🎵 Media & Audio Tools

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| cmus | `cmus` ✅ | `cmus` extra ✅ | terminal music player |
| mpv | `mpv` ✅ | `mpv` extra ✅ | video player |
| ffmpeg | `ffmpeg` ✅ | `ffmpeg` extra ✅ | |
| audacity | `audacity` ✅ | `audacity` extra ✅ | audio editor |
| mediainfo | `mediainfo` ✅ | `mediainfo` extra ✅ | file info CLI |
| lame | `lame` ✅ | `lame` extra ✅ | MP3 encoder |
| shntool | `shntool` ✅ | `shntool` AUR ✅ | lossless splitting |
| cuetools | `cuetools` ✅ | `cuetools` extra ✅ | cue file parsing |
| flacon | `flacon` ✅ | `flacon` AUR ✅ | album splitter GUI |
| fatsort | `fatsort` ✅ | `fatsort` extra ✅ | FAT dir order (car audio) |
| puddletag | `puddletag` ✅ | `puddletag` AUR ✅ | tag editor GUI |
| freac | `freac` ✅ | `freac-bin` AUR ✅ | ⚠️ different names — Void: `freac`, Arch: `freac-bin` |

---

## 🌐 Browsers & Web

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| brave | ⚠️ not in xbps | `brave-bin` AUR ✅ | Void: Flatpak or AppImage |
| firefox | `firefox` ✅ | `firefox` extra ✅ | |
| yt-dlp | `yt-dlp` ✅ | `yt-dlp` extra ✅ | replaces youtube-dl |

---

## 📝 Documents & Office

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| newsboat | `newsboat` ✅ | `newsboat` extra ✅ | RSS reader |
| sc-im | `sc-im` ✅ | `sc-im` AUR ✅ | terminal spreadsheet |
| calcurse | `calcurse` ✅ | `calcurse` extra ✅ | terminal calendar |
| neomutt | `neomutt` ✅ | `neomutt` extra ✅ | terminal email |
| libreoffice | `libreoffice` ✅ | `libreoffice-fresh` extra ✅ | ⚠️ different names |
| texlive | `texlive-latexextra` ✅ | `texlive-latexextra` extra ✅ | LaTeX for emacs org-export |
| irssi | `irssi` ✅ | `irssi` extra ✅ | IRC client |

---

## 🔧 System Utilities

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| htop | `htop` ✅ | `htop` extra ✅ | |
| acpi | `acpi` ✅ | `acpi` extra ✅ | battery/power info |
| tlp | `tlp` ✅ | `tlp` extra ✅ | power management |
| bluez | `bluez` ✅ | `bluez` extra ✅ | |
| bluez-utils | `bluez-utils` ✅ | `bluez-utils` extra ✅ | |
| rsync | `rsync` ✅ | `rsync` extra ✅ | |
| stow | `stow` ✅ | `stow` extra ✅ | dotfile management |
| fzf | `fzf` ✅ | `fzf` extra ✅ | |
| socat | `socat` ✅ | `socat` extra ✅ | |
| bc | `bc` ✅ | `bc` extra ✅ | |
| lnav | `lnav` ✅ | `lnav` extra ✅ | log file navigator |
| pdftk | `pdftk` ✅ | `pdftk` extra ✅ | PDF CLI tools |
| img2pdf | `img2pdf` ✅ | `img2pdf` extra ✅ | |
| ocrmypdf | `ocrmypdf` ✅ | `ocrmypdf` AUR ✅ | ⚠️ Arch: AUR only |
| imagemagick | `ImageMagick` ✅ | `imagemagick` extra ✅ | ⚠️ Void: capital I and M |
| exiv2 | `exiv2` ✅ | `exiv2` extra ✅ | |
| perl-image-exiftool | `perl-Image-ExifTool` ✅ | `perl-image-exiftool` extra ✅ | ⚠️ Void: capital I and E |
| wine | `wine` ✅ | `wine-staging` extra ✅ | ⚠️ different names — Arch: use staging for better compat |
| ventoy | ⚠️ not in xbps | `ventoy` AUR ✅ | Void: download from ventoy.net |

---

## 🔤 Fonts

| Package | Void (xbps) | Arch (pacman/AUR) | Notes |
|---|---|---|---|
| JetBrains Mono Nerd | `font-jetbrains-mono-nerd-fonts` ✅ | `ttf-jetbrains-mono-nerd` extra ✅ | ⚠️ different names |
| Font Awesome | `font-awesome6` ✅ | `otf-font-awesome` extra ✅ | ⚠️ different names |
| Noto Emoji | `noto-fonts-emoji` ✅ | `noto-fonts-emoji` extra ✅ | required for emoji in terminal |
| Nerd Fonts symbols | `nerd-fonts` ✅ | `ttf-nerd-fonts-symbols` extra ✅ | ⚠️ different names — fallback glyph coverage |

> **kitty.conf:** Use `family='JetBrainsMono Nerd Font'` with `disable_ligatures never` for ligatures. Switch to `JetBrainsMono Nerd Font Mono` for strict 1-cell icon width (loses ligatures).

---

## ⚠️ Not in Repos — Workarounds

| Package | Void | Arch |
|---|---|---|
| brave | Flatpak: `com.brave.Browser` or AppImage | `brave-bin` AUR |
| obsidian | Flatpak: `md.obsidian.Obsidian` or AppImage | `obsidian` AUR |
| ventoy | Download from ventoy.net | `ventoy` AUR |
| mutt-wizard | Clone: github.com/LukeSmithXYZ/mutt-wizard | Clone: same |
| psi-notify | Build from source (Rust) | Build from source |
| quickserve | `pip install quickserve` or `python3 -m http.server` | same |

---

## 🔁 Runit Services (Void only)

| Service | sv name | Notes |
|---|---|---|
| dbus | `dbus` | required by nearly everything |
| elogind | `elogind` | session management |
| keyd | `keyd` | must start before login |
| NetworkManager | `NetworkManager` | replaces dhcpcd + wpa_supplicant post-bootstrap |
| sshd | `sshd` | |
| chronyd | `chronyd` | NTP time sync |
| acpid | `acpid` | power events |
| udevd | `udevd` | device events |
| udisks2 | `udisks2` | disk management |
| polkitd | `polkitd` | privilege escalation |
| cronie | `cronie` | cron jobs |
| bluetoothd | `bluetoothd` | bluetooth |
| tlp | `tlp` | power management |

> **pipewire / wireplumber** are user services — do not put in `/etc/sv/`. Start from `.zprofile` or user-level runit.

---

## 📦 Naming Traps — Quick Reference

Differences that will silently break install scripts:

| Package | Void | Arch |
|---|---|---|
| Emacs Wayland | `emacs-pgtk` | `emacs-wayland` |
| ImageMagick | `ImageMagick` (capital) | `imagemagick` |
| perl exiftool | `perl-Image-ExifTool` (capital) | `perl-image-exiftool` |
| Font Awesome | `font-awesome6` | `otf-font-awesome` |
| JetBrains Nerd | `font-jetbrains-mono-nerd-fonts` | `ttf-jetbrains-mono-nerd` |
| Nerd Fonts | `nerd-fonts` | `ttf-nerd-fonts-symbols` |
| wine | `wine` | `wine-staging` |
| freac | `freac` | `freac-bin` |
| libreoffice | `libreoffice` | `libreoffice-fresh` |
| wireplumber elogind | `wireplumber-elogind` (separate pkg) | included in `wireplumber` |
| alsa-pipewire | `alsa-pipewire` (separate pkg) | included in `pipewire` |
