# _isInstalled {package}
_isInstalled() {
    package="$1"
    package_info=$(zypper se -i "$package" 2>/dev/null | grep "^i" | awk '{print $3}')
    ret=1
    for pkg in $package_info
    do
	if [ "$package" == "$pkg" ]; then
		ret=0
		break
	fi
	done
	echo $ret
}

# _installPackage {package}
_installPackage() {
    package="$1"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		_echo "${package} ${pkginst_lang["package_already_installed"]}"
    else
		_echo "${pkginst_lang["install_package"]} ${package}"
        sudo zypper -n install "${package}" > /dev/null 2>&1
	fi
}