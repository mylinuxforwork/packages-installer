check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_pacman "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		if [ $cmdoutput == 1 ]; then
			paru -S --needed --noconfirm {name} > /dev/null 2>&1
		else
			paru -S --needed --noconfirm {name}
		fi
	fi
else
	echo ":: Installing {name}..."
	if [ $cmdoutput == 1 ]; then
		paru -S --needed --noconfirm {name} > /dev/null 2>&1
	else
		paru -S --needed --noconfirm {name}
	fi
fi
