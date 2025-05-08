# _echo {output}
_echo() {
    output="$1"
    echo "${echo_prefix}${output}"
}

# _echo_error {output}
_echo_error() {
    output="$1"
    echo "${echo_prefix_error}${output}"
}

# _echo_success {output}
_echo_success() {
    output="$1"
    printf '\u2714\ufe0e' 
    echo " ${output}"
}

# _sourceFilesInFolder {folder}
_sourceFilesInFolder() {
    folder="$1"
    if [ -d $folder ]; then
        for f in $(ls "$folder"); do 
            source "$folder/$f"
        done
    fi
}

# _sourceFile {file}
_sourceFile() {
    file="$1"
    if [ -f "$file" ]; then
        source "$file"
    fi
}

# _loadConfigurationFile {file}
_getConfiguration() {
    conf_key="$1"
    if [[ $(jq -r .$conf_key $pkginst_data_folder/config.json) != "null" ]]; then
        echo $(jq -r .$conf_key $pkginst_data_folder/config.json)
    else
        echo ""
    fi
}

# _writeModuleHeadline {headline}
_writeModuleHeadline() {
    headline="$1"
    if [ -f "$pkginst_data_folder/templates/moduleheader.sh" ]; then
        source "$pkginst_data_folder/templates/moduleheader.sh"
    else
        source "$pkginst_script_folder/templates/moduleheader.sh"
    fi    
}

# _showAllPackages
_showAllPackages() {
    _echo "${pkginst_lang["show_all_packages_message"]}"
    echo
    _echo "Dependencies ($(jq -r '.packages | length' $pkginst_script_dependencies/packages.json)):"
    for pkg in $(jq -r '.packages[] | .package' $pkginst_script_dependencies/packages.json); do
        _echo_success ${pkg}
    done
    echo    
    _echo "Packages ($(jq -r '.packages | length' $pkginst_data_folder/packages.json)):"
    for pkg in $(jq -r '.packages[] | .package' $pkginst_data_folder/packages.json); do
        _echo_success ${pkg}
    done    
    echo
}

# _showAllPackagesDialog
_showAllPackagesDialog() {
    _showAllPackages
    echo
    _selectManager
}

# _getNumberOfPackages
_getNumberOfPackages() {
    echo "$(jq -r '.packages | length' $pkginst_data_folder/packages.json)"
}

# _installFlatpakPkg {row}
_installFlatpakPkg() {
    row="$1"
    pkg_flatpak=$(echo $row | jq -r '.flatpak')
    pkg_flatpaktype=$(echo $row | jq -r '.flatpaktype')
    pkg_flatpakremoteurl=$(echo $row | jq -r '.flatpakremoteurl')
    pkg_flatpaklocaldir=$(echo $row | jq -r '.flatpaklocaldir')
    if [[ ! "$pkg_flatpak" == "null" ]]; then
        pkg="$pkg_flatpak"
    fi                 
    if [[ ! "$pkg_flatpaktype" == "null" ]]; then
        case $pkg_flatpaktype in
            "flatpak")
                _installFlatpak "$pkg"
            ;;
            "remote")
                if [[ ! "$pkg_flatpakremoteurl" == "null" ]]; then
                _installFlatpakRemote "$pkg" "$pkg_flatpakremoteurl"
                else
                    break
                fi
            ;;
            "local")
                if [[ ! "$pkg_flatpaklocaldir" == "null" ]]; then
                _installFlatpakLocal "$pkg" "$pkg_flatpaklocaldir"
                else
                    break
                fi
            ;;
            "flathub")
                _installFlatpakFlathub "$pkg"
            ;;
        esac
    else
        _installFlatpakFlathub "$pkg"
    fi        
}

# _installPipPkg {row}
_installPipPkg() {
    row="$1"
    pkg_pip=$(echo $row | jq -r '.pip')
    if [[ ! "$pkg_pip" == "null" ]]; then
        pkg="$pkg_pip"
    fi                 
    if [ ! -z $pkg ]; then
        _installPip "$pkg"
    fi
}

# _installCargoPkg {row}
_installCargoPkg() {
    row="$1"
    pkg_cargo=$(echo $row | jq -r '.cargo')
    if [[ ! "$pkg_cargo" == "null" ]]; then
        pkg="$pkg_cargo"
    fi                 
    if [ ! -z $pkg ]; then
        _installCargo "$pkg"
    fi
}

# _installPkg {row}
_installPkg() {
    row="$1"
    pkg=$(echo "$row" | jq -r '.package')
    pkg_aur=$(echo "$row" | jq -r '.aur')
    pkg_fedoracopr=$(echo "$row" | jq -r '.fedoracopr')
    pkg_pacman=$(echo "$row" | jq -r '.pacman')
    pkg_zypper=$(echo "$row" | jq -r '.zypper')
    pkg_dnf=$(echo "$row" | jq -r '.dnf')
    pkg_apt=$(echo "$row" | jq -r '.apt')
    pkg_test=$(echo "$row" | jq -r '.test')
    pkg_pip=$(echo "$row" | jq -r '.pip')
    pkg_cargo=$(echo "$row" | jq -r '.cargo')
    pkg_flatpak=$(echo "$row" | jq -r '.flatpak')

    if [ -f "$pkginst_data_folder/$pkginst_manager/$pkg" ]; then
        source "$pkginst_data_folder/$pkginst_manager/$pkg"
    elif [[ ! "$pkg_flatpak" == "null" ]]; then
        _installFlatpakPkg "$row"
    elif [[ ! "$pkg_pip" == "null" && ! "$pkginst_manager" == "pacman" ]]; then
        _installPipPkg "$row"
    elif [[ ! "$pkg_cargo" == "null" ]]; then
        _installCargoPkg "$row"
    else
        case $pkginst_manager in
        "pacman")
            if [[ ! "$pkg_aur" == "null" ]]; then
                _installPackageAur "$pkg" "$pkg_test"
            else
                if [[ ! "$pkg_pacman" == "null" ]]; then
                    pkg="$pkg_pacman"
                fi
                if [[ ! "$pkg" == "SKIP" ]]; then
                    _installPackage "$pkg" "$pkg_test"
                fi
            fi
            ;;
        "dnf")
            if [[ ! "$pkg_fedoracopr" == "null" ]]; then
                _addCoprRepository "$pkg_fedoracopr"
            fi
            if [[ ! "$pkg_dnf" == "null" ]]; then
                pkg="$pkg_dnf"
            fi
            if [[ ! "$pkg" == "SKIP" ]]; then
                _installPackage "$pkg" "$pkg_test"
            fi
            ;;
        "apt")
            if [[ ! "$pkg_apt" == "null" ]]; then
                pkg="$pkg_apt"
            fi
            if [[ ! "$pkg" == "SKIP" ]]; then
                _installPackage "$pkg" "$pkg_test"
            fi
            ;;
        "zypper")
            if [[ ! "$pkg_zypper" == "null" ]]; then
                pkg="$pkg_zypper"
            fi            
            if [[ ! "$pkg" == "SKIP" ]]; then
                _installPackage "$pkg" "$pkg_test"
            fi
            ;;
        "flatpak")
            _installFlatpakPkg $row
            ;;
        esac
    fi    
}

# _installPackages {json_file}
_installPackages() {
    json_file="$1"
    for row in $(jq -c '.packages[]' "$json_file"); do
        pkg=$(echo "$row" | jq -r '.package')
        if [[ "$pkg" != "null" ]]; then
            _installPkg "$row"
        fi
    done    
}

# _checkInstalledOptions {json_file}
_checkInstalledOptions() {
    json_file="$1"
    type_arr=()
    for row in $(jq -c '.options[] | .packages[]' $json_file); do
        pkg=$(echo $row | jq -r '.package')
        pkg_type=$(echo $row | jq -r '.type')
        if [[ "$pkg_type" == "flatpak" ]]; then
            if [[ $(_isInstalledFlatpak "$pkg") == 0 ]]; then
		        _echo_success "$pkg ${pkginst_lang["package_already_installed"]}"
            fi
        else
            if [[ $(_isInstalled "$pkg") == 0 ]]; then
		        _echo_success "$pkg ${pkginst_lang["package_already_installed"]}"
            fi
        fi
    done
    echo
}

# _getInstallationOptions {json_file}
_getInstallationOptions() {
    json_file="$1"
    options_arr=""
    for option in $(jq -r '.options[] | .name' $json_file); do
        options_arr+="${option} "
    done
    options_arr+="Cancel"
    _echo "${pkginst_lang["choose_available_options"]}"
    echo
    selected_option=$(gum choose $options_arr)
    if [ ! $selected_option == "Cancel" ]; then
        counter=0
        for i in ${options_arr[@]}; do
            if [[ "$selected_option" == "$i" ]]; then
                selected_index=$counter
                break
            fi
            ((counter++))
        done
        _getInstallationOption "$json_file" "$selected_index" "$i"
    fi
}

# _getInstallationOption {json_file} {index} {option}
_getInstallationOption() {
    json_file="$1"
    index="$2"
    option_name="$3"
    packages_arr=""
    _writeModuleHeadline "$i"
    _echo "${pkginst_lang["choose_available_packages"]}"
    echo
    for package in $(jq -r '.options['$index'] | .packages[] | .package' $json_file); do
        packages_arr+="${package} "
    done
    selected_packages=$(gum choose --no-limit $packages_arr)
    if [ -z $selected_packages ]; then
        _getInstallationOptions "$json_file"
    else
        _echo "${pkginst_lang["selected_packages"]} $selected_packages"
        echo
        if gum confirm "${pkginst_lang["install_seleced_packages"]}"; then
            for i in ${selected_packages[@]}; do
                for row in $(jq -c '.options['$index'] | .packages[]' $json_file); do
                    pkg=$(echo $row | jq -r '.package')
                    pkg_type=$(echo $row | jq -r '.type')
                    pkg_test=$(echo $row | jq -r '.test')
                    if [[ $pkg == $i ]]; then
                        if [ -f "$pkginst_data_folder/$pkginst_manager/$pkg" ]; then
                            source "$pkginst_data_folder/$pkginst_manager/$pkg"
                        elif [ -f "$pkginst_data_folder/$pkg_type/$pkg" ]; then 
                            source "$pkginst_data_folder/$pkg_type/$pkg"
                        else
                            if [ $pkg_type == "flatpak" ]; then
                                _installFlatpakFlathub "$pkg"
                            else
                                _installPackage "$pkg" "$pkg_test"
                            fi
                        fi
                    fi
                done
            done
            _getInstallationOptions "$json_file"                
        else
            _getInstallationOptions "$json_file"                
        fi
    fi
}

# _checkCommandExists {command}
_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
    else
        echo 0
    fi
}

# _installPip {package}
_installPip() {
    package="$1"
    _echo_success "${pkginst_lang["install_package"]} ${package} with pip"
    if [[ "$debug" == 0 ]]; then
        pip install -y "${package}"
    else
        pip install -y "${package}" &>>$(_getLogFile)
    fi
}

# _installCargo {package}
_installCargo() {
    package="$1"
    _echo_success "${pkginst_lang["install_package"]} ${package} with cargo"
    if [[ "$debug" == 0 ]]; then
        cargo install "${package}"
    else
        cargo install "${package}" &>>$(_getLogFile)
    fi
}

# Define log file extension
_getLogFile() {
    log_filename="log.txt"
    echo "$pkginst_log_folder/$pkginst_package/$pkginst_log_file-$log_filename"
}
