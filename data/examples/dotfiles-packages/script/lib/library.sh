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
    headline_tmp="$1"
    echo "$headline_tmp"
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

# _selectManager
_selectManager() {
    if [ $(jq -r '.managers | length' $pkginst_data_folder/config.json) == 0 ]; then
        _echo_error ${pkginst_lang["error_no_package_manager_defined"]}
        exit
    fi
    if [ $(jq -r '.managers | length' $pkginst_data_folder/config.json) == 1 ]; then
        _echo "${pkginst_lang["message_using"]} $(jq -r .managers[0] $pkginst_data_folder/config.json)"
        pkginst_manager=$(jq -r .managers[0] $pkginst_data_folder/config.json)
    else
        echo
        _echo "${pkginst_lang["select_package_manager"]}"
        counter=1
        for mng in $(jq -r .managers[] $pkginst_data_folder/config.json); do
            echo "   $counter: $mng"
            ((counter++))
        done
        echo
        if [ $(_getConfiguration "show_all_packages") == "true" ]; then
            _echo "${pkginst_lang["package_manager_not_supported"]}"
            echo "   $counter: ${pkginst_lang["show_all_packages"]}"
            show_all_packages_counter=$counter
            echo
        fi
        while true; do
            read -p "${pkginst_lang["please_select"]}: " yn
            if [ $(_getConfiguration "show_all_packages") == "true" ]; then
                if [ $yn == $show_all_packages_counter ]; then
                    _showAllPackagesDialog
                    break
                elif (($yn > 0 && $yn < $counter-1)); then
                    pkginst_manager=$(jq -r .managers[$yn-1] $pkginst_data_folder/config.json)
                    break
                else
                    _echo_error "${pkginst_lang["please_select_an_option"]}"              
                fi
            else
                if (($yn > 0 && $yn < $counter)); then
                    pkginst_manager=$(jq -r .managers[$yn-1] $pkginst_data_folder/config.json)
                    break
                else
                    _echo_error "${pkginst_lang["please_select_an_option"]}"                
                fi
            fi
        done
    fi
}

# _installPackages {json_file}
_installPackages() {
    json_file="$1"
    json_array="packages"
    json_node="package"
    counter=0
    pkg_test=""
    pkg_type=""
    flatpak_url=""
    for pkg in $(jq -r '.'$json_array'[] | .'$json_node $json_file); do
        pkg=${pkg}
        pkg_test=$(jq -r '.'$json_array'['$counter'] | .test' $json_file)
        pkg_type=$(jq -r '.'$json_array'['$counter'] | .type' $json_file)
        if [ -f "$pkginst_data_folder/$pkginst_manager/$pkg" ]; then
            source "$pkginst_data_folder/$pkginst_manager/$pkg"
        else
            case "$pkg_type" in
                "null")
                    _installPackage "${pkg}" "${pkg_test}"
                ;;
                "package")
                    _installPackage "${pkg}" "${pkg_test}"
                ;;
                "flatpak-remote")
                    flatpak_url=$(jq -r '.'$json_array'['$counter'] | .url' $json_file)
                    if [[ ! "$flatpak_url" == "null" ]]; then
                        _installFlatpakRemote "${pkg}" "${flatpak_url}"
                    fi
                ;;
                "flatpak-local")
                    _installFlatpakLocak "${pkg}" "${pkg_test}"
                ;;
                "flatpak-flathub")
                    _installFlatpakFlathub "${pkg}" "${pkg_test}"
                ;;
                "flatpak")
                    _installFlatpak "${pkg}" "${pkg_test}"
                ;;
                *)
                    _echo_error "$pkg_type not supported"
                ;;
            esac        
        fi
        ((counter++))
    done    
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
    _echo_success "${pkginst_lang["install_package"]} ${package}"
    pip install "${package}" &>>$(_getLogFile)
}

# Define log file extension
_getLogFile() {
    log_filename="-log.txt"
    echo "$pkginst_log_folder/$(date '+%Y%m%d%H%M%S')$log_filename"
}
