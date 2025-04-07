clear
if [ -f "$pkginst_data_folder/templates/header.sh" ]; then
    source "$pkginst_data_folder/templates/header.sh"
else
    source "$pkginst_script_folder/templates/header.sh"
fi
