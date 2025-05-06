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
	testcommand="$2"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		_echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
		_echo_success "${pkginst_lang["install_package"]} ${package} with zypper"
        if [[ "$debug" == 0 ]]; then
            sudo zypper -n install "${package}"
        else
            sudo zypper -n install "${package}" &>>$(_getLogFile)
        fi
        if [ ! -z "$testcommand" ] && [ "$testcommand" != "null" ]; then
            if [ $(_checkCommandExists "$testcommand") == 1 ]; then
                _echo_error "$testcommand ${pkginst_lang["command_check_failed"]}"
                pkginst_commanderrors+=($testcommand)
            fi
        fi   		
	fi
}