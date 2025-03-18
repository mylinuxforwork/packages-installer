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
    _echo "${pkginst_lang["add_copr_repository"]} ${repository}"
    sudo dnf copr enable --assumeyes "${repository}" > /dev/null 2>&1
}

# _installPackage {package}
_installPackage() {
    package="$1"
	if [[ $(_isInstalled "${package}") == 0 ]]; then
		echo "${package} ${pkginst_lang["package_already_installed"]}"
    else
		echo "${pkginst_lang["install_package"]} ${package}"
        sudo dnf install --assumeyes "${package}" > /dev/null 2>&1
	fi
}