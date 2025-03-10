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

# Variables
{variables}

# Is installed
{isinstalled}



# Header
_sep
echo "{title}"
echo "{description}"
_space
echo "{greeting}"
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
{commands}
_space

# Success Message
_sep
echo "{successmessage}"
_sep