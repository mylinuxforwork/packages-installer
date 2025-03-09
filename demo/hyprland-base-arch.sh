#!/bin/bash
clear
# Seperator
_sep() {
	echo "----------------------------------------------------"
}

# Spacer
_space() {
	echo
}

# Is Package already installed
_isInstalled() {
    package="$1"
    case $install_platform in
        arch)
            check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
            echo "${check}"
            if [ -n "${check}" ]; then
                echo 0
            else
                echo 1
            fi
            ;;
        fedora)
            check=$(dnf list --installed | grep $package)
            if [ -z "$check" ]; then
                echo 1
            else
                echo 0
            fi
            ;;
        *)
            echo 1
            ;;
    esac
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
echo "IMPORTANT: Please make sure that your system is updated before starting the installation."
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
echo $(_isInstalled "kitty")

# if [[ $(_isInstalled "hyprland") == "1" ]]; then
#     sudo pacman -S --needed --noconfirm hyprland
# else
#     echo ":: hyprland is already installed"
# fi

_space

# Success Message
_sep
echo "DONE. Installation completed."
_sep