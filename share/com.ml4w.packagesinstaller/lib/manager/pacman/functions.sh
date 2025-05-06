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
    install_type="$3"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		_echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
        if [[ "$debug" == 0 ]]; then
            sudo pacman -S --needed --noconfirm "${package}"
        else
            sudo pacman -S --needed --noconfirm "${package}" &>>$(_getLogFile)
        fi
		_echo_success "${pkginst_lang["install_package"]} ${package} with pacman"
        if [ ! -z "$testcommand" ] && [ "$testcommand" != "null" ]; then
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
		_echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
		_echo_success "${pkginst_lang["install_package"]} ${package} with ${aur_helper}"
        if [[ "$debug" == 0 ]]; then
            ${aur_helper} -S --noconfirm "${package}"
        else
            ${aur_helper} -S --noconfirm "${package}" &>>$(_getLogFile)
        fi
        if [ ! -z "$testcommand" ] && [ "$testcommand" != "null" ]; then
            if [ $(_checkCommandExists "$testcommand") == 1 ]; then
                _echo_error "$testcommand ${pkginst_lang["command_check_failed"]}"
                pkginst_commanderrors+=($testcommand)
            fi
        fi           
	fi
}

# _installYay
_installYay() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git $pkginst_download_folder/yay
    cd $pkginst_download_folder/yay
    makepkg -si
    cd $temp_path
    _echo_success "${pkginst_lang["yay_installed"]}"
}

# _installParu
_installParu() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/paru.git $pkginst_download_folder/paru
    cd $pkginst_download_folder/paru
    makepkg -si
    cd $temp_path
    _echo_success "${pkginst_lang["paru_installed"]}"
}
