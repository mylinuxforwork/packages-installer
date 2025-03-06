#!/bin/bash
clear
_sep() {
	echo "----------------------------------------------------"
}

_space() {
	echo
}

# Header
_sep
echo "Hyprland Base Installation"
echo "Installation of the recommended core packages for Hyprland."
echo "Arch Linux"
_space
echo "Generated with Packages Installer Version 1.0"
_sep
_space

# Confirm Start
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            _space
            break
            ;;
        [Nn]*)
            echo ":: Installation canceled"
            exit
            break
            ;;
        *)
            echo ":: Please answer yes or no."
            ;;
    esac
done

# sudo permissions
sudo -v
_space

# Packages
sudo pacman -S --needed --noconfirm qt6-wayland
sudo pacman -S --needed --noconfirm qt5-wayland
sudo pacman -S --needed --noconfirm wofi
sudo pacman -S --needed --noconfirm kitty
sudo pacman -S --needed --noconfirm dunst
sudo pacman -S --needed --noconfirm libnotify
sudo pacman -S --needed --noconfirm xdg-desktop-portal-hyprland
sudo pacman -S --needed --noconfirm xdg-desktop-portal
sudo pacman -S --needed --noconfirm hypridle
sudo pacman -S --needed --noconfirm hyprlock
sudo pacman -S --needed --noconfirm hyprpaper
sudo pacman -S --needed --noconfirm hyprland

_space

# Success Message
_sep
echo "DONE. Installation completed."
_sep
