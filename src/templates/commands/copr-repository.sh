if [ $cmdoutput == 1 ]; then
	sudo dnf copr enable --assumeyes "{name}" > /dev/null 2>&1
else
	sudo dnf copr enable --assumeyes "{name}"
fi
