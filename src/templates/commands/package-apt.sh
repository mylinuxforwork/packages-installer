check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_apt "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		if [ $cmdoutput == 0 ]; then
			sudo apt-get -y install "{name}" > /dev/null 2>&1
		else
			sudo apt-get -y install "{name}"
		fi
	fi
else
	echo ":: Installing {name}..."
	if [ $cmdoutput == 0 ]; then
		sudo apt-get -y install "{name}" > /dev/null 2>&1
	else
		sudo apt-get -y install "{name}"
	fi
fi
