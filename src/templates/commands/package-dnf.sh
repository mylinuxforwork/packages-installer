check_isinstalled="{isinstalled}"
if [ $check_isinstalled == "True" ]; then
	if [[ $(_isInstalled_dnf "{name}") == 0 ]]; then
		echo ":: {name} is already installed"
	else
		echo ":: Installing {name}..."
		sudo dnf install --assumeyes "{name}" > /dev/null 2>&1
	fi
else
	echo ":: Installing {name}..."
	sudo dnf install --assumeyes "{name}" > /dev/null 2>&1
fi
