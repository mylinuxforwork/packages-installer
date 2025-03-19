if [ $pkginst_manager = "pacman" ]; then

    yay_installed="false"
    paru_installed="false"
    aur_helper=""

    _installYay() {
        _installPackages "base-devel"
        SCRIPT=$(realpath "$0")
        temp_path=$(dirname "$SCRIPT")
        git clone https://aur.archlinux.org/yay.git $pkginst_download_folder/yay
        cd $pkginst_download_folder/yay
        makepkg -si
        cd $temp_path
        _echo "yay has been installed successfully."
    }

    _installParu() {
        _installPackages "base-devel"
        SCRIPT=$(realpath "$0")
        temp_path=$(dirname "$SCRIPT")
        git clone https://aur.archlinux.org/paru.git $pkginst_download_folder/paru
        cd $pkginst_download_folder/paru
        makepkg -si
        cd $temp_path
        _echo "paru has been installed successfully."
    }

    _selectAURHelper() {
        _writeModuleHeadline "AUR Helper"
        _echo "Please select your preferred AUR Helper"
        echo
        aur_helper=$(gum choose "yay" "paru")
        if [ -z $aur_helper ]; then
            _selectAURHelper
        fi
        _echo 0 "Using $aur_helper as AUR Helper"
    }

    _checkAURHelper() {
        if _checkCommandExists "yay"; then
            yay_installed="true"
        fi
        if _checkCommandExists "paru"; then
            paru_installed="true"
        fi
        if [[ $yay_installed == "true" ]] && [[ $paru_installed == "false" ]]; then
            aur_helper="yay"
        elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "true" ]]; then
            aur_helper="paru"
        elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "false" ]]; then
            if [[ $(_check_update) == "false" ]]; then
                _selectAURHelper
                if [[ $aur_helper == "yay" ]]; then
                    _installYay
                else
                    _installParu
                fi
            fi
        else
            _selectAURHelper
        fi
    }

    _checkAURHelper
fi
