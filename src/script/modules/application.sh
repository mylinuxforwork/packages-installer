# Source Library
pkginst_version="0.5"

source "$pkginst_script_folder/lib/library.sh"

# Source Global Variables
_sourceFilesInFolder "$pkginst_script_folder/global"

# Load Language File
pkginstall_language="en"
source "$pkginst_script_folder/lang/$pkginstall_language.sh"

# Package Manager
pkg_manager="pacman"

# Source Package Manager Folder
_sourceFilesInFolder "$pkginst_script_folder/manager/$pkg_manager"

# Assume Yes
assumeyes=1

while getopts "s:yvh" opt; do
    case $opt in
        s)
            # Get pkginst source
            pkginst_data_folder="$OPTARG"
            ;;
        y)
            # Set Assume Yes
            assumeyes=0
            ;;
        v)
            echo
            echo ":: Packages Installer $pkginst_version"
            echo ":: https://github.com/mylinuxforwork/packages-installer"
            exit
            ;;

        h)
            echo
            echo ":: Packages Installer $pkginst_version"
            echo ":: https://github.com/mylinuxforwork/packages-installer"
            echo
            echo "-s Define the installation source"
            echo "   - Url to .pkginst file e.g., https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/packages.pkginst"
            echo "   - Path to local pkginst folder e.g., \$HOME/Documents/packages/pkginst"
            echo "-y AssumeYes for confirmation of the installation"
            exit
            ;;
    esac
done

# Prepare the pkginst folder
if [[ "$pkginst_data_folder" == *"https"* ]]; then
    pkginst_package_name=$(basename "$pkginst_data_folder")
    rm -rf "$HOME/.cache/pkginst"
    wget -q -P "$HOME/.cache/pkginst" "$pkginst_data_folder"
    unzip -qq "$HOME/.cache/pkginst/$pkginst_package_name" -d "$HOME/.cache/pkginst"
    if [ ! -d "$HOME/.cache/pkginst/pkginst" ]; then
        echo "ERROR: Downloaded file doesn't include a pkginst folder."
        exit
    fi
    rm "$HOME/.cache/pkginst/$pkginst_package_name"
    mv "$HOME/.cache/pkginst/pkginst" "$HOME/.cache/pkginst/$pkginst_package_name" 
    pkginst_data_folder="$HOME/.cache/pkginst/$pkginst_package_name"
else
    if [ ! -d $pkginst_data_folder ]; then
        echo "ERROR: No such directory"
        exit
    fi
fi
