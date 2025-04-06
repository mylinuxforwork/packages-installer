if [ ! $(jq -r '.options | length' $pkginst_data_folder/packages.json) == "0" ]; then
    _writeModuleHeadline "${pkginst_lang["headline_options"]}"
    _checkInstalledOptions "$pkginst_data_folder/packages.json"
    _getInstallationOptions "$pkginst_data_folder/packages.json"
fi