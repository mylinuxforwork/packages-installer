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
    _echo_error "For remote sources please install wget and unzip installed on your system."
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

# Clone latest version
git clone --depth 1 https://github.com/mylinuxforwork/packages-installer.git $HOME/.cache/packages-installer

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