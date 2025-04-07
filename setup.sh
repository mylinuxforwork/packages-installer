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

# Check for git
if [[ $(_checkCommandExists "wget") == 1 ]]; then
    echo "ERROR: Please install 'wget' and 'jq' on your system first."
    exit
fi

# Check for jq
if [[ $(_checkCommandExists "jq") == 1 ]]; then
    echo "ERROR: Please install 'wget' and 'jq' on your system first."
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

# Create .cache folder if not exists
if [ -d $HOME/.cache/packages-installer ]; then
    rm -rf $HOME/.cache/packages-installer
fi

# Get latest version
echo ":: Downloading latest version of packages-installer..."

# Download latest release
wget -q -c "https://github.com/mylinuxforwork/packages-installer/releases/latest/download/packages-installer.zip" -O "$HOME/.cache/packages-installer.zip"

# Unzip
unzip -o -q $HOME/.cache/packages-installer.zip -d $HOME/.cache

# Create folders id not exists
if [ ! -f "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
fi

if [ ! -f "$HOME/.local/share" ]; then
    mkdir -p "$HOME/.local/share"
fi

# Copy to .local
cp -rf $HOME/.cache/packages-installer/bin/. $HOME/.local/bin
cp -rf $HOME/.cache/packages-installer/share/. $HOME/.local/share

# Run packages-installer
$HOME/.local/bin/packages-installer $@