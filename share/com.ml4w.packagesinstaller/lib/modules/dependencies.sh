# Source Flatpak Folder
_sourceFilesInFolder "$pkginst_script_folder/manager/flatpak"

# Read Dependencies
if [ ! "$pkginst_manager" == "flatpak" ]; then
    # Source Package Manager Folder
    _sourceFilesInFolder "$pkginst_script_folder/manager/$pkginst_manager"
    _installPackages "$pkginst_script_dependencies/packages.json"
fi
