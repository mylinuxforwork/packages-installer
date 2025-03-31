figlet -f smslant "Installer"
echo $echo_line
_getConfiguration "name"
echo $pkginst_package
_getConfiguration "description"
_getConfiguration "author"
echo "Copyright" $(_getConfiguration "copyright")
_getConfiguration "homepage"
echo
echo "Package Manager: $pkginst_manager"
echo "Number of Packages: $(_getNumberOfPackages)"
echo $echo_line
echo