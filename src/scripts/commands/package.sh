[COMMAND]
check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_apt "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		sudo apt get "{name}" > /dev/null 2>&1
	fi
else
	echo ":: Installing {name}..."
	sudo apt get "{name}" > /dev/null 2>&1
fi

[COMMAND]
check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_dnf "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		sudo dnf install --assumeyes "{name}" > /dev/null 2>&1
	fi
else
	echo ":: Installing {name}..."
	sudo dnf install "{name}" > /dev/null 2>&1
fi

[COMMAND]
check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_pacman "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		sudo pacman -S --needed --noconfirm "{name}" > /dev/null 2>&1
	fi
else
	echo ":: Installing {name}..."
	sudo pacman -S --needed --noconfirm "{name}" > /dev/null 2>&1
fi

[COMMAND]
check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_zypper "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		sudo zypper install "{name}" > /dev/null 2>&1
	fi
else
	echo ":: Installing {name}..."
	sudo zypper install "{name}" > /dev/null 2>&1
fi
