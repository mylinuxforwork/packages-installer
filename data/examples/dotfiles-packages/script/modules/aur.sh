if [ $pkginst_manager = "pacman" ]; then

    yay_installed="false"
    paru_installed="false"
    aur_helper=""

    _selectAURHelper() {
        _writeModuleHeadline "AUR Helper"
        _echo "${pkginst_lang["select_aur_helper"]}"
        echo
        aur_helper=$(gum choose "yay" "paru")
        if [ -z $aur_helper ]; then
            _selectAURHelper
        fi
        _echo "$aur_helper ${pkginst_lang["aur_helper_selected"]}"
        echo
    }

    _checkAURHelper() {
        if [[ $(_checkCommandExists "yay") == "0" ]]; then
            yay_installed="true"
        fi
        if [[ $(_checkCommandExists "paru") == "0" ]]; then
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
