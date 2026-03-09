#!/bin/bash

# 1. Fix Keyring and Update (Crucial for fresh ISOs)
echo "Fixing GPG keyrings..."
sudo pacman -Sy archlinux-keyring manjaro-keyring --noconfirm
sudo pacman-key --init && sudo pacman-key --populate archlinux manjaro

# 2. Bootstrap Yay (AUR Helper)
# Manjaro includes 'base-devel' by default, but we ensure it's there.
echo "Installing Yay..."
sudo pacman -S --needed base-devel git --noconfirm
git clone https://aur.archlinux.org/yay.git ~/.tmp/yay
cd ~/.tmp/yay && makepkg -si --noconfirm
cd ~ && rm -rf .tmp/
