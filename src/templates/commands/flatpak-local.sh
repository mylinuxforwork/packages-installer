cd "{dir}"
echo ":: Installing {name}"
if [ $cmdoutput == 1 ]; then
	flatpak --user -y --reinstall install {name}.flatpak > /dev/null 2>&1
else
	flatpak --user -y --reinstall install {name}.flatpak
fi
