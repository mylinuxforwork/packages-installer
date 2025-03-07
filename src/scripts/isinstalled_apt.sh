_isInstalled_apt() {
    package="$1"

	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $package|grep "install ok installed")
	if [ "" = "$PKG_OK" ]; then
		echo 1
	else
		echo 0
	fi
}
