#!/usr/bin/env bash

# Create releases folder
if [ ! -d "$HOME/Projects/releases" ]; then
    mkdir -p "$HOME/Projects/releases"
fi

# Remove existing package-installer
if [ -f "$HOME/Projects/releases/packages-installer.zip" ]; then
    rm "$HOME/Projects/releases/packages-installer.zip"
fi

# Create temp folder
if [ -d "$HOME/.cache/packages-installer-pack" ]; then
    rm -rf "$HOME/.cache/packages-installer-pack"
fi
mkdir -p "$HOME/.cache/packages-installer-pack"

# Copy project into temp folder
cp -rf "$HOME/Projects/packages-installer/." "$HOME/.cache/packages-installer-pack/packages-installer"

# Clean up
rm -rf "$HOME/.cache/packages-installer-pack/packages-installer/.git"
rm -rf "$HOME/.cache/packages-installer-pack/packages-installer/dev"

# Zip packages-installer
cd "$HOME/.cache/packages-installer-pack"
zip -r "packages-installer.zip" "packages-installer"

# Copy file back to Projects folder
cp "packages-installer.zip" "$HOME/Projects/releases"
