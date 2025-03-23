#!/usr/bin/env bash

# _checkCommandExists {command}
_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
    else
        echo 0
    fi
}

# Download latest version
if [[ $(_checkCommandExists "unzip") == 1 ]] || [[ $(_checkCommandExists "wget") == 1 ]]; then
    _echo_error "For remote sources you need to have wget and unzip installed on your system."
    exit
fi

# Clean up
if [ -f "$HOME/.cache/packages-installer.zip" ]; then
    rm "$HOME/.cache/packages-installer.zip"
fi

if [ -d "$HOME/.cache/packages-installer" ]; then
    rm -rf "$HOME/.cache/packages-installer"
fi

# Create .cache folder if not exists
if [ ! -d $HOME/.cache ]; then
    mkdir -p $HOME/.cache
fi

# Download latest version
wget -c "https://github.com/mylinuxforwork/packages-installer/releases/latest/download/packages-installer.zip" -O "$HOME/.cache/packages-installer.zip"

# Unzip
unzip -o $HOME/.cache/packages-installer.zip -d $HOME/.cache/

# Copy to .local
cp -rf $HOME/.cache/packages-installer/. $HOME/.local/

# Run packages-installer
# $HOME/.local/com.ml4w.packagesinstaller/bin/packagesinstaller $1