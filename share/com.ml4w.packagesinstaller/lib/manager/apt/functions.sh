# _isInstalled {package}
_isInstalled() {
    package="$1"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $package|grep "install ok installed")
	if [ "" = "$PKG_OK" ]; then
		echo 1
	else
		echo 0
	fi
}

# _installPackage {package}
_installPackage() {
    package="$1"
	testcommand="$2"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		_echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
		_echo_success "${pkginst_lang["install_package"]} ${package} with apt"
        if [[ "$debug" == 0 ]]; then
	        sudo apt-get -y install "${package}"
		else
	        sudo apt-get -y install "${package}" &>>$(_getLogFile)
		fi
        if [ ! -z $testcommand ]; then
            if [ $(_checkCommandExists "$testcommand") == 1 ]; then
                _echo_error "$testcommand ${pkginst_lang["command_check_failed"]}"
                pkginst_commanderrors+=($testcommand)
            fi
        fi   
	fi
}