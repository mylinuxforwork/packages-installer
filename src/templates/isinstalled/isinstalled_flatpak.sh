_isInstalled_flatpak() {
	package="$1"
	check=$(flatpak info ${package})
	if [[ $check == *"ID:"* ]]; then
	  	echo 0
	else
		echo 1
	fi
}

# Add flathub remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo > /dev/null 2>&1
