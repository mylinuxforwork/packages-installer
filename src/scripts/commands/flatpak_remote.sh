# Command flatpak_remote
pkg="{name}"
if [ ! -d $HOME/.cache ]; then
	mkdir -p $HOME/.cache
fi
wget -q -P "$HOME/.cache" "{name}"
cd "$HOME/.cache"
echo ":: Installing ${pkg}"
flatpak --user -y --reinstall install ${pkg} > /dev/null 2>&1