# Command flatpak_local
pkg="ada"
dir=""
cd "${dir}"
echo ":: Installing ${pkg}"
flatpak --user -y --reinstall install ${pkg} > /dev/null 2>&1