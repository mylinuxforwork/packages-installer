_isInstalled_dnf() {
    package="$1"
    check=$(dnf list --installed | grep $package)
    if [ -z "$check" ]; then
        echo 1
    else
        echo 0
    fi
}
