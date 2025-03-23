if [ -z $pkginst_manager ]; then
    _selectManager
fi

# Source Package Manager Folder
_sourceFilesInFolder "$pkginst_script_folder/manager/$pkginst_manager"

# Source Flatpak Folder
_sourceFilesInFolder "$pkginst_script_folder/manager/flatpak"
