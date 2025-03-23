if [ ! $(jq -r '.options | length' $pkginst_data_folder/packages.json) == "0" ]; then
    _getInstallationOptions "$pkginst_data_folder/packages.json"
fi