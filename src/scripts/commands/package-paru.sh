check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_pacman "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		paru -S --needed --noconfirm {name} > /dev/null 2>&1
	fi
else
	echo ":: Installing {name}..."
	paru -S --needed --noconfirm {name} > /dev/null 2>&1
fi
