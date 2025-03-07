_isinstalled_flatpak() {
	package="$1"
	check=$(flatpak info ${package})
	if [[ $check == *"ID:"* ]]; then
	  	echo 0
	else
		echo 1
	fi
}