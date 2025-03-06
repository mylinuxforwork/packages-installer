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

# Header
_sep
echo "{title}"
echo "{description}"
echo "{distribution}"
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
{packages}
_space

# Success Message
_sep
echo "{successmessage}"
_sep