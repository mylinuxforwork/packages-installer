#!/usr/bin/env bash

# Create folders id not exists
if [ ! -f "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
fi

if [ ! -f "$HOME/.local/share" ]; then
    mkdir -p "$HOME/.local/share"
fi

# Copy to .local
cp -rf $HOME/Projects/packages-installer/bin/. $HOME/.local/bin
cp -rf $HOME/Projects/packages-installer/share/. $HOME/.local/share