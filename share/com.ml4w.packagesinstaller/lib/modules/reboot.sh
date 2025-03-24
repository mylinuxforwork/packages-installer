echo $echo_line
echo "${pkginst_lang['installation_completed']}"
echo $echo_line
if [ "$assumeyes" == "1" ]; then
    if gum confirm "${pkginst_lang['reboot_question']}"; then
        reboot
    fi
fi
