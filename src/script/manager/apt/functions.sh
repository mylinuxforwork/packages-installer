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
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		echo "${package} ${pkginst_lang["package_already_installed"]}"
    else
		echo "${pkginst_lang["install_package"]} ${package}"
        sudo apt-get -y install "${package}" > /dev/null 2>&1
	fi
}