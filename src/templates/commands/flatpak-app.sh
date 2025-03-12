check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_apt "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		if [ $cmdoutput == 1 ]; then
			flatpak -y install "{name}" > /dev/null 2>&1
		else
			flatpak -y install "{name}"
		fi
	fi
else
	echo ":: Installing {name}..."
	if [ $cmdoutput == 1 ]; then
		flatpak -y --reinstall install "{name}" > /dev/null 2>&1
	else
		flatpak -y --reinstall install "{name}"
	fi
fi
