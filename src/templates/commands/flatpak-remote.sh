if [ ! -d $HOME/.cache ]; then
	mkdir -p $HOME/.cache
fi
wget -q -P "$HOME/.cache" "{url}"
cd "$HOME/.cache"
echo ":: Installing {name}"
eval 'flatpak --user -y --reinstall install {name} > $cmdoutput'
rm "$HOME/.cache/{name}"
