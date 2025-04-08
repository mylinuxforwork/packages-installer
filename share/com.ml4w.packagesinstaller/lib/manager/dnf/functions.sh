# _isInstalled {package}
_isInstalled() {
    package="$1"
    check=$(dnf list --installed | grep $package)
    if [ -z "$check" ]; then
        echo 1
    else
        echo 0
    fi
}

# _addCoprRepository {repository}
_addCoprRepository() {
    repository="$1"
    _echo_success "${pkginst_lang["add_copr_repository"]} ${repository}"
    sudo dnf copr enable --assumeyes "${repository}" &>>$(_getLogFile)
}

# _installPackage {package}
_installPackage() {
    package="$1"
    testcommand="$2"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		_echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
		_echo_success "${pkginst_lang["install_package"]} ${package} with dnf"
        sudo dnf install --assumeyes "${package}" &>>$(_getLogFile)
        if [ ! -z $testcommand ]; then
            if [ $(_checkCommandExists "$testcommand") == 1 ]; then
                _echo_error "$testcommand ${pkginst_lang["command_check_failed"]}"
                pkginst_commanderrors+=($testcommand)
            fi
        fi          
	fi
}