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

_getNumberOfPackages() {
    echo "$(jq -r '.packages | length' $pkginst_data_folder/packages.json)"
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
        supported="1"
        for mng in $(jq -r .managers[] $pkginst_data_folder/config.json); do
            if [[ "$mng" == "$pkginst_manager" ]]; then
                supported=0
            fi
        done
        if [ $supported == "1" ]; then
            _echo "${pkginst_lang["package_manager_not_supported"]}"
            exit
        fi
    fi
}

# _installPackages {json_file}
_installPackages() {
    json_file="$1"
    counter=0
    for row in $(jq -c '.packages[]' $json_file); do
        pkg=$(echo $row | jq -r '.package')
        pkg_test=$(echo $row | jq -r '.test')
        pkg_type=$(echo $row | jq -r '.type')
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
    _echo_success "${pkginst_lang["install_package"]} ${package}"
    pip install "${package}" &>>$(_getLogFile)
}

# Define log file extension
_getLogFile() {
    log_filename="log.txt"
    echo "$pkginst_log_folder/$pkginst_package/$pkginst_log_file-$log_filename"
}
