# Read Dependencies
if [ ! "$pkginst_manager" == "flatpak" ]; then
    if [ $(_checkCommandExists "pacman") == "0" ]; then
        pkginst_manager="pacman"
    elif [ $(_checkCommandExists "apt") == "0" ]; then
        pkginst_manager="apt"
    elif [ $(_checkCommandExists "zypper") == "0" ]; then
        pkginst_manager="zypper"
    elif [ $(_checkCommandExists "dnf") == "0" ]; then
        pkginst_manager="dnf"
    fi   

    # Source Package Manager Folder
    _sourceFilesInFolder "$pkginst_script_folder/manager/$pkginst_manager"

    _installPackages "$pkginst_script_dependencies/packages.json"
fi

# Source Flatpak Folder
_sourceFilesInFolder "$pkginst_script_folder/manager/flatpak"
