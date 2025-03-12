#!/bin/bash
# Created with Packages Installer 0.5
# https://github.com/mylinuxforwork/packages-installer

clear
# Seperator
_sep() {
	echo "----------------------------------------------------"
}

# Spacer
_space() {
	echo
}

# Default
assumeyes=1
cmdoutput=1

# Options
while getopts y?h?o? option
do
    case "${option}"
        in
        y|\?)
	        assumeyes=0
        	;;
        o|\?)
	        cmdoutput=0
        	;;
        h|\?)
		echo "Created with Packages Installer"
		echo
		echo "Usage:"
		echo "-y Skip confirmation"
		echo "-o Show installation command outputs"
		echo "-h Help"
		exit
        	;;
    esac
done

# Variables


# Is installed
_isInstalled_dnf() {
    package="$1"
    check=$(dnf list --installed | grep $package)
    if [ -z "$check" ]; then
        echo 1
    else
        echo 0
    fi
}
_isInstalled_flatpak() {
	package="$1"
	check=$(flatpak info ${package})
	if [[ $check == *"ID:"* ]]; then
	  	echo 0
	else
		echo 1
	fi
}

# Add flathub remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo > /dev/null 2>&1


# Header
_sep
echo "Hyprland Base Installation"
echo "Installation of the recommended base packages for Hyprland."
_space
echo "Created with Packages Installer"
_sep
_space
echo "IMPORTANT: Please make sure that your system is updated before starting the installation."
_space

# Confirm Start
if [ $assumeyes == 1 ]; then
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
fi

# sudo permissions
sudo -v
_space

# Packages
if [ $cmdoutput == 1 ]; then
	sudo dnf copr enable --assumeyes "solopasha/hyprland" > /dev/null 2>&1
else
	sudo dnf copr enable --assumeyes "solopasha/hyprland"
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "hyprland") == 0 ]]; then
		echo ":: hyprland is already installed"
	else
		echo ":: Installing hyprland..."
		sudo dnf install --assumeyes "hyprland" > /dev/null 2>&1
	fi
else
	echo ":: Installing hyprland..."
	sudo dnf install --assumeyes "hyprland" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "hyprland-qtutils") == 0 ]]; then
		echo ":: hyprland-qtutils is already installed"
	else
		echo ":: Installing hyprland-qtutils..."
		sudo dnf install --assumeyes "hyprland-qtutils" > /dev/null 2>&1
	fi
else
	echo ":: Installing hyprland-qtutils..."
	sudo dnf install --assumeyes "hyprland-qtutils" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "hyprpaper") == 0 ]]; then
		echo ":: hyprpaper is already installed"
	else
		echo ":: Installing hyprpaper..."
		sudo dnf install --assumeyes "hyprpaper" > /dev/null 2>&1
	fi
else
	echo ":: Installing hyprpaper..."
	sudo dnf install --assumeyes "hyprpaper" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "hyprlock") == 0 ]]; then
		echo ":: hyprlock is already installed"
	else
		echo ":: Installing hyprlock..."
		sudo dnf install --assumeyes "hyprlock" > /dev/null 2>&1
	fi
else
	echo ":: Installing hyprlock..."
	sudo dnf install --assumeyes "hyprlock" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "hypridle") == 0 ]]; then
		echo ":: hypridle is already installed"
	else
		echo ":: Installing hypridle..."
		sudo dnf install --assumeyes "hypridle" > /dev/null 2>&1
	fi
else
	echo ":: Installing hypridle..."
	sudo dnf install --assumeyes "hypridle" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "xdg-desktop-portal") == 0 ]]; then
		echo ":: xdg-desktop-portal is already installed"
	else
		echo ":: Installing xdg-desktop-portal..."
		sudo dnf install --assumeyes "xdg-desktop-portal" > /dev/null 2>&1
	fi
else
	echo ":: Installing xdg-desktop-portal..."
	sudo dnf install --assumeyes "xdg-desktop-portal" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "libnotify") == 0 ]]; then
		echo ":: libnotify is already installed"
	else
		echo ":: Installing libnotify..."
		sudo dnf install --assumeyes "libnotify" > /dev/null 2>&1
	fi
else
	echo ":: Installing libnotify..."
	sudo dnf install --assumeyes "libnotify" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "dunst") == 0 ]]; then
		echo ":: dunst is already installed"
	else
		echo ":: Installing dunst..."
		sudo dnf install --assumeyes "dunst" > /dev/null 2>&1
	fi
else
	echo ":: Installing dunst..."
	sudo dnf install --assumeyes "dunst" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "wofi") == 0 ]]; then
		echo ":: wofi is already installed"
	else
		echo ":: Installing wofi..."
		sudo dnf install --assumeyes "wofi" > /dev/null 2>&1
	fi
else
	echo ":: Installing wofi..."
	sudo dnf install --assumeyes "wofi" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "kitty") == 0 ]]; then
		echo ":: kitty is already installed"
	else
		echo ":: Installing kitty..."
		sudo dnf install --assumeyes "kitty" > /dev/null 2>&1
	fi
else
	echo ":: Installing kitty..."
	sudo dnf install --assumeyes "kitty" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "qt5-wayland") == 0 ]]; then
		echo ":: qt5-wayland is already installed"
	else
		echo ":: Installing qt5-wayland..."
		sudo dnf install --assumeyes "qt5-wayland" > /dev/null 2>&1
	fi
else
	echo ":: Installing qt5-wayland..."
	sudo dnf install --assumeyes "qt5-wayland" > /dev/null 2>&1
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "qt6-wayland") == 0 ]]; then
		echo ":: qt6-wayland is already installed"
	else
		echo ":: Installing qt6-wayland..."
		sudo dnf install --assumeyes "qt6-wayland" > /dev/null 2>&1
	fi
else
	echo ":: Installing qt6-wayland..."
	sudo dnf install --assumeyes "qt6-wayland" > /dev/null 2>&1
fi


_space

# Success Message
_sep
echo "DONE. Installation completed."
_sep