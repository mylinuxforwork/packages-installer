if [ ! -d $HOME/.cache ]; then
	mkdir -p $HOME/.cache
fi
wget -q -P "$HOME/.cache" "{url}"
cd "$HOME/.cache"
echo ":: Installing {name}"
flatpak --user -y --reinstall install {name} > /dev/null 2>&1
rm "$HOME/.cache/{name}"
