# Read Dependencies
_writeModuleHeadline "${pkginst_lang['installing_dependencies']}"
counter=0
for pkg in $(jq -r '.packages[] | .package' $pkginst_script_dependencies/packages.json); do
    pkg=${pkg}
    pkg_test=$(jq -r '.packages['$counter'] | .test' $pkginst_script_dependencies/packages.json)
    if [ -f "$pkginst_data_folder/$pkginst_manager/$pkg" ]; then
        source "$pkginst_data_folder/$pkginst_manager/$pkg"
    else
        _installPackage "${pkg}" "${pkg_test}"
    fi
    ((counter++))
done
echo
