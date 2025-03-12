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
_isInstalled_zypper() {
    package="$1"
    package_info=$(zypper se -i "$package" 2>/dev/null | grep "^i" | awk '{print $3}')
    ret=1
    for pkg in $package_info
    do
	if [ "$package" == "$pkg" ]; then
		ret=0
		break
	fi
	done
	echo $ret
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
	if [[ $(_isInstalled_zypper "hyprland") == 0 ]]; then
		echo ":: hyprland is already installed"
	else
		echo ":: Installing hyprland..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "hyprland" > /dev/null 2>&1
		else
			sudo zypper -n install "hyprland"
		fi
	fi
else
	echo ":: Installing hyprland..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "hyprland" > /dev/null 2>&1
	else
		sudo zypper -n install "hyprland"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "hyprland-qtutils") == 0 ]]; then
		echo ":: hyprland-qtutils is already installed"
	else
		echo ":: Installing hyprland-qtutils..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "hyprland-qtutils" > /dev/null 2>&1
		else
			sudo zypper -n install "hyprland-qtutils"
		fi
	fi
else
	echo ":: Installing hyprland-qtutils..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "hyprland-qtutils" > /dev/null 2>&1
	else
		sudo zypper -n install "hyprland-qtutils"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "hyprpaper") == 0 ]]; then
		echo ":: hyprpaper is already installed"
	else
		echo ":: Installing hyprpaper..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "hyprpaper" > /dev/null 2>&1
		else
			sudo zypper -n install "hyprpaper"
		fi
	fi
else
	echo ":: Installing hyprpaper..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "hyprpaper" > /dev/null 2>&1
	else
		sudo zypper -n install "hyprpaper"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "hyprlock") == 0 ]]; then
		echo ":: hyprlock is already installed"
	else
		echo ":: Installing hyprlock..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "hyprlock" > /dev/null 2>&1
		else
			sudo zypper -n install "hyprlock"
		fi
	fi
else
	echo ":: Installing hyprlock..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "hyprlock" > /dev/null 2>&1
	else
		sudo zypper -n install "hyprlock"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "hypridle") == 0 ]]; then
		echo ":: hypridle is already installed"
	else
		echo ":: Installing hypridle..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "hypridle" > /dev/null 2>&1
		else
			sudo zypper -n install "hypridle"
		fi
	fi
else
	echo ":: Installing hypridle..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "hypridle" > /dev/null 2>&1
	else
		sudo zypper -n install "hypridle"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "xdg-desktop-portal") == 0 ]]; then
		echo ":: xdg-desktop-portal is already installed"
	else
		echo ":: Installing xdg-desktop-portal..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "xdg-desktop-portal" > /dev/null 2>&1
		else
			sudo zypper -n install "xdg-desktop-portal"
		fi
	fi
else
	echo ":: Installing xdg-desktop-portal..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "xdg-desktop-portal" > /dev/null 2>&1
	else
		sudo zypper -n install "xdg-desktop-portal"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "libnotify") == 0 ]]; then
		echo ":: libnotify is already installed"
	else
		echo ":: Installing libnotify..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "libnotify" > /dev/null 2>&1
		else
			sudo zypper -n install "libnotify"
		fi
	fi
else
	echo ":: Installing libnotify..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "libnotify" > /dev/null 2>&1
	else
		sudo zypper -n install "libnotify"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "dunst") == 0 ]]; then
		echo ":: dunst is already installed"
	else
		echo ":: Installing dunst..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "dunst" > /dev/null 2>&1
		else
			sudo zypper -n install "dunst"
		fi
	fi
else
	echo ":: Installing dunst..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "dunst" > /dev/null 2>&1
	else
		sudo zypper -n install "dunst"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "wofi") == 0 ]]; then
		echo ":: wofi is already installed"
	else
		echo ":: Installing wofi..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "wofi" > /dev/null 2>&1
		else
			sudo zypper -n install "wofi"
		fi
	fi
else
	echo ":: Installing wofi..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "wofi" > /dev/null 2>&1
	else
		sudo zypper -n install "wofi"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "kitty") == 0 ]]; then
		echo ":: kitty is already installed"
	else
		echo ":: Installing kitty..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "kitty" > /dev/null 2>&1
		else
			sudo zypper -n install "kitty"
		fi
	fi
else
	echo ":: Installing kitty..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "kitty" > /dev/null 2>&1
	else
		sudo zypper -n install "kitty"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "qt5-wayland") == 0 ]]; then
		echo ":: qt5-wayland is already installed"
	else
		echo ":: Installing qt5-wayland..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "qt5-wayland" > /dev/null 2>&1
		else
			sudo zypper -n install "qt5-wayland"
		fi
	fi
else
	echo ":: Installing qt5-wayland..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "qt5-wayland" > /dev/null 2>&1
	else
		sudo zypper -n install "qt5-wayland"
	fi
fi

check_isinstalled="True"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "qt6-wayland") == 0 ]]; then
		echo ":: qt6-wayland is already installed"
	else
		echo ":: Installing qt6-wayland..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "qt6-wayland" > /dev/null 2>&1
		else
			sudo zypper -n install "qt6-wayland"
		fi
	fi
else
	echo ":: Installing qt6-wayland..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "qt6-wayland" > /dev/null 2>&1
	else
		sudo zypper -n install "qt6-wayland"
	fi
fi


_space

# Success Message
_sep
echo "DONE. Installation completed."
_sep