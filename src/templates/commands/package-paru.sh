check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_pacman "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		eval 'paru -S --needed --noconfirm {name} > $cmdoutput'
	fi
else
	echo ":: Installing {name}..."
	eval 'paru -S --needed --noconfirm {name} > $cmdoutput'
fi
