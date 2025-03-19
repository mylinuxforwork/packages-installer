clear
echo $echo_line
_getConfiguration "name"
_getConfiguration "description"
_getConfiguration "author"
echo "Copyright" $(_getConfiguration "copyright")
_getConfiguration "homepage"
echo
echo "Package Manager: $pkginst_manager"
echo "Number of Packages: $(jq -r '.packages | length' packages/packages.json)"
echo "Number of Flatpaks: $(jq -r '.flatpaks | length' packages/packages.json)"
echo $echo_line
echo