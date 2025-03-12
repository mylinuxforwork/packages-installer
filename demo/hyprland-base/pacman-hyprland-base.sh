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
_isInstalled_pacman() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0
    else
        echo 1
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
check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "hyprland") == 0 ]]; then
		echo ":: hyprland is already installed"
	else
		echo ":: Installing hyprland..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "hyprland" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "hyprland"
		fi
	fi
else
	echo ":: Installing hyprland..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "hyprland" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "hyprland"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "hyprland-qtutils") == 0 ]]; then
		echo ":: hyprland-qtutils is already installed"
	else
		echo ":: Installing hyprland-qtutils..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "hyprland-qtutils" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "hyprland-qtutils"
		fi
	fi
else
	echo ":: Installing hyprland-qtutils..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "hyprland-qtutils" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "hyprland-qtutils"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "hyprpaper") == 0 ]]; then
		echo ":: hyprpaper is already installed"
	else
		echo ":: Installing hyprpaper..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "hyprpaper" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "hyprpaper"
		fi
	fi
else
	echo ":: Installing hyprpaper..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "hyprpaper" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "hyprpaper"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "hyprlock") == 0 ]]; then
		echo ":: hyprlock is already installed"
	else
		echo ":: Installing hyprlock..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "hyprlock" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "hyprlock"
		fi
	fi
else
	echo ":: Installing hyprlock..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "hyprlock" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "hyprlock"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "hypridle") == 0 ]]; then
		echo ":: hypridle is already installed"
	else
		echo ":: Installing hypridle..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "hypridle" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "hypridle"
		fi
	fi
else
	echo ":: Installing hypridle..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "hypridle" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "hypridle"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "xdg-desktop-portal") == 0 ]]; then
		echo ":: xdg-desktop-portal is already installed"
	else
		echo ":: Installing xdg-desktop-portal..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "xdg-desktop-portal" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "xdg-desktop-portal"
		fi
	fi
else
	echo ":: Installing xdg-desktop-portal..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "xdg-desktop-portal" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "xdg-desktop-portal"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "libnotify") == 0 ]]; then
		echo ":: libnotify is already installed"
	else
		echo ":: Installing libnotify..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "libnotify" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "libnotify"
		fi
	fi
else
	echo ":: Installing libnotify..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "libnotify" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "libnotify"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "dunst") == 0 ]]; then
		echo ":: dunst is already installed"
	else
		echo ":: Installing dunst..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "dunst" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "dunst"
		fi
	fi
else
	echo ":: Installing dunst..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "dunst" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "dunst"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "wofi") == 0 ]]; then
		echo ":: wofi is already installed"
	else
		echo ":: Installing wofi..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "wofi" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "wofi"
		fi
	fi
else
	echo ":: Installing wofi..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "wofi" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "wofi"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "kitty") == 0 ]]; then
		echo ":: kitty is already installed"
	else
		echo ":: Installing kitty..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "kitty" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "kitty"
		fi
	fi
else
	echo ":: Installing kitty..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "kitty" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "kitty"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "qt5-wayland") == 0 ]]; then
		echo ":: qt5-wayland is already installed"
	else
		echo ":: Installing qt5-wayland..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "qt5-wayland" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "qt5-wayland"
		fi
	fi
else
	echo ":: Installing qt5-wayland..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "qt5-wayland" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "qt5-wayland"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "qt6-wayland") == 0 ]]; then
		echo ":: qt6-wayland is already installed"
	else
		echo ":: Installing qt6-wayland..."
		if [ $cmdoutput == 1 ]; then
			sudo pacman -S --needed --noconfirm "qt6-wayland" > /dev/null 2>&1
		else
			sudo pacman -S --needed --noconfirm "qt6-wayland"
		fi
	fi
else
	echo ":: Installing qt6-wayland..."
	if [ $cmdoutput == 1 ]; then
		sudo pacman -S --needed --noconfirm "qt6-wayland" > /dev/null 2>&1
	else
		sudo pacman -S --needed --noconfirm "qt6-wayland"
	fi
fi


_space

# Success Message
_sep
echo "DONE. Installation completed."
_sep