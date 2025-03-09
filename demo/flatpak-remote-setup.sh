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

# Is installed
_isInstalled_flatpak() {
	package="$1"
	check=$(flatpak info ${package})
	if [[ $check == *"ID:"* ]]; then
	  	echo 0
	else
		echo 1
	fi
}

_space

# Header
_sep
echo "Flatpak Setup"
echo "Installation script for remote Flatpak Apps"
echo "All Distributions"
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
if [[ $(_isInstalled_flatpak "org.gnome.Platform/x86_64/47") == 0 ]]; then
	echo ":: org.gnome.Platform/x86_64/47 is already installed"
else
	sudo flatpak -y install org.gnome.Platform/x86_64/47
fi
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo ":: Downloading com.ml4w.packagesinstaller.flatpak"
wget -q -P "$HOME/.cache" "https://github.com/mylinuxforwork/packages-installer/releases/latest/download/com.ml4w.packagesinstaller.flatpak"
cd "$HOME/.cache"
echo ":: Installing com.ml4w.packagesinstaller.flatpak"
flatpak --user -y --reinstall install com.ml4w.packagesinstaller.flatpak > /dev/null 2>&1

_space

# Success Message
_sep
echo "DONE! Flatpak App installed successfully"
_sep