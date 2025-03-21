# _isInstalledFlatpak {package}
_isInstalledFlatpak() {
	package="$1"
	check=$(flatpak info ${package})
	if [[ $check == *"ID:"* ]]; then
	  	echo 0
	else
		echo 1
	fi
}

# _installFlatpak {package}
_installFlatpak() {
    package="$1"
    if [[ $(_isInstalledFlatpak "${package}") == 0 ]]; then
        _echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
        _echo_success "${pkginst_lang["install_package"]} ${package}"
        flatpak -y install "${package}" &>>$(_getLogFile)
    fi
}

# _installFlatpakRemote {url} {package}
_installFlatpakRemote() {
    package="$1"
    url="$2"
    if [ ! -d $HOME/.cache ]; then
        mkdir -p $HOME/.cache
    fi
    wget -q -P "$HOME/.cache" "${url}"
    cd "$HOME/.cache"
    flatpak --user -y --reinstall install ${package} &>>$(_getLogFile)
    rm "$HOME/.cache/{name}"    
    _echo_success "${pkginst_lang["install_package"]} ${package}"
}

# _installFlatpakLocal {dir} {package}
_installFlatpakLocal() {
    dir="$1"
    package="$2"
    _echo_success "${pkginst_lang["install_package"]} ${package}"
    flatpak --user -y --reinstall install ${package}.flatpak &>>$(_getLogFile)
}

# _installFlatpakFlathub {package}
_installFlatpakFlathub() {
    package="$1"
    if [[ $(_isInstalledFlatpak "${package}") == 0 ]]; then
        _echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
        _echo_success "${pkginst_lang["install_package"]} ${package}"
        flatpak -y install flathub "${package}" &>>$(_getLogFile)
    fi
}