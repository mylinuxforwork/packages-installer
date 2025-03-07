if [[ $(_isInstalled_{manager} "{package}") == 0 ]]; then
	echo ":: {package} is already installed"
else
	{command}
fi