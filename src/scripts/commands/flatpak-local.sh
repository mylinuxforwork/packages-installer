cd "{dir}"
echo ":: Installing {name}"
flatpak --user -y --reinstall install {name}.flatpak > /dev/null 2>&1
