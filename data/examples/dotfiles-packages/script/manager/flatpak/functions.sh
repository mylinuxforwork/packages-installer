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
        _echo "${package} ${pkginst_lang["package_already_installed"]}"
    else
        _echo "${pkginst_lang["install_package"]} ${package}"
        flatpak -y install "${package}" > /dev/null 2>&1
    fi
}

# _installFlatpakRemote {url} {package}
_installFlatpakRemote() {
    url="$1"
    package="$2"
    if [ ! -d $HOME/.cache ]; then
        mkdir -p $HOME/.cache
    fi
    wget -q -P "$HOME/.cache" "${url}"
    cd "$HOME/.cache"
    _echo "${pkginst_lang["install_package"]} ${package}"
    flatpak --user -y --reinstall install ${package} > /dev/null 2>&1
    rm "$HOME/.cache/{name}"    
}

# _installFlatpakLocal {dir} {package}
_installFlatpakLocal() {
    dir="$1"
    package="$2"
    _echo "${pkginst_lang["install_package"]} ${package}"
    flatpak --user -y --reinstall install ${package}.flatpak > /dev/null 2>&1
}

# _installFlatpakFlathub {package}
_installFlatpakFlathub() {
    package="$1"
    if [[ $(_isInstalledFlatpak "${package}") == 0 ]]; then
        _echo "${package} ${pkginst_lang["package_already_installed"]}"
    else
        _echo "${pkginst_lang["install_package"]} ${package}"
        flatpak -y install flathub "${package}" > /dev/null 2>&1
    fi
}