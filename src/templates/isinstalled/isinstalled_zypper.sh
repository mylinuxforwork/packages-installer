_isInstalled_zypper() {
    package="$1"
    package_info=$(zypper se -i "$package" 2>/dev/null | grep "^i" | awk '{print $3}')
    ret=1
    for pkg in $package_info
    do
	if [ "$package" == "$pkg" ]; then
		ret=0
		break
	fi
	done
	echo $ret
}
