# Load configuration file
_loadConfigurationFile "$pkginst_data_folder"

# Read Packages
pkg_list=$(_readPackages "$pkginst_data_folder")

# Install Application  Dependencies
for pkg in $pkg_list; do
    if [ -f "$pkginst_data_folder/$pkg_manager/$pkg" ]; then
        source "$pkginst_data_folder/$pkg_manager/$pkg"
    else
        _installPackage "$pkg"
    fi
done

