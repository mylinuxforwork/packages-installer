clear
_loadConfigurationFile "$pkginst_data_folder"
echo $echo_line
[[ ! -z $conf_name ]] && echo "$conf_name"
[[ ! -z $conf_description ]] && echo "$conf_description"
[[ ! -z $conf_author ]] && echo "by $conf_author"
[[ ! -z $conf_copyright ]] && echo "(Copyright $conf_copyright)"
echo
[[ ! -z $conf_homepage ]] && echo "$conf_homepage"
echo $echo_line
echo 
