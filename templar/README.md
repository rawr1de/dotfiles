# Templar specific configs - Dell Raptor Lake, Intel UHD

_1._ Fresh Void install
_2._ Mount USB, copy keys to ~/.ssh/

**Without udiskie on a fresh install before packages are installed:**
``` bash
# find the device name
lsblk

# mount it
sudo mount /dev/sdX1 /mnt

# copy keys
cp /mnt/id_templar* ~/.ssh/

# unmount
sudo umount /mnt
```
Replace sdX1 with whatever lsblk shows for your USB.

_3._ Clone dotfiles via HTTPS

``` bash
sudo xbps-install -u xbps
sudo xbps-install -S git
git clone https://github.com/rawr1de/dotfiles ~/.dotfiles
```

_4._ Run SH_main.sh
_5._ After step 08, switch remote to SSH
``` bash
git remote set-url origin git@github.com:rawr1de/dotfiles.git             
```