check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "true" ]; then
	if [[ $(_isInstalled_apt "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		eval 'sudo apt get "{name}" > $cmdoutput'
	fi
else
	echo ":: Installing {name}..."
	eval 'sudo apt get "{name}" > $cmdoutput'
fi
