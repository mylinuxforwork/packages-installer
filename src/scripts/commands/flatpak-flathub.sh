check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_apt "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		flatpak -y install flathub {name} > /dev/null 2>&1
	fi
else
	echo ":: Installing {name}..."
	flatpak -y install flathub {name} > /dev/null 2>&1
fi
