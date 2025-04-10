# _isInstalledFlatpak {package}
_isInstalledFlatpak() {
	package="$1"
	check=$(flatpak list --app)
    if [[ $check = *"$package"* ]]; then
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
        _echo_success "${pkginst_lang["install_package"]} ${package} with flatpak"
        flatpak -y install "${package}" &>>$(_getLogFile)
    fi
}

# _installFlatpakRemote {package} {url} 
_installFlatpakRemote() {
    package="$1"
    url="$2"
    _echo_success "${pkginst_lang["install_package"]} ${package} with flatpak/remote"
    if [ ! -d $HOME/.cache ]; then
        mkdir -p $HOME/.cache
    fi
    if [ -f "$HOME/.cache/${package}.flatpak" ]; then
        rm "$HOME/.cache/${package}.flatpak"
    fi
    wget -q -P "$HOME/.cache" "${url}"
    cd "$HOME/.cache"
    flatpak --user -y --reinstall install ${package}.flatpak &>>$(_getLogFile)
    rm "$HOME/.cache/${package}.flatpak"    
    cd "$pkginst_script_directory"
}

# _installFlatpakLocal {dir} {package}
_installFlatpakLocal() {
    package="$1"
    dir="$2"
    _echo_success "${pkginst_lang["install_package"]} ${package} with flatpak/local"
    flatpak --user -y --reinstall install ${package}.flatpak &>>$(_getLogFile)
}

# _installFlatpakFlathub {package}
_installFlatpakFlathub() {
    package="$1"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &>>$(_getLogFile)
    if [[ $(_isInstalledFlatpak "${package}") == 0 ]]; then
        _echo_success "${package} ${pkginst_lang["package_already_installed"]}"
    else
        _echo_success "${pkginst_lang["install_package"]} ${package} with flatpak/flathub"
        flatpak -y install flathub "${package}" &>>$(_getLogFile)
    fi
}