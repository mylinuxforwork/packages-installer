if [ -z $pkginst_package ]; then
    _echo_error "Please specify the name of the pkginst package: package-installer pkginstpackage"
    exit
fi

# Remove Old Package
if [ -d "$HOME/.local/share/com.ml4w.packagesinstaller/pkginst/$pkginst_package" ]; then
    rm -rf "$HOME/.local/share/com.ml4w.packagesinstaller/pkginst/$pkginst_package"
fi

# Install Source
if [ ! -z "$pkginst_source" ]; then
    if [[ $pkginst_source == *"https://"* ]]; then
        # Check for dependencies
        if [[ $(_checkCommandExists "unzip") == 1 ]] || [[ $(_checkCommandExists "wget") == 1 ]]; then
            _echo_error "For remote sources you need to have wget and unzip installed on your system."
            exit
        fi

        # Clean up
        if [ -f "$HOME/.cache/pkginst_tmp.zip" ]; then
            rm "$HOME/.cache/pkginst_tmp.zip"
        fi
        if [ -d "$HOME/.cache/pkginst_tmp.zip" ]; then
            rm -rf "$HOME/.cache/pkginst_tmp.zip"
        fi
        if [ ! -d $HOME/.cache ]; then
            mkdir -p $HOME/.cache
        fi

        # Download Remote
        if wget --spider "$pkginst_source" 2>/dev/null; then
            wget -q -c "$pkginst_source" -O "$HOME/.cache/pkginst_tmp.zip"
        else
            _echo_error "Remote file does not exists. Please check your url."
            exit
        fi

        # Unzip to target folder
        if [ ! -f $HOME/.cache/pkginst_tmp.zip ]; then
            echo "Error"        
            exit
        fi
        unzip -o -q $HOME/.cache/pkginst_tmp.zip -d $HOME/.local/share/com.ml4w.packagesinstaller/pkginst/
    else
        if [ ! -d $pkginst_source/$pkginst_package ]; then
            _echo_error "pkginst package '$pkginst_source/$pkginst_package' does not exist."
            exit
        fi
        cp -rf $pkginst_source/$pkginst_package $HOME/.local/share/com.ml4w.packagesinstaller/pkginst
    fi
fi

# Set target folder
pkginst_data_folder="$HOME/.local/share/com.ml4w.packagesinstaller/pkginst/$pkginst_package/pkginst"
if [ ! -d "$pkginst_data_folder" ]; then
    _echo_error "Cannot find the pkginst package $pkginst_package in $HOME/.local/share/com.ml4w.packagesinstaller/pkginst/"
    exit
fi

# Set Log Folder
if [ ! -d "$pkginst_log_folder/$pkginst_package" ]; then
    mkdir -p "$pkginst_log_folder/$pkginst_package"
fi