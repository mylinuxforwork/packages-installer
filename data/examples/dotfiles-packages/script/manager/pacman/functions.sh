# _isInstalled {package}
_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0
    else
        echo 1
    fi
}

# _installPackage {package}
_installPackage() {
    package="$1"
    testcommand="$2"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		_echo "${package} ${pkginst_lang["package_already_installed"]}"
    else
		_echo "${pkginst_lang["install_package"]} ${package}"
        sudo pacman -S --needed --noconfirm "${package}" > /dev/null 2>&1
        if [ ! -z $testcommand ]; then
            if [ $(_checkCommandExists "$testcommand") == 1 ]; then
                _echo_error "$testcommand ${pkginst_lang["command_check_failed"]}"
                pkginst_commanderrors+=($testcommand)
            fi
        fi        
	fi
}

# _installPackageAur {package}
_installPackageAur() {
    package="$1"
    testcommand="$2"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		_echo "${package} ${pkginst_lang["package_already_installed"]}"
    else
		_echo "${pkginst_lang["install_package"]} ${package}"
        ${aur_helper} -S --noconfirm "${package}" > /dev/null 2>&1
        if [ ! -z $testcommand ]; then
            if [ $(_checkCommandExists "$testcommand") == 1 ]; then
                _echo_error "$testcommand ${pkginst_lang["command_check_failed"]}"
                pkginst_commanderrors+=($testcommand)
            fi
        fi           
	fi
}