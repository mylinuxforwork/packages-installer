# _echo {output}
_echo() {
    output="$1"
    echo "${echo_prefix}${output}"
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

# _readPackages {folder}
_readPackages() {
    folder="$1"
    if [ -f "$folder/packages" ]; then
        packages=$(cat "$folder/packages")
        echo "$packages"
    fi
}

# _readDependencies {folder}
_readDependencies() {
    folder="$1"
    if [ -f "$folder/dependencies" ]; then
        dependencies=$(cat "$folder/dependencies")
        echo "$dependencies"
    fi
}

# _loadConfigurationFile {file}
_loadConfigurationFile() {
    folder="$1"
    if [ -f "$folder/pkginst" ]; then
        source "$folder/pkginst"
    fi
}

_writeModuleHeadline() {
    headline_tmp="$1"
    echo "$headline_tmp"
}
