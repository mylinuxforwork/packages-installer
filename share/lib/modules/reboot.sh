echo $echo_line
echo "${pkginst_lang['installation_completed']}"
echo $echo_line
if gum confirm "${pkginst_lang['reboot_question']}"; then
    reboot
fi
