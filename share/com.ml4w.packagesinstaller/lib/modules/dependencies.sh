# Read Dependencies
if [ ! "$pkginst_manager" == "flatpak" ]; then
    _installPackages "$pkginst_script_dependencies/packages.json"
fi
