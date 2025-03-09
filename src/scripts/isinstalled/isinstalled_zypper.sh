_isInstalled_zypper() {
    package="$1"
    check="$(sudo zypper search --installed-only "${package}")"
    if [ -n "${check}" ]; then
        echo 0
    else
        echo 1
    fi
}
