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

# _selectManager
_selectManager() {
    if [ $(jq -r '.managers | length' $pkginst_data_folder/config.json) == 0 ]; then
        _echo "No package manager(s) defined in config.json"
        exit
    fi
    if [ $(jq -r '.managers | length' $pkginst_data_folder/config.json) == 1 ]; then
        _echo "Using $(jq -r .managers[0] $pkginst_data_folder/config.json)"
        pkginst_manager=$(jq -r .managers[0] $pkginst_data_folder/config.json)
    else

        _echo "Please select one of the following supported Package Manager that is available on your system:"
        echo
        counter=1
        for mng in $(jq -r .managers[] $pkginst_data_folder/config.json); do
            echo "   $counter: $mng"
            ((counter++))
        done
        echo
        while true; do
            read -p "PLEASE SELECT: " yn
            if (($yn > 0 && $yn < $counter)); then
                pkginst_manager=$(jq -r .managers[$yn-1] $pkginst_data_folder/config.json)
                break
            else
                _echo "Please select a package manager."                
            fi
        done
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
    pip install "${package}" > /dev/null 2>&1
}
