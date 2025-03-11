check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_zypper "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		if [ $cmdoutput == 1 ]; then
			sudo zypper -n install "{name}" > /dev/null 2>&1
		else
			sudo zypper -n install "{name}"
		fi
	fi
else
	echo ":: Installing {name}..."
	if [ $cmdoutput == 1 ]; then
		sudo zypper -n install "{name}" > /dev/null 2>&1
	else
		sudo zypper -n install "{name}"
	fi
fi
