cd "{dir}"
echo ":: Installing {name}"
eval 'flatpak --user -y --reinstall install {name}.flatpak > $cmdoutput'
