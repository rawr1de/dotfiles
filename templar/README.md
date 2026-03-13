# Templar specific configs - Dell Raptor Lake, Intel UHD

1. Fresh Void install
2. Mount USB, copy keys to ~/.ssh/
3. Clone dotfiles via HTTPS
4. Run SH_main.sh
5. After step 08, switch remote to SSH

## Without udiskie on a fresh install before packages are installed:

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