#!/usr/bin/env bash

# Copy packages-installer to $HOME/.local/bin
cp bin/packages-installer $HOME/.local/bin

# Copy lib $HOME/.local/share/com.ml4w.packagesinstaller
cp -rf share/lib/ $HOME/.local/share/com.ml4w.packagesinstaller/

echo ":: Done"