#!/bin/bash
# Created with Packages Installer {version}
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
cmdoutput="/dev/null 2>&1"

# Options
while getopts y?h?o? option
do
    case "${option}"
        in
        y|\?)
	        assumeyes=0
        	;;
        o|\?)
	        cmdoutput="echo"
        	;;
        h|\?)
		echo "{greeting}"
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
{commands}
_space

# Success Message
_sep
echo "{successmessage}"
_sep