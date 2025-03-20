# Source Library
source "$pkginst_script_folder/lib/library.sh"

# Source Global Variables
_sourceFilesInFolder "$pkginst_script_folder/global"

# Load Language File
pkginst_language="en"
source "$pkginst_script_folder/lang/$pkginst_language.sh"

# Package Manager
pkginst_manager=""

# Assume Yes
assumeyes=1

# Assume Yes
aur_helper="yay"

# CommandErrorList
pkginst_commanderrors=()

if [ ! -d $pkginst_download_folder ]; then
    mkdir -p $pkginst_download_folder
fi

if [ ! -d $pkginst_log_folder ]; then
    mkdir -p $pkginst_log_folder
fi



while getopts "a:p:iyvh" opt; do
    case $opt in
        i)
            _showAllPackages
            exit
            ;;
        a)
            aur_helper=${OPTARG}
            ;;
        p)
            pkginst_manager=${OPTARG}
            ;;
        y)
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
            echo "-p Package Manager (supported are apt,dnf,pacman+aurhelper,zypper)"
            echo "-y Assume yes for confirmation of the installation"
            echo "-a Aur Helper for Arch only"
            echo "-i Show packages to be installed"
            echo "-h Help"
            exit
            ;;
    esac
done

