if [ ! -d $HOME/.cache ]; then
	mkdir -p $HOME/.cache
fi
wget -q -P "$HOME/.cache" "{url}"
cd "$HOME/.cache"
echo ":: Installing {name}"
if [ $cmdoutput == 1 ]; then
	flatpak --user -y --reinstall install {name} > /dev/null 2>&1
else
	flatpak --user -y --reinstall install {name}
fi
rm "$HOME/.cache/{name}"
