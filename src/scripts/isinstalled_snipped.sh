if [[ $(_isInstalled_{manager} "{name}") == 0 ]]; then
	echo ":: {name} is already installed"
else
	{command}
fi