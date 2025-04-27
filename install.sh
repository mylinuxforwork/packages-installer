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
if [[ $(_checkCommandExists "git") == 1 ]]; then
    echo "ERROR: Please install 'git' on your system first."
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
echo ":: Downloading latest version of packages-installer..."
git clone --quiet --depth 1 https://github.com/mylinuxforwork/packages-installer.git $HOME/.cache/packages-installer  > /dev/null

# Create folders if not exists
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
fi

if [ ! -d "$HOME/.local/share" ]; then
    mkdir -p "$HOME/.local/share"
fi

# Copy to .local
cp -rf $HOME/.cache/packages-installer/bin/. $HOME/.local/bin
echo ":: packages-installer installed in $HOME/.local/bin"
cp -rf $HOME/.cache/packages-installer/share/. $HOME/.local/share
echo ":: packages-installer library installed in $HOME/.local/share"
echo 
echo ":: Please follow the Packages Installer Wiki to learn how to setup your first project."
